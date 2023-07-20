class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? credit;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.credit,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['credit'] = credit;
    return data;
  }
}
