// ignore_for_file: non_constant_identifier_names

class Inventory{
  String? batchid;
  String? batchnum;
  String? quantity;
  String? date_of_production;
  String? best_before_date;
  String? productid;

  Inventory({
      required this.batchid,
      required this.batchnum,
      required this.quantity,
      required this.date_of_production,
      required this.best_before_date,
    }
  );

    Inventory.fromJson(Map<String, dynamic> json){
    batchid = json['batch_id'];
    batchnum = json['batch_num'];
    quantity = json['quantity'];
    date_of_production = json['date_of_production'];
    best_before_date = json['best_before_date'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['batch_id'] = batchid;
    data['batch_num'] = batchnum;
    data['quantity'] = quantity;
    data['date_of_production'] = date_of_production;
    data['best_before_date'] = best_before_date  ;
    return data;
  }
}