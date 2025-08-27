class UserModel {
  int id;
  String name;
  String password;
  int type;
  int branchId;
  String branchName;
  String? localImagePath;
  String? branchLogo;
  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.type,
    required this.branchId,
    required this.branchName,
    this.localImagePath,
    this.branchLogo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': name,
      'password': password,
      'type': type,
      'branch_id': branchId,
      'branch_name': branchName,
      'local_image_path': localImagePath,
      'branch_logo': branchLogo
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['username'] as String,
      password: map['password'] as String,
      type: map['type'] as int,
      branchId: map['branch_id'] as int,
      branchName: map['branch_name'] as String,
      branchLogo: map['branch_logo'] as String,
      localImagePath: map['local_image_path'] as String? ?? "",
    );
  }
}
