class JobModel {
  late String id;
  late String name;
  late String category;
  late String companyName;
  late String companyLogo;
  late String location;
  late List about;
  late List qualifications;
  late List responsibilities;
  late int createdAt;
  late int updatedAt;

  JobModel({
    required this.id,
    required this.name,
    required this.category,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.about,
    required this.qualifications,
    required this.responsibilities,
    required this.createdAt,
    required this.updatedAt,
  });

  JobModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.category = json['category'];
    this.companyName = json['companyName'];
    this.companyLogo = json['companyLogo'];
    this.location = json['location'];
    this.about = json['about'];
    this.qualifications = json['qualifications'];
    this.responsibilities = json['responsibilities'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'category': this.category,
      'companyName': this.companyName,
      'companyLogo': this.companyLogo,
      'location': this.location,
      'about': this.about,
      'qualifications': this.qualifications,
      'responsibilities': this.responsibilities,
      'createdAt': this.createdAt,
      'updatesAt': this.updatedAt,
    };
  }
}
