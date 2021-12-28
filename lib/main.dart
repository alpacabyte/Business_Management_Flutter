import 'package:business_management/functions/init_hive.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/localization_model.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/models/transaction_data.dart';
import 'package:business_management/screens/home/db_error_page.dart';
import 'package:business_management/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isError = false;
  try {
    await initHive();
  } catch (error) {
    isError = true;
  }

  runApp(App(isError: isError));

  doWhenWindowReady(() {
    appWindow.minSize = const Size(1363, 725);
    appWindow.maximize();
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({Key? key, required this.isError}) : super(key: key);

  final bool isError;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocalizationData(), lazy: false),
        ChangeNotifierProvider(create: (context) => TransactionsData(), lazy: false),
        ChangeNotifierProvider(create: (context) => ProductsData(), lazy: false),
        ChangeNotifierProvider(create: (context) => CostumersData(), lazy: false),
        ChangeNotifierProvider(create: (context) => SuppliersData(), lazy: false),
      ],
      builder: (context, child) => MaterialApp(
        locale: Provider.of<LocalizationData>(context).locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('tr', ''),
        ],
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: appbarColor,
          scrollbarTheme: const ScrollbarThemeData().copyWith(thickness: MaterialStateProperty.all(15)),
        ),
        debugShowCheckedModeBanner: false,
        home: !isError ? const HomePage() : const DBErrorWidget(),
      ),
    );
  }
}

AppLocalizations appLocalization(BuildContext context) => AppLocalizations.of(context)!;
