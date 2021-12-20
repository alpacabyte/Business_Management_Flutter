import 'package:business_management/main.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:business_management/widgets/property_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SaleTransactionForm extends StatelessWidget {
  const SaleTransactionForm({
    Key? key,
    required TextEditingController commentController,
    required TextEditingController quantityController,
    required TextEditingController unitPriceController,
    required TextEditingController transactionDateController,
  })  : _commentController = commentController,
        _quantityController = quantityController,
        _unitPriceController = unitPriceController,
        _transactionDateController = transactionDateController,
        super(key: key);

  final TextEditingController _commentController;
  final TextEditingController _quantityController;
  final TextEditingController _unitPriceController;
  final TextEditingController _transactionDateController;

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
            const Text(
              "New Sale Transaction",
              style: TextStyle(
                color: Color(0xffdbdbdb),
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 50),
            _Properties(
                commentController: _commentController,
                transactionDateController: _transactionDateController,
                unitPriceController: _unitPriceController,
                quantityController: _quantityController),
          ],
        ),
      ),
    );
  }
}

class _Properties extends StatefulWidget {
  const _Properties({
    Key? key,
    required TextEditingController commentController,
    required TextEditingController transactionDateController,
    required TextEditingController unitPriceController,
    required TextEditingController quantityController,
  })  : _commentController = commentController,
        _transactionDateController = transactionDateController,
        _unitPriceController = unitPriceController,
        _quantityController = quantityController,
        super(key: key);

  final TextEditingController _commentController;
  final TextEditingController _transactionDateController;
  final TextEditingController _unitPriceController;
  final TextEditingController _quantityController;

  @override
  State<_Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<_Properties> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 150,
      runSpacing: 55,
      children: [
        CustomTextField(
          title: "Comment",
          controller: widget._commentController,
        ),
        CustomTextField(
          title: "Transaction Date",
          controller: widget._transactionDateController,
          inputFormatters: [
            MaskedInputFormatter("00/00/0000"),
          ],
          hintText: "dd/mm/yyyy",
        ),
        CustomTextField(
          title: "Unit Price",
          controller: widget._unitPriceController,
          trailing: const Text(
            "TL",
            style: TextStyle(
              color: Color(0xffdbdbdb),
              fontSize: 20,
            ),
          ),
          textFieldWidth: 260,
          onChanged: (value) => setState(() {}),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^(\d+)?\.?\d{0,5}'),
            ),
          ],
        ),
        CustomTextField(
          title: "Quantity",
          controller: widget._quantityController,
          onChanged: (value) => setState(() {}),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        PropertyText(
          title: "Total Price",
          text: "${calculateTotalPrice()} TL",
        ),
      ],
    );
  }

  double calculateTotalPrice() {
    try {
      double quantity = widget._quantityController.text != "" ? double.parse(widget._quantityController.text) : 0;
      double unitPrice = widget._unitPriceController.text != "" ? double.parse(widget._unitPriceController.text) : 0;
      return quantity * unitPrice;
    } catch (error) {
      return 0;
    }
  }
}
