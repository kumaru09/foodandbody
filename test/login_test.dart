import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:foodandbody/screens/login/login_form.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenRepository {}

void main() {
  group('LoginPage', () {
    test('has a page', () {
      expect(Login.page(), isA<MaterialPage>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: Login()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}