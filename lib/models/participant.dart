class Participant {
  final int? id;
  final int trackId;
  final String name;
  final String avatar;

  Participant({
    this.id, 
    required this.trackId,
    required this.name, 
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 'id': id,
      'trackId': trackId,
      'name': name,
      'avatar': avatar
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'] as int?,
      trackId: map['track_id'] as int,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
    );
  }

  @override
  String toString() {
    return 'Participant(id: $id, trackId: $trackId, name: $name)';
  }

}