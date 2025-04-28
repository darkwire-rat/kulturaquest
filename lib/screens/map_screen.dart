import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _onRegionClicked(BuildContext context, String region) {
    // For now, just show a simple alert
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Region Selected'),
            content: Text('You clicked: $region'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _onRegionClicked(context, 'Luzon'),
              child: const Text('Luzon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onRegionClicked(context, 'Visayas'),
              child: const Text('Visayas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onRegionClicked(context, 'Mindanao'),
              child: const Text('Mindanao'),
            ),
          ],
        ),
      ),
    );
  }
}
