import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/product/product_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/screens/product/product_form.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  final Product currentProduct;

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  XFile? imageFile;
  String? imagePath;
  String creationDate = "";

  @override
  void initState() {
    super.initState();

    final Product currentProduct = widget.currentProduct;

    creationDate = currentProduct.creationDate;
    imagePath = currentProduct.image;
    _nameController.text =
        currentProduct.name != "-" ? currentProduct.name : "";
    _productCodeController.text =
        currentProduct.productCode != "-" ? currentProduct.productCode : "";
    _moldCodeController.text =
        currentProduct.moldCode != "-" ? currentProduct.moldCode : "";
    _printingWeightController.text = currentProduct.printingWeight.toString();
    _numberOfCompartmentsController.text =
        currentProduct.numberOfCompartments.toString();
    _productionTimeController.text = currentProduct.productionTime.toString();
    _usedMaterialController.text =
        currentProduct.usedMaterial != "-" ? currentProduct.usedMaterial : "";
    _usedPaintController.text =
        currentProduct.usedPaint != "-" ? currentProduct.usedPaint : "";
    _auxiliaryMaterialController.text = currentProduct.auxiliaryMaterial != "-"
        ? currentProduct.auxiliaryMaterial
        : "";
    _machineTonnageController.text = currentProduct.machineTonnage.toString();
    _marketPriceController.text = currentProduct.marketPrice.toString();
  }

  // #region Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _moldCodeController = TextEditingController();
  final TextEditingController _printingWeightController =
      TextEditingController();
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
        page: Pages.products,
        children: [
          const Spacer(),
          ProductForm(
            image: imagePath,
            nameController: _nameController,
            productCodeController: _productCodeController,
            moldCodeController: _moldCodeController,
            printingWeightController: _printingWeightController,
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
          _ProductPageButtons(addOrEditProduct: _editProduct),
          const SizedBox(width: 20),
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

  void _editProduct() async {
    String? name = _nameController.text != "" ? _nameController.text : "-";
    String? productCode =
        _productCodeController.text != "" ? _productCodeController.text : "-";
    String? moldCode =
        _moldCodeController.text != "" ? _moldCodeController.text : "-";
    double? printingWeight = _printingWeightController.text != ""
        ? double.parse(_printingWeightController.text)
        : 0;
    int? numberOfCompartments = _numberOfCompartmentsController.text != ""
        ? int.parse(_numberOfCompartmentsController.text)
        : 0;
    double? productionTime = _productionTimeController.text != ""
        ? double.parse(_productionTimeController.text)
        : 0;
    String? usedMaterial =
        _usedMaterialController.text != "" ? _usedMaterialController.text : "-";
    String? usedPaint =
        _usedPaintController.text != "" ? _usedPaintController.text : "-";
    String? auxiliaryMaterial = _auxiliaryMaterialController.text != ""
        ? _auxiliaryMaterialController.text
        : "-";
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

    await Provider.of<ProductsData>(context, listen: false).editProduct(
      name: name,
      image: imagePath,
      productCode: productCode,
      moldCode: moldCode,
      printingWeight: printingWeight,
      numberOfCompartments: numberOfCompartments,
      productionTime: productionTime,
      usedMaterial: usedMaterial,
      usedPaint: usedPaint,
      auxiliaryMaterial: auxiliaryMaterial,
      machineTonnage: machineTonnage,
      marketPrice: marketPrice,
      productIndex: widget.currentProduct.productIndex,
      creationDate: creationDate,
    );

    navigateWithoutAnim(context, const ProductPage());
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
            CircleIconButton(
              onPressed: _saveProduct,
              toolTipText: "Save product",
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
                  pageBuilder: (context, anim1, anim2) => const ProductPage(),
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
