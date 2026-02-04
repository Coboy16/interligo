class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String accountDetail = 'account-detail';
  static const String transactions = 'transactions';
  static const String cards = 'cards';
  static const String cardDetail = 'card-detail';
  static const String selectBeneficiary = 'select-beneficiary';
  static const String transferAmount = 'transfer-amount';
  static const String transferReview = 'transfer-review';
  static const String transferConfirmation = 'transfer-confirmation';
}

class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String accountDetail = '/dashboard/account/:accountId';
  static const String transactions =
      '/dashboard/account/:accountId/transactions';
  static const String cards = '/cards';
  static const String cardDetail = '/cards/:cardId';
  static const String selectBeneficiary = '/transfer/beneficiary';
  static const String transferAmount = '/transfer/amount';
  static const String transferReview = '/transfer/review';
  static const String transferConfirmation = '/transfer/confirmation';
}
