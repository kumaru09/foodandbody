import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/register/register.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenRepository {}

void main() {
  group('RegisterPage', () {
    test('has a route', () {
      expect(Register.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a RegisterForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: MaterialApp(home: Register()),
        ),
      );
      expect(find.byType(Register), findsOneWidget);
    });
  });
}