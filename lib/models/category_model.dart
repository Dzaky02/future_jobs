class CategoryModel {
  String id;
  String name;
  String imageUrl;
  int createdAt;
  int updatesAt;

  CategoryModel({
    this.id,
    this.name,
    this.imageUrl,
    this.createdAt,
    this.updatesAt,
  });
  
  CategoryModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
    this.createdAt = json['createdAt'];
    this.updatesAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
      'updatesAt': this.updatesAt,
    };
  }
}
