import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

/// Thành công khi gửi yêu cầu rút tiền
class WalletSuccess extends WalletState {}

/// Lỗi chung (tạo hoặc load)
class WalletFailure extends WalletState {
  final String error;

  const WalletFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// Thành công khi load danh sách filter
class WalletListLoaded extends WalletState {
  final List<WithdrawalRequestModel> items;

  const WalletListLoaded(this.items);

  @override
  List<Object?> get props => [items];
}
