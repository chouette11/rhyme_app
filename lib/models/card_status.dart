enum CardStatus { stock, used, trash }

extension CardStatusX on CardStatus {
  String get key => switch (this) {
        CardStatus.stock => 'stock',
        CardStatus.used => 'used',
        CardStatus.trash => 'trash',
      };

  static CardStatus fromKey(String? key) {
    switch (key) {
      case 'used':
        return CardStatus.used;
      case 'trash':
        return CardStatus.trash;
      case 'stock':
      default:
        return CardStatus.stock;
    }
  }
}
