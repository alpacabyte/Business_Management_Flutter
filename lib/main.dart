import 'package:business_management/functions/init_hive.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/db_error_page.dart';
import 'package:business_management/screens/home_page.dart';
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
    appWindow.maximize();
    appWindow.minSize = const Size(1363, 725);
    appWindow.show();
  });
}

const backgroundColorHeavy = Color(0xff33333D);
const backgroundColorLight = Color(0xff35353F);

class App extends StatelessWidget {
  const App({Key? key, required this.isError}) : super(key: key);

  final bool isError;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsData()),
      ],
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: backgroundColorHeavy,
          scrollbarTheme: const ScrollbarThemeData()
              .copyWith(thickness: MaterialStateProperty.all(15)),
        ),
        debugShowCheckedModeBanner: false,
        home: !isError ? const HomePage() : const DBErrorWidget(),
      ),
    );
  }
}
