import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bldui/common/types.dart';

part 'design_event.dart';
part 'design_state.dart';

class DesignBloc extends Bloc<DesignEvent, DesignState> {
  DesignBloc() : super(DesignInitial()) {
    on<DesignEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DesignFieldChangeEvent>((event, emit) async {
      emit(DesignFieldChange(
          fieldName: event.fieldName, fieldAction: event.fieldAction));
    });
  }
}
