import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/screens/costumers_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/costumer_form.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class CostumerAddPage extends StatefulWidget {
  const CostumerAddPage({Key? key}) : super(key: key);

  @override
  State<CostumerAddPage> createState() => _CostumerAddPageState();
}

class _CostumerAddPageState extends State<CostumerAddPage> {
  // #region Controllers
  final TextEditingController _corporateTitleController =
      TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _taxAdministrationController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
// #endregion

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.costumers,
        children: [
          const Spacer(),
          CostumerForm(
            corporateTitleController: _corporateTitleController,
            taxNumberController: _taxNumberController,
            taxAdministrationController: _taxAdministrationController,
            addressController: _addressController,
            phoneNumberController: _phoneNumberController,
            emailController: _emailController,
          ),
          const Spacer(),
          _ProductPageButtons(addCostumer: _addCostumer),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> _addCostumer() async {
    String corporateTitle = _corporateTitleController.text != ""
        ? _corporateTitleController.text
        : "null";
    String taxNumber =
        _taxNumberController.text != "" ? _taxNumberController.text : "null";

    String taxAdministration = _taxAdministrationController.text != ""
        ? _taxAdministrationController.text
        : "null";

    String address =
        _addressController.text != "" ? _addressController.text : "null";

    String phoneNumber = _phoneNumberController.text != ""
        ? _phoneNumberController.text
        : "null";

    String email = _emailController.text != "" ? _emailController.text : "null";

    await Provider.of<CostumersData>(context, listen: false).addCostumer(
        corporateTitle: corporateTitle,
        taxNumber: taxNumber,
        taxAdministration: taxAdministration,
        address: address,
        phoneNumber: phoneNumber,
        email: email);
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
    required Function addCostumer,
  })  : _addCostumer = addCostumer,
        super(key: key);

  final Function _addCostumer;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      color: backgroundColorLight,
      child: SizedBox(
        width: 200,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleIconButton(
              onPressed: () async {
                await _addCostumer();
                navigateWithoutAnim(context, const CostumerAddPage());
              },
              toolTipText: "Save the product and create another",
              preferBelow: false,
              icon: Icons.edit,
            ),
            Container(
              height: 2,
              width: 150,
              color: Colors.black26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleIconButton(
                  onPressed: () async {
                    await _addCostumer();
                    navigateWithoutAnim(context, const CostumersPage());
                  },
                  toolTipText: "Save the product and go to list",
                  icon: Icons.done,
                ),
                Container(
                  height: 75,
                  width: 2,
                  color: Colors.black26,
                ),
                CircleIconButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, anim1, anim2) =>
                          const CostumersPage(),
                      transitionDuration: Duration.zero,
                    ),
                  ),
                  toolTipText: 'Cancel and go back',
                  icon: Icons.close,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
