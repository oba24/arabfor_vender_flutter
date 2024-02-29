class WalletState {}

class LoadingWalletState extends WalletState {}

class FaildWalletState extends WalletState {
  String msg;
  int errType;
  FaildWalletState({required this.errType, required this.msg});
}

class DoneWalletState extends WalletState {
  String msg;
  double wallet;
  DoneWalletState(this.msg, this.wallet);
}

class DoneRefundState extends WalletState {
  String msg;
  DoneRefundState(this.msg);
}
