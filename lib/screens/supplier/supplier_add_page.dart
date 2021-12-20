import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/screens/supplier/supplier_form.dart';
import 'package:business_management/screens/supplier/suppliers_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierAddPage extends StatefulWidget {
  const SupplierAddPage({Key? key}) : super(key: key);

  @override
  State<SupplierAddPage> createState() => _SupplierAddPageState();
}

class _SupplierAddPageState extends State<SupplierAddPage> {
  // #region Controllers
  final TextEditingController _corporateTitleController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _taxAdministrationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
// #endregion

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.suppliers,
        children: [
          const Spacer(),
          SupplierForm(
            corporateTitleController: _corporateTitleController,
            taxNumberController: _taxNumberController,
            taxAdministrationController: _taxAdministrationController,
            addressController: _addressController,
            phoneNumberController: _phoneNumberController,
            emailController: _emailController,
          ),
          const Spacer(),
          _ProductPageButtons(addSupplier: _addSupplier),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Future<void> _addSupplier() async {
    String corporateTitle = _corporateTitleController.text != "" ? _corporateTitleController.text : "-";
    String taxNumber = _taxNumberController.text != "" ? _taxNumberController.text : "-";

    String taxAdministration = _taxAdministrationController.text != "" ? _taxAdministrationController.text : "-";

    String address = _addressController.text != "" ? _addressController.text : "-";

    String phoneNumber = _phoneNumberController.text != "" ? _phoneNumberController.text : "-";

    String email = _emailController.text != "" ? _emailController.text : "-";

    await Provider.of<SuppliersData>(context, listen: false).addSupplier(
      corporateTitle: corporateTitle,
      taxNumber: taxNumber,
      taxAdministration: taxAdministration,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
    );
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
    required Function addSupplier,
  })  : _addSupplier = addSupplier,
        super(key: key);

  final Function _addSupplier;

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
                await _addSupplier();
                navigateWithoutAnim(context, const SupplierAddPage());
              },
              toolTipText: "Save the supplier and create another",
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
                    await _addSupplier();
                    navigateWithoutAnim(context, const SuppliersPage());
                  },
                  toolTipText: "Save the supplier and go to list",
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
                      pageBuilder: (context, anim1, anim2) => const SuppliersPage(),
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
