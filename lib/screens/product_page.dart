import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/product_edit_page.dart';
import 'package:business_management/screens/products_page.dart';
import 'package:business_management/widgets/image_from_file.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<ProductsData>(
        builder: (context, productsData, child) {
          Product currentProduct = productsData.activeProduct!;
          return TitleBarWithLeftNav(
            children: [
              const Spacer(),
              _ProductProperties(currentProduct: currentProduct),
              const Spacer(),
              _ProductPageButtons(currentProduct: currentProduct),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}

class _ProductProperties extends StatelessWidget {
  const _ProductProperties({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  final Product currentProduct;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColorLight,
      child: Container(
        width: 850,
        height: SizeConfig.safeBlockVertical * 85,
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageFromFile(
                image: currentProduct.image,
                width: 650,
                height: 200,
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 30,
                runSpacing: 45,
                children: [
                  _PropertyText(
                    title: "Name",
                    text: currentProduct.name,
                  ),
                  _PropertyText(
                    title: "Product Code",
                    text: currentProduct.productCode,
                  ),
                  _PropertyText(
                    title: "Mold Code",
                    text: currentProduct.moldCode,
                  ),
                  _PropertyText(
                    title: "Printing Weight",
                    text: currentProduct.printingWeight.toString(),
                  ),
                  _PropertyText(
                    title: "Unit Weight",
                    text: currentProduct.unitWeight.toString(),
                  ),
                  _PropertyText(
                    title: "Number of Compartments",
                    text: currentProduct.numberOfCompartments.toString(),
                  ),
                  _PropertyText(
                    title: "Production Time",
                    text: currentProduct.productionTime.toString(),
                  ),
                  _PropertyText(
                    title: "Used Material",
                    text: currentProduct.usedMaterial,
                  ),
                  _PropertyText(
                    title: "Used Paint",
                    text: currentProduct.usedPaint,
                  ),
                  _PropertyText(
                    title: "Auxiliary Material",
                    text: currentProduct.auxiliaryMaterial,
                  ),
                  _PropertyText(
                    title: "Machine Tonnage",
                    text: currentProduct.machineTonnage.toString(),
                  ),
                  _PropertyText(
                    title: "Market Price",
                    text: currentProduct.marketPrice.toString(),
                  ),
                ],
              ),
              Align(
                alignment: const Alignment(0.75, 0),
                child: Text(
                  "Product No: ${currentProduct.productIndex}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyText extends StatelessWidget {
  const _PropertyText({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Color(0xffdbdbdb), fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  final Product currentProduct;

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
              message: 'Edit product',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => navigateWithoutAnim(
                  context,
                  ProductEditPage(
                    currentProduct: currentProduct,
                  ),
                ),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.edit,
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
              message: 'Go back',
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
                    Icons.arrow_back,
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
