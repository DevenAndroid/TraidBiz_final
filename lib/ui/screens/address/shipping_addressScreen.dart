import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:traidbiz/controller/AddressController.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_text_field.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

import '../../../repositories/update_user_meta_repository.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({Key? key}) : super(key: key);

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final AddressController _addressController = Get.put(AddressController());
  String shippingCountry = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_addressController.isDataLoading.value) {
      fnameController.text = _addressController
          .model.value.data!.shippingAddress.shippingFirstName
          .toString();
      lnameController.text = _addressController
          .model.value.data!.shippingAddress.shippingLastName
          .toString();
      address1.text = _addressController
          .model.value.data!.shippingAddress.shippingAddress_1
          .toString();
      address2.text = _addressController
          .model.value.data!.shippingAddress.shippingAddress_2
          .toString();
      postcodeController.text = _addressController
          .model.value.data!.shippingAddress.shippingPostcode
          .toString();
      cityController.text = _addressController
          .model.value.data!.shippingAddress.shippingCity
          .toString();
      shippingCountry = _addressController
          .model.value.data!.shippingAddress.shippingCountry
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('First name'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.person,
              hint: 'First name',
              controller: fnameController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Last name'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.person,
              hint: 'last name',
              controller: lnameController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Address 1'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Street address',
              controller: address1,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Address 2'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Street Optional',
              controller: address2,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Postcode/ zip'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Postcode',
              controller: postcodeController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Town/ City'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.location_city_sharp,
              hint: 'City/town',
              controller: cityController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Country *'),
            addHeight(12),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
              padding: const EdgeInsets.all(10),
              child: CountryPickerDropdown(
                initialValue: 'in',
                isExpanded: true,
                itemBuilder: _buildDropdownItem,
                onValuePicked: (Country country) {
                  shippingCountry = country.isoCode.toString();
                  print(shippingCountry);
                },
              ),
            ),
            addHeight(12),
            CommonButton(
                buttonHeight: 6.5,
                buttonWidth: 100,
                text: 'SAVE ADDRESS',
                onTap: () {
                  updateAddress(
                    context,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    // for country code
                    "",
                    "",
                    // for country code end
                    fnameController.text.toString(),
                    lnameController.text.toString(),
                    address1.text.toString(),
                    address2.text.toString(),
                    postcodeController.text.toString(),
                    cityController.text.toString(),
                    shippingCountry.toString(),
                  ).then((value) {
                    if (value.status) {
                      Fluttertoast.showToast(
                        msg: value.message, // message
                        toastLength: Toast.LENGTH_SHORT, // length
                        gravity: ToastGravity.BOTTOM, // location// duration
                      );
                    }
                    return null;
                  });
                },
                mainGradient: AppTheme.primaryGradientColor)
          ],
        ),
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
            )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
}
