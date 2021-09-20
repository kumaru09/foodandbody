import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:foodandbody/screens/initial_info/initial_info_form.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenRepository {}

class MockInitialInfoCubit extends MockCubit<InitialInfoState>
    implements InitialInfoCubit {}

class FakeInitialInfoState extends Fake implements InitialInfoState {}

class MockUsername extends Mock implements Username {}

class MockWeight extends Mock implements Weight {}

class MockHeight extends Mock implements Height {}

class MockGender extends Mock implements Gender {}

class MockCalory extends Mock implements Calory {}

void main() {
  const initialInfoButtonKey = Key('initialInfoForm_continue_raisedButton');
  const usernameInputKey = Key('initialInfoForm_usernameInput_textField');
  const weightInputKey = Key('initialInfoForm_weightInput_textField');
  const heightInputKey = Key('initialInfoForm_heightInput_textField');
  const genderInputKey = Key('initialInfoForm_genderInput_textField');
  const caloryInputKey = Key('initialInfoForm_caloryInput_textField');

  const testUsername = 'test_name123';
  const testWeight = '50';
  const testHeight = '150';
  const testGender = 'หญิง';
  const testCalory = '1500';

  group('InitialInfoForm', () {
    late InitialInfoCubit initialInfoCubit;

    setUpAll(() {
      registerFallbackValue<InitialInfoState>(FakeInitialInfoState());
    });

    setUp(() {
      initialInfoCubit = MockInitialInfoCubit();
      when(() => initialInfoCubit.state).thenReturn(const InitialInfoState());
      when(() => initialInfoCubit.initialInfoFormSubmitted())
          .thenAnswer((_) async {});
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

        // await tester.tap(find.byKey(genderInputKey));
        await tester.tap(find.byKey(genderInputKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text(testGender).last);
        await tester.pump();

        var input2 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(genderInputKey));
        expect(input2.initialValue, 'F');

      });

      testWidgets('caloryChanged when calory changes', (tester) async {
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
        await tester.enterText(find.byKey(caloryInputKey), testCalory);
        verify(() => initialInfoCubit.caloryChanged(testCalory)).called(1);
      });

      testWidgets('initialInfoFormSubmitted when sign up button is pressed',
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
        await tester.tap(find.byKey(initialInfoButtonKey));
        verify(() => initialInfoCubit.initialInfoFormSubmitted()).called(1);
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
        expect(find.text('กรุณาระบุเพศ'), findsOneWidget);
      });

      testWidgets('invalid calory error text when calory is invalid',
          (tester) async {
        final calory = MockCalory();
        when(() => calory.invalid).thenReturn(true);
        when(() => initialInfoCubit.state)
            .thenReturn(InitialInfoState(calory: calory));
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
        expect(find.text('กรุณาระบุเป้าหมายแคลอรีให้ถูกต้อง'), findsOneWidget);
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

      testWidgets('enabled sign up button when status is validated',
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
