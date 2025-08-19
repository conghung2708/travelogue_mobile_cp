import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_event.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_state.dart';
import 'package:travelogue_mobile/core/repository/refund_request_repository.dart';

class RefundBloc extends Bloc<RefundEvent, RefundState> {
  final RefundRepository refundRepository;

  RefundBloc(this.refundRepository) : super(RefundInitial()) {
    on<SendRefundRequestEvent>(_onSendRefundRequest);
    on<LoadUserRefundRequestsEvent>(_onLoadUserRefundRequests);
  }

  Future<void> _onSendRefundRequest(
    SendRefundRequestEvent event,
    Emitter<RefundState> emit,
  ) async {
    emit(RefundLoading());
    final errorMsg = await refundRepository.sendRefundRequest(event.model);
    if (errorMsg == null) {
      emit(RefundSuccess());
    } else {
      emit(RefundFailure(errorMsg));
    }
  }

  Future<void> _onLoadUserRefundRequests(
    LoadUserRefundRequestsEvent event,
    Emitter<RefundState> emit,
  ) async {
    emit(RefundLoading());
    try {
      final refunds = await refundRepository.getUserRefundRequests(
        fromDate: event.fromDate,
        toDate: event.toDate,
        status: event.status,
      );
      // refunds lúc này là List<RefundRequestModel>
      emit(RefundListLoaded(refunds));
    } catch (e) {
      emit(RefundListLoadFailure(e.toString()));
    }
  }
}
