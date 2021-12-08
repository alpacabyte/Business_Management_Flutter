import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/screens/costumer/costumer_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/screens/costumer/costumer_form.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
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

    _corporateTitleController.text = currentCostumer.corporateTitle != "null"
        ? currentCostumer.corporateTitle
        : "";

    _taxNumberController.text =
        currentCostumer.taxNumber != "null" ? currentCostumer.taxNumber : "";

    _taxAdministrationController.text =
        currentCostumer.taxAdministration != "null"
            ? currentCostumer.taxAdministration
            : "";

    _addressController.text =
        currentCostumer.address != "null" ? currentCostumer.address : "";

    _phoneNumberController.text = currentCostumer.phoneNumber != "null"
        ? currentCostumer.phoneNumber
        : "";

    _emailController.text =
        currentCostumer.email != "null" ? currentCostumer.email : "";
  }

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
              emailController: _emailController),
          const Spacer(),
          _CostumerPageButtons(editCostumer: _editCostumer),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _editCostumer() async {
    List<Transaction> transactions = widget.currentCostumer.transactions;
    int costumerIndex = widget.currentCostumer.costumerIndex;
    String creationDate = widget.currentCostumer.creationDate;
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

    await Provider.of<CostumersData>(context, listen: false).editCostumer(
      costumerIndex: costumerIndex,
      creationDate: creationDate,
      address: address,
      corporateTitle: corporateTitle,
      email: email,
      phoneNumber: phoneNumber,
      taxAdministration: taxAdministration,
      taxNumber: taxNumber,
      transactions: transactions,
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
              toolTipText: "Save costumer",
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
