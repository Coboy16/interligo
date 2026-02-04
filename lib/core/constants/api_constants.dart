class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:3000/api';

  // Auth
  static const String authToken = '/auth/oidc/token';

  // Accounts
  static const String accounts = '/accounts';
  static String accountTransactions(String id) => '/accounts/$id/transactions';

  // Beneficiaries
  static const String beneficiaries = '/beneficiaries';

  // Transfers
  static const String transfers = '/transfers';
  static String confirmTransfer(String id) => '/transfers/$id/confirm';

  // Cards
  static const String cards = '/cards';
  static String card(String id) => '/cards/$id';
}
