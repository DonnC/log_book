import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import 'package:log_book/utils/index.dart';
import 'package:log_book/widgets/index.dart';

/// main service for all app dialogs
class DialogService extends MomentumService {
  showPopDialogLoader(
    BuildContext context,
    String title, {
    String loaderText: 'loading...',
    bool isBarrierDismissable: true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isBarrierDismissable,
      builder: (_) => SimpleDialog(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: customLoader(
              loaderText: loaderText,
            ),
          ),
        ],
      ),
    );
  }

  void showFlashBar(BuildContext context, String info, String title) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: [bgColor, secondaryColor],
          ),
          position: FlashPosition.bottom,
          enableDrag: true,
          horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
          margin: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.slowMiddle,
          child: FlashBar(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            message: Text(info),
            /*
            primaryAction: IconButton(
              icon: Icon(Icons.info),
              onPressed: () {},
            ),
            */
            icon: Icon(
              Icons.info,
              color: textColor,
            ),
            shouldIconPulse: false,
            showProgressIndicator: true,
          ),
        );
      },
    );
  }

  void showInfoDialog(BuildContext context, String info, String title) async {
    showFlash(
      context: context,
      // persistent: false,
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          margin: const EdgeInsets.all(8),
          child: FlashBar(
            message: Text(
              info,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.dismiss();
                },
                child: Text('CLOSE'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showFlashInfoDialog(
      BuildContext context, String info, String title) async {
    await showFlash(
      context: context,
      //persistent: false,
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: [bgColor, secondaryColor],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          margin: const EdgeInsets.all(8),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.slowMiddle,
          position: FlashPosition.bottom,
          enableDrag: true,
          child: FlashBar(
            icon: Icon(
              Icons.info,
              color: textColor,
            ),
            shouldIconPulse: false,
            showProgressIndicator: true,
            message: Text(
              info,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.dismiss();
                },
                child: Text('CANCEL'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> showFlashDialogConfirm(
      BuildContext context, String info, String title) async {
    var res = showFlash<bool>(
      context: context,
      //persistent: false,
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: [bgColor, secondaryColor],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          margin: const EdgeInsets.all(8),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.slowMiddle,
          position: FlashPosition.bottom,
          enableDrag: true,
          child: FlashBar(
            icon: Icon(
              Icons.delete,
              color: textColor,
            ),
            shouldIconPulse: false,
            showProgressIndicator: true,
            message: Text(
              info,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.dismiss(true);
                },
                child: Text('YES'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.dismiss(false);
                },
                child: Text('NO'),
              ),
            ],
          ),
        );
      },
    );

    return res;
  }

  Future<bool> showDialogConfirmation(
      BuildContext context, String info, String title) async {
    var res = showFlash<bool>(
      context: context,
      //persistent: false,
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          margin: const EdgeInsets.all(8),
          child: FlashBar(
            message: Text(
              info,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.dismiss(true);
                },
                child: Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.dismiss(false);
                },
                child: Text('CANCEL'),
              ),
            ],
          ),
        );
      },
    );

    return res;
  }

  void showFloatingFlushbar({
    BuildContext context,
    String title,
    String message,
    bool showOnTop: true,
    bool warning: false, // to change color of popup
    bool autoDismiss: false,
  }) {
    showFlash(
      context: context,
      duration: autoDismiss ? null : const Duration(milliseconds: 3000),
      //persistent: false,
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: warning
                ? [Colors.red.shade800, Colors.redAccent.shade700]
                : [Colors.green.shade800, Colors.greenAccent.shade700],
            stops: [0.6, 1],
          ),
          position: showOnTop ? FlashPosition.top : FlashPosition.bottom,
          enableDrag: true,
          horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
          margin: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.slowMiddle,
          child: FlashBar(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            message: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false,
          ),
        );
      },
    );
  }
}
