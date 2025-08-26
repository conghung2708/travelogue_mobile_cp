import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';

abstract class TourGuideEvent extends Equatable {
  const TourGuideEvent();

  @override
  List<Object?> get props => [];
}


class GetAllTourGuidesEvent extends TourGuideEvent {
  const GetAllTourGuidesEvent();
}


class GetTourGuideByIdEvent extends TourGuideEvent {
  final String id;
  const GetTourGuideByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}


class FilterTourGuideEvent extends TourGuideEvent {
  final TourGuideFilterModel filter;
  const FilterTourGuideEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
