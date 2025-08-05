class ActivityModel {
  final String? id;
  final String? activity;
  final String? description;
  final String? startTimeFormatted;
  final String? endTimeFormatted;
  final int? duration; 
  final String? notes; 
  final String? imageUrl; 

  ActivityModel({
    this.id,
    this.activity,
    this.description,
    this.startTimeFormatted,
    this.endTimeFormatted,
    this.duration,
    this.notes,
    this.imageUrl,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'],
      activity: map['activity'],
      description: map['description'],
      startTimeFormatted: map['startTimeFormatted'],
      endTimeFormatted: map['endTimeFormatted'],
      duration: map['duration'],
      notes: map['notes'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity,
      'description': description,
      'startTimeFormatted': startTimeFormatted,
      'endTimeFormatted': endTimeFormatted,
      'duration': duration,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }
}
