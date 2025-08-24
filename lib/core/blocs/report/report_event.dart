import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/report/report_review_request.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class SubmitReportEvent extends ReportEvent {
  final ReportReviewRequest request;
  const SubmitReportEvent(this.request);
  @override
  List<Object?> get props => [request];
}

// NEW
class FetchMyReportsEvent extends ReportEvent {
  const FetchMyReportsEvent();
}

class UpdateMyReportEvent extends ReportEvent {
  final String reportId;
  final String reason;
  const UpdateMyReportEvent({required this.reportId, required this.reason});
  @override
  List<Object?> get props => [reportId, reason];
}

class DeleteMyReportEvent extends ReportEvent {
  final String reportId;
  const DeleteMyReportEvent(this.reportId);
  @override
  List<Object?> get props => [reportId];
}
