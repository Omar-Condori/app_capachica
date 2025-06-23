class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phone;
  final String? country;
  final String? birthDate;
  final String? address;
  final String? gender;
  final String? preferredLanguage;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
    this.country,
    this.birthDate,
    this.address,
    this.gender,
    this.preferredLanguage,
  });

  Map<String, String> toMap() {
    final map = <String, String>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (phone != null) map['phone'] = phone!;
    if (country != null) map['country'] = country!;
    if (birthDate != null) map['birth_date'] = birthDate!;
    if (address != null) map['address'] = address!;
    if (gender != null) map['gender'] = gender!;
    if (preferredLanguage != null) map['preferred_language'] = preferredLanguage!;
    return map;
  }
}

class LoginResponse {
  final String? token;
  final String? message;
  final User? user;

  LoginResponse({this.token, this.message, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'],
    message: json['message'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'message': message,
    'user': user?.toJson(),
  };
}

class User {
  final int id;
  final String? name;
  final String email;

  User({required this.id, this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}