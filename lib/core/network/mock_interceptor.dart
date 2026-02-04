import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Simulamos un pequeño delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // 1. INTERCEPTAR LOGIN
    if (options.path.contains('/auth/oidc/token') && options.method == 'POST') {
      final data = options.data;

      // Validamos las credenciales que usaste: demo@interligo.com / demo123
      if (data['email'] == 'demo@interligo.com' &&
          data['password'] == 'demo123') {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              "access_token": "mock_access_token_12345",
              "refresh_token": "mock_refresh_token_67890",
              "expires_in": 3600,
            },
          ),
        );
      } else {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'message': 'Credenciales inválidas'},
            ),
          ),
        );
      }
    }

    // 2. INTERCEPTAR CUENTAS (Dashboard)
    if (options.path.contains('/accounts') && options.method == 'GET') {
      // Si la URL contiene "transactions", devolvemos transacciones
      if (options.path.contains('transactions')) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: [
              {
                "id": "txn_001",
                "account_id": "acc_001",
                "date": DateTime.now()
                    .subtract(const Duration(days: 1))
                    .toIso8601String(),
                "amount": -150.00,
                "description": "Pago Netflix",
                "type": "expense",
              },
              {
                "id": "txn_002",
                "account_id": "acc_001",
                "date": DateTime.now()
                    .subtract(const Duration(days: 2))
                    .toIso8601String(),
                "amount": 2500.00,
                "description": "Sueldo",
                "type": "income",
              },
            ],
          ),
        );
      }

      // Si no, devolvemos la lista de cuentas
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              "id": "acc_001",
              "alias": "Cuenta Principal",
              "currency": "USD",
              "available_balance": 15000.50,
              "ledger_balance": 15500.00,
            },
            {
              "id": "acc_002",
              "alias": "Ahorros",
              "currency": "PEN",
              "available_balance": 5000.00,
              "ledger_balance": 5000.00,
            },
          ],
        ),
      );
    }

    // Si no coincide con nada, dejamos que falle o devolvemos 404
    handler.next(options);
  }
}
