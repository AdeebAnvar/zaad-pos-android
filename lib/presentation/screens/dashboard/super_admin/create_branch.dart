// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/branch_model.dart';
import 'package:pos_app/data/models/response_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_textfield.dart';
import 'package:pos_app/widgets/multi_expansion_card.dart';

class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key, this.branchModel});
  final BranchModel? branchModel;
  static String route = '/create_branch';

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? logoFilePath;
  String? _installationDate;
  String? _expiryDate;
// Controllers
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();
  final TextEditingController _invPrefixController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _vatPercentController = TextEditingController();
  final TextEditingController _trnNumberController = TextEditingController();

// FocusNodes
  final FocusNode _branchNameFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _contactNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _socialMediaFocus = FocusNode();
  final FocusNode _invPrefixFocus = FocusNode();
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _vatPercentFocus = FocusNode();
  final FocusNode _trnNumberFocus = FocusNode();

  @override
  void dispose() {
    _branchNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _socialMediaController.dispose();
    _invPrefixController.dispose();
    _vatController.dispose();
    _vatPercentController.dispose();
    _locationController.dispose();
    _trnNumberController.dispose();

    _branchNameFocus.dispose();
    _contactNumberFocus.dispose();
    _locationFocus.dispose();
    _emailFocus.dispose();
    _socialMediaFocus.dispose();
    _invPrefixFocus.dispose();
    _vatFocus.dispose();
    _vatPercentFocus.dispose();
    _trnNumberFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Branch',
          style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 900;
          final double fieldWidth = isWide ? (constraints.maxWidth / 2) - 60 : constraints.maxWidth;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: MultipleExpansionCard(
                  initialExpanded: {0: true},
                  titles: [
                    Text(
                      'Basic Details',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 12),
                    ),
                    Text(
                      'Additional Details',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 12),
                    ),
                  ],
                  childrens: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: Row(
                              children: [
                                Container(
                                  width: 71,
                                  height: 71,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: logoFilePath != null
                                      ? Image.file(
                                          File(logoFilePath!),
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.image_outlined,
                                          size: 60,
                                          color: Colors.grey.shade500,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: () async {
                                    final picker = ImagePicker();
                                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                    if (pickedFile == null) return;
                                    logoFilePath = pickedFile.path;
                                    widget.branchModel?.image = pickedFile.path;
                                    setState(() {});
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStateProperty.all(AppColors.primaryColor),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Choose Image'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Branch Name',
                              controller: _branchNameController,
                              focusNode: _branchNameFocus,
                              onChanged: (value) {
                                widget.branchModel?.name = value;
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid branch name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Contact Number',
                              controller: _contactNumberController,
                              focusNode: _contactNumberFocus,
                              keyBoardType: TextInputType.phone,
                              onChanged: (v) {
                                widget.branchModel?.contactNumber = v;
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid contact number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Location',
                              controller: _locationController,
                              focusNode: _locationFocus,
                              onChanged: (v) {
                                widget.branchModel?.location = v;
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid location';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Email Address',
                              controller: _emailController,
                              onChanged: (v) {
                                widget.branchModel?.email = v;
                              },
                              keyBoardType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Social Media',
                              onChanged: (v) {
                                widget.branchModel?.socialMedia = v;
                              },
                              controller: _socialMediaController,
                              focusNode: _socialMediaFocus,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Branch INV prefix',
                              controller: _invPrefixController,
                              focusNode: _invPrefixFocus,
                              onChanged: (v) {
                                widget.branchModel?.invPrefix = v;
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid inv prefix';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'VAT',
                              focusNode: _vatFocus,
                              onChanged: (v) {
                                widget.branchModel?.vat = v;
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid VAT';
                                }
                                return null;
                              },
                              controller: _vatController,
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'VAT Percentage',
                              controller: _vatPercentController,
                              focusNode: _vatPercentFocus,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyBoardType: TextInputType.number,
                              onChanged: (v) {
                                widget.branchModel?.vatPercent = int.parse(v);
                              },
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid VAT percentage';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: CustomTextField(
                              labelText: 'Trn Number',
                              onChanged: (v) {
                                widget.branchModel?.location = v;
                              },
                              controller: _trnNumberController,
                              focusNode: _trnNumberFocus,
                              validator: (v) {
                                if (v.isNullOrEmpty()) {
                                  return 'Add a valid TRN number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  _installationDate = pickedDate.toIso8601String().split('T').first;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_installationDate ?? "Instalation Date"),
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  _expiryDate = pickedDate.toIso8601String().split('T').first;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_expiryDate ?? "Expiry Date"),
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          try {
            CustomDialog.showLoading(context, loadingText: "Creating Branch");
            BranchModel branchModel = BranchModel(
                id: widget.branchModel?.id ?? 0,
                image: logoFilePath,
                name: _branchNameController.text,
                contactNumber: _contactNumberController.text,
                location: _locationController.text,
                email: _emailController.text,
                socialMedia: _socialMediaController.text,
                invPrefix: _invPrefixController.text,
                vat: _vatController.text,
                vatPercent: int.parse(_vatPercentController.text),
                expiryDate: DateTime.parse(_expiryDate.toString()),
                installationDate: DateTime.parse(_installationDate.toString()));
            var response = await uploadBranchWithImage(branchModel, logoFilePath);
            print(response);
            if (response.isSuccess) {
              context.pop();
            }
          } catch (e) {
            print(e);
          } finally {
            CustomDialog.hideLoading(context);
          }
        },
        child: Container(
          height: 70,
          color: AppColors.primaryColor,
          child: Center(
            child: Text(
              'Save',
              style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

Future<ResponseModel> uploadBranchWithImage(BranchModel branchModel, String? imagePath) async {
  try {
    final Dio _dio = Client().init();

    FormData formData = FormData.fromMap({
      'id': branchModel.id,
      'name': branchModel.name,
      'inv_prefix': branchModel.invPrefix,
      'location': branchModel.location,
      'contact_number': branchModel.contactNumber,
      'email': branchModel.email,
      'social_media': branchModel.socialMedia,
      'vat': branchModel.vat,
      'vat_percent': branchModel.vatPercent,
      'trn_number': branchModel.trnNumber,
      'installation_date': branchModel.installationDate?.toIso8601String(),
      'expiry_date': branchModel.expiryDate?.toIso8601String(),
      if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
    });

    final response = await _dio.post(
      Urls.saveBranch,
      data: formData,
      options: Options(headers: {
        ...Urls.getHeaders(),
        'Content-Type': 'multipart/form-data',
      }),
    );

    final jsonObject = response.data as Map<String, dynamic>;
    return ResponseModel(
      statusCode: response.statusCode!,
      body: json.encode(response.data),
      response: response,
      responseObject: jsonObject,
      errorMessage: jsonObject['message'],
      isSuccess: jsonObject['status'],
    );
  } catch (e) {
    print(e);
    return ResponseModel(
      statusCode: 0,
      body: e.toString(),
      response: null,
      errorMessage: e.toString(),
      isSuccess: false,
      responseObject: {},
    );
  }
}
