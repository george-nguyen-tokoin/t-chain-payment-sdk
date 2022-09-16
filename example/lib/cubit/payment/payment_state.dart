part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentDepositState extends PaymentState {
  final String orderID;
  final double amount;
  final TChainPaymentStatus status;
  final String? transactionID;
  final String? errorMessage;

  const PaymentDepositState({
    required this.orderID,
    required this.amount,
    required this.status,
    this.transactionID,
    this.errorMessage,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      orderID,
      amount,
      status,
      transactionID,
      errorMessage,
    ]);
}

class PaymentQrState extends PaymentState {
  final String orderID;
  final double amount;
  final Image? qrImage;
  final TChainPaymentStatus status;
  final String? transactionID;
  final String? errorMessage;

  const PaymentQrState({
    required this.orderID,
    required this.amount,
    required this.qrImage,
    required this.status,
    this.transactionID,
    this.errorMessage,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      orderID,
      amount,
      qrImage,
      status,
      transactionID,
      errorMessage,
    ]);
}
