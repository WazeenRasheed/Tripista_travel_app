class UserModal {
  int? id;
  final String name;
  final String mail;
  final String password;
  late final String? image;

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
