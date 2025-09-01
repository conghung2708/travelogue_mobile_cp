class ActivityModel {
  final String? id;
  final String? activity;
  final String? description;

  
  final String? startTimeFormatted; 
  final String? endTimeFormatted;


  final int? durationMinutes;

  
  final String? notes;
  final String? imageUrl;


  final int? activityOrder;

  const ActivityModel({
    this.id,
    this.activity,
    this.description,
    this.startTimeFormatted,
    this.endTimeFormatted,
    this.durationMinutes,
    this.notes,
    this.imageUrl,
    this.activityOrder,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    // alias helper
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return ActivityModel(
      id: map['id'] as String? ?? map['activityId'] as String?,
      activity: map['activity'] as String? ?? map['name'] as String?,
      description: map['description'] as String? ?? map['content'] as String?,

    
      startTimeFormatted: map['startTimeFormatted'] as String?,
      endTimeFormatted: map['endTimeFormatted'] as String?,


      durationMinutes: _toInt(map['durationMinutes'] ?? map['duration']),

      notes: map['notes'] as String?,
      imageUrl: map['imageUrl'] as String?,

      activityOrder: _toInt(map['activityOrder'] ?? map['order']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'activity': activity,
        'description': description,
        'startTimeFormatted': startTimeFormatted,
        'endTimeFormatted': endTimeFormatted,
        'durationMinutes': durationMinutes,
        'notes': notes,
        'imageUrl': imageUrl,
        'activityOrder': activityOrder,
      };
}
