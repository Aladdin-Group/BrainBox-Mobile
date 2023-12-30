import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {

  WebViewController? controller;
  double progressValue = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              progressValue = (progress/100).toDouble();
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {

          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://englify.uz/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://englify.uz/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: controller!),
          Positioned(
            bottom: 0,
              right: 0,
              left: 0,
              child: LinearProgressIndicator(
                value: progressValue.toDouble(),
              )
          ),
        ],
      ),
    );
  }
}
