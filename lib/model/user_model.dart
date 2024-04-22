class UserModel {
  final String name;
  final String email;
  final String age;
  final String password;

  UserModel({
    required this.age,
    required this.name,
    required this.password,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      email: map['phoneNo'] ?? '',
      age: map['phoneNo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phoneNo': email,
      'age': age,
    };
  }
}
