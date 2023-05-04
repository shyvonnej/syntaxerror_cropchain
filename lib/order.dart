// ignore_for_file: non_constant_identifier_names

class Order{
  String? orderid;
  // String? billid;
  String? date_order;
  String? totalprice;
  bool status = false;


  Order({
      required this.orderid,
      // required this.billid,
      required this.date_order,
      required this.totalprice,
      required this.status,
    }
  );

    Order.fromJson(Map<String, dynamic> json){
    orderid = json['order']['order_id'];
    // billid = json['order']['bill_id'];
    date_order = json['order']['date_order'];
    totalprice = json['order']['total_price'];
    status = json['status'] == true || json['status'] == 1;  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderid;
    // data['bill_id'] = billid;
    data['date_order'] = date_order;
    data['total_price'] = totalprice;
    return data;
  }
}