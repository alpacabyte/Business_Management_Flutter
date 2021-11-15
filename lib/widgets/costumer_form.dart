import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CostumerForm extends StatelessWidget {
  const CostumerForm({
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
                  title: "Corporate Title",
                  controller: _corporateTitleController,
                ),
                CustomTextField(
                  title: "Address",
                  controller: _addressController,
                ),
                CustomTextField(
                  title: "E-Mail",
                  controller: _emailController,
                ),
                CustomTextField(
                  title: "Phone Number",
                  controller: _phoneNumberController,
                  inputFormatters: [
                    MaskedInputFormatter("0000-000-0000"),
                  ],
                ),
                CustomTextField(
                  title: "Tax Administration",
                  controller: _taxAdministrationController,
                ),
                CustomTextField(
                  title: "Tax Number",
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
