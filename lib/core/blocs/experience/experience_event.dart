part of 'experience_bloc.dart';

abstract class ExperienceEvent {}

class GetAllExperienceEvent extends ExperienceEvent {}

class FilterExperienceEvent extends ExperienceEvent {
  final ExperienceCategory currentCategory;
  FilterExperienceEvent({required this.currentCategory});
}
