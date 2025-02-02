import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/presentation/screens/auth/login.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/cart_product_Card.dart';

import '../../../constatnts/colors.dart';
import '../../../constatnts/styles.dart';
import '../../../widgets/custom_textfield.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  static String route = '/cart';

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CustomerModel> customerList = [];
  FocusNode customerNameFocus = FocusNode();
  FocusNode customerPhoneFocus = FocusNode();
  FocusNode customerAddressFocus = FocusNode();
  FocusNode customerGenderFocus = FocusNode();
  int index = 0;
  PaymentMode selctedPaymentMode = PaymentMode.cash;

  TextEditingController cashController = TextEditingController(text: "0");
  TextEditingController cardController = TextEditingController(text: "0");
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerGenderController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<CartBloc>(context).add(LoadCartEvent());
    BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());

    super.initState();
  }

  @override
  void dispose() {
    cashController.dispose();
    cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(listener: (c, s) {
      if (s is CartSubmittedState) {
        context.pop();
        CartDb.clearDb();
        customSnackBar(context, "Order Created");
      }
    }, builder: (context, state) {
      if (state is CartLoadedState) {
        cashController.addListener(() => updateAmount(cashController, cardController, state.cart.grandTotal));
        cardController.addListener(() => updateAmount(cardController, cashController, state.cart.grandTotal));
        if (selctedPaymentMode == PaymentMode.cash) {
          cashController.text = state.cart.grandTotal.toString();
        }
        return BlocListener<CrmBloc, CrmState>(
          listener: (context, state) {
            if (state is CrmScreenLoadingSuccessState) {
              customerList = state.customersList;
            }
          },
          child: Scaffold(
            body: state.cart.cartItems.isEmpty
                ? SizedBox(
                    height: 400,
                    child: Center(
                      child: Text("Cart is Empty"),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        elevation: 0,
                        floating: true,
                        toolbarHeight: 70,
                        backgroundColor: AppColors.primaryColor,
                        iconTheme: const IconThemeData(color: Colors.white),
                        automaticallyImplyLeading: false,
                        title: Hero(
                          tag: 'assets/images/png/logo.png',
                          child: Image.asset(
                            height: 45,
                            width: 45,
                            'assets/images/png/logo.png',
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Hero(
                              tag: '1',
                              child: Form(
                                key: formKey,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(20)),
                                  ),
                                  constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height - 70),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Items',
                                          style: AppStyles.getMediumTextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 10),
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: state.cart.cartItems.length,
                                          itemBuilder: (BuildContext c, int i) {
                                            return CartProductCard(cartItemModel: state.cart.cartItems[i]);
                                          },
                                        ),
                                        SizedBox(height: 18),
                                        Divider(),
                                        SizedBox(height: 18),
                                        Text(
                                          'Payment Mode',
                                          style: AppStyles.getMediumTextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          height: 45,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 8,
                                                color: Colors.black26,
                                                spreadRadius: 0.1,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: PaymentMode.values.asMap().entries.map((e) {
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      index = e.key;
                                                      selctedPaymentMode = e.value;
                                                      setAmount(state.cart.grandTotal);
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(milliseconds: 600),
                                                    height: 45,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: index == e.key ? AppColors.primaryColor : null,
                                                      border: Border(
                                                        right: BorderSide(color: e.key == 3 ? Colors.white : Colors.grey),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        e.value.name.toUpperCase(),
                                                        style: AppStyles.getRegularTextStyle(fontSize: 13, color: e.key == index ? Colors.white : null),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        if (selctedPaymentMode != PaymentMode.credit)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Material(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  elevation: 4,
                                                  child: CustomTextField(
                                                    keyBoardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    controller: selctedPaymentMode == PaymentMode.cash
                                                        ? cashController
                                                        : selctedPaymentMode == PaymentMode.card
                                                            ? cardController
                                                            : cashController,
                                                    fillColor: Colors.white,
                                                    labelText: selctedPaymentMode == PaymentMode.cash
                                                        ? "Cash Amount"
                                                        : selctedPaymentMode == PaymentMode.card
                                                            ? 'Card Amount'
                                                            : "Cash Amount",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 9),
                                              if (selctedPaymentMode == PaymentMode.split)
                                                Expanded(
                                                  child: Material(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    elevation: 4,
                                                    child: CustomTextField(
                                                      keyBoardType: TextInputType.number,
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      controller: cardController,
                                                      fillColor: Colors.white,
                                                      labelText: 'Card Amount',
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 10),
                                        Text(
                                          'Customer Details',
                                          style: AppStyles.getMediumTextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 10),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          child: AutoCompleteTextField<CustomerModel>(
                                            controller: customerNameController,
                                            items: customerList,
                                            defaultText: "Customer Name",
                                            labelText: 'Customer Name',
                                            displayStringFunction: (v) {
                                              return v.customerName ?? "";
                                            },
                                            focusNode: customerNameFocus,
                                            onSelected: (customer) {
                                              setCustomerVariables(customer);
                                            },
                                            optionsViewOpenDirection: OptionsViewOpenDirection.up,
                                            onChanged: (value) {
                                              customerNameController.text = value;
                                            },
                                            validator: customerNameController.text.isNotEmpty
                                                ? (v) {
                                                    if (!v!.length.isGreaterThanZero()) {
                                                      return "Enter customer name";
                                                    }
                                                    return null;
                                                  }
                                                : null,
                                            selectedItems: [customerNameController.text],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          child: AutoCompleteTextField<CustomerModel>(
                                            controller: customerPhoneController,
                                            items: customerList,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            defaultText: "Customer Phone",
                                            labelText: 'Customer Phone',
                                            displayStringFunction: (v) {
                                              return v.mobileNumber ?? "";
                                            },
                                            focusNode: customerPhoneFocus,
                                            onSelected: (customer) {
                                              setCustomerVariables(customer);
                                            },
                                            optionsViewOpenDirection: OptionsViewOpenDirection.up,
                                            onChanged: (value) {
                                              customerPhoneController.text = value;
                                            },
                                            validator: customerPhoneController.text.isNotEmpty
                                                ? (v) {
                                                    if (!v!.length.isGreaterThanZero()) {
                                                      return "Enter customer Mobile Number";
                                                    }
                                                    return null;
                                                  }
                                                : null,
                                            selectedItems: [customerPhoneController.text],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          child: AutoCompleteTextField<CustomerModel>(
                                            controller: customerAddressController,
                                            items: customerList,
                                            defaultText: "Customer Address",
                                            labelText: 'Customer Address',
                                            displayStringFunction: (v) {
                                              return v.address ?? "";
                                            },
                                            focusNode: customerAddressFocus,
                                            onSelected: (customer) {
                                              setCustomerVariables(customer);
                                            },
                                            optionsViewOpenDirection: OptionsViewOpenDirection.up,
                                            onChanged: (value) {
                                              customerAddressController.text = value;
                                            },
                                            selectedItems: [customerAddressController.text],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          child: AutoCompleteTextField<String>(
                                            controller: customerGenderController,
                                            items: ["Male", "Female"],
                                            defaultText: "Customer Gender",
                                            labelText: 'Customer Gender',
                                            displayStringFunction: (v) {
                                              return v ?? "";
                                            },
                                            focusNode: customerGenderFocus,
                                            onSelected: (customer) {
                                              customerGenderController.text = customer;
                                            },
                                            optionsViewOpenDirection: OptionsViewOpenDirection.up,
                                            onChanged: (value) {
                                              customerGenderController.text = value;
                                            },
                                            selectedItems: [customerGenderController.text],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Divider(),
                                        SizedBox(height: 10),
                                        Text(
                                          'Order Details',
                                          style: AppStyles.getMediumTextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Items:',
                                                style: AppStyles.getMediumTextStyle(fontSize: 17),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    state.cart.cartItems.length.toString(),
                                                    style: AppStyles.getMediumTextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Total:',
                                                style: AppStyles.getMediumTextStyle(fontSize: 17),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'AED ${state.cart.grandTotal}',
                                                        style: AppStyles.getMediumTextStyle(fontSize: 17),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => showDiscountDialogue(context),
                                                        style: TextButton.styleFrom(
                                                          padding: EdgeInsets.zero,
                                                        ),
                                                        child: Text(
                                                          "> add discount",
                                                          style: AppStyles.getMediumTextStyle(color: AppColors.stextColor, fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(8),
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          fixedSize: Size(0, 45),
                          foregroundColor: AppColors.primaryColor,
                          side: BorderSide(
                            color: AppColors.textColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: Text(
                        'BACK',
                        // style: AppStyles.getLightTextStyle(fontSize: 10),
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  SizedBox(width: 5),
                  if (state.cart.cartItems.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(0, 45),
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text('SUBMIT'),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                title: Text(
                                  'Checkout Confirmation',
                                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                                ),
                                content: Text(
                                  'Are you sure you want to proceed with checkout?',
                                  style: AppStyles.getRegularTextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      OrderModel orderModel = OrderModel(
                                        cart: state.cart,
                                        discount: 0,
                                        paymentMethod: selctedPaymentMode,
                                        cardAmount: double.parse(cardController.text),
                                        cashAmount: double.parse(cashController.text),
                                        grossTotal: state.cart.grandTotal,
                                        netTotal: state.cart.grandTotal,
                                        orderNumber: "ORD-${Random().nextDouble()}",
                                        orderType: "Counter sale",
                                        recieptNumber: "REC-${Random().nextDouble()}",
                                        customerId: customerList.firstWhereOrNull((e) => e.mobileNumber == customerPhoneController.text)?.id ?? 0,
                                      );
                                      CustomerModel customerModel = CustomerModel(
                                        customerName: customerNameController.text,
                                        email: "",
                                        address: customerAddressController.text,
                                        gender: customerGenderController.text,
                                        id: customerList.firstWhereOrNull((e) => e.mobileNumber == customerPhoneController.text)?.id ?? 0,
                                        mobileNumber: customerPhoneController.text,
                                      );
                                      BlocProvider.of<CartBloc>(context).add(
                                        SubmitingCartEvent(orderModel: orderModel, customerModel: customerModel),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }

  void updateAmount(TextEditingController editedController, TextEditingController otherController, double grandTotal) {
    String oldText = editedController.text;
    int oldCursorPos = editedController.selection.baseOffset;

    if (oldText.isNotEmpty) {
      double enteredAmount = double.tryParse(oldText) ?? 0.0;

      // Ensure that the amount does not exceed grand total
      enteredAmount = enteredAmount.clamp(0, grandTotal);

      double remainingAmount = (grandTotal - enteredAmount).clamp(0, grandTotal);

      String newText = remainingAmount.toStringAsFixed(2);

      // Update the other field (cash or card) without exceeding the grand total
      otherController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );

      // Restore cursor position in the edited field
      editedController.value = TextEditingValue(
        text: oldText,
        selection: TextSelection.collapsed(offset: oldCursorPos),
      );
    }
  }

  showDiscountDialogue(BuildContext context) {
    // return showModalBottomSheet(
    //   context: context,
    //   builder: (c) => Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Column(
    //         children: [
    //           Row(
    //             children: [
    //               Text(
    //                 "By Percentage",
    //                 style: AppStyles.getRegularTextStyle(fontSize: 12),
    //               ),
    //               Radio(
    //                 value: "percent",
    //                 groupValue: "In",
    //                 onChanged: (v) {},
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Text(
    //                 "By Amount",
    //                 style: AppStyles.getRegularTextStyle(fontSize: 12),
    //               ),
    //               Radio(
    //                 value: "amount",
    //                 groupValue: "In",
    //                 onChanged: (v) {},
    //               ),
    //             ],
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

  void setCustomerVariables(CustomerModel customer) {
    customerNameController.text = customer.customerName ?? "";
    customerAddressController.text = customer.address ?? "";
    customerGenderController.text = customer.gender ?? "";
    customerPhoneController.text = customer.mobileNumber ?? "";
  }

  void setAmount(double grandTotal) {
    if (grandTotal < 0) {
      return;
    }

    if (selctedPaymentMode == PaymentMode.cash) {
      cashController.text = grandTotal.toStringAsFixed(2);
      cardController.clear();
    } else if (selctedPaymentMode == PaymentMode.card) {
      cashController.clear();
      cardController.text = grandTotal.toStringAsFixed(2);
    } else if (selctedPaymentMode == PaymentMode.split) {
      double amt1 = (grandTotal / 2).floorToDouble();
      double amt2 = grandTotal - amt1;
      cashController.text = amt1.toStringAsFixed(2);
      cardController.text = amt2.toStringAsFixed(2);
    }
  }
}
