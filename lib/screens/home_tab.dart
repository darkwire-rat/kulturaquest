import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'luzon_screen.dart';
import 'visayas_screen.dart';
import 'mindanao_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final double mapWidth = MediaQuery.of(context).size.width * 0.95;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Philippines')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LuzonScreen(),
                    ),
                  );
                },
                child: const Text('Luzon'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisayasScreen(),
                    ),
                  );
                },
                child: const Text('Visayas'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MindanaoScreen(),
                    ),
                  );
                },
                child: const Text('Mindanao'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Map
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/philmap.svg',
                width: mapWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
