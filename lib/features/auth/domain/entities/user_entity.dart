class UserEntity {
  final String id;
  final String fullName;
  final String? email;
  final String? avatarUrl;
  final String? phone;
  final String? upiId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    this.email,
    this.avatarUrl,
    this.phone,
    this.upiId,
    this.createdAt,
    this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? phone,
    String? upiId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      upiId: upiId ?? this.upiId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
