class CardModel {
  String? cardName;
  String? cardNumber;
  String? cardMonth;
  String? cardYear;
  String? cardCvv;
  String? cardType;
  String? cardDatereg;

  CardModel({
    this.cardName,
    this.cardNumber,
    this.cardMonth,
    this.cardYear,
    this.cardCvv,
    this.cardType,
    this.cardDatereg,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    cardName = json['card_name'];
    cardNumber = json['card_number'];
    cardMonth = json['card_month'];
    cardYear = json['card_year'];
    cardCvv = json['card_cvv'];
    cardType = json['card_type'];
    cardDatereg = json['card_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_name'] = cardName;
    data['card_number'] = cardNumber;
    data['card_month'] = cardMonth;
    data['card_year'] = cardYear;
    data['card_cvv'] = cardCvv;
    data['card_type'] = cardType;
    data['card_datereg'] = cardDatereg;
    return data;
  }
}
