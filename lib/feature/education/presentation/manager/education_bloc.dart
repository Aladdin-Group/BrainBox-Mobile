
import 'package:bloc/bloc.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:brain_box/feature/education/data/models/params.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../data/models/edu_model.dart';
import '../../domain/use_cases/get_edu_items_use_case.dart';
import '../../domain/use_cases/get_words_use_case.dart';

part 'education_event.dart';

part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final GetEduItemsUseCase getEduItemsUseCase = GetEduItemsUseCase();
  final GetEssentialWordsUseCase getEssentialWordsUseCase = GetEssentialWordsUseCase();

  EducationBloc() : super(const EducationState()) {
    on<ShowTranslationsEvent>(_showTranslationsEvent);
    on<ChangeWordFontSize>(_changeWordFontSizeEvent);
    on<GetEduItemsEvent>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await getEduItemsUseCase.call(state.page);

      if (result.isRight) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            list: result.right.results,
            count: result.right.count,
            page: state.page + 1));
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });
    on<GetMoreEduItemsEvent>((event, emit) async {
      final result = await getEduItemsUseCase.call(state.page);

      if (result.isRight) {
        emit(state.copyWith(
          list: [...state.list, ...result.right.results],
          count: result.right.count,
          status: FormzSubmissionStatus.success,
          page: result.right.count > (state.list.length + result.right.results.length) ? state.page + 1 : state.page,
        ));
      }
    });
    on<GetWordsEvent>((event, emit) async {
      if (event.onProgress != null) event.onProgress!();

      final result = await getEssentialWordsUseCase.call(Two(t: event.essential, b: event.unit));

      if (result.isRight) {
        event.onSuccess(result.right);
      } else {
        event.onFail(result.left);
      }
    });
    on<GetWordsByUnitsEvent>((event, emit) async {
      List<EssentialModel> list = [];

      for (var element in event.unit) {
        final result = await getEssentialWordsUseCase.call(Two(t: event.essential, b: element));
        if (result.isRight) list.addAll(result.right);
      }

      event.onSuccess(list);
    });
  }

  void _changeWordFontSizeEvent(ChangeWordFontSize event, Emitter<EducationState> emit) {
    emit(state.copyWith(fontSize: event.fontSize));
  }

  void _showTranslationsEvent(ShowTranslationsEvent event, Emitter<EducationState> emit) {
    emit(state.copyWith(showTranslation: !state.showTranslation));
  }
}
