enum CurrentScreen {
  openingBalance,
  crm,
  sale,
  // recentSales,
  // creditSales,
  // dayClosing,
  // expense,
  // payBack,
  settings;

  String get syncMessage {
    return switch (this) {
      CurrentScreen.openingBalance => "",
      CurrentScreen.crm => "Syncing Customers",
      CurrentScreen.sale => "Syncing Sale Data",
      // CurrentScreen.recentSales => "Syncing recent sale data",
      // CurrentScreen.creditSales => "Syncing Credit sale data",
      // CurrentScreen.dayClosing => "Syncing day closing data",
      // CurrentScreen.expense => "Syncing expence data",
      // CurrentScreen.payBack => "",
      CurrentScreen.settings => "",
    };
  }

  static CurrentScreen fromIndex(int index) {
    return values.elementAt(index);
  }
}

enum PaymentMode {
  cash(1),
  card(2),
  credit(3),
  split(4);

  final int value;
  const PaymentMode(this.value);
}

enum UserType {
  superAdmin(1),
  mainAdmin(2),
  branchAdmin(3),
  counterSales(4);

  final int value;
  const UserType(this.value);
}

enum DiscountType {
  byPercentage(1, 'By Percentage'),
  byAmount(2, 'By Amount');

  final int value;
  final String label;
  const DiscountType(this.value, this.label);
}
