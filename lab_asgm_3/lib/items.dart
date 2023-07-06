class Item {
  String? itemId;
  String? userId;
  String? itemTitle;
  String? itemDescription;
  String? itemType;
  String? itemPrice;
  String? itemState;
  String? itemLat;
  String? itemLong;
  String? itemLocality;
  String? itemDate;

  Item(
      {this.itemId,
      this.userId,
      this.itemTitle,
      this.itemDescription,
      this.itemType,
      this.itemPrice,
      this.itemState,
      this.itemLat,
      this.itemLong,
      this.itemLocality,
      this.itemDate});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemTitle = json['item_title'];
    itemDescription = json['item_description'];
    itemType = json['item_type'];
    itemPrice = json['item_price'];
    itemState = json['item_state'];
    itemLat = json['item_lat'];
    itemLong = json['item_long'];
    itemLocality = json['item_locality'];
    itemDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_title'] = itemTitle;
    data['item_description'] = itemDescription;
    data['item_type'] = itemType;
    data['item_price'] = itemPrice;
    data['item_state'] = itemState;
    data['item_lat'] = itemLat;
    data['item_long'] = itemLong;
    data['item_locality'] = itemLocality;
    data['item_date'] = itemDate;
    return data;
  }
}
