class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? required(String? value, {String fieldName = 'Este campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'El monto es requerido';
    }
    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) {
      return 'Ingresa un monto válido';
    }
    if (amount <= 0) {
      return 'El monto debe ser mayor a 0';
    }
    return null;
  }

  static String? minAmount(String? value, double minAmount) {
    final baseValidation = amount(value);
    if (baseValidation != null) return baseValidation;

    final parsedAmount = double.parse(value!.replaceAll(',', '.'));
    if (parsedAmount < minAmount) {
      return 'El monto mínimo es \$${minAmount.toStringAsFixed(2)}';
    }
    return null;
  }

  static String? maxAmount(String? value, double maxAmount) {
    final baseValidation = amount(value);
    if (baseValidation != null) return baseValidation;

    final parsedAmount = double.parse(value!.replaceAll(',', '.'));
    if (parsedAmount > maxAmount) {
      return 'El monto máximo es \$${maxAmount.toStringAsFixed(2)}';
    }
    return null;
  }
}
