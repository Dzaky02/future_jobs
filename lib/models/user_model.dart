class UserModel {
  String id;
  String name;
  String email;
  String password;
  String goal;

  UserModel({this.id, this.name, this.email, this.password, this.goal});

  UserModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.email = json['email'];
    this.password = json['password'];
    this.goal = json['goal'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'goal': this.goal,
    };
  }
}
