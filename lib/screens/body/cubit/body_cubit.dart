import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/repositories/body_repository.dart';

part 'body_state.dart';

class BodyCubit extends Cubit<BodyState> {
  BodyCubit(this._bodyRepository) : super(BodyState());

  final BodyRepository _bodyRepository;

  Future<void> fetchBody() async {
    try {
      final body = await _bodyRepository.getBodyLatest();
      emit(state.copyWith(status: BodyStatus.success, body: body));
    } on Exception {
      emit(state.copyWith(status: BodyStatus.failure));
    }
  }
}
