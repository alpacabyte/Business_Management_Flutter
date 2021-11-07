import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/product_add_page.dart';
import 'package:business_management/screens/product_page.dart';
import 'package:business_management/widgets/image_from_file.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle tileTextStyle = TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      body: TitleBarWithLeftNav(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _HeaderTile(tileTextStyle: tileTextStyle),
              _ProductsListView(tileTextStyle: tileTextStyle),
            ],
          ),
          const Spacer(),
          const _ProductButtons(),
          const Spacer(),
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

class _HeaderTile extends StatelessWidget {
  const _HeaderTile({
    Key? key,
    required this.tileTextStyle,
  }) : super(key: key);

  final TextStyle tileTextStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Material(
        color: backgroundColorLight,
        elevation: 5,
        child: SizedBox(
          height: 50,
          width: 850,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Container(
                width: 75,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Image",
                  style: tileTextStyle,
                ),
              ),
              const Spacer(),
              Container(
                width: 500,
                alignment: Alignment.center,
                child: Text(
                  "Name",
                  textAlign: TextAlign.center,
                  style: tileTextStyle,
                ),
              ),
              const Spacer(),
              Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  "Code",
                  style: tileTextStyle,
                ),
              ),
              const Spacer(),
              Container(
                width: 75,
                alignment: Alignment.center,
                child: Text(
                  "Price",
                  style: tileTextStyle,
                ),
              ),
              const SizedBox(width: 20),
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
  final Color normalColor = backgroundColorLight;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ProductsData>(context, listen: false).setActiveContact(
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
          color: !isEnter ? backgroundColorLight : mouseOverColor,
          elevation: 2,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                ImageFromFile(
                  image: widget._currentProduct.image,
                  width: 75,
                  height: 40,
                  fontSize: 12,
                  errorWidth: 75,
                ),
                const Spacer(),
                Container(
                  width: 500,
                  alignment: Alignment.center,
                  child: Text(
                    widget._currentProduct.name,
                    textAlign: TextAlign.center,
                    style: widget.tileTextStyle,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    widget._currentProduct.productCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 75,
                  alignment: Alignment.center,
                  child: Text(
                    "${widget._currentProduct.marketPrice.toString()} TL",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
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
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              verticalOffset: 30,
              preferBelow: false,
              height: 30,
              message: 'Add a product to list',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const ProductAddPage(),
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
                    Icons.add,
                    color: Color(0xffa81633),
                    size: 40,
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
              message: 'Delete a product from list',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () =>
                    Provider.of<ProductsData>(context, listen: false)
                        .deleteAllProducts(),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.delete,
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
