import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/register/verify_email.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppState extends Fake implements AppState {}

class FakeAppEvent extends Fake implements AppEvent {}

class MockFirebaseDynamicLinks extends Mock implements FirebaseDynamicLinks {}

class MockPendingDynamicLinkData extends Mock
    implements PendingDynamicLinkData {}

class MockUri extends Mock implements Uri {}

typedef Callback(MethodCall call);

setupCloudFirestoreMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
            'storageBucket': 'myapp.appspot.com',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

void main() {
  group('VerifyEmail', () {
    late AuthenRepository authenRepository;
    late AppBloc appBloc;
    // late FirebaseDynamicLinks firebaseDynamicLinks;
    // late PendingDynamicLinkData pendingDynamicLinkData;
    // late Uri uri;

    setupCloudFirestoreMocks();

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<AppEvent>(FakeAppEvent());
    });

    setUp(() {
      appBloc = MockAppBloc();
      authenRepository = MockAuthenRepository();
      when(() => authenRepository.sendVerifyEmail()).thenAnswer((_) async {});
      // firebaseDynamicLinks = MockFirebaseDynamicLinks();
      // pendingDynamicLinkData = MockPendingDynamicLinkData();
      // uri = MockUri();
      //   when(()=> firebaseDynamicLinks.getInitialLink()).thenAnswer((_) async {return pendingDynamicLinkData;});
      // when(()=> pendingDynamicLinkData.link).thenReturn(uri);
      // when(()=> uri.queryParameters['oobCode']).thenReturn('actionCode');

      // when(() => firebaseDynamicLinks.getInitialLink())
      //     .thenAnswer((_) async {});
      // when(()=> firebaseDynamicLinks.onLink.listen(any())).thenAnswer((_) async {});
    });

    testWidgets(
        'calls authenRepository sendVerifyEmail when pressed send again button',
        (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenRepository,
          child: BlocProvider.value(
            value: appBloc,
            child: MaterialApp(
              home: Scaffold(
                body: VerifyEmail(),
              ),
            ),
          ),
        ),
      );
      expect(find.text('ส่งอีกครั้ง'), findsOneWidget);
      await tester.tap(find.text('ส่งอีกครั้ง'));
      await tester.pump();
      expect(find.text('รอสักครู่ | 30'), findsOneWidget);
      verify(() => authenRepository.sendVerifyEmail()).called(1);
    });

    group('render', () {
      testWidgets('all widget correct', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider.value(
            value: authenRepository,
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: Scaffold(
                  body: VerifyEmail(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('ลงทะเบียน'), findsOneWidget);
        expect(
            find.text(
                '''ระบบได้ส่งข้อความไปที่อีเมลของคุณแล้ว\nกรุณายืนยันตัวตนเพื่อลงทะเบียน'''),
            findsOneWidget);
        expect(find.byType(ArgonTimerButton), findsOneWidget);
        expect(find.text('ส่งอีกครั้ง'), findsOneWidget);
      });

      testWidgets('waiting button when pressed send again button',
          (tester) async {
        await tester.pumpWidget(
          RepositoryProvider.value(
            value: authenRepository,
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: Scaffold(
                  body: VerifyEmail(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('ส่งอีกครั้ง'), findsOneWidget);
        await tester.tap(find.text('ส่งอีกครั้ง'));
        await tester.pump();
        expect(find.text('รอสักครู่ | 30'), findsOneWidget);
      });

      testWidgets('send again button when time out', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider.value(
            value: authenRepository,
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: Scaffold(
                  body: VerifyEmail(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ส่งอีกครั้ง'));
        await tester.pump();
        expect(find.text('รอสักครู่ | 30'), findsOneWidget);
        await tester.pumpAndSettle(Duration(seconds: 30));
        expect(find.text('ส่งอีกครั้ง'), findsOneWidget);
      });
    });
  });
}
