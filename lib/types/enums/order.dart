enum Order {
  ascending,
  descending;

  String get text => switch (this) {
        Order.ascending => 'Asc.',
        Order.descending => 'Desc.',
      };
}
