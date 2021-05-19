class UserModel {
  String id;
  String email;
  String password;
  String name;
  String goal;

  UserModel({this.id, this.email, this.password, this.name, this.goal});

  UserModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.email = json['email'];
    this.password = json['password'];
    this.name = json['name'];
    this.goal = json['goal'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'emial': this.email,
      'password': this.password,
      'name': this.name,
      'goal': this.goal,
    };
  }
}
