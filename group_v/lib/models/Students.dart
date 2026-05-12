class Student {
  final String id;
  final String name;
  final String phone;
  final String? profilePictureUrl; // NEW: Optional image URL
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  Student({
    required this.id,
    required this.name,
    required this.phone,
    this.profilePictureUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  // Convert JSON → Student (from Supabase)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profilePictureUrl: json['profile_picture_url'],
      userId: json['user_id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  // Convert Student → JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
    };
  }

  // copyWith - how we "UPDATE" data (creates a new copy with changes)
  Student copyWith({
    String? id,
    String? name,
    String? phone,
    String? profilePictureUrl,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}