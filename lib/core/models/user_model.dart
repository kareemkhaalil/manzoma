class UserModel {
  String employeeId;
  String name;
  String role; // manager/worker
  String password;
  String userName;
  String email;

  UserModel({
    required this.employeeId,
    required this.name,
    required this.role,
    required this.password,
    required this.userName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      employeeId: json['employee_id'] ?? docId,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      password: json['password'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'name': name,
      'role': role,
      'password': password,
      'userName': userName,
      'email': email,
    };
  }

  UserModel copyWith({
    String? employeeId,
    String? name,
    String? role,
    String? password,
    String? userName,
    String? email,
  }) {
    return UserModel(
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      role: role ?? this.role,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}
