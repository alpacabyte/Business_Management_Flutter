import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/screens/costumer/costumer_add_page.dart';
import 'package:business_management/screens/costumer/costumer_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumersPage extends StatefulWidget {
  const CostumersPage({Key? key}) : super(key: key);

  @override
  State<CostumersPage> createState() => _CostumersPageState();
}

class _CostumersPageState extends State<CostumersPage> {
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
        page: Pages.costumers,
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
                      onChanged: (value) => setState(() => Provider.of<CostumersData>(context, listen: false).setIsSelectedOfAllCostumers(value)),
                    ),
                    // ignore: prefer_const_constructors
                    _CostumersListView(tileTextStyle: tileTextStyle),
                  ],
                ),
                Align(
                  alignment: const Alignment(0.98, -0.98),
                  child: CircleIconButton(
                    onPressed: () => Provider.of<CostumersData>(context, listen: false).createExcelFromCostumers(),
                    toolTipText: 'Create excel from selected costumers',
                    icon: Icons.content_copy,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const _CostumerButtons(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _CostumersListView extends StatelessWidget {
  const _CostumersListView({
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
      child: Consumer<CostumersData>(
        builder: (context, costumersData, child) {
          return ListView.separated(
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) => CostumerTile(
              currentCostumer: costumersData.getCostumer(index),
              tileTextStyle: tileTextStyle,
            ),
            itemCount: costumersData.costumerCount,
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

class CostumerTile extends StatefulWidget {
  const CostumerTile({
    Key? key,
    required Costumer currentCostumer,
    required this.tileTextStyle,
  })  : _currentCostumer = currentCostumer,
        super(key: key);

  final Costumer _currentCostumer;
  final TextStyle tileTextStyle;

  @override
  State<CostumerTile> createState() => _CostumerTileState();
}

class _CostumerTileState extends State<CostumerTile> {
  final Color normalColor = backgroundColorHeavy;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget._currentCostumer.isSelected;
    return GestureDetector(
      onTap: () {
        Provider.of<CostumersData>(context, listen: false).setCurrentCostumer(
          widget._currentCostumer.costumerIndex,
        );
        navigateWithoutAnim(
          context,
          const CostumerPage(),
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
                          widget._currentCostumer.corporateTitle,
                          textAlign: TextAlign.center,
                          style: widget.tileTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          widget._currentCostumer.phoneNumber,
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
                  onChanged: (value) => setState(() => widget._currentCostumer.isSelected = value!),
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

class _CostumerButtons extends StatelessWidget {
  const _CostumerButtons({
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
                  pageBuilder: (context, anim1, anim2) => const CostumerAddPage(),
                  transitionDuration: Duration.zero,
                ),
              ),
              toolTipText: 'Add a costumer to list',
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
              onPressed: () => Provider.of<CostumersData>(context, listen: false).deleteSelectedCostumers(),
              toolTipText: 'Delete selected costumers from list',
              icon: Icons.delete,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
