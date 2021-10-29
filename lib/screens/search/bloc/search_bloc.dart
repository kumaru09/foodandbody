import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const _duration = const Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchRepository}) : super(SearchState()) {
    on<TextChanged>(_onTextChanged, transformer: debounce(_duration));
  }

  final SearchRepository searchRepository;
  int numpage = 1;
  String keySearch = '';

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.text=='') return emit(state.copyWith(status: SearchStatus.initial));
    //ทำเมื่อ search คำใหม่ หรือ คำเดิมที่ยังแสดงไม่หมด
    if (event.text != keySearch || state.hasReachedMax == false) {
      try {
        //ถ้าไม่ใช้คำเดิมจะ search page 1 เก็บ keySearch เป็นคำใหม่
        //ถ้าคำเดิมจะเพิ่ม page +1
        if (event.text != keySearch) {
          numpage = 1;
          keySearch = event.text;
          emit(state.copyWith(status: SearchStatus.loading));
        } else numpage += 1;
        final results = await searchRepository.search('$keySearch?querypage=$numpage');
        emit(
          state.copyWith(
            status: SearchStatus.success,
            result: numpage == 1 ? results : (List.of(state.result)..addAll(results)),
            hasReachedMax: results.length < 10 ? true : false,
          ),
        );
      } catch (error) {
        print('e: $error');
        emit(state.copyWith(status: SearchStatus.failure));
      }
    }
  }
}
