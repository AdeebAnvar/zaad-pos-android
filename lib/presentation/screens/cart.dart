import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  List<int> quantities = [1, 1, 1, 1];
  int index = 0;

  TextEditingController cashController = TextEditingController();
  TextEditingController cardController = TextEditingController();
  TextEditingController splitBillingCashController = TextEditingController();
  TextEditingController splitBillingCardController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                            itemCount: quantities.length,
                            itemBuilder: (BuildContext c, int i) {
                              return Container(
                                height: 80,
                                padding: const EdgeInsets.all(13),
                                margin: const EdgeInsets.symmetric(vertical: 5),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chicken Shawarma',
                                          style: AppStyles.getRegularTextStyle(fontSize: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'AED 200',
                                          style: AppStyles.getRegularTextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 35,
                                      width: 100,
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
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (quantities[i] > 0) {
                                                    quantities[i]--;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(color: AppColors.primaryColor),
                                                child: Center(
                                                    child: Text(
                                                  '-',
                                                  style: AppStyles.getBoldTextStyle(fontSize: 15, color: Colors.white),
                                                )),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                  child: Text(
                                                quantities[i].toString(),
                                                style: AppStyles.getRegularTextStyle(fontSize: 15),
                                              )),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  quantities[i]++;
                                                });
                                                print(quantities);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(color: AppColors.primaryColor),
                                                child: Center(
                                                    child: Text(
                                                  '+',
                                                  style: AppStyles.getBoldTextStyle(fontSize: 15, color: Colors.white),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 10),
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
                              children: paymentModes.asMap().entries.map((e) {
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        index = e.key;
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
                                          e.value,
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
                          if (paymentModes[index] == 'CASH')
                            Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: CustomTextField(
                                controller: cashController,
                                fillColor: Colors.white,
                                labelText: 'Cash',
                              ),
                            )
                          else if (paymentModes[index] == 'CARD')
                            Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: CustomTextField(
                                controller: cardController,
                                fillColor: Colors.white,
                                labelText: 'Card',
                              ),
                            )
                          else if (paymentModes[index] == 'SPLIT')
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                    child: CustomTextField(
                                      controller: splitBillingCashController,
                                      fillColor: Colors.white,
                                      labelText: 'Cash',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 9),
                                Expanded(
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                    child: CustomTextField(
                                      controller: splitBillingCardController,
                                      fillColor: Colors.white,
                                      labelText: 'Card',
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
                          Container(
                            height: 50,
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: CustomTextField(
                                controller: customerPhoneController,
                                fillColor: Colors.white,
                                labelText: 'Contact number',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 50,
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: CustomTextField(
                                controller: customerNameController,
                                fillColor: Colors.white,
                                labelText: 'Customer name',
                              ),
                            ),
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
                                      '5',
                                      style: AppStyles.getMediumTextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
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
                                    Text(
                                      'AED 4000',
                                      style: AppStyles.getMediumTextStyle(fontSize: 17),
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
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}

List paymentModes = ['CASH', 'CARD', 'CREDIT', 'SPLIT'];
