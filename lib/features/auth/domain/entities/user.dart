import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.photoUrl,
    this.isProfileComplete = false,
  });

  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool isProfileComplete;

  User copyWith({
    String? name,
    String? email,
    String? photoUrl,
    bool? isProfileComplete,
  }) =>
      User(
        id: id,
        phone: phone,
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      );

  @override
  List<Object?> get props => [id, phone, name, email, photoUrl, isProfileComplete];
}
