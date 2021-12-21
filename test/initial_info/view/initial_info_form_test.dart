import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/age.dart';
import 'package:foodandbody/models/exercise.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:foodandbody/screens/initial_info/initial_info_form.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockInitialInfoCubit extends MockCubit<InitialInfoState>
    implements InitialInfoCubit {}

class FakeInitialInfoState extends Fake implements InitialInfoState {}

class MockUsername extends Mock implements Username {}

class MockWeight extends Mock implements Weight {}

class MockHeight extends Mock implements Height {}

class MockAge extends Mock implements Age {}

class MockGender extends Mock implements Gender {}

class MockExercise extends Mock implements Exercise {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  const initialInfoButtonKey = Key('initialInfoForm_continue_raisedButton');
  const usernameInputKey = Key('initialInfoForm_usernameInput_textField');
  const weightInputKey = Key('initialInfoForm_weightInput_textField');
  const heightInputKey = Key('initialInfoForm_heightInput_textField');
  const ageInputKey = Key('initialInfoForm_ageInput_textField');
  const genderInputKey = Key('initialInfoForm_genderInput_textField');
  const exerciseInputKey = Key('initialInfoForm_exerciseInput_textField');

  const testUsername = 'test_name123';
  const testWeight = '50';
  const testHeight = '150';
  const testAge = '25';
  const testGender = 'หญิง';
  const testExercise = 'ออกกำลังกายกลาง 3-5 วันต่อสัปดาห์';
  const testUid = 's1uskWSx4NeSECk8gs2R9bofrG23';

  group('InitialInfoForm', () {
    late InitialInfoCubit initialInfoCubit;
    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<InitialInfoState>(FakeInitialInfoState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      initialInfoCubit = MockInitialInfoCubit();
      when(() => initialInfoCubit.state).thenReturn(const InitialInfoState());
      when(() => initialInfoCubit.initialInfoFormSubmitted())
          .thenAnswer((_) async {});
      when(() => appBloc.state)
          .thenReturn(const AppState.authenticated(User(uid: testUid)));
    });

    group('calls', () {
      testWidgets('usernameChanged when username changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(usernameInputKey), testUsername);
        verify(() => initialInfoCubit.usernameChanged(testUsername)).called(1);
      });

      testWidgets('weightChanged when weight changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(weightInputKey), testWeight);
        verify(() => initialInfoCubit.weightChanged(testWeight)).called(1);
      });

      testWidgets('heightChanged when height changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(heightInputKey), testHeight);
        verify(() => initialInfoCubit.heightChanged(testHeight)).called(1);
      });

      testWidgets('ageChanged when age changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(ageInputKey), testAge);
        verify(() => initialInfoCubit.ageChanged(testAge)).called(1);
      });

      testWidgets('genderChanged when gender changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        var input1 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(genderInputKey));
        expect(input1.initialValue, null);

        await tester.tap(find.byKey(genderInputKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text(testGender).last);
        await tester.pump();

        var input2 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(genderInputKey));
        expect(input2.initialValue, 'F');
      });

      testWidgets('exerciseChanged when exercise changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.dragFrom(Offset(0, 300), Offset(0, -300));
        var input1 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(exerciseInputKey));
        expect(input1.initialValue, null);

        await tester.tap(find.byKey(exerciseInputKey));
        await tester.pump();
        await tester.tap(find.text(testExercise).last);
        await tester.pump();

        var input2 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(exerciseInputKey));
        expect(input2.initialValue, '1.55');
      });

      testWidgets('initialInfoFormSubmitted when save button is pressed',
          (tester) async {
        when(() => initialInfoCubit.state).thenReturn(
          const InitialInfoState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
                body: BlocProvider.value(
              value: appBloc,
              child: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            )),
          ),
        );
        await tester.dragFrom(Offset(0, 300), Offset(0, -300));
        await tester.tap(find.byKey(initialInfoButtonKey));
        verify(() => initialInfoCubit.initialInfoFormSubmitted())
            .called(1);
      });
    });

    group('renders', () {
      testWidgets('InitialInfo Failure SnackBar when submission fails',
          (tester) async {
        whenListen(
          initialInfoCubit,
          Stream.fromIterable(const <InitialInfoState>[
            InitialInfoState(status: FormzStatus.submissionInProgress),
            InitialInfoState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
            find.text('กรอกข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง'), findsOneWidget);
      });

      testWidgets('invalid username error text when username is invalid',
          (tester) async {
        final username = MockUsername();
        when(() => username.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(username: username));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุชื่อผู้ใช้งาน'), findsOneWidget);
      });

      testWidgets('invalid weight error text when weight is invalid',
          (tester) async {
        final weight = MockWeight();
        when(() => weight.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(weight: weight));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุน้ำหนักให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid height error text when height is invalid',
          (tester) async {
        final height = MockHeight();
        when(() => height.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(height: height));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุส่วนสูงให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid age error text when age is invalid',
          (tester) async {
        final age = MockAge();
        when(() => age.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(age: age));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุอายุให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid gender error text when gender is invalid',
          (tester) async {
        final gender = MockGender();
        when(() => gender.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(gender: gender));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุเพศของคุณ'), findsOneWidget);
      });

      testWidgets('invalid exercise error text when exercise is invalid',
          (tester) async {
        final exercise = MockExercise();
        when(() => exercise.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(exercise: exercise));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุการออกกำลังกายของคุณ'), findsOneWidget);
      });

      testWidgets('disabled save button when status is not validated',
          (tester) async {
        when(() => initialInfoCubit.state).thenReturn(
          const InitialInfoState(status: FormzStatus.invalid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        final initialInfoButton = tester.widget<ElevatedButton>(
          find.byKey(initialInfoButtonKey),
        );
        expect(initialInfoButton.enabled, isFalse);
      });

      testWidgets('enabled save button when status is validated',
          (tester) async {
        when(() => initialInfoCubit.state).thenReturn(
          const InitialInfoState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: initialInfoCubit,
                child: const InitialInfoForm(),
              ),
            ),
          ),
        );
        final initialInfoButton = tester.widget<ElevatedButton>(
          find.byKey(initialInfoButtonKey),
        );
        expect(initialInfoButton.enabled, isTrue);
      });
    });
  });
}
