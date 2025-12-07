import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mserp/networkSupport/ConnectivityService.dart';
import 'package:mserp/main.dart'; // Import your main file to access navigatorKey

class NetworkListener extends StatefulWidget {
  final Widget child;

  const NetworkListener({super.key, required this.child});

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    print('NetworkListener initialized');
    _initializeConnectivity();
  }

  void _initializeConnectivity() async {
    await _connectivityService.initialize();

    _connectivityService.connectivityStream.listen((ConnectivityResult status) {
      print('Connectivity changed: $status');
      if (status == ConnectivityResult.none) {
        _showNoInternetDialog();
      } else {
        _hideNoInternetDialog();
      }
    });
  }

  void _showNoInternetDialog() {
    if (_isDialogShown) {
      print('Dialog already shown, skipping...');
      return;
    }

    print('Attempting to show dialog...');
    _isDialogShown = true;

    // Check if navigator context is available
    if (MyApp.overlayKey.currentContext == null) {
      _isDialogShown = false;
      return;
    }

    // Use the global navigator key to show dialog
    showDialog(
      context: MyApp.overlayKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        print('Dialog builder called successfully');
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button from closing
          child: Dialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Internet Connection",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please check your network settings and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      print('Retry button pressed');
                      final connected = await _connectivityService.isConnected;
                      print('Retry check result: $connected');
                      if (connected) {
                        _hideNoInternetDialog();
                      }
                    },
                    child: const Text("Retry Connection"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // This runs when dialog is dismissed by other means
      print('Dialog closed');
      _isDialogShown = false;
    });
  }

  void _hideNoInternetDialog() {
    if (!_isDialogShown) {
      print('No dialog to hide');
      return;
    }

    print('🔄 Attempting to hide dialog...');
    _isDialogShown = false;

    // Use navigatorKey to pop dialog
    if (MyApp.overlayKey.currentState != null) {
      Navigator.of(MyApp.overlayKey.currentContext!, rootNavigator: true).pop();
      print('Dialog hidden successfully');
    } else {
      print('No navigator state available to hide dialog');
    }
  }

  @override
  void dispose() {
    print('NetworkListener disposed');
    _hideNoInternetDialog();
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}