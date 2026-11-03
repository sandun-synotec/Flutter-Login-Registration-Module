class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? token;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.token,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      token: json['token'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      if (token != null) 'token': token,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ phone.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone)';
  }
}
