import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SupplierForm extends StatelessWidget {
  const SupplierForm({
    Key? key,
    required TextEditingController corporateTitleController,
    required TextEditingController taxNumberController,
    required TextEditingController taxAdministrationController,
    required TextEditingController addressController,
    required TextEditingController phoneNumberController,
    required TextEditingController emailController,
  })  : _corporateTitleController = corporateTitleController,
        _taxNumberController = taxNumberController,
        _taxAdministrationController = taxAdministrationController,
        _addressController = addressController,
        _phoneNumberController = phoneNumberController,
        _emailController = emailController,
        super(key: key);

  final TextEditingController _corporateTitleController;
  final TextEditingController _taxNumberController;
  final TextEditingController _taxAdministrationController;
  final TextEditingController _addressController;
  final TextEditingController _phoneNumberController;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColorLight,
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 1000,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 150,
              runSpacing: 55,
              children: [
                CustomTextField(
                  title: appLocalization(context).corporateTitle,
                  controller: _corporateTitleController,
                ),
                CustomTextField(
                  title: appLocalization(context).address,
                  controller: _addressController,
                ),
                CustomTextField(
                  title: appLocalization(context).eMail,
                  controller: _emailController,
                ),
                CustomTextField(
                  title: appLocalization(context).phoneNumber,
                  controller: _phoneNumberController,
                  inputFormatters: [
                    MaskedInputFormatter("0000-000-0000"),
                  ],
                ),
                CustomTextField(
                  title: appLocalization(context).taxAdministration,
                  controller: _taxAdministrationController,
                ),
                CustomTextField(
                  title: appLocalization(context).taxNumber,
                  controller: _taxNumberController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
