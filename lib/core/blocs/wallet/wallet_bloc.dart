import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_event.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_state.dart';
import 'package:travelogue_mobile/core/repository/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<SendWithdrawalRequestEvent>(_onSendWithdrawalRequest);
    on<LoadMyWithdrawalRequestsEvent>(_onLoadMyWithdrawalRequests);
  }

  Future<void> _onSendWithdrawalRequest(
      SendWithdrawalRequestEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final error = await walletRepository.createWithdrawalRequest(event.model);
    if (error == null) {
      emit(WalletSuccess());
    } else {
      emit(WalletFailure(error));
    }
  }

  Future<void> _onLoadMyWithdrawalRequests(
      LoadMyWithdrawalRequestsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final list = await walletRepository.getMyWithdrawalRequests(
        status: event.status,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(WalletListLoaded(list));
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }
}
