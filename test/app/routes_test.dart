import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/app/routes.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/register/verify_email.dart';
import 'package:test/test.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [MainScreenPage] when authenticated', () {
      expect(onGenerateAppViewPages(AppStatus.authenticated, []), [
        isA<MaterialPage>().having((p) => p.child, 'child', isA<MainScreen>())
      ]);
    });

    test('returns [VerifyEmailPage] when notverified', () {
      expect(onGenerateAppViewPages(AppStatus.notverified, []), [
        isA<MaterialPage>().having((p) => p.child, 'child', isA<VerifyEmail>())
      ]);
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<Login>())],
      );
    });
  });
}
