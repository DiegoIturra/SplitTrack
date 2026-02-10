class Track {
  final int? id;
  final String name;
  final int createdAt;

  Track({
    this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'created_at': createdAt,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: map['created_at'] as int,
    );
  }
}
