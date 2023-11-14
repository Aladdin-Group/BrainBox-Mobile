import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_event.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent,NavigationState>{

  NavigationBloc():super(const NavigationState()){

    on<NavigationRouteEvent>((even,emit){
      emit(state.copyWith(navigationIndex: even.index));
    });

  }

}