import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/screens/supplier/supplier_form.dart';
import 'package:business_management/screens/supplier/supplier_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierEditPage extends StatefulWidget {
  const SupplierEditPage({
    Key? key,
    required this.currentSupplier,
  }) : super(key: key);

  final Supplier currentSupplier;

  @override
  State<SupplierEditPage> createState() => _SupplierEditPageState();
}

class _SupplierEditPageState extends State<SupplierEditPage> {
  @override
  void initState() {
    super.initState();

    final Supplier currentSupplier = widget.currentSupplier;

    _corporateTitleController.text = currentSupplier.corporateTitle != "-" ? currentSupplier.corporateTitle : "";

    _taxNumberController.text = currentSupplier.taxNumber != "-" ? currentSupplier.taxNumber : "";

    _taxAdministrationController.text = currentSupplier.taxAdministration != "-" ? currentSupplier.taxAdministration : "";

    _addressController.text = currentSupplier.address != "-" ? currentSupplier.address : "";

    _phoneNumberController.text = currentSupplier.phoneNumber != "-" ? currentSupplier.phoneNumber : "";

    _emailController.text = currentSupplier.email != "-" ? currentSupplier.email : "";
  }

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
              emailController: _emailController),
          const Spacer(),
          _SupplierPageButtons(editSupplier: _editSupplier),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _editSupplier() async {
    List<Transaction> transactions = widget.currentSupplier.transactions;
    int supplierIndex = widget.currentSupplier.supplierIndex;
    String creationDate = widget.currentSupplier.creationDate;
    String corporateTitle = _corporateTitleController.text != "" ? _corporateTitleController.text : "-";
    String taxNumber = _taxNumberController.text != "" ? _taxNumberController.text : "-";

    String taxAdministration = _taxAdministrationController.text != "" ? _taxAdministrationController.text : "-";

    String address = _addressController.text != "" ? _addressController.text : "-";

    String phoneNumber = _phoneNumberController.text != "" ? _phoneNumberController.text : "-";

    String email = _emailController.text != "" ? _emailController.text : "-";

    await Provider.of<SuppliersData>(context, listen: false).editSupplier(
      supplierIndex: supplierIndex,
      creationDate: creationDate,
      address: address,
      corporateTitle: corporateTitle,
      email: email,
      phoneNumber: phoneNumber,
      taxAdministration: taxAdministration,
      taxNumber: taxNumber,
      transactions: transactions,
    );

    navigateWithoutAnim(context, const SupplierPage());
  }
}

class _SupplierPageButtons extends StatelessWidget {
  const _SupplierPageButtons({
    Key? key,
    required Function editSupplier,
  })  : _editSupplier = editSupplier,
        super(key: key);

  final Function _editSupplier;

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
              onPressed: _editSupplier,
              toolTipText: "Save supplier",
              icon: Icons.done,
            ),
            Container(
              height: 2,
              width: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) => const SupplierPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: 'Cancel and go back',
              icon: Icons.close,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
