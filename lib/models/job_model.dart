class JobModel {
  String id;
  String name;
  String category;
  String companyName;
  String companyLogo;
  String location;
  List about;
  List qualifications;
  List responsibilities;
  int createdAt;
  int updatedAt;

  JobModel({
    this.id,
    this.name,
    this.category,
    this.companyName,
    this.companyLogo,
    this.location,
    this.about,
    this.qualifications,
    this.responsibilities,
    this.createdAt,
    this.updatedAt,
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
