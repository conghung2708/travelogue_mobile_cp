import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/model/experience_model.dart';

class ExperienceLocal {
  final Box boxExperience = Hive.box(StorageKey.boxExperience);

  // Getter
  List<ExperienceModel>? getAllExperience() {
    final List? experiences = boxExperience.get(
      StorageKey.experiences,
      defaultValue: null,
    );

    if (experiences == null) {
      return null;
    }

    return experiences
        .map(
          (experience) => ExperienceModel.fromJson(experience),
        )
        .toList();
  }

  // Setter

  void saveExperiences({
    required List<ExperienceModel> experiences,
  }) {
    if (experiences.isEmpty) {
      return;
    }

    boxExperience.put(
      StorageKey.experiences,
      experiences
          .map(
            (experience) => experience.toJson(),
          )
          .toList(),
    );
  }

  // Clean
  void clear() {
    boxExperience.clear();
  }
}
