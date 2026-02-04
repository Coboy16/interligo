# Interligo – Entrega de Reto Técnico

Este proyecto es una aplicación desarrollada en Flutter como entrega de un reto técnico. La app simula una experiencia bancaria e implementa funcionalidades clave siguiendo buenas prácticas de arquitectura y desarrollo moderno en Flutter.

## Descripción general

La aplicación permite autenticación de usuarios, visualización de cuentas, movimientos, transferencias, control de tarjetas y lectura de información en modo offline, utilizando una arquitectura limpia y un enfoque desacoplado por capas.

## Alcance funcional implementado

De acuerdo con los requerimientos del reto, se implementaron los siguientes módulos:

* **Autenticación** - Autenticación basada en tokens. La comunicación con la API se realiza mediante Dio.
* **Dashboard** - Listado de cuentas con su respectivo balance.
* **Movimientos** - Listado paginado de transacciones por cuenta.
* **Transferencias** - Flujo de transferencia a un beneficiario simulado, con pantalla de revisión y confirmación.
* **Tarjeta** - Funcionalidad para congelar y descongelar una tarjeta con confirmación previa.
* **Modo offline (solo lectura)** - Se almacena el último estado conocido de:
  * Cuentas
  * Movimientos
  * Tarjetas usando una base de datos local con drift (SQLite).
* **Notificaciones in-app** - Mensajes informativos simples mediante fluttertoast.
* **Estados de UX** - Manejo de estados de carga, error, vacío y reintento, utilizando flutter_bloc y skeletonizer para indicadores de carga.

## Usuarios de prueba

La aplicación incluye usuarios de demostración:

* `demo@inteligo.com` - Contraseña: `demo123`
* `marcotimanag@gmail.com` - Contraseña: `Marco123`

## Requerimientos técnicos implementados

### Arquitectura

Se utiliza Clean Architecture, separando claramente las responsabilidades por capas.

Estructura simplificada:
```
lib/
 ├─ core/
 │   ├─ router/
 │   ├─ error/        (failures, excepciones)
 │   └─ constants/
 └─ features/
     └─ <feature>/
         ├─ data/
         │   ├─ datasources
         │   ├─ models
         │   └─ repositories
         ├─ domain/
         │   ├─ entities
         │   ├─ repositories
         │   └─ usecases
         └─ presentation/
             ├─ bloc/
             ├─ pages
             └─ widgets
```

### Características técnicas

* **Gestión de estado** - BLoC junto con Equatable para comparación eficiente de estados y eventos.
* **Inyección de dependencias** - Implementada con get_it.
* **Almacenamiento local**
  * Cache de lectura con drift (SQLite).
  * Manejo seguro de tokens con flutter_secure_storage.
* **Seguridad mínima**
  * Tokens almacenados de forma segura.
  * Firma de la aplicación Android configurada mediante keystore (`.jks`).
* **Pruebas**
  * Tests unitarios en las capas de data, domain y presentation.
  * Uso de `flutter_test`, `mocktail` y `bloc_test`.
  * Se añadieron más de 5 pruebas unitarias relevantes durante el desarrollo.
* **CI/CD básico**
  * No se incluye pipeline dentro del repositorio (se asume integración externa).
* **Documentación**
  * Este `README.md` actúa como documentación breve.
  * Las decisiones de arquitectura se describen de forma resumida (ver `architecture.md` / ADR).

## Puesta en marcha

### Requisitos

* Flutter SDK
* JDK (para Android)

### Instalación
```bash
git clone <repository_url>
cd interligo
flutter pub get
```

Generar código (drift y otros):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ejecución

Modo debug:
```bash
flutter run
```

Generar APK release:
```bash
flutter build apk --release
```

El APK se genera en:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Pruebas
```bash
flutter test
```

## Decisiones de desarrollo (resumen)

* `flutter_bloc` + `Equatable` se eligieron para garantizar un flujo de estados predecible y testeable.
* Clean Architecture permite aislar la lógica de negocio de la infraestructura y de la UI, facilitando el mantenimiento y la escalabilidad.
* `drift` se utiliza como solución local tipada y segura para soportar lectura offline.
* El flujo de autenticación simula un escenario OAuth2 / OIDC con PKCE, simplificado para el contexto del reto.