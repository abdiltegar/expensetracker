import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paml_20190140086_ewallet/domain/repositories/report/report_repository.dart';

import '../../../../../domain/models/report/report_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    final repotRepository = ReportRepository();

    on<ReportEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDataReport>((event, emit) async {
      // TODO: implement event handler
      try {
        emit(ReportLoading());

        final response = await repotRepository.getByRangeDate(event.startDate, event.endDate);
          
        emit(ReportLoaded(data: response));
      } catch (e) {
        emit(ReportError(error: e.toString()));
      }
    });
  }
}
