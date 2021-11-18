class UserModel {
  late String id;
  late String name;
  late String email;
  late String password;
  late String goal;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.goal});

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

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, password: $password, goal: $goal}';
  }
}
