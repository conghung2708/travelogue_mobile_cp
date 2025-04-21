import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/home_repository.dart';
import 'package:travelogue_mobile/data/data_local/home_local.dart';
import 'package:travelogue_mobile/model/event_model.dart';

part 'festival_event.dart';
part 'festival_state.dart';

class FestivalBloc extends Bloc<FestivalEvent, FestivalState> {
  List<EventModel> festivals = [];
  int monthCurrent = 0;

  FestivalBloc() : super(FestivalInitial()) {
    on<FestivalEvent>((event, emit) async {
      if (event is GetAllFestivalEvent) {
        if (HomeLocal().getEvents()?.isNotEmpty ?? false) {
          festivals.addAll(HomeLocal().getEvents()!);
          emit(_festivalSuccess);
        }

        await _getFestivals();
        emit(_festivalSuccess);
      }

      if (event is FilterFestivalEvent) {
        if (HomeLocal().getEvents()?.isNotEmpty ?? false) {
          festivals = HomeLocal().getEvents()!;
          monthCurrent = event.month;

          if (monthCurrent == 0) {
            emit(_festivalSuccess);
            return;
          }
          festivals = festivals
              .where((festival) =>
                  festival.startDate?.month == event.month &&
                  festival.startDate?.year == DateTime.now().year)
              .toList();
          emit(_festivalSuccess);
        }
      }
    });
  }

  // Private function
  FestivalSuccess get _festivalSuccess => FestivalSuccess(
        festivals: festivals,
        monthCurrent: monthCurrent,
      );

  Future<void> _getFestivals() async {
    final List<EventModel> allEvents = await HomeRepository().getEvents();
    if (allEvents.isEmpty) {
      return;
    }

    festivals.addAll(allEvents);
    HomeLocal().saveEvents(events: allEvents);
  }
}
