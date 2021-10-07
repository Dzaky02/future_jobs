class CategoryModel {
  late String id;
  late String name;
  late String imageUrl;
  late int createdAt;
  late int updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
      'updatesAt': this.updatedAt,
    };
  }
}
