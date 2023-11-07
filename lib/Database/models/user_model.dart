class UserModal {
  int? id;
  String name;
  String mail;
  String password;
  String? image;

  UserModal(
      {required this.name,
      required this.mail,
      required this.password,
      this.image,
      this.id});

// convert map into usermodel obj
  static UserModal fromJson(map) {
    return UserModal(
      id: map['id'] as int,
      name: map['name'] as String,
      mail: map['mail'] as String,
      password: map['password'] as String,
      image: map['image'] as String,
    );
  }
}
