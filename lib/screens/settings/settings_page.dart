import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/localization_model.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final bool isTurkish = Provider.of<LocalizationData>(context).localeName == "tr";
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.settings,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 300,
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: backgroundColorHeavy,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        appLocalization(context).language,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SettingsButton(
                            text: appLocalization(context).turkish,
                            isSelected: isTurkish,
                            locales: Locales.tr,
                          ),
                          _SettingsButton(
                            text: appLocalization(context).english,
                            isSelected: !isTurkish,
                            locales: Locales.en,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 220),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.locales,
  }) : super(key: key);

  final String text;
  final bool isSelected;
  final Locales locales;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = isSelected ? Colors.white : Colors.grey;
    return GestureDetector(
      onTap: () => Provider.of<LocalizationData>(context, listen: false).changeLocale(locales),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: buttonColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: buttonColor,
                ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: buttonColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
