import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/report/report_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportSubmitting extends ReportState {
  const ReportSubmitting();
}

class ReportSuccess extends ReportState {
  final String? message;
  const ReportSuccess({this.message});
  @override
  List<Object?> get props => [message];
}

class ReportFailure extends ReportState {
  final String error;
  const ReportFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// NEW: My reports list
class MyReportsLoading extends ReportState {}

class MyReportsLoaded extends ReportState {
  final List<ReportModel> reports;
  const MyReportsLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class MyReportsActionSuccess extends ReportState {
  final String? message;
  const MyReportsActionSuccess({this.message});
  @override
  List<Object?> get props => [message];
}
