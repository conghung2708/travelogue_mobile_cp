// lib/model/workshop/ticket_type_model.dart
import 'activity_model.dart';

class TicketTypeModel {
  final String? id;
  final String? workshopId;
  final int? type;
  final String? name;
  final num? price;
  final bool? isCombo;
  final int? durationMinutes;
  final String? content;
  final List<ActivityModel> activities;

  const TicketTypeModel({
    this.id,
    this.workshopId,
    this.type,
    this.name,
    this.price,
    this.isCombo,
    this.durationMinutes,
    this.content,
    this.activities = const [],
  });

  factory TicketTypeModel.fromMap(Map<String, dynamic> map) {
    final acts = ((map['activities'] as List?) ?? const [])
        .whereType<Map>()
        .map((m) => ActivityModel.fromMap(m.cast<String, dynamic>()))
        .toList();

    return TicketTypeModel(
      id: map['id'] as String?,
      workshopId: map['workshopId'] as String?,
      type: map['type'] as int?,
      name: map['name'] as String?,
      price: (map['price'] is num)
          ? map['price'] as num
          : num.tryParse('${map['price']}'),
      isCombo: map['isCombo'] as bool?,
      durationMinutes: (map['durationMinutes'] is num)
          ? (map['durationMinutes'] as num).toInt()
          : int.tryParse('${map['durationMinutes']}'),
      content: map['content'] as String?,
      activities: acts,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'workshopId': workshopId,
    'type': type,
    'name': name,
    'price': price,
    'isCombo': isCombo,
    'durationMinutes': durationMinutes,
    'content': content,
    'activities': activities.map((e) => e.toMap()).toList(),
  };
}
