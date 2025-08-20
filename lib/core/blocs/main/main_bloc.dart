import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/core/blocs/main/main_state.dart';


class MainBloc extends Bloc<MainEvent, MainState> {
  int currentScreen = 0;

  MainBloc() : super(MainInitial()) {
    on<OnChangeIndexEvent>((event, emit) {
      currentScreen = event.indexChange;
      emit(MainDone(currentScreen: currentScreen));
    });
  }
}
