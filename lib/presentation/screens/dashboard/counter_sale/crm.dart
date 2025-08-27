import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale/customer_details.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_textfield.dart';
import 'package:pos_app/widgets/customer_card.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  TextEditingController customerData = TextEditingController();
  FocusNode customerNode = FocusNode();
  List<String> titles = ['sl no', 'Customer', 'Customer purchased Amount', 'Customer Purchased count'];

  @override
  void initState() {
    super.initState();
    print('defs');
    BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerData.dispose();
    customerNode.dispose();
  }

  int? hoveredRowIndex;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrmBloc, CrmState>(
      listener: (context, state) {},
      builder: (context, state) {
        print('kjdsfoi  $state');
        if (state is CrmScreenLoadingSuccessState) {
          return AppResponsive.isDesktop(context)
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // height: 40,
                          // width: 250,
                          child: AutoCompleteTextField<CustomerModel>(
                            items: state.customersList,
                            controller: customerData,
                            focusNode: customerNode,
                            displayStringFunction: (v) {
                              return v.name ?? "";
                            },
                            searchFunction: (customer) => [
                              customer.phone ?? "",
                              customer.name ?? "",
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
                        ),
                        Spacer(flex: 2),
                        CustomResponsiveButton(
                          onPressed: () => showCustomerCreationSheet(context),
                          text: 'Create Customer',
                          height: 40,
                          width: 250,
                          isFullWidth: false,
                          elevation: 0,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                          ...state.filteredCustomersList
                              .asMap()
                              .entries
                              .map((customer) => TableRow(
                                    children: titles.asMap().entries.map((e) {
                                      return InkWell(
                                        onHover: (value) {
                                          setState(() {
                                            hoveredRowIndex = value ? customer.key : null;
                                          });
                                        },
                                        onTap: () => context.pushNamed(CustomerDetailsScreen.route, extra: {"data": customer.value}),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: hoveredRowIndex == customer.key ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            e.key == 0
                                                ? '${customer.key + 1}'
                                                : e.key == 1
                                                    ? "${customer.value.name}-${customer.value.phone}"
                                                    : e.key == 2
                                                        ? ""
                                                        : "",
                                            style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ))
                              .toList()
                        ],
                      ),
                    )
                  ],
                )
              : Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<CrmBloc>(context).add(GetAllCustomersEvent());
                    },
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(14),
                      children: [
                        AutoCompleteTextField<CustomerModel>(
                          items: state.customersList,
                          controller: customerData,
                          focusNode: customerNode,
                          displayStringFunction: (v) {
                            return v.name ?? "";
                          },
                          searchFunction: (customer) => [
                            customer.phone ?? "",
                            customer.name ?? "",
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

  void showCustomerCreationSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    FocusNode focusNode = FocusNode();
    final GlobalKey<FormState> formKey = GlobalKey();

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
                      controller: genderController,
                      showAsUpperLabel: true,
                      focusNode: focusNode,
                      optionsViewOpenDirection: OptionsViewOpenDirection.up,
                      items: ["Male", "Female"],
                      displayStringFunction: (v) {
                        return v;
                      },
                      onSelected: (v) {
                        genderController.text = v;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) {
                          return "Select gender";
                        }
                        return null;
                      },
                      defaultText: "Gender",
                      searchFunction: (v) => [genderController.text],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          CustomerModel customer = CustomerModel(
                            address: addressController.text,
                            name: nameController.text,
                            email: emailController.text,
                            gender: genderController.text.toString(),
                            phone: numberController.text,
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
