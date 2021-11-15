import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/screens/costumer_add_page.dart';
import 'package:business_management/screens/costumer_page.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumersPage extends StatelessWidget {
  const CostumersPage({Key? key}) : super(key: key);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _HeaderTile(tileTextStyle: tileTextStyle),
                _CostumersListView(tileTextStyle: tileTextStyle),
              ],
            ),
          ),
          const Spacer(),
          const _CostumerButtons(),
          const Spacer(),
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
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: 10,
            ),
          );
        },
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
        color: appbarColor,
        elevation: 5,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          height: 50,
          width: 850,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  "Corporate Title",
                  textAlign: TextAlign.center,
                  style: tileTextStyle,
                ),
              ),
              SizedBox(
                width: 250,
                child: Text(
                  "Phone",
                  textAlign: TextAlign.center,
                  style: tileTextStyle,
                ),
              ),
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
                        const CostumerAddPage(),
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
                    Provider.of<CostumersData>(context, listen: false)
                        .deleteAllCostumers(),
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
