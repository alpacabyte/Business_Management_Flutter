import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/product/product_edit_page.dart';
import 'package:business_management/screens/product/products_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/image_from_file.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/property_text.dart';
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
            page: Pages.products,
            children: [
              const Spacer(),
              _ProductProperties(currentProduct: currentProduct),
              const Spacer(),
              _ProductPageButtons(currentProduct: currentProduct),
              const SizedBox(width: 20),
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 1000,
        height: SizeConfig.safeBlockVertical * 85,
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 500,
                child: Text(
                  currentProduct.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xffdbdbdb),
                    fontSize: 35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 25),
              ImageFromFile(
                image: currentProduct.image,
                width: 650,
                height: 200,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                height: 5,
                width: 750,
                color: backgroundColorHeavy,
              ),
              Wrap(
                spacing: 150,
                runSpacing: 45,
                children: [
                  PropertyText(
                    title: appLocalization(context).productCode,
                    text: currentProduct.productCode,
                  ),
                  PropertyText(
                    title: appLocalization(context).moldCode,
                    text: currentProduct.moldCode,
                  ),
                  PropertyText(
                    title: appLocalization(context).printingWeight,
                    text: currentProduct.printingWeight.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).unitWeight,
                    text: currentProduct.unitWeight.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).numberOfCompartments,
                    text: currentProduct.numberOfCompartments.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).productionTime,
                    text: currentProduct.productionTime.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).usedMaterial,
                    text: currentProduct.usedMaterial,
                  ),
                  PropertyText(
                    title: appLocalization(context).usedPaint,
                    text: currentProduct.usedPaint,
                  ),
                  PropertyText(
                    title: appLocalization(context).auxiliaryMaterial,
                    text: currentProduct.auxiliaryMaterial,
                  ),
                  PropertyText(
                    title: appLocalization(context).machineTonnage,
                    text: currentProduct.machineTonnage.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).marketPrice,
                    text: currentProduct.marketPrice.toString(),
                  ),
                  PropertyText(
                    title: appLocalization(context).created,
                    text: currentProduct.creationDate,
                  ),
                  PropertyText(
                    title: appLocalization(context).lastModified,
                    text: currentProduct.lastModifiedDate ?? "-",
                  ),
                  PropertyText(
                    title: appLocalization(context).productNo,
                    text: currentProduct.productIndex.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
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
            CircleIconButton(
              onPressed: () => navigateWithoutAnim(
                context,
                ProductEditPage(
                  currentProduct: currentProduct,
                ),
              ),
              toolTipText: appLocalization(context).editProduct,
              icon: Icons.edit,
              preferBelow: false,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) => const ProductsPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: appLocalization(context).goBack,
              icon: Icons.arrow_back,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
