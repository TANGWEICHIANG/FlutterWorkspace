class Order {
  String? orderId;
  String? orderBill;
  String? orderPaid;
  String? userId;
  String? sellerId;
  String? orderDate;

  Order({
    this.orderId,
    this.orderBill,
    this.orderPaid,
    this.userId,
    this.sellerId,
    this.orderDate,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderBill = json['order_bill'];
    orderPaid = json['order_paid'];
    userId = json['buyer_id'];
    sellerId = json['seller_id'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_bill'] = orderBill;
    data['order_paid'] = orderPaid;
    data['buyer_id'] = userId;
    data['seller_id'] = sellerId;
    data['order_date'] = orderDate;
    return data;
  }
}
