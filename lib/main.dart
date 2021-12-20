import 'package:business_management/functions/init_hive.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/screens/home/db_error_page.dart';
import 'package:business_management/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';

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

const appbarColor = Color(0xff27272e);
const backgroundColorHeavy = Color(0xff2d2d36);
const backgroundColorLight = Color(0xff35353F);

class App extends StatelessWidget {
  const App({Key? key, required this.isError}) : super(key: key);

  final bool isError;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsData()),
        ChangeNotifierProvider(create: (context) => CostumersData()),
        ChangeNotifierProvider(create: (context) => SuppliersData()),
      ],
      child: MaterialApp(
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
