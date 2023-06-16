part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class GetDataReport extends ReportEvent {
  final String startDate;
  final String endDate;

  const GetDataReport({
    required this.startDate,
    required this.endDate
  });
}