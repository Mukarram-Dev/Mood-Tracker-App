class UserModel {
  final String username;
  final String password;
  final String phoneNo;
  final String profileStatus;
  final String betProId;
  final String betProPassword;

  UserModel({
    required this.username,
    required this.password,
    required this.phoneNo,
    required this.profileStatus,
    required this.betProId,
    required this.betProPassword,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      profileStatus: map['profileStatus'] ?? '',
      betProId: map['betProId'] ?? '',
      betProPassword: map['betProPassword'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'phoneNo': phoneNo,
      'profileStatus': profileStatus,
      'betProId': betProId,
      'betProPassword': betProPassword,
    };
  }
}
