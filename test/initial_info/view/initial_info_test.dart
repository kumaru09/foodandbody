import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/initial_info/initial_info.dart';
import 'package:foodandbody/screens/initial_info/initial_info_form.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenRepository {}

void main() {
  group('Initial Info Page', () {
    test('has a page', () {
      expect(InitialInfo.page(), isA<MaterialPage>());
    });

    testWidgets('renders a InitialInfoForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: InitialInfo()),
        ),
      );
      expect(find.byType(InitialInfoForm), findsOneWidget);
    });
  });
}