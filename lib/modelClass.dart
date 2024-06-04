class ModelClass {
  final String? email;
  final String? password;
  final String? uID;

  ModelClass({required this.email, required this.password, required this.uID});

  factory ModelClass.fromFireBase(Map map) {
    return ModelClass(
        email: map['E-mail'], password: map['password'], uID: map['uId']);
  }
}
