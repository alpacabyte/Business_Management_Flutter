import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/product/product_add_page.dart';
import 'package:business_management/screens/product/product_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/image_from_file.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    const TextStyle tileTextStyle = TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.products,
        children: [
          const Spacer(),
          Container(
            width: 1000,
            height: SizeConfig.safeBlockVertical * 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: backgroundColorLight,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HeaderTile(
                      tileTextStyle: tileTextStyle,
                      onChanged: (value) => setState(() => Provider.of<ProductsData>(context, listen: false).setIsSelectedOfAllProducts(value)),
                    ),
                    // ignore: prefer_const_constructors
                    _ProductsListView(tileTextStyle: tileTextStyle),
                  ],
                ),
                Align(
                  alignment: const Alignment(0.98, -0.98),
                  child: CircleIconButton(
                    onPressed: () => Provider.of<ProductsData>(context, listen: false).createExcelFromProducts(),
                    toolTipText: 'Create excel from products',
                    icon: Icons.content_copy,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const _ProductButtons(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _ProductsListView extends StatelessWidget {
  const _ProductsListView({
    Key? key,
    required this.tileTextStyle,
  }) : super(key: key);

  final TextStyle tileTextStyle;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: 850,
      height: SizeConfig.safeBlockVertical * 70,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) => Consumer<ProductsData>(
          builder: (context, productsData, child) {
            Product currentProduct = productsData.getProduct(index);
            return ProductTile(
              currentProduct: currentProduct,
              tileTextStyle: tileTextStyle,
            );
          },
        ),
        itemCount: Provider.of<ProductsData>(context).productCount,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}

class _HeaderTile extends StatefulWidget {
  const _HeaderTile({
    Key? key,
    required this.tileTextStyle,
    required this.onChanged,
  }) : super(key: key);

  final TextStyle tileTextStyle;
  final void Function(bool?) onChanged;

  @override
  State<_HeaderTile> createState() => _HeaderTileState();
}

class _HeaderTileState extends State<_HeaderTile> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Material(
        color: appbarColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 5,
        child: SizedBox(
          width: 850,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  height: 50,
                  width: 850,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Image",
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Name",
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Price",
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 17.5,
                child: Checkbox(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  fillColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.7),
                  ),
                  checkColor: Colors.transparent,
                  onChanged: (value) {
                    isSelected = value!;
                    widget.onChanged(value);
                  },
                  value: isSelected,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  const ProductTile({
    Key? key,
    required Product currentProduct,
    required this.tileTextStyle,
  })  : _currentProduct = currentProduct,
        super(key: key);

  final Product _currentProduct;
  final TextStyle tileTextStyle;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  final Color normalColor = backgroundColorHeavy;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget._currentProduct.isSelected;
    return GestureDetector(
      onTap: () {
        Provider.of<ProductsData>(context, listen: false).setActiveProduct(
          widget._currentProduct.productIndex,
        );
        navigateWithoutAnim(
          context,
          const ProductPage(),
        );
      },
      child: MouseRegion(
        onEnter: _mouseEntered,
        onExit: _mouseExited,
        cursor: SystemMouseCursors.click,
        child: Material(
          color: !isEnter ? normalColor : mouseOverColor,
          elevation: 2,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        alignment: Alignment.center,
                        child: ImageFromFile(
                          image: widget._currentProduct.image,
                          width: 150,
                          height: 40,
                          fontSize: 14,
                          errorWidth: 150,
                          errorColor: backgroundColorLight,
                        ),
                      ),
                      Container(
                        width: 200,
                        alignment: Alignment.center,
                        child: Text(
                          widget._currentProduct.name,
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: 200,
                        alignment: Alignment.center,
                        child: Text(
                          "${widget._currentProduct.marketPrice.toString()} TL",
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 17.5,
                child: Checkbox(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  fillColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.7),
                  ),
                  checkColor: Colors.transparent,
                  onChanged: (value) => setState(() => widget._currentProduct.isSelected = value!),
                  value: isSelected,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _mouseEntered(PointerEvent details) {
    setState(() {
      isEnter = true;
    });
  }

  void _mouseExited(PointerEvent details) {
    setState(() {
      isEnter = false;
    });
  }
}

class _ProductButtons extends StatelessWidget {
  const _ProductButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      color: backgroundColorLight,
      child: SizedBox(
        width: 200,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleIconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) => const ProductAddPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: 'Add a product to list',
              icon: Icons.add,
              preferBelow: false,
              iconSize: 40,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => Provider.of<ProductsData>(context, listen: false).deleteSelectedCostumers(),
              toolTipText: 'Delete a product from list',
              icon: Icons.delete,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
