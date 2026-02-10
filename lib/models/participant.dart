class Participant {
  final int? id;
  final int trackId;
  final String name;
    final int createdAt;

  Participant({
    this.id, 
    required this.trackId,
    required this.name, 
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 'id': id,
      'trackId': trackId,
      'name': name
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'] as int?,
      trackId: map['trackId'] as int,
      name: map['name'] as String,
      createdAt: map['created_at'] as int,
    );
  }

}