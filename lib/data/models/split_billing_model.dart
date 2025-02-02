import 'package:pos_app/constatnts/enums.dart';

class SplitBillingModel {
  PaymentMode paymentMethod;
  String amount;
  SplitBillingModel({
    required this.paymentMethod,
    required this.amount,
  });
}
