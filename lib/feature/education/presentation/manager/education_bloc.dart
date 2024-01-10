import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../data/models/edu_model.dart';
import '../../domain/use_cases/get_edu_items_use_case.dart';

part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {

  final GetEduItemsUseCase getEduItemsUseCase = GetEduItemsUseCase();

  EducationBloc() : super(const EducationState()) {
    on<GetEduItemsEvent>((event, emit) async{
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

        final result = await getEduItemsUseCase.call(state.page);

        if(result.isRight){

          emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            list: result.right.results,
            count: result.right.count,
            page: state.page+1
          ));

        }else{

          emit(state.copyWith(status: FormzSubmissionStatus.failure));

        }

    });
    on<GetMoreEduItemsEvent>((event,emit)async{

      final result = await getEduItemsUseCase.call(state.page);

      if(result.isRight){

        emit(state.copyWith(
          list: [...state.list, ...result.right.results],
          count: result.right.count,
          status: FormzSubmissionStatus.success,
          page: result.right.count > (state.list.length + result.right.results.length) ? state.page + 1 : state.page,
        ));

      }
    });
  }
}
