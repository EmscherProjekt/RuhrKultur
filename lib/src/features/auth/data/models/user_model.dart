import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruhrkultur/src/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0) // Correct annotation here
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(3)
  final String token;

  UserModel({required this.id, required this.email, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }

  User toEntity() {
    return User(id: id, email: email, token: token);
  }

  static UserModel fromEntity(User user) {
    return UserModel(id: user.id, email: user.email, token: user.token);
  }
}
