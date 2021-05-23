import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:log_book/widgets/index.dart';

import 'index.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends MomentumState<SplashView> {
  void _setFullscreen() async {
    await DesktopWindow.setFullScreen(true);
  }

  _startTimer() {
    Duration duration = const Duration(milliseconds: 3000);
    return Timer(duration, _navigatorPage);
  }

  _navigatorPage() {
    MomentumRouter.clearHistoryWithContext(context);
    MomentumRouter.goto(context, HomeView);
  }

  @override
  void initMomentumState() {
    // set full screen window
    _setFullscreen();
    _startTimer();
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      child: Scaffold(
        body: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  SizedBox(height: height * 0.2),
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: AutoSizeText(
                        'Intern LogBook',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        presetFontSizes: [
                          70,
                          65,
                          60,
                          55,
                          50,
                          45,
                          43,
                          40,
                          35,
                          30,
                          25,
                          20
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: sy(50)),
                  Center(
                    child: AutoSizeText(
                      '"A daily work logbook"',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      presetFontSizes: [40, 35, 30, 25, 20, 17],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(sy(30)),
                    child: customLoader(loaderType: 3, loaderText: ''),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
