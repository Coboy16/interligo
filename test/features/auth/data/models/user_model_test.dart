import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:interligo/features/auth/data/models/user_model.dart';
import 'package:interligo/features/auth/domain/entities/user_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tUserModel = UserModel(
    id: '123',
    username: 'testuser',
    email: 'test@example.com',
    name: 'Test User',
  );

  group('UserModel', () {
    test('should be a subclass of UserEntity', () async {
      expect(tUserModel, isA<UserEntity>());
    });

    group('fromJson', () {
      test('should return a valid UserModel from JSON with full data',
          () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('auth/user.json'));

        // Act
        final result = UserModel.fromJson(jsonMap);

        // Assert
        expect(result, tUserModel);
      });

      test('should return a valid UserModel from JSON with missing name',
          () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('auth/user_no_name.json'));
        const tUserModelNoName = UserModel(
          id: '123',
          username: 'testuser',
          email: 'test@example.com',
          name: null,
        );

        // Act
        final result = UserModel.fromJson(jsonMap);

        // Assert
        expect(result, tUserModelNoName);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // Act
        final result = tUserModel.toJson();

        // Assert
        final expectedMap = {
          'id': '123',
          'username': 'testuser',
          'email': 'test@example.com',
          'name': 'Test User',
        };
        expect(result, expectedMap);
      });

      test('should return a JSON map containing proper data even if name is null',
          () async {
        // Arrange
        const tUserModelNoName = UserModel(
          id: '123',
          username: 'testuser',
          email: 'test@example.com',
          name: null,
        );
        // Act
        final result = tUserModelNoName.toJson();

        // Assert
        final expectedMap = {
          'id': '123',
          'username': 'testuser',
          'email': 'test@example.com',
          'name': null,
        };
        expect(result, expectedMap);
      });
    });

    group('fromEntity', () {
      test('should return a valid UserModel from a UserEntity', () async {
        // Arrange
        const tUserEntity = UserEntity(
          id: '123',
          username: 'testuser',
          email: 'test@example.com',
          name: 'Test User',
        );

        // Act
        final result = UserModel.fromEntity(tUserEntity);

        // Assert
        expect(result, tUserModel);
      });
    });
  });
}
