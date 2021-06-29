import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:epson_epos/epson_epos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EPSON ePOS'),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextButton(
                    onPressed: onDiscoveryTCP, child: Text('Discovery TCP'))
              ],
            ),
          ),
        )),
      ),
    );
  }

  onDiscoveryTCP() async {
    try {
      final data = await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
    } catch (e) {
      log("Error: " + e.toString());
    }
  }
}
