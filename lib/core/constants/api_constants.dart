class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://interligo-api.onrender.com/api/v1';

  // Auth
  static const String authToken = '/auth/oidc/token';
  static const String authRefresh = '/auth/oidc/refresh';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';

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
