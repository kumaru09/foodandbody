import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/home/home.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUser extends Mock implements User {}

void main() {
  const logoutButtonKey = Key('homePage_logout_iconButton');
  const menuAllButtonKey = Key('menu_all_button');
  group('Home Page', () {
    late AppBloc appBloc;
    late User user;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    group("has a page", () {
      test("has a page", () {
        expect(Home.page(), isA<MaterialPage>());
      });
    }); //group "has a page"

    group("calls", () {
      testWidgets("AppLogoutRequested when logout out is pressed",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(logoutButtonKey));
          verify(() => appBloc.add(AppLogoutRequested())).called(1);
        });
      }); //test "AppLogoutRequested when logout out is pressed"
    }); //group "calls"

    group("render", () {
      
    }); //group "render"
  }); //group "Home Page"
} //main
