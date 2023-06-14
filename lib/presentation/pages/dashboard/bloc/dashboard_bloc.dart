import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paml_20190140086_ewallet/domain/models/dashboard/dashboard_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/user/user_model.dart';
import 'package:paml_20190140086_ewallet/domain/repositories/dashboard/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    final dashboardRepository = DashboardRepository();

    on<DashboardEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDataDashboard>((event, emit) async {
      try {
        emit(DashboardLoading());
        final response = await dashboardRepository.get();
          
        emit(DashboardLoaded(data: response));
      } catch (e) {
        emit(DashboardError(error: e.toString()));
      }
    });
  }
}
