import 'package:equatable/equatable.dart';

class OcrResult extends Equatable {
  final PayData? payData;
  final String? output;
  final String? error;

  const OcrResult(this.payData, this.output, this.error);

  @override
  List<Object?> get props => [payData, output, error];
}

class PayData extends Equatable {
  final PayType type;
  final String? transactionId;

  const PayData(this.type, this.transactionId);

  @override
  List<Object?> get props => [type, transactionId];

}

enum PayType {
  kbzPay("KBZ Pay"),
  wavePay("Wave Pay");

  final String label;
  const PayType(this.label);
}