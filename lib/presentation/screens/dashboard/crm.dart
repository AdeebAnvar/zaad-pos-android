import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_textfield.dart';
import 'package:pos_app/widgets/customer_card.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  TextEditingController customerData = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrmBloc, CrmState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CrmScreenLoadingSuccessState) {
          return Scaffold(
            body: ListView(
              padding: EdgeInsets.all(14),
              children: [
                AutoCompleteTextField<CustomerModel>(
                  items: state.customersList,
                  controller: customerData,
                  displayStringFunction: (v) {
                    return v.customerName ?? "";
                  },
                  searchFunction: (customer) => [
                    customer.mobileNumber ?? "",
                    customer.customerName ?? "",
                    customer.email ?? "",
                  ],
                  onSelected: (customer) {
                    BlocProvider.of<CrmBloc>(context).add(SelectCustomerEvent(selectedCustomer: customer));
                  },
                  onChanged: (value) {
                    BlocProvider.of<CrmBloc>(context).add(SearchCustomersEvent(searchQuery: value));
                  },
                  defaultText: "Search Customer",
                  labelText: "Search Customer",
                ),
                SizedBox(height: 15),
                if (state.customersList.isEmpty)
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Data Found Please sync"),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
                          },
                          child: Text("Refresh"))
                    ],
                  ))
                else
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.filteredCustomersList.length,
                    itemBuilder: (c, i) {
                      return CustomerCard(customerModel: state.customersList[i]);
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
        } else {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Data Found Please sync"),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
                  },
                  child: Text("Refresh"))
            ],
          ));
        }
      },
    );
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

  void showCustomerCreationSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();
    String? selectedGender;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BlocListener<CrmBloc, CrmState>(
        listener: (context, state) {
          if (state is CrmScreenLoadingState) {
            FocusScope.of(context).unfocus();
            context.pop();
          }
        },
        child: PopScope(
          onPopInvoked: (d) {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(18),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Text(
                      "Create Customer",
                      style: AppStyles.getMediumTextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      labelText: "Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      fillColor: Colors.transparent,
                      controller: nameController,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      labelText: "Email",
                      keyBoardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      fillColor: Colors.transparent,
                      controller: emailController,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      labelText: "Phone Number",
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyBoardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      fillColor: Colors.transparent,
                      controller: numberController,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      labelText: "Address",
                      keyBoardType: TextInputType.streetAddress,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                      fillColor: Colors.transparent,
                      controller: addressController,
                    ),
                    const SizedBox(height: 14),
                    AutoCompleteTextField<String>(
                      disableSearch: true,
                      labelText: "Select Gender",
                      showAsUpperLabel: true,
                      optionsViewOpenDirection: OptionsViewOpenDirection.up,
                      items: ["Male", "Female"],
                      displayStringFunction: (v) {
                        return v;
                      },
                      onSelected: (v) {
                        selectedGender = v;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) {
                          return "Select gender";
                        }
                        return null;
                      },
                      defaultText: "Gender",
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          CustomerModel customer = CustomerModel(
                            address: addressController.text,
                            customerName: nameController.text,
                            email: emailController.text,
                            gender: selectedGender.toString(),
                            mobileNumber: numberController.text,
                          );
                          BlocProvider.of<CrmBloc>(context).add(AddCustomerEvent(customer: customer));
                        }
                      },
                      style: AppStyles.filledButton,
                      child: const Text("Create"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
