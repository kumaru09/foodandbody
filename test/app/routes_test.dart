import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/app/routes.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:test/test.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(onGenerateAppViewPages(AppStatus.authenticated, []),
      [isA<MaterialPage>().having((p) => p.child, 'child', isA<Home>())]);
    });

     test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<Login>())],
      );
    });
  });
}