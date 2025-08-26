import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/location_repository.dart';
import 'package:travelogue_mobile/model/location_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<LocationModel> listSearch = [];

  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchLocationEvent) {
        await _searchLocation(event);
        emit(_searchSuccess);
      }
      if (event is CleanSearchEvent) {
        listSearch.clear();
        emit(SearchInitial());
      }
    });
  }


  SearchSuccess get _searchSuccess => SearchSuccess(listSearch: listSearch);

  Future<void> _searchLocation(SearchLocationEvent event) async {
    final List<LocationModel> listLocationSearch =
        await LocationRepository().searchLocation(search: event.searchText);

    listSearch.clear();
    listSearch.addAll(listLocationSearch);
  }
}
