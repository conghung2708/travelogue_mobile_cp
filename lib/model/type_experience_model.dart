class TypeExperienceModel {
  String? id;
  String? typeName;
  String? createdTime;
  String? lastUpdatedTime;

  TypeExperienceModel({
    this.id,
    this.typeName,
    this.createdTime,
    this.lastUpdatedTime,
  });

  TypeExperienceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['typeName'];
    createdTime = json['createdTime'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['typeName'] = typeName;
    data['createdTime'] = createdTime;
    data['lastUpdatedTime'] = lastUpdatedTime;

    return data;
  }
}
