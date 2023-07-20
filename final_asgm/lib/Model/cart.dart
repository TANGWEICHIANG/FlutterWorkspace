class Cart {
  String? cartId;
  String? itemId;
  String? itemTitle;
  String? cartPrice;
  String? userId;
  String? barterId;
  String? cartDate;

  Cart(
      {this.cartId,
      this.itemId,
      this.itemTitle,
      this.cartPrice,
      this.userId,
      this.barterId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    itemId = json['item_id'];
    itemTitle = json['item_title'];
    cartPrice = json['cart_price'];
    userId = json['user_id'];
    barterId = json['barter_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    data['item_title'] = itemTitle;
    data['cart_price'] = cartPrice;
    data['user_id'] = userId;
    data['barter_id'] = barterId;
    data['cart_date'] = cartDate;
    return data;
  }
}
