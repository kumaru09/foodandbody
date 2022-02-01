import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    on<ReFetched>(_onReFetched, transformer: debounce(_duration));
  }

  final SearchRepository searchRepository;
  int numpage = 1;
  String keySearch = '';
  String text = '';
  List<String> filter = [];

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.text == '' && event.selectFilter == []) {
      text = '';
      filter = [];
      return emit(state.copyWith(status: SearchStatus.initial));
    }
    //ทำเมื่อ search คำใหม่ หรือ filter ใหม่ หรือ คำเดิม filter เดืมที่ยังแสดงไม่หมด
    if (event.text != text ||
        !ListEquality().equals(event.selectFilter, filter) ||
        state.hasReachedMax == false) {
      try {
        //ถ้าเป็นคำใหม่หรือ filter ใหม่จะกำหนด querypage 1 เก็บ keySearch ใหม่
        //ถ้าคำเดิมและ filter เดิมจะเพิ่ม querypage +1
        if (event.text != text || event.selectFilter != filter) {
          numpage = 1;
          text = event.text;
          filter = List.from(event.selectFilter);
          String filterText = '';
          if (filter != []) for (var item in filter) filterText += 'c=$item&';
          keySearch = '$filterText${text != '' ? 'name=$text&' : ''}';
          emit(state.copyWith(status: SearchStatus.loading));
        } else
          numpage += 1;
        final results =
            await searchRepository.search('${keySearch}querypage=$numpage');
        emit(
          state.copyWith(
            status: SearchStatus.success,
            result: numpage == 1
                ? results
                : (List.of(state.result)..addAll(results)),
            hasReachedMax: results.length < 10 ? true : false,
          ),
        );
      } catch (error) {
        print('e: $error');
        emit(state.copyWith(status: SearchStatus.failure));
      }
    }
  }

  Future<void> _onReFetched(
    ReFetched event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final results =
          await searchRepository.search('${keySearch}querypage=$numpage');
      emit(
        state.copyWith(
          status: SearchStatus.success,
          result:
              numpage == 1 ? results : (List.of(state.result)..addAll(results)),
          hasReachedMax: results.length < 10 ? true : false,
        ),
      );
    } catch (error) {
      print('e: $error');
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }
}
