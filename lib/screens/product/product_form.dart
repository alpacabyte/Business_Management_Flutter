import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/widgets/custom_text_field.dart';
import 'package:business_management/widgets/image_from_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({
    Key? key,
    required this.image,
    required TextEditingController nameController,
    required TextEditingController productCodeController,
    required TextEditingController moldCodeController,
    required TextEditingController printingWeightController,
    required TextEditingController numberOfCompartmentsController,
    required TextEditingController productionTimeController,
    required TextEditingController usedMaterialController,
    required TextEditingController usedPaintController,
    required TextEditingController auxiliaryMaterialController,
    required TextEditingController machineTonnageController,
    required TextEditingController marketPriceController,
    required Function imageSelect,
  })  : _nameController = nameController,
        _productCodeController = productCodeController,
        _moldCodeController = moldCodeController,
        _printingWeightController = printingWeightController,
        _numberOfCompartmentsController = numberOfCompartmentsController,
        _productionTimeController = productionTimeController,
        _usedMaterialController = usedMaterialController,
        _usedPaintController = usedPaintController,
        _auxiliaryMaterialController = auxiliaryMaterialController,
        _machineTonnageController = machineTonnageController,
        _marketPriceController = marketPriceController,
        _imageSelect = imageSelect,
        super(key: key);

  final String? image;
  final TextEditingController _nameController;
  final TextEditingController _productCodeController;
  final TextEditingController _moldCodeController;
  final TextEditingController _printingWeightController;
  final TextEditingController _numberOfCompartmentsController;
  final TextEditingController _productionTimeController;
  final TextEditingController _usedMaterialController;
  final TextEditingController _usedPaintController;
  final TextEditingController _auxiliaryMaterialController;
  final TextEditingController _machineTonnageController;
  final TextEditingController _marketPriceController;
  final Function _imageSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColorLight,
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 1000,
        padding: const EdgeInsets.symmetric(vertical: 9),
        height: SizeConfig.safeBlockVertical * 85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageFromFile(
                image: image,
                width: 650,
                height: 200,
              ),
              IconButton(
                onPressed: () => _imageSelect(),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffa81633),
                    ),
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Color(0xffa81633),
                    size: 20,
                  ),
                ),
                iconSize: 50,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 150,
                runSpacing: 24,
                children: [
                  CustomTextField(
                    title: appLocalization(context).productName,
                    controller: _nameController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).productCode,
                    controller: _productCodeController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).moldCode,
                    controller: _moldCodeController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).printingWeight,
                    controller: _printingWeightController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,5}'),
                      ),
                    ],
                  ),
                  CustomTextField(
                    title: appLocalization(context).numberOfCompartments,
                    controller: _numberOfCompartmentsController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  CustomTextField(
                    title: appLocalization(context).productionTime,
                    controller: _productionTimeController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,5}'),
                      ),
                    ],
                  ),
                  CustomTextField(
                    title: appLocalization(context).usedMaterial,
                    controller: _usedMaterialController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).usedPaint,
                    controller: _usedPaintController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).auxiliaryMaterial,
                    controller: _auxiliaryMaterialController,
                  ),
                  CustomTextField(
                    title: appLocalization(context).machineTonnage,
                    controller: _machineTonnageController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,5}'),
                      ),
                    ],
                  ),
                  CustomTextField(
                    title: appLocalization(context).marketPrice,
                    controller: _marketPriceController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,5}'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
