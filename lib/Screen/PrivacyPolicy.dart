import 'package:flutter/material.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late final WebViewController webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              checkInternet(
                context,
                false,
              );
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
            'https://docs.google.com/document/d/10MKid3JVccHZLHtZ1khu7gc766utLQJbRjQ4UK8zcs0/edit'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          WebViewWidget(controller: webViewController),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: kPrimeryColor,
              ),
            ),
          Container(
            alignment: Alignment.topRight,
            height: 80,
            width: double.infinity,
            color: kPrimeryColor,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 40, right: 10),
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
