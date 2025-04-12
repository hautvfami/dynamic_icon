import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dynamic_icon/dynamic_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dynamicIconPlugin = DynamicIcon();
  List<String>? icons;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic Icon')),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            ElevatedButton(
              onPressed: () async {
                icons = await _dynamicIconPlugin.getAvailableIcons();
                setState(() {

                });
                // print(icons);
              },
              child: const Text('Get Available Icons'),
            ),
            ElevatedButton(
              onPressed: () async {
                final currentIcon = await _dynamicIconPlugin.getCurrentIcon();
                print(currentIcon);
              },
              child: const Text('Get Current Icon'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _dynamicIconPlugin.setIcon('MainAliasFestival');
              },
              child: const Text('Set Icon 1'),
            ),
            ...icons?.map(
                  (e) => ElevatedButton(
                    onPressed: () async {
                      await _dynamicIconPlugin.setIcon(e);
                    },
                    child: Text('Set Icon $e'),
                  ),
                ) ??
                const [],
          ],
        ),
      ),
    );
  }
}
