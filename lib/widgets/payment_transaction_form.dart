import 'package:business_management/main.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PaymentTransactionForm extends StatelessWidget {
  const PaymentTransactionForm({
    Key? key,
    required TextEditingController commentController,
    required TextEditingController amountController,
    required TextEditingController transactionDateController,
  })  : _commentController = commentController,
        _amountController = amountController,
        _transactionDateController = transactionDateController,
        super(key: key);

  final TextEditingController _commentController;
  final TextEditingController _amountController;
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
              "New Payment Transaction",
              style: TextStyle(
                color: Color(0xffdbdbdb),
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 50),
            _Properties(
              commentController: _commentController,
              transactionDateController: _transactionDateController,
              amountController: _amountController,
            ),
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
    required TextEditingController amountController,
  })  : _commentController = commentController,
        _transactionDateController = transactionDateController,
        _amountController = amountController,
        super(key: key);

  final TextEditingController _commentController;
  final TextEditingController _transactionDateController;
  final TextEditingController _amountController;

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
          title: "Amount",
          controller: widget._amountController,
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
      ],
    );
  }
}