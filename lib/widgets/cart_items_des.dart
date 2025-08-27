import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/constatnts/extenstions.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/presentation/screens/dashboard/main_dashboard.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/cart_product_card.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

class CartItemsDes extends StatefulWidget {
  const CartItemsDes({super.key});
  static String route = '/cart';

  @override
  State<CartItemsDes> createState() => _CartItemsDesState();
}

class _CartItemsDesState extends State<CartItemsDes> {
  List<CustomerModel> customerList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartFromLocalEvent());
      context.read<CrmBloc>().add(GetAllCustomersEvent());
    });
  }

  double getTotalAmount(CartModel cart) {
    return cart.cartItems.fold(0.0, (sum, item) => sum + ((item.product.unitPrice ?? 0) * item.quantity));
  }

  bool get _hasCartItems => customerList.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 1000;

    return BlocListener<CrmBloc, CrmState>(
      listener: (context, state) {
        if (state is CrmScreenLoadingSuccessState) {
          setState(() {
            customerList = state.customersList;
          });
        }
        if (AppResponsive.isDesktop(context)) {
          context.pushReplacement(MainDashboard.route);
        }
      },
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartSubmittedState) {
            CartDb.clearCartDb();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoadedState) {
            final hasItems = state.cart?.cartItems.isNotEmpty == true;

            return Scaffold(
              appBar: AppResponsive.isMobile(context)
                  ? AppBar(
                      title: const Text('Cart'),
                      centerTitle: true,
                    )
                  : null,
              body: !hasItems
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add some items to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: state.cart!.cartItems.length,
                      itemBuilder: (context, index) {
                        return CartProductCard(
                          cartItemModel: state.cart!.cartItems[index],
                        );
                      },
                    ),
              bottomNavigationBar: !hasItems ? null : _buildBottomBar(context, state, isSmallScreen),
            );
          }

          if (state is CartLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartLoadedState state, bool isSmallScreen) {
    final totalAmount = getTotalAmount(state.cart!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Total Items: ${state.cart!.cartItems.length}',
                  style: AppStyles.getMediumTextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                Text(
                  'Total Amount: ${totalAmount.toStringAsFixed(3)}',
                  style: AppStyles.getMediumTextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                Text(
                  'Net Amount: ${state.cart!.totalCartPrice.toStringAsFixed(2)}',
                  style: AppStyles.getMediumTextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomResponsiveButton(
                height: 50,
                onPressed: () => _showCustomerDialog(context, state),
                text: "Proceed to Checkout",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDialog(BuildContext context, CartLoadedState state) {
    final formKey = GlobalKey<FormState>();
    final totalAmount = getTotalAmount(state.cart!);
    final netAmount = state.cart!.totalCartPrice;

    // Controllers
    final controllers = _DialogControllers();

    // Focus nodes
    final focusNodes = _DialogFocusNodes();

    void setCustomerVariables(CustomerModel customer) {
      controllers.customerName.text = customer.name ?? "";
      controllers.customerAddress.text = customer.address ?? "";
      controllers.customerGender.text = customer.gender ?? "";
      controllers.customerPhone.text = customer.phone ?? "";
      controllers.customerEmail.text = customer.email ?? "";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Column(
                children: [
                  Text(
                    "Order Summary",
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      "AED ${totalAmount.toStringAsFixed(2)}",
                      style: AppStyles.getSemiBoldTextStyle(
                        fontSize: 18,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: _buildDialogContent(
                      controllers,
                      focusNodes,
                      setCustomerVariables,
                      setState,
                      totalAmount,
                      netAmount,
                      state,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _submitOrder(
                    dialogContext,
                    formKey,
                    controllers,
                    state,
                  ),
                  child: const Text('Submit Order'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      controllers.dispose();
      focusNodes.dispose();
    });
  }

  Widget _buildDialogContent(
    _DialogControllers controllers,
    _DialogFocusNodes focusNodes,
    Function(CustomerModel) setCustomerVariables,
    StateSetter setState,
    double totalAmount,
    double netAmount,
    CartLoadedState state,
  ) {
    void _applyDiscount() {
      double discountValue = 0;
      if (controllers.discountByAmount.text.isNotEmpty) {
        discountValue = double.tryParse(controllers.discountByAmount.text) ?? 0;
        setState(() {});
        BlocProvider.of<CartBloc>(context).add(CartDiscountEvent(cartModel: state.cart!, isPercentage: true, discountedPrice: discountValue));
      } else if (controllers.discountByPercent.text.isNotEmpty) {
        discountValue = double.tryParse(controllers.discountByPercent.text) ?? 0;
        setState(() {});
        BlocProvider.of<CartBloc>(context).add(CartDiscountEvent(cartModel: state.cart!, isPercentage: false, discountedPrice: discountValue));
      }
    }

    void _removeDiscount() {
      // widget.cartItemModel.totalPrice = widget.cartItemModel.product.unitPrice ?? 0;
      // widget.cartItemModel.discount = 0;

      BlocProvider.of<CartBloc>(context).add(CartDiscountEvent(discountedPrice: -1, cartModel: state.cart!, isPercentage: false));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 16 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Customer Information Section
            SizedBox(
              width: constraints.maxWidth,
              child: Text(
                'Customer Information',
                style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
              ),
            ),

            _buildCustomerFields(
              controllers,
              focusNodes,
              setCustomerVariables,
              fieldWidth,
            ),

            const Divider(),

            // Discount Section
            SizedBox(
              width: constraints.maxWidth,
              child: Text(
                'Discount',
                style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
              ),
            ),

            _buildDiscountFields(controllers, focusNodes, fieldWidth),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _removeDiscount,
                  child: const Text('Remove Discount'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyDiscount,
                  child: const Text('Apply'),
                ),
              ],
            ),
            const Divider(),

            // Payment Section
            SizedBox(
              width: constraints.maxWidth,
              child: Text(
                'Payment Method',
                style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
              ),
            ),

            _buildPaymentFields(controllers, focusNodes, fieldWidth, totalAmount, setState),

            const Divider(),

            // Summary Section
            _buildSummarySection(totalAmount, netAmount, constraints.maxWidth),
          ],
        );
      },
    );
  }

  Widget _buildCustomerFields(
    _DialogControllers controllers,
    _DialogFocusNodes focusNodes,
    Function(CustomerModel) setCustomerVariables,
    double fieldWidth,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: fieldWidth,
          child: AutoCompleteTextField<CustomerModel>(
            controller: controllers.customerPhone,
            items: customerList,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            defaultText: "Customer Phone",
            labelText: 'Customer Phone',
            displayStringFunction: (v) => v.phone ?? "",
            focusNode: focusNodes.customerPhone,
            onSelected: setCustomerVariables,
            validator: (v) {
              if (v?.isEmpty ?? true) {
                return "Enter customer phone number";
              }
              return null;
            },
            selectedItems: [controllers.customerPhone.text],
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: AutoCompleteTextField<CustomerModel>(
            controller: controllers.customerName,
            items: customerList,
            defaultText: "Customer Name",
            labelText: 'Customer Name',
            displayStringFunction: (v) => v.name ?? "",
            focusNode: focusNodes.customerName,
            onSelected: setCustomerVariables,
            validator: (v) {
              if (v?.isEmpty ?? true) {
                return "Enter customer name";
              }
              return null;
            },
            selectedItems: [controllers.customerName.text],
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: AutoCompleteTextField<CustomerModel>(
            controller: controllers.customerEmail,
            items: customerList,
            defaultText: "Customer Email",
            labelText: 'Customer Email',
            displayStringFunction: (v) => v.email ?? "",
            focusNode: focusNodes.customerEmail,
            onSelected: setCustomerVariables,
            selectedItems: [controllers.customerEmail.text],
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: AutoCompleteTextField<CustomerModel>(
            controller: controllers.customerAddress,
            items: customerList,
            defaultText: "Customer Address",
            labelText: 'Customer Address',
            displayStringFunction: (v) => v.address ?? "",
            focusNode: focusNodes.customerAddress,
            onSelected: setCustomerVariables,
            selectedItems: [controllers.customerAddress.text],
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: AutoCompleteTextField<String>(
            controller: controllers.customerGender,
            items: const ["Male", "Female"],
            defaultText: "Customer Gender",
            labelText: 'Customer Gender',
            displayStringFunction: (v) => v,
            focusNode: focusNodes.customerGender,
            onSelected: (gender) => controllers.customerGender.text = gender,
            selectedItems: [controllers.customerGender.text],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountFields(
    _DialogControllers controllers,
    _DialogFocusNodes focusNodes,
    double fieldWidth,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: fieldWidth,
          child: CustomTextField(
            labelText: 'Discount Amount',
            controller: controllers.discountByAmount,
            focusNode: focusNodes.discountByAmount,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyBoardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => controllers.discountByPercent.clear(),
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: CustomTextField(
            labelText: 'Discount %',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: controllers.discountByPercent,
            focusNode: focusNodes.discountByPercent,
            keyBoardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => controllers.discountByAmount.clear(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFields(
    _DialogControllers controllers,
    _DialogFocusNodes focusNodes,
    double fieldWidth,
    double totalAmount,
    StateSetter setState,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: fieldWidth,
          child: CustomTextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            labelText: 'Cash Amount',
            controller: controllers.cash,
            focusNode: focusNodes.cash,
            keyBoardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: CustomTextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            labelText: 'Card Amount',
            controller: controllers.card,
            focusNode: focusNodes.card,
            keyBoardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: CustomTextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            labelText: 'Credit Amount',
            controller: controllers.credit,
            focusNode: focusNodes.credit,
            keyBoardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        if (!fieldsAreEqualToAmount(controllers, totalAmount))
          Text(
            '*please check the amount again. Expected total amount is $totalAmount ',
            style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.red.shade600),
          )
      ],
    );
  }

  bool fieldsAreEqualToAmount(_DialogControllers controllers, double totalAmount) {
    num cashValue = num.tryParse(controllers.cash.text) ?? 0;
    num cardValue = num.tryParse(controllers.card.text) ?? 0;
    num creditValue = num.tryParse(controllers.credit.text) ?? 0;
    num sum = cashValue + cardValue + creditValue;
    if (sum == totalAmount) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildSummarySection(double totalAmount, double netAmount, double width) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: AppStyles.getMediumTextStyle(fontSize: 16),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net Amount:',
                  style: AppStyles.getSemiBoldTextStyle(fontSize: 18),
                ),
                Text(
                  '₹${netAmount.toStringAsFixed(2)}',
                  style: AppStyles.getSemiBoldTextStyle(
                    fontSize: 18,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrder(
    BuildContext dialogContext,
    GlobalKey<FormState> formKey,
    _DialogControllers controllers,
    CartLoadedState state,
  ) {
    if (!formKey.currentState!.validate()) return;

    // Create order items
    final orderItems = state.cart!.cartItems
        .map(
          (cartItem) => OrderItem(
            price: cartItem.totalPrice,
            productId: cartItem.product.id,
            quantity: cartItem.quantity,
          ),
        )
        .toList();

    // Get payment method
    String paymentMethod = 'Cash';
    if (controllers.card.text.isNotEmpty) paymentMethod = 'Card';
    if (controllers.credit.text.isNotEmpty) paymentMethod = 'Credit';

    // Create order model
    final orderModel = OrderModel(
      orderItems: orderItems,
      discount: 0, // Calculate based on discount fields if needed
      paymentMethod: paymentMethod,
      cardAmount: controllers.card.text.isEmpty ? 0 : num.parse(controllers.card.text),
      cashAmount: controllers.cash.text.isEmpty ? 0 : num.parse(controllers.cash.text),
      grossTotal: state.cart!.totalCartPrice,
      netTotal: state.cart!.totalCartPrice,
      customerId: customerList.firstWhereOrNull((customer) => customer.phone == controllers.customerPhone.text)?.id ?? 0,
    );

    // Create customer model
    final customerModel = CustomerModel(
      name: controllers.customerName.text,
      email: controllers.customerEmail.text,
      address: controllers.customerAddress.text,
      gender: controllers.customerGender.text,
      id: customerList.firstWhereOrNull((customer) => customer.phone == controllers.customerPhone.text)?.id ?? 0,
      phone: controllers.customerPhone.text,
    );

    // Submit order
    context.read<CartBloc>().add(
          SubmitingCartEvent(
            orderModel: orderModel,
            customerModel: customerModel,
          ),
        );

    Navigator.of(dialogContext).pop();
  }
}

// Helper classes for better organization
class _DialogControllers {
  final customerName = TextEditingController();
  final customerEmail = TextEditingController();
  final customerAddress = TextEditingController();
  final customerPhone = TextEditingController();
  final customerGender = TextEditingController();
  final discountByPercent = TextEditingController();
  final discountByAmount = TextEditingController();
  final cash = TextEditingController();
  final card = TextEditingController();
  final credit = TextEditingController();

  void dispose() {
    customerName.dispose();
    customerEmail.dispose();
    customerAddress.dispose();
    customerPhone.dispose();
    customerGender.dispose();
    discountByPercent.dispose();
    discountByAmount.dispose();
    cash.dispose();
    card.dispose();
    credit.dispose();
  }
}

class _DialogFocusNodes {
  final customerName = FocusNode();
  final customerEmail = FocusNode();
  final customerAddress = FocusNode();
  final customerPhone = FocusNode();
  final customerGender = FocusNode();
  final discountByPercent = FocusNode();
  final discountByAmount = FocusNode();
  final cash = FocusNode();
  final card = FocusNode();
  final credit = FocusNode();

  void dispose() {
    customerName.dispose();
    customerEmail.dispose();
    customerAddress.dispose();
    customerPhone.dispose();
    customerGender.dispose();
    discountByPercent.dispose();
    discountByAmount.dispose();
    cash.dispose();
    card.dispose();
    credit.dispose();
  }
}
