import 'dart:io';
import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/products_page.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // #region Variables
  XFile? imageFile;
  String? imagePath;
  String? name;
  String? productCode;
  String? moldCode;
  double? printingWeight;
  double? unitWeight;
  int? numberOfCompartments;
  double? productionTime;
  String? usedMaterial;
  String? usedPaint;
  String? auxiliaryMaterial;
  double? machineTonnage;
  double? marketPrice;
  // #endregion

// #region Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _moldCodeController = TextEditingController();
  final TextEditingController _printingWeightController =
      TextEditingController();
  final TextEditingController _unitWeightController = TextEditingController();
  final TextEditingController _numberOfCompartmentsController =
      TextEditingController();
  final TextEditingController _productionTimeController =
      TextEditingController();
  final TextEditingController _usedMaterialController = TextEditingController();
  final TextEditingController _usedPaintController = TextEditingController();
  final TextEditingController _auxiliaryMaterialController =
      TextEditingController();
  final TextEditingController _machineTonnageController =
      TextEditingController();
  final TextEditingController _marketPriceController = TextEditingController();
// #endregion

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        children: [
          const Spacer(),
          _ProductProperties(
            image: imagePath,
            nameController: _nameController,
            productCodeController: _productCodeController,
            moldCodeController: _moldCodeController,
            printingWeightController: _printingWeightController,
            unitWeightController: _unitWeightController,
            numberOfCompartmentsController: _numberOfCompartmentsController,
            productionTimeController: _productionTimeController,
            usedMaterialController: _usedMaterialController,
            usedPaintController: _usedPaintController,
            auxiliaryMaterialController: _auxiliaryMaterialController,
            machineTonnageController: _machineTonnageController,
            marketPriceController: _marketPriceController,
            imageSelect: () => _openImageFile(context).then(
              (value) {
                if (value != null) {
                  setState(() {
                    imageFile = value;
                    imagePath = value.path;
                  });
                }
              },
            ),
          ),
          const Spacer(),
          _ProductPageButtons(addOrEditProduct: _addOrEditProduct),
          const Spacer(),
        ],
      ),
    );
  }

  Future<XFile?> _openImageFile(BuildContext context) async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'png', 'jpeg'],
    );
    final XFile? imageFile = await FileSelectorPlatform.instance
        .openFile(acceptedTypeGroups: [typeGroup]);

    if (imageFile == null) return null;

    return imageFile;
  }

  void _addOrEditProduct() async {
    String? name = _nameController.text != "" ? _nameController.text : "null";
    String? productCode = _productCodeController.text != ""
        ? _productCodeController.text
        : "null";
    String? moldCode =
        _moldCodeController.text != "" ? _moldCodeController.text : "null";
    double? printingWeight = _printingWeightController.text != ""
        ? double.parse(_printingWeightController.text)
        : 0;
    double? unitWeight = _unitWeightController.text != ""
        ? double.parse(_unitWeightController.text)
        : 0;
    int? numberOfCompartments = _numberOfCompartmentsController.text != ""
        ? int.parse(_numberOfCompartmentsController.text)
        : 0;
    double? productionTime = _productionTimeController.text != ""
        ? double.parse(_productionTimeController.text)
        : 0;
    String? usedMaterial = _usedMaterialController.text != ""
        ? _usedMaterialController.text
        : "null";
    String? usedPaint =
        _usedPaintController.text != "" ? _usedPaintController.text : "null";
    String? auxiliaryMaterial = _auxiliaryMaterialController.text != ""
        ? _auxiliaryMaterialController.text
        : "null";
    double? machineTonnage = _machineTonnageController.text != ""
        ? double.parse(_machineTonnageController.text)
        : 0;
    double? marketPrice = _marketPriceController.text != ""
        ? double.parse(_marketPriceController.text)
        : 0;

    if (imageFile != null) {
      final String fileExtension = p.extension(imageFile!.path);

      final String docPath = await getAppDocDirFolder("ProductImages");

      imagePath = '$docPath/${name}_$productCode$fileExtension';

      await imageFile!.saveTo(imagePath!);
    }

    Provider.of<ProductsData>(context, listen: false).addOrEditContact(
      name: name,
      image: imagePath,
      productCode: productCode,
      moldCode: moldCode,
      printingWeight: printingWeight,
      unitWeight: unitWeight,
      numberOfCompartments: numberOfCompartments,
      productionTime: productionTime,
      usedMaterial: usedMaterial,
      usedPaint: usedPaint,
      auxiliaryMaterial: auxiliaryMaterial,
      machineTonnage: machineTonnage,
      marketPrice: marketPrice,
    );

    navigateWithoutAnim(context, const ProductsPage());
  }
}

class _ProductProperties extends StatelessWidget {
  const _ProductProperties({
    Key? key,
    required this.image,
    required TextEditingController nameController,
    required TextEditingController productCodeController,
    required TextEditingController moldCodeController,
    required TextEditingController printingWeightController,
    required TextEditingController unitWeightController,
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
        _unitWeightController = unitWeightController,
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
  final TextEditingController _unitWeightController;
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
      child: SizedBox(
        width: 850,
        height: SizeConfig.safeBlockVertical * 85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              if (image != null)
                Image.file(
                  File(image!),
                  fit: BoxFit.contain,
                  width: 650,
                  height: 200,
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: backgroundColorHeavy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "No Photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
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
                spacing: 50,
                runSpacing: 25,
                children: [
                  _CustomTextField(
                    title: "Name",
                    controller: _nameController,
                  ),
                  _CustomTextField(
                    title: "Product Code",
                    controller: _productCodeController,
                  ),
                  _CustomTextField(
                    title: "Mold Code",
                    controller: _moldCodeController,
                  ),
                  _CustomTextField(
                    title: "Printing Weight",
                    controller: _printingWeightController,
                  ),
                  _CustomTextField(
                    title: "Unit Weight",
                    controller: _unitWeightController,
                  ),
                  _CustomTextField(
                    title: "Number of Compartments",
                    controller: _numberOfCompartmentsController,
                  ),
                  _CustomTextField(
                    title: "Production Time",
                    controller: _productionTimeController,
                  ),
                  _CustomTextField(
                    title: "Used Material",
                    controller: _usedMaterialController,
                  ),
                  _CustomTextField(
                    title: "Used Paint",
                    controller: _usedPaintController,
                  ),
                  _CustomTextField(
                    title: "Auxiliary Material",
                    controller: _auxiliaryMaterialController,
                  ),
                  _CustomTextField(
                    title: "Machine Tonnage",
                    controller: _machineTonnageController,
                  ),
                  _CustomTextField(
                    title: "Market Price",
                    controller: _marketPriceController,
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    Key? key,
    required this.title,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _controller,
            style: const TextStyle(color: Color(0xffdbdbdb), fontSize: 20),
            cursorColor: const Color(0xffede6d6),
            decoration: const InputDecoration(
              errorMaxLines: 3,
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
    required Function addOrEditProduct,
  })  : _saveProduct = addOrEditProduct,
        super(key: key);

  final Function _saveProduct;

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
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              verticalOffset: 30,
              preferBelow: false,
              height: 30,
              message: 'Save the product',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () async => _saveProduct(),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.done,
                    color: Color(0xffa81633),
                    size: 25,
                  ),
                ),
                iconSize: 45,
              ),
            ),
            Container(
              height: 2,
              width: 150,
              color: Colors.black26,
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              verticalOffset: 30,
              height: 30,
              message: 'Cancel and go back',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const ProductsPage(),
                    transitionDuration: Duration.zero,
                  ),
                ),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xffa81633),
                    size: 30,
                  ),
                ),
                iconSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
