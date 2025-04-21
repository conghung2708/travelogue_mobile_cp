part of 'experience_bloc.dart';

abstract class ExperienceState {
  List<Object> get props => [<ExperienceModel>[], ExperienceCategory];
}

class ExperienceInitial extends ExperienceState {}

class ExperienceSuccess extends ExperienceState {
  final List<ExperienceModel> experiences;
  final ExperienceCategory category;
  ExperienceSuccess({required this.experiences, required this.category});

  @override
  List<Object> get props => [experiences, category];
}
