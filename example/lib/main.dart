import 'package:flutter/material.dart';
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
  String? currentIcon;

  Future<void> _loadCurrentIcon() async {
    final icon = await _dynamicIconPlugin.getCurrentIcon();
    setState(() => currentIcon = icon);
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic Icon'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Current Icon: ${currentIcon ?? "Loading..."}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final availableIcons =
                              await _dynamicIconPlugin.getAvailableIcons();
                          setState(() => icons = availableIcons);
                          await _loadCurrentIcon();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Load Available Icons'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _dynamicIconPlugin.reset();
                          await _loadCurrentIcon();
                        },
                        icon: const Icon(Icons.restore),
                        label: const Text('Reset to Default Icon'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (icons != null) ...[
                Text(
                  'Available Icons',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: icons!.length,
                    itemBuilder: (context, index) {
                      final iconName = icons![index];
                      final isSelected = iconName == currentIcon;
                      return ElevatedButton(
                        onPressed: () async {
                          await _dynamicIconPlugin.setIcon(iconName);
                          await _loadCurrentIcon();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                        ),
                        child: Text(iconName),
                      );
                    },
                  ),
                ),
              ] else
                const Expanded(
                  child: Center(
                    child: Text('Press "Load Available Icons" to see options'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
