class Product {
  String? id;
  String? name;
  String? price;
  String? imageUrl;
  String? detail;

  Product({this.id, this.name, this.price, this.imageUrl, this.detail});

  Product.empty();

  factory Product.fromJson(dynamic data) {
    return Product(
        id: data['id'],
        name: data['name'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        detail: data['detail']);
  }

  Object? toJson() {
    return null;
  }
}
