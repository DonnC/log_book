import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

import 'package:log_book/components/index.dart';
import 'package:log_book/services/index.dart';
import 'package:log_book/utils/index.dart';
import 'package:log_book/views/index.dart';
import 'package:log_book/widgets/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPref = SharedPreferencesWindows.instance;
  // only allow persistence per session
  // to avoid persisting views with issues
  await sharedPref.clear();
  runApp(momentum());

  doWhenWindowReady(() {
    final win = appWindow;

    final initialSize = Size(900, 680);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "LogBook";
    //win.maximize();
    win.show();
  });
}

Momentum momentum() => Momentum(
      key: UniqueKey(),
      restartCallback: main,
      child: MyApp(),
      appLoader:
          customLoader(loaderText: 'Initializing...', isInitLoader: true),
      persistSave: (context, key, value) async {
        final sharedPref = SharedPreferencesWindows.instance;
        var result = await sharedPref.setValue("String", key, value);
        return result;
      },
      persistGet: (context, key) async {
        final sharedPref = SharedPreferencesWindows.instance;
        var result = await sharedPref.getAll();
        return result[key];
      },
      controllers: [
        HomeViewController()..config(lazy: true),
        PdfPrinterViewController()..config(lazy: true),
      ],
      services: [
        DialogService(),
        AppService(),
        MomentumRouter(
          [
            SplashView(),
            HomeView(),
            PdfGenView(),
          ],
        ),
      ],
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LogBook',
        theme: colorTheme,
        home: Scaffold(
          body: WindowBorder(
            color: borderColor,
            width: 3,
            child: MomentumRouter.getActivePage(context),
          ),
        ),
      );
}
