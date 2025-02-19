import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
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
    // TODO: implement initState
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
      ),
      body: BlocConsumer<CrmBloc, CrmState>(
        bloc: _crmBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomerOrdersFetchedState) {
            return ListView(
              padding: EdgeInsets.all(14),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.black26,
                      //   blurRadius: 12,
                      // ),
                    ],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Details",
                        style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 15),
                      buildLabel("Customer Name  : ", widget.customerModel.name),
                      buildLabel("Customer Phone Number : ", widget.customerModel.phone),
                      buildLabel("Customer Email : ", widget.customerModel.email),
                      buildLabel("Customer Address : ", widget.customerModel.address),
                      buildLabel("Customer Gender : ", widget.customerModel.gender),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                ExpansionTile(
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  childrenPadding: EdgeInsets.all(12),
                  dense: true,
                  shape: RoundedRectangleBorder(),
                  title: Text(
                    "Latest 5 Orders",
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
                  ),
                  children: state.orders
                      .asMap()
                      .entries
                      .take(5)
                      .expand((e) => [
                            buildLabel(
                              "Reciept Number : ",
                              e.value.recieptNumber,
                              needPoPup: true,
                              onTapItems: () {
                                showItemDialogue(context, productsList: e.value.cart?.cartItems ?? []);
                              },
                            ),
                            buildLabel("Order Type : ", e.value.orderType),
                            buildLabel("Gross Total : ", e.value.grossTotal.toString()),
                            buildLabel("Discount : ", e.value.discount.toString()),
                            buildLabel("Net Total : ", e.value.netTotal.toString()),
                            e.key == (state.orders.take(5).length - 1) ? SizedBox() : Divider(),
                          ])
                      .toList(),
                ),
                SizedBox(height: 18),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildLabel(String? title, String? label, {bool needPoPup = false, void Function()? onTapItems}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  title ?? "",
                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                )),
            Expanded(
                flex: 3,
                child: Text(
                  label ?? "",
                  style: AppStyles.getRegularTextStyle(fontSize: 14),
                )),
            if (needPoPup)
              PopupMenuButton(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                itemBuilder: (c) => [
                  PopupMenuItem(
                    onTap: onTapItems,
                    child: Text('Items'),
                  ),
                  PopupMenuItem(
                    child: Text('Payback'),
                  ),
                ],
              )
          ],
        ),
      );

  showItemDialogue(BuildContext context, {required List<CartItemModel> productsList}) {
    return showDialog(
        context: context,
        builder: (c) => AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...productsList.expand(
                    (e) => [
                      Text(e.product?.name ?? ""),
                      // SizedBox(height: 5),
                      // Text(e.product!.category.toString()),
                      SizedBox(height: 5),
                      Text("Discount Price ${e.product!.discountPrice.toString()}"),
                      SizedBox(height: 5),
                      Text("Unit Price ${e.product!.unitPrice.toString()}"),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ));
  }
}
