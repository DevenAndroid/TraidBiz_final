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

class _ShippingAddressState extends State<ShippingAddress> with AutomaticKeepAliveClientMixin {

  final controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              controller: controller.fnameController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Last name'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.person,
              hint: 'last name',
              controller: controller.lnameController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Address 1'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Street address',
              controller: controller.address1,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Address 2'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Street Optional',
              controller: controller.address2,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Postcode/ zip'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.home_outlined,
              hint: 'Postcode',
              controller: controller.postcodeController,
              bgColor: AppTheme.colorEditFieldBg,
            ),
            addHeight(12),
            const Text('Town/ City'),
            addHeight(8),
            CommonTextFieldWidget(
              icon: Icons.location_city_sharp,
              hint: 'City/town',
              controller: controller.cityController,
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
                initialValue: controller.shippingCountry == "" || controller.shippingCountry == "null" ? 'in' : controller.shippingCountry,
                isExpanded: true,
                itemBuilder: _buildDropdownItem,
                onValuePicked: (Country country) {
                  controller.shippingCountry = country.isoCode.toString();
                  print(controller.shippingCountry);
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
                    controller.fnameController.text.toString(),
                    controller.lnameController.text.toString(),
                    controller.address1.text.toString(),
                    controller.address2.text.toString(),
                    controller.postcodeController.text.toString(),
                    controller.cityController.text.toString(),
                    controller.shippingCountry.toString(),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
