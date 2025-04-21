// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TypeLocationModel {
  String? id;
  String? name;
  TypeLocationModel({
    this.id,
    this.name,
  });

  TypeLocationModel copyWith({
    String? id,
    String? name,
  }) {
    return TypeLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory TypeLocationModel.fromMap(Map<String, dynamic> map) {
    return TypeLocationModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeLocationModel.fromJson(String source) =>
      TypeLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TypeLocationModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant TypeLocationModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
