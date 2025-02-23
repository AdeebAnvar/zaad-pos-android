import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        elevation: 0,
        title: Text(
          "Customer Details",
        ),
      ),
      body: BlocConsumer<CrmBloc, CrmState>(
        bloc: _crmBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomerOrdersFetchedState) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
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
