import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/screens/supplier/supplier_add_page.dart';
import 'package:business_management/screens/supplier/supplier_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({Key? key}) : super(key: key);

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
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
        page: Pages.suppliers,
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
                      onChanged: (value) => setState(() => Provider.of<SuppliersData>(context, listen: false).setIsSelectedOfSuppliers(value)),
                    ),
                    // ignore: prefer_const_constructors
                    _SuppliersListView(tileTextStyle: tileTextStyle),
                  ],
                ),
                Align(
                  alignment: const Alignment(0.98, -0.98),
                  child: CircleIconButton(
                    onPressed: () => Provider.of<SuppliersData>(context, listen: false).createExcelFromSuppliers(),
                    toolTipText: 'Create excel from selected suppliers',
                    icon: Icons.content_copy,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const _SupplierButtons(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _SuppliersListView extends StatelessWidget {
  const _SuppliersListView({
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
      child: Consumer<SuppliersData>(
        builder: (context, suppliersData, child) {
          return ListView.separated(
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) => SupplierTile(
              currentSupplier: suppliersData.getSupplier(index),
              tileTextStyle: tileTextStyle,
            ),
            itemCount: suppliersData.supplierCount,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 10,
            ),
          );
        },
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
        elevation: 5,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: SizedBox(
          width: 850,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          "Corporate Title",
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          "Phone",
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

class SupplierTile extends StatefulWidget {
  const SupplierTile({
    Key? key,
    required Supplier currentSupplier,
    required this.tileTextStyle,
  })  : _currentSupplier = currentSupplier,
        super(key: key);

  final Supplier _currentSupplier;
  final TextStyle tileTextStyle;

  @override
  State<SupplierTile> createState() => _SupplierTileState();
}

class _SupplierTileState extends State<SupplierTile> {
  final Color normalColor = backgroundColorHeavy;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget._currentSupplier.isSelected;
    return GestureDetector(
      onTap: () {
        Provider.of<SuppliersData>(context, listen: false).setCurrentSupplier(
          widget._currentSupplier.supplierIndex,
        );
        navigateWithoutAnim(
          context,
          const SupplierPage(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          widget._currentSupplier.corporateTitle,
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          widget._currentSupplier.phoneNumber,
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
                  onChanged: (value) => setState(() => widget._currentSupplier.isSelected = value!),
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

class _SupplierButtons extends StatelessWidget {
  const _SupplierButtons({
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
                  pageBuilder: (context, anim1, anim2) => const SupplierAddPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: 'Add a supplier to list',
              icon: Icons.add,
              iconSize: 45,
              preferBelow: true,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => Provider.of<SuppliersData>(context, listen: false).deleteSelectedSuppliers(),
              toolTipText: 'Delete selected suppliers from list',
              icon: Icons.delete,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
