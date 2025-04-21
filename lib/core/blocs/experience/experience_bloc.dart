import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/experience_repository.dart';
import 'package:travelogue_mobile/data/data_local/experience_local.dart';
import 'package:travelogue_mobile/model/experience_category_model.dart';
import 'package:travelogue_mobile/model/experience_model.dart';

part 'experience_event.dart';
part 'experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final List<ExperienceModel> experiences = [];
  ExperienceCategory currentCategory = experienceCategories.first;

  ExperienceBloc() : super(ExperienceInitial()) {
    on<ExperienceEvent>((event, emit) async {
      if (event is GetAllExperienceEvent) {
        if (ExperienceLocal().getAllExperience()?.isNotEmpty ?? false) {
          experiences.addAll(ExperienceLocal().getAllExperience()!);
          emit(_getExperienceSuccess);
        }

        await _getAllExperience();
        emit(_getExperienceSuccess);
      }

      if (event is FilterExperienceEvent) {
        currentCategory = event.currentCategory;
        if (ExperienceLocal().getAllExperience()?.isNotEmpty ?? false) {
          experiences.clear();
          if (currentCategory.id.isEmpty) {
            experiences.addAll(ExperienceLocal().getAllExperience()!);
            emit(_getExperienceSuccess);
            return;
          }
          experiences.addAll(
            ExperienceLocal()
                .getAllExperience()!
                .where((e) => e.typeExperienceId == currentCategory.id)
                .toList(),
          );
          emit(_getExperienceSuccess);
        }
      }
    });
  }

  // Private function
  ExperienceSuccess get _getExperienceSuccess => ExperienceSuccess(
        experiences: experiences,
        category: currentCategory,
      );

  Future<void> _getAllExperience() async {
    final List<ExperienceModel> allExperience =
        await ExperienceRepository().getAllExperience();
    if (allExperience.isEmpty) {
      return;
    }

    experiences.addAll(allExperience);
    ExperienceLocal().saveExperiences(experiences: allExperience);
  }
}
