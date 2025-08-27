import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/presentation/screens/dashboard/main_dashboard.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

import '../../../constatnts/colors.dart';
import '../../../constatnts/styles.dart';
import '../../../widgets/custom_textfield.dart';
import '../../data/models/orders_model.dart';
import '../../widgets/cart_product_card.dart';

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
  FocusNode customerEmailFocus = FocusNode();
  FocusNode customerAddressFocus = FocusNode();
  FocusNode customerGenderFocus = FocusNode();
  int index = 0;
  PaymentMode selectedPaymentMode = PaymentMode.cash;

  TextEditingController cashController = TextEditingController(text: "0");
  TextEditingController cardController = TextEditingController(text: "0");
  TextEditingController creditController = TextEditingController(text: "0");
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerGenderController = TextEditingController();
  bool cartDiscountAdded = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      BlocProvider.of<CartBloc>(context).add(LoadCartFromLocalEvent());
      BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
    });

    super.initState();
  }

  @override
  void dispose() {
    cashController.dispose();
    cardController.dispose();
    creditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(listener: (c, s) {
      if (s is CartSubmittedState) {
        context.pop();
        CartDb.clearCartDb();
        CustomSnackBar.showSuccess(message: "Order placed successfully!");
      }
      if (AppResponsive.isDesktop(context)) {
        context.pushReplacement(MainDashboard.route);
      }
    }, builder: (c, state) {
      if (state is CartLoadedState) {
        if (state.cart == null) {
          context.pop();
        }
        if (selectedPaymentMode == PaymentMode.cash) {
          cashController.text = state.cart!.totalCartPrice.toString();
        }

        return BlocListener<CrmBloc, CrmState>(
          listener: (context, state) {
            if (state is CrmScreenLoadingSuccessState) {
              customerList = state.customersList;
            }
          },
          child: Scaffold(
            body: (state.cart?.cartItems.isEmpty ?? true)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Your cart is empty",
                          style: AppStyles.getMediumTextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            "Continue Shopping",
                            style: AppStyles.getMediumTextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
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
                        title: Row(
                          children: [
                            Image.asset(
                              height: 45,
                              width: 45,
                              'assets/images/png/appicon2.webp',
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "Shopping Cart",
                              style: AppStyles.getMediumTextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Form(
                              key: formKey,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.sizeOf(context).height - 70,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Items',
                                              style: AppStyles.getMediumTextStyle(fontSize: 17),
                                            ),
                                            Text(
                                              '${state.cart!.cartItems.length} items',
                                              style: AppStyles.getRegularTextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (state.cart != null)
                                        ListView.builder(
                                          padding: const EdgeInsets.all(16),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: state.cart!.cartItems.length,
                                          itemBuilder: (BuildContext c, int i) {
                                            return CartProductCard(cartItemModel: state.cart!.cartItems[i]);
                                          },
                                        ),
                                      const SizedBox(height: 18),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 13),
                                        color: Colors.grey.shade100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 18),
                                            Text(
                                              'Customer Details',
                                              style: AppStyles.getMediumTextStyle(fontSize: 17),
                                            ),
                                            const SizedBox(height: 20),
                                            _buildCustomerFields(),
                                            const SizedBox(height: 18),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Text(
                                          'Payment Mode',
                                          style: AppStyles.getMediumTextStyle(fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildPaymentModeSelector(state.cart!),
                                      const SizedBox(height: 20),
                                      selectedPaymentMode == PaymentMode.credit
                                          ? Center(
                                              child: Text(
                                                'AED ${state.cart!.totalCartPrice.toStringAsFixed(2)} will pay later',
                                                style: AppStyles.getRegularTextStyle(fontSize: 14),
                                              ),
                                            )
                                          : paymentModeSection(),
                                      const SizedBox(height: 18),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      _buildOrderSummary(state.cart!),
                                    ],
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
              padding: const EdgeInsets.all(8),
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
                        fixedSize: const Size(0, 45),
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(
                          color: AppColors.textColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('BACK'),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (state.cart!.cartItems.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size(0, 45),
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('CHECKOUT'),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            CustomSnackBar.showError(message: "Please fill all required fields");
                            return;
                          }

                          // Validate cart has items
                          if (state.cart!.cartItems.isEmpty) {
                            CustomSnackBar.showError(message: "Cart is empty. Please add items before checkout.");
                            return;
                          }

                          // Validate customer information
                          if (customerPhoneController.text.isEmpty || customerNameController.text.isEmpty) {
                            CustomSnackBar.showError(message: "Please enter customer phone and name");
                            return;
                          }

                          // Validate payment amounts
                          double cashAmount = double.tryParse(cashController.text) ?? 0.0;
                          double cardAmount = double.tryParse(cardController.text) ?? 0.0;
                          double creditAmount = double.tryParse(creditController.text) ?? 0.0;
                          double totalPayment = cashAmount + cardAmount + creditAmount;
                          double cartTotal = state.cart!.totalCartPrice;

                          if (totalPayment < cartTotal) {
                            CustomSnackBar.showError(
                                message: "Total payment amount (${totalPayment.toStringAsFixed(2)}) is less than cart total (${cartTotal.toStringAsFixed(2)})");
                            return;
                          }

                          if (totalPayment > cartTotal * 1.1) {
                            CustomSnackBar.showWarning(message: "Payment amount is significantly higher than cart total. Please verify the amounts.");
                          }

                          checkoutDialogue(context, state.cart!);
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildCustomerFields() {
    return Column(
      children: [
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoCompleteTextField<CustomerModel>(
            controller: customerPhoneController,
            items: customerList,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            defaultText: "Customer Phone",
            labelText: 'Customer Phone',
            displayStringFunction: (v) => v.phone ?? "",
            focusNode: customerPhoneFocus,
            onSelected: (customer) => setCustomerVariables(customer),
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            onChanged: (value) {},
            validator: (v) => v!.isEmpty ? "Enter customer Mobile Number" : null,
            selectedItems: [customerPhoneController.text],
          ),
        ),
        const SizedBox(height: 10),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoCompleteTextField<CustomerModel>(
            controller: customerNameController,
            items: customerList,
            defaultText: "Customer Name",
            labelText: 'Customer Name',
            displayStringFunction: (v) => v.name ?? "",
            focusNode: customerNameFocus,
            onSelected: (customer) => setCustomerVariables(customer),
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            onChanged: (value) => {},
            validator: (v) => v!.isEmpty ? "Enter customer name" : null,
            selectedItems: [customerNameController.text],
          ),
        ),
        const SizedBox(height: 10),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoCompleteTextField<CustomerModel>(
            controller: customerEmailController,
            items: customerList,
            defaultText: "Customer Email",
            labelText: 'Customer Email',
            displayStringFunction: (v) => v.email ?? "",
            focusNode: customerEmailFocus,
            onSelected: (customer) => setCustomerVariables(customer),
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            onChanged: (value) => {},
            validator: (v) => v!.isEmpty ? "Enter customer Email Id" : null,
            selectedItems: [customerEmailController.text],
          ),
        ),
        const SizedBox(height: 10),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoCompleteTextField<CustomerModel>(
            controller: customerAddressController,
            items: customerList,
            defaultText: "Customer Address",
            labelText: 'Customer Address',
            displayStringFunction: (v) => v.address ?? "",
            focusNode: customerAddressFocus,
            onSelected: (customer) => setCustomerVariables(customer),
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            onChanged: (value) => {},
            selectedItems: [customerAddressController.text],
          ),
        ),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoCompleteTextField<String>(
            controller: customerGenderController,
            items: const ["Male", "Female"],
            defaultText: "Customer Gender",
            labelText: 'Customer Gender',
            displayStringFunction: (v) => v,
            focusNode: customerGenderFocus,
            onSelected: (customer) => customerGenderController.text = customer,
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            onChanged: (value) => {},
            disableSearch: true,
            selectedItems: [customerGenderController.text],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentModeSelector(CartModel cart) {
    return Container(
      margin: const EdgeInsets.all(16.0),
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
                cashController.clear();
                cardController.clear();
                creditController.clear();
                setState(() {
                  index = e.key;
                  selectedPaymentMode = e.value;
                  splitAmountEqually(cart.totalCartPrice);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 45,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: index == e.key ? AppColors.primaryColor : null,
                  border: Border(
                    right: BorderSide(color: e.key == 3 ? Colors.white : Colors.grey),
                  ),
                ),
                child: Center(
                  child: Text(
                    e.value.name.toUpperCase(),
                    style: AppStyles.getRegularTextStyle(
                      fontSize: 13,
                      color: e.key == index ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderSummary(CartModel cart) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppStyles.getMediumTextStyle(fontSize: 17),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Items', cart.cartItems.length.toString()),
          const SizedBox(height: 20),
          _buildSummaryRow('Total Amount', 'AED ${getTotalAmount(cart)}'),
          const SizedBox(height: 20),
          _buildSummaryRow('Net Amount', 'AED ${cart.totalCartPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.getMediumTextStyle(fontSize: 17),
        ),
        Text(
          value,
          style: AppStyles.getMediumTextStyle(fontSize: 17),
        ),
      ],
    );
  }

  String getTotalAmount(CartModel cart) {
    double sumAmount = 0.0;

    for (var cartItem in cart.cartItems) {
      sumAmount += (cartItem.product.unitPrice ?? 0) * cartItem.quantity;
    }

    return sumAmount.toStringAsFixed(3); // Optional: format to 2 decimal places
  }

  checkoutDialogue(BuildContext context, CartModel cart) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        return StatefulBuilder(builder: (c, s) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Checkout Confirmation',
              style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Items",
                      style: AppStyles.getMediumTextStyle(fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        if (cartDiscountAdded) {
                          // Restore individual product discounts
                          double sumAmount = 0.0;
                          for (var item in cart.cartItems) {
                            item.totalPrice = (item.product.unitPrice ?? 0) - item.discount;
                            sumAmount += item.totalPrice;
                          }
                          cart.totalCartPrice = sumAmount;
                          cartDiscountAdded = false;
                          s(() {});
                        } else {
                          Navigator.pop(context); // Close checkout dialog before showing discount
                          showDiscountDialogue(context, cart);
                        }
                      },
                      child: Text(cartDiscountAdded ? 'Remove Discount' : 'Add Discount'),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Name',
                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quantity',
                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: cart.cartItems.map((cartItem) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              cartItem.product.name ?? "",
                              style: AppStyles.getRegularTextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              child: Text(
                                cartItem.quantity.toString(),
                                style: AppStyles.getRegularTextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'AED ${cartItem.totalPrice.toStringAsFixed(2)}',
                                  style: AppStyles.getRegularTextStyle(fontSize: 12),
                                ),
                                if (cartItem.discount > 0)
                                  Text(
                                    'Discount: AED ${cartItem.discount.toStringAsFixed(2)}',
                                    style: AppStyles.getRegularTextStyle(
                                      fontSize: 10,
                                      color: Colors.green[700],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
                Text(
                  "Total Items  :   ${cart.cartItems.length}",
                  style: AppStyles.getMediumTextStyle(fontSize: 17),
                ),
                Text(
                  "Total Amount  :   AED ${getTotalAmount(cart)}",
                  style: AppStyles.getMediumTextStyle(fontSize: 17),
                ),
                Text(
                  "Net Amount  :   AED ${cart.totalCartPrice.toStringAsFixed(2)}",
                  style: AppStyles.getMediumTextStyle(fontSize: 17),
                ),
                SizedBox(height: 12),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  List<OrderItem> orderItemsList = [];
                  for (var cartItem in cart.cartItems) {
                    orderItemsList.add(OrderItem(
                      price: cartItem.totalPrice,
                      productId: cartItem.product.id,
                      quantity: cartItem.quantity,
                    ));
                  }
                  OrderModel orderModel = OrderModel(
                    orderItems: orderItemsList,
                    discount: cartDiscountAdded ? cart.totalCartPrice - double.parse(getTotalAmount(cart)) : 0,
                    paymentMethod: selectedPaymentMode.value.toString(),
                    cardAmount: num.tryParse(cardController.text) ?? 0,
                    cashAmount: num.tryParse(cashController.text) ?? 0,
                    grossTotal: double.parse(getTotalAmount(cart)),
                    netTotal: cart.totalCartPrice,
                    customerId: customerList.firstWhereOrNull((e) => e.phone == customerPhoneController.text)?.id ?? 0,
                  );
                  CustomerModel customerModel = CustomerModel(
                    name: customerNameController.text,
                    email: customerEmailController.text,
                    address: customerAddressController.text,
                    gender: customerGenderController.text,
                    id: customerList.firstWhereOrNull((e) => e.phone == customerPhoneController.text)?.id ?? 0,
                    phone: customerPhoneController.text,
                  );
                  context.read<CartBloc>().add(
                        SubmitingCartEvent(orderModel: orderModel, customerModel: customerModel),
                      );
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void splitAmountEqually(amount) {
    double totalAmount = amount; // your fixed total amount
    int visibleFields = 0;

    if (selectedPaymentMode == PaymentMode.card) {
      cardController.text = amount.toString();
    }
    // Check which fields are visible in split mode
    if (selectedPaymentMode == PaymentMode.split) {
      visibleFields = 3; // cash, card, credit all are shown
    }

    if (visibleFields > 0) {
      double perFieldAmount = totalAmount / visibleFields;

      cashController.text = perFieldAmount.toStringAsFixed(2);
      cardController.text = perFieldAmount.toStringAsFixed(2);
      creditController.text = perFieldAmount.toStringAsFixed(2);
    }
  }

  validateAndDistributeAmount({required double totalAmount}) {
    double cash = cashController.text.isEmpty ? 0 : double.tryParse(cashController.text) ?? 0;
    double card = cardController.text.isEmpty ? 0 : double.tryParse(cardController.text) ?? 0;
    double credit = creditController.text.isEmpty ? 0 : double.tryParse(creditController.text) ?? 0;

    double sum = cash + card + credit;

    if (sum.round() == totalAmount.round()) return; // all good

    // Identify non-zero / filled controllers
    List<_PaymentEntry> filled = [];

    if (cash > 0) filled.add(_PaymentEntry("cash", cashController));
    if (card > 0) filled.add(_PaymentEntry("card", cardController));
    if (credit > 0) filled.add(_PaymentEntry("credit", creditController));

    if (filled.isEmpty) {
      CustomSnackBar.showWarning(message: "Please enter at least one payment method.");
      return;
    }

    // Distribute total amount equally among filled fields
    double equalShare = totalAmount / filled.length;
    for (var entry in filled) {
      entry.controller.text = equalShare.toStringAsFixed(2);
    }
  }

  showDiscountDialogue(BuildContext context, CartModel cart) {
    String discountBy = 'By Percentage';
    TextEditingController discountController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) => AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Discount Value',
                        hintText: discountBy == 'By Percentage' ? 'Enter %' : 'Enter Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: discountBy,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: ['By Percentage', 'By Amount']
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        discountBy = value ?? "";
                        discountController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              c.pop();
              checkoutDialogue(context, cart);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (discountController.text.isEmpty) {
                CustomSnackBar.showError(message: "Please enter a discount value");
                return;
              }

              Navigator.pop(c);

              double discountValue = double.tryParse(discountController.text) ?? 0.0;
              double sumAmount = 0.0;

              // Store original prices with individual discounts
              for (var item in cart.cartItems) {
                item.totalPrice = (item.product.unitPrice ?? 0) - item.discount;
                sumAmount += item.totalPrice;
              }

              double discountedTotal = sumAmount;

              if (discountBy == 'By Percentage') {
                if (discountValue > 100) {
                  CustomSnackBar.showError(message: "Discount percentage cannot exceed 100%");
                  return;
                }
                double discount = sumAmount * (discountValue / 100);
                discountedTotal = sumAmount - discount;
              } else if (discountBy == 'By Amount') {
                if (discountValue > sumAmount) {
                  CustomSnackBar.showError(message: "Discount amount cannot exceed total amount");
                  return;
                }
                discountedTotal = sumAmount - discountValue;
              }

              cart.totalCartPrice = discountedTotal.clamp(0, double.infinity);
              cartDiscountAdded = true;
              setState(() {});
              checkoutDialogue(context, cart);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void setCustomerVariables(CustomerModel customer) {
    customerNameController.text = customer.name ?? "";
    customerAddressController.text = customer.address ?? "";
    customerGenderController.text = customer.gender ?? "";
    customerPhoneController.text = customer.phone ?? "";
    customerEmailController.text = customer.email ?? "";
  }

  paymentModeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          if (selectedPaymentMode == PaymentMode.cash || selectedPaymentMode == PaymentMode.split)
            CustomTextField(
              keyBoardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: cashController,
              fillColor: Colors.white,
              labelText: "Cash Amount",
              onChanged: (v) {},
            ),
          SizedBox(height: 18),
          if (selectedPaymentMode == PaymentMode.card || selectedPaymentMode == PaymentMode.split)
            CustomTextField(
              keyBoardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: cardController,
              fillColor: Colors.white,
              labelText: 'Card Amount',
            ),
          SizedBox(height: 18),
          if (selectedPaymentMode == PaymentMode.split)
            CustomTextField(
              keyBoardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: creditController,
              fillColor: Colors.white,
              labelText: 'credit Amount',
            ),
        ],
      ),
    );
  }
}

class _PaymentEntry {
  final String name;
  final TextEditingController controller;
  _PaymentEntry(this.name, this.controller);
}
