import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key, required this.customerModel});
  static String route = "/customer_details_screen.dart";
  final CustomerModel customerModel;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late CrmBloc _crmBloc;

  @override
  void initState() {
    super.initState();
    _crmBloc = CrmBloc();
    _crmBloc.add(FetchCustomerOrdersEvent(customerId: widget.customerModel.id ?? 0));
  }

  List<String> titles = ['Customer Name', 'Email', 'Phone Number', 'Address', 'Gender'];
  List<String> orderTitles = ['Receipt No.', 'Order Type', 'Gross Total', 'Discount', 'Net Total', 'Actions'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        title: Text(
          "Customer Details",
          style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: BlocConsumer<CrmBloc, CrmState>(
        bloc: _crmBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomerOrdersFetchedState) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: AppResponsive.isDesktop(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                ),
                                children: titles
                                    .map((e) => Container(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            e,
                                            style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              TableRow(
                                children: [
                                  widget.customerModel.name,
                                  widget.customerModel.email,
                                  widget.customerModel.phone,
                                  widget.customerModel.address,
                                  widget.customerModel.gender
                                ].asMap().entries.map((e) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      e.value ?? "",
                                      style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Latest 5 Orders",
                          style: AppStyles.getMediumTextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(height: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                            ),
                            children: [
                              // Header Row
                              TableRow(
                                children: orderTitles.asMap().entries.map((entry) {
                                  final isFirst = entry.key == 0;
                                  final isLast = entry.key == orderTitles.length - 1;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: isFirst ? Radius.circular(7) : Radius.zero,
                                        topRight: isLast ? Radius.circular(7) : Radius.zero,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      entry.value,
                                      style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),

                              // Data Rows
                              ...state.orders.asMap().entries.map((customer) {
                                return TableRow(
                                  children: List.generate(orderTitles.length, (index) {
                                    final value = () {
                                      switch (index) {
                                        case 0:
                                          return '${customer.key + 1}';
                                        case 1:
                                          return customer.value.recieptNumber;
                                        case 2:
                                          return customer.value.orderType ?? "";
                                        case 3:
                                          return "₹${customer.value.grossTotal}";
                                        case 4:
                                          return "₹${customer.value.discount}";
                                        case 5:
                                          return "₹${customer.value.netTotal}";
                                        default:
                                          return ""; // For index 6 or beyond
                                      }
                                    }();
                                    return Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        value ?? "",
                                        style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    );
                                  }),
                                );
                              }).toList(),
                            ],
                          ),
                        )
                      ],
                    )

                  // Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         child: _buildCustomerDetailsCard(),
                  //       ),
                  //       SizedBox(width: 20),
                  //       Expanded(
                  //         child: _buildOrdersExpansionTile(state.orders),
                  //       ),
                  //     ],
                  //   )
                  : Column(
                      children: [
                        _buildCustomerDetailsCard(),
                        SizedBox(height: 20),
                        _buildOrdersExpansionTile(state.orders),
                      ],
                    ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  /// **Customer Details Card**
  Widget _buildCustomerDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          buildLabel("Phone:", widget.customerModel.phone),
          buildLabel("Name:", widget.customerModel.name),
          buildLabel("Email:", widget.customerModel.email),
          buildLabel("Address:", widget.customerModel.address),
          buildLabel("Gender:", widget.customerModel.gender),
        ],
      ),
    );
  }

  /// **Orders List (Expandable)**
  Widget _buildOrdersExpansionTile(List<OrderModel> orders) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      childrenPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      title: Text(
        "Latest 5 Orders",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      children: orders
          .take(5)
          .map((order) => Column(
                children: [
                  buildLabel(
                    "Receipt No.:",
                    order.recieptNumber,
                    needPoPup: true,
                    onTapItems: () => showItemDialogue(context, orderItemList: order.orderItems ?? []),
                  ),
                  buildLabel("Order Type:", order.orderType),
                  buildLabel("Gross Total:", "₹${order.grossTotal}"),
                  buildLabel("Discount:", "₹${order.discount}"),
                  buildLabel("Net Total:", "₹${order.netTotal}"),
                  Divider(color: Colors.grey.shade300),
                ],
              ))
          .toList(),
    );
  }

  /// **Reusable Label Widget**
  Widget buildLabel(String title, String? label, {bool needPoPup = false, void Function()? onTapItems}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Expanded(flex: 4, child: Text(label ?? "-", style: TextStyle(fontSize: 14))),
          if (needPoPup)
            PopupMenuButton(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              itemBuilder: (context) => [
                PopupMenuItem(onTap: onTapItems, child: Text('View Items')),
                PopupMenuItem(child: Text('Payback')),
              ],
            )
        ],
      ),
    );
  }

  void showItemDialogue(BuildContext context, {required List<OrderItem> orderItemList}) {
    List<ProductModel> productList = [];

    productList = ProductDb.getProducts();

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Order Items",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: orderItemList.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final item = orderItemList[index];
              final String productName = productList.firstWhereOrNull((e) => e.id == item.productId)?.name ?? "";
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.blueGrey, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "price: ₹${item.price}",
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Quantity: ${item.quantity}",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
