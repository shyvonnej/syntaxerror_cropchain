// ignore_for_file: non_constant_identifier_names

class Product{
  String? productid;
  String? name;
  String? shelf_life;
  String? total;
  String? price;

  Product({
      required this.productid,
      required this.name,
      required this.shelf_life,
      required this.total,
      required this.price,
    }
  );

    Product.fromJson(Map<String, dynamic> json){
    productid = json['product']['product_id'];
    name = json['product']['product_name'];
    shelf_life = json['product']['shelf_life'];
    total = json['product']['total_quantity'];
    price = json['product']['price'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productid;
    data['product_name'] = name;
    data['shelf_life'] = shelf_life;
    data['total_quantity'] = total;
    data['price'] = price;
    return data;
  }
}