import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/screens/costumer/costumer_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/screens/costumer/costumer_form.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CostumerEditPage extends StatefulWidget {
  const CostumerEditPage({
    Key? key,
    required this.currentCostumer,
  }) : super(key: key);

  final Costumer currentCostumer;

  @override
  State<CostumerEditPage> createState() => _CostumerEditPageState();
}

class _CostumerEditPageState extends State<CostumerEditPage> {
  @override
  void initState() {
    super.initState();

    final Costumer currentCostumer = widget.currentCostumer;

    _corporateTitleController.text = currentCostumer.corporateTitle != "-" ? currentCostumer.corporateTitle : "";

    _taxNumberController.text = currentCostumer.taxNumber != "-" ? currentCostumer.taxNumber : "";

    _taxAdministrationController.text = currentCostumer.taxAdministration != "-" ? currentCostumer.taxAdministration : "";

    _addressController.text = currentCostumer.address != "-" ? currentCostumer.address : "";

    _phoneNumberController.text = currentCostumer.phoneNumber != "-" ? currentCostumer.phoneNumber : "";

    _emailController.text = currentCostumer.email != "-" ? currentCostumer.email : "";
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
        page: Pages.costumers,
        children: [
          const Spacer(),
          CostumerForm(
              corporateTitleController: _corporateTitleController,
              taxNumberController: _taxNumberController,
              taxAdministrationController: _taxAdministrationController,
              addressController: _addressController,
              phoneNumberController: _phoneNumberController,
              emailController: _emailController),
          const Spacer(),
          _CostumerPageButtons(editCostumer: _editCostumer),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _editCostumer() async {
    HiveList<Transaction> transactionsBoxList = widget.currentCostumer.transactionsHiveList;
    int costumerIndex = widget.currentCostumer.costumerIndex;
    String creationDate = widget.currentCostumer.creationDate;
    String corporateTitle = _corporateTitleController.text != "" ? _corporateTitleController.text : "-";
    String taxNumber = _taxNumberController.text != "" ? _taxNumberController.text : "-";

    String taxAdministration = _taxAdministrationController.text != "" ? _taxAdministrationController.text : "-";

    String address = _addressController.text != "" ? _addressController.text : "-";

    String phoneNumber = _phoneNumberController.text != "" ? _phoneNumberController.text : "-";

    String email = _emailController.text != "" ? _emailController.text : "-";

    await Provider.of<CostumersData>(context, listen: false).editCostumer(
      costumerIndex: costumerIndex,
      creationDate: creationDate,
      address: address,
      corporateTitle: corporateTitle,
      email: email,
      phoneNumber: phoneNumber,
      taxAdministration: taxAdministration,
      taxNumber: taxNumber,
      transactionsBoxList: transactionsBoxList,
    );

    navigateWithoutAnim(context, const CostumerPage());
  }
}

class _CostumerPageButtons extends StatelessWidget {
  const _CostumerPageButtons({
    Key? key,
    required Function editCostumer,
  })  : _editCostumer = editCostumer,
        super(key: key);

  final Function _editCostumer;

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
              onPressed: _editCostumer,
              toolTipText: appLocalization(context).saveCostumer,
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
                  pageBuilder: (context, anim1, anim2) => const CostumerPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: appLocalization(context).cancelAndGoBack,
              icon: Icons.close,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
