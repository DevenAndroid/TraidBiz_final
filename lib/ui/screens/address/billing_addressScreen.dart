import 'dart:developer';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:traidbiz/controller/AddressController.dart';
import 'package:traidbiz/repositories/update_user_meta_repository.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_text_field.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

class BillingAddress extends StatefulWidget {
  const BillingAddress({Key? key}) : super(key: key);

  @override
  State<BillingAddress> createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddress> {
  String? countryPostCode;
  String? countryIsoCode;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _addressController = Get.put(AddressController());
  String billingCountry = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Obx(() {
          if (_addressController.isDataLoading.value) {
            fNameController.text = _addressController
                .model.value.data!.billingAddress.billingFirstName
                .toString();

            lnameController.text = _addressController
                .model.value.data!.billingAddress.billingLastName
                .toString();

            billingCountry = _addressController.model.value.data!.billingAddress.billingCountry.toString();
            address1.text = _addressController
                .model.value.data!.billingAddress.billingAddress_1
                .toString();
            address2.text = _addressController
                .model.value.data!.billingAddress.billingAddress_2
                .toString();

            postcodeController.text = _addressController
                .model.value.data!.billingAddress.billingPostcode
                .toString();
            cityController.text = _addressController
                .model.value.data!.billingAddress.billingCity
                .toString();
            phoneController.text = _addressController
                .model.value.data!.billingAddress.billingPhone
                .toString();
            emailController.text = _addressController
                .model.value.data!.billingAddress.billingEmail
                .toString();
          }
          return _addressController.isDataLoading.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First name *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.person,
                      hint: 'First name',
                      controller: fNameController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Last name *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.person,
                      hint: 'Last name  ',
                      controller: lnameController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Address line 1 *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.home_outlined,
                      hint: 'Street address',
                      controller: address1,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Address line 2'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.home_outlined,
                      hint: 'Street Optional',
                      controller: address2,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Postcode/ zip *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.home_outlined,
                      hint: 'Postcode',
                      controller: postcodeController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Town/ City *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.location_city_sharp,
                      hint: 'City/town',
                      controller: cityController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Country Code'),
                    addHeight(8),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey)),
                      padding: const EdgeInsets.all(8),
                      child: CountryPickerDropdown(
                        isExpanded: true,
                        initialValue: _addressController.model.value.data!.billingAddress.countryIsoCode.toString()??'fj',
                        itemBuilder: _buildDropdownItemNew,
                        onValuePicked: (Country country) {
                          print("${country.name}");
                          print("${country.phoneCode}");
                          countryPostCode = country.phoneCode;
                          countryIsoCode = country.isoCode.toLowerCase();
                          print("object$countryPostCode");
                          print("object1$countryIsoCode");
                        },
                      ),
                    ),
                    addHeight(12),
                    const Text('Phone *'),
                    addHeight(8),
                    /*CommonTextFieldWidget(
                      icon: Icons.phone_android_sharp,
                      hint: 'Phone',
                      controller: phoneController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),*/
                    TextFormField(
                      controller: phoneController,
                      // obscureText: isPasswordShow.value,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                        return 'Mobile Number can\'t be empty.';
                      }
                        return null;},
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Phone',
                          counterText: "",
                          filled: true,
                          errorMaxLines: 2,
                          fillColor: AppTheme.colorEditFieldBg,
                          focusColor: AppTheme.colorEditFieldBg,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppTheme.primaryColorVariant),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: AppTheme.primaryColorVariant),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppTheme.primaryColor, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(Icons.phone_android_outlined),
                          suffixIcon: const SizedBox.shrink()),
                    ),
                    addHeight(12),
                    const Text('Email *'),
                    addHeight(8),
                    CommonTextFieldWidget(
                      icon: Icons.mail_outlined,
                      hint: 'Email address',
                      controller: emailController,
                      bgColor: AppTheme.colorEditFieldBg,
                    ),
                    addHeight(12),
                    const Text('Country *'),
                    addHeight(12),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey)),
                      padding: const EdgeInsets.all(10),
                      child: CountryPickerDropdown(
                        initialValue: _addressController.model.value.data!.billingAddress.billingCountry==null
                            ? "fj"
                            : _addressController.model.value.data!.billingAddress.billingCountry.toString(),
                        isExpanded: true,
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Country country) {
                          billingCountry = country.isoCode.toString();
                          print(billingCountry.toString());
                        },
                      ),
                    ),
                    addHeight(12),
                    CommonButton(
                        buttonHeight: 6.5,
                        buttonWidth: 100,
                        text: 'SAVE ADDRESS',
                        onTap: () {
                          if (fNameController.text.toString().isEmpty ||
                              lnameController.text.toString().isEmpty ||
                              address1.text.toString().isEmpty ||
                              postcodeController.text.toString().isEmpty ||
                              cityController.text.toString().isEmpty ||
                              billingCountry.toString().isEmpty ||
                              phoneController.text.toString().isEmpty ||
                              emailController.text.toString().isEmpty) {
                            showToast("Please fill all required details");
                          } else {
                            (
                                updateAddress(
                              context,
                              fNameController.text.toString(),
                              lnameController.text.toString(),
                              address1.text.toString(),
                              address2.text.toString(),
                              postcodeController.text.toString(),
                              cityController.text.toString(),
                              countryIsoCode==null ?"fj": countryIsoCode.toString(),
                              countryPostCode!=null ? "+$countryPostCode" : _addressController.model.value.data!.billingAddress.countryIsoCode.toString(),
                              phoneController.text.toString(),
                              emailController.text.toString(),
                              billingCountry.toString(),
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                            ).then((value) {
                              if (value.status) {
                                Fluttertoast.showToast(
                                  msg: value.message, // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity
                                      .BOTTOM, // location// duration
                                );
                              }
                              return null;
                            }));
                          }
                        },
                        mainGradient: AppTheme.primaryGradientColor)
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.newprimaryColor));
        }),
      ),
    );
  }
  Widget _buildDropdownItem(Country country) => SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                country.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );

  Widget _buildDropdownItemNew(Country country) => Container(
    child: Row(
      children: <Widget>[
        const SizedBox(
          width: 12.0,
        ),
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0,),
        // Text("+${country.phoneCode}(${country.isoCode})"),
        Text("+${country.phoneCode}"),
      ],
    ),
  );

}
