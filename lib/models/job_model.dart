class JobModel {
  String id;
  String name;
  String category;
  String companyName;
  String companyLogo;
  String location;
  List<String> about;
  List<String> qualifications;
  List<String> responsibiities;
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
    this.responsibiities,
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
    this.responsibiities = json['responsibiities'];
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
      'responsibiities': this.responsibiities,
      'createdAt': this.createdAt,
      'updatesAt': this.updatedAt,
    };
  }
}
