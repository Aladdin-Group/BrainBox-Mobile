import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../words/domain/use_cases/get_words_by_coun_usecase.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {

  final GetWordsByCountUseCase getWordsByCountUseCase = GetWordsByCountUseCase();

  TestBloc() : super(const TestState()) {
    on<NextTestEvent>((event,emit)async{

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await getWordsByCountUseCase.call(state.page);

      if(result.isRight){


        emit(state.copyWith(
          list: [...state.list, ...result.right.results],
          count: result.right.count,
          status: FormzSubmissionStatus.success,
          page: result.right.count > (state.list.length + result.right.results.length) ? state.page + 1 : state.page,
        ));

        event.success(result.right.results);

      }else{
        event.failure('Something went wrong!'.tr());
      }

    });
  }
}
