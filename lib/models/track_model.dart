import 'dart:convert';

class Track {
  final int? id;
  final String name;
  final List<Map<String, dynamic>> participants;
  final int createdAt;

  Track({
    this.id,
    required this.name,
    required this.participants,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'participants': jsonEncode(participants),
      'created_at': createdAt,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int?,
      name: map['name'] as String,
      participants: List<Map<String, dynamic>>.from(
        jsonDecode(map['participants']),
      ),
      createdAt: map['created_at'] as int,
    );
  }
}
