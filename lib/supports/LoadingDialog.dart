import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  static bool _isShowing = false;

  static void show(BuildContext context, {required Key key}) {
    if (_isShowing) return;
    _isShowing = true;
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => LoadingDialog(key: key),
    );
  }

  static void hide(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  const LoadingDialog({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
            ],
          ),
        )

        /*Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                const Text('Requesting data...'),
              ],
            ),
          ),
        )*/,
      ),
    );
  }
}
