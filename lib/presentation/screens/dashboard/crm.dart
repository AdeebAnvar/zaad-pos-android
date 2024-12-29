import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/presentation/screens/cart.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

class CrmScreen extends StatelessWidget {
  const CrmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          DropdownButtonFormField<String>(
            hint: Text("Select Customer"),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_sharp),
            items: [
              DropdownMenuItem(
                value: "0",
                child: Text("All"),
              ),
              DropdownMenuItem(
                value: "2",
                child: Text("12345678900 - Sooraj"),
              ),
              DropdownMenuItem(
                value: "4",
                child: Text("94627817378 - fwe"),
              ),
            ],
            onChanged: (v) {},
          ),
          SizedBox(height: 15),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (c, i) {
              return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Faheem", "09837483679"),
                        SizedBox(height: 10),
                        buildLabel("Purchased Amount", "\$10000"),
                        SizedBox(height: 10),
                        buildLabel("Purchased Unit", "300"),
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        child: ElevatedButton(
          onPressed: () => showCustomerCreationSheet(context),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          child: Text("Create Customer"),
        ),
      ),
    );

    // floatingActionButton: FloatingActionButton(
    //   onPressed: () => context.pushNamed(CartView.route),
    //   shape: const CircleBorder(),
    //   backgroundColor: AppColors.primaryColor,
    //   child: SvgPicture.asset('assets/images/svg/cart.svg'),
    // ),
  }

  Row buildLabel(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Text(
          title,
          style: AppStyles.getRegularTextStyle(fontSize: 14),
        )),
        Expanded(
            child: Text(
          '-',
          style: AppStyles.getRegularTextStyle(fontSize: 12),
        )),
        Expanded(
            child: Text(
          data,
          style: AppStyles.getRegularTextStyle(fontSize: 14),
        )),
      ],
    );
  }

  showCustomerCreationSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController adddressController = TextEditingController();
    return showDialog(
      context: context,
      builder: (c) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Create Customer",
              style: AppStyles.getMediumTextStyle(fontSize: 12),
            ),
            SizedBox(height: 14),
            CustomTextField(
              hint: "Name",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: (value) {},
              fillColor: Colors.transparent,
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              controller: nameController,
            ),
            SizedBox(height: 14),
            CustomTextField(
              hint: "Email",
              keyboardType: TextInputType.emailAddress,
              validator: (value) {},
              fillColor: Colors.transparent,
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              controller: emailController,
            ),
            SizedBox(height: 14),
            CustomTextField(
              hint: "Number",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: (value) {},
              fillColor: Colors.transparent,
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              controller: numberController,
            ),
            SizedBox(height: 14),
            CustomTextField(
              hint: "Address",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.streetAddress,
              validator: (value) {},
              fillColor: Colors.transparent,
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              controller: adddressController,
            ),
            SizedBox(height: 14),
            DropdownButtonFormField<String>(
              hint: Text("Gender"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down_sharp),
              items: [
                DropdownMenuItem(
                  value: "0",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "2",
                  child: Text("Female"),
                ),
              ],
              onChanged: (v) {},
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Create",
              ),
              style: AppStyles.filledButton,
            ),
          ],
        ),
      ),
    );
  }
}
