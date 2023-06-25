import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' show FToast, ToastGravity;
import '../main.dart';

class HelperFunctions {
  static void showToastMessage({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Icon? icon,
    int duration = 2200,
  }) async {
    final ctx = navigatorKey.currentContext;
    FToast().init(ctx!);

    //remove previous toast if exists
    await FToast().removeCustomToast();
    FToast().showToast(
      toastDuration: Duration(milliseconds: duration),
      gravity: ToastGravity.BOTTOM,
      child: InkWell(
        onTap: () {
          FToast().removeCustomToast();
        },
        child: Container(
          height: 90,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            // ignore: use_build_context_synchronously
            color: backgroundColor ?? Theme.of(ctx).colorScheme.error,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon ??
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      height: 0,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<bool> showPopUp(
    BuildContext context,
    String title,
    String message,
    Function() onConfirm, {
    String confirmText = "موافق",
    String cancelText = "إلغاء",
    bool showCancel = true,
  }) async {
    bool result = false;
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            content: Text(
              message,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 2.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: Container(
                  height: 40,
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    minWidth: 80,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    confirmText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          height: 0,
                        ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    minWidth: 80,
                  ),
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    cancelText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          height: 0,
                        ),
                  ),
                ),
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
    return result;
  }
}
