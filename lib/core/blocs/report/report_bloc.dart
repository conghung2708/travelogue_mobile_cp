import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/report/report_event.dart';
import 'package:travelogue_mobile/core/blocs/report/report_state.dart';
import 'package:travelogue_mobile/core/repository/report_repository.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc(this.reportRepository) : super(ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<FetchMyReportsEvent>(_onFetchMyReports);
    on<UpdateMyReportEvent>(_onUpdateMyReport);
    on<DeleteMyReportEvent>(_onDeleteMyReport);
  }

  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportSubmitting());
    try {
      final result = await reportRepository.submitReport(event.request);
      if (result.ok) {
        emit(ReportSuccess(message: result.message));
      } else {
        emit(ReportFailure(result.message ?? 'Gửi báo cáo thất bại.'));
      }
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }

  Future<void> _onFetchMyReports(
    FetchMyReportsEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(MyReportsLoading());
    try {
      final reports = await reportRepository.getMyReports();
      emit(MyReportsLoaded(reports));
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }

  Future<void> _onUpdateMyReport(
    UpdateMyReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportSubmitting());
    try {
      final result = await reportRepository.updateReport(
        reportId: event.reportId,
        reason: event.reason,
      );
      if (result.ok) {
        emit(MyReportsActionSuccess(message: result.message));
        // Optionally reload
        final reports = await reportRepository.getMyReports();
        emit(MyReportsLoaded(reports));
      } else {
        emit(ReportFailure(result.message ?? 'Cập nhật báo cáo thất bại.'));
      }
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }

  Future<void> _onDeleteMyReport(
    DeleteMyReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportSubmitting());
    try {
      final result = await reportRepository.deleteReport(event.reportId);
      if (result.ok) {
        emit(MyReportsActionSuccess(message: result.message));
        final reports = await reportRepository.getMyReports();
        emit(MyReportsLoaded(reports));
      } else {
        emit(ReportFailure(result.message ?? 'Xoá báo cáo thất bại.'));
      }
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }
}
