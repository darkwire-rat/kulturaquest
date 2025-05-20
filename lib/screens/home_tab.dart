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
      appBar: AppBar(
        title: const Text('Explore Philippines', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5F4B32), // Dark brown text
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: const Color(0xFFF5EFE0), // Parchment/vintage paper color
        elevation: 4,
        shadowColor: Color(0xFFD0C8B0), // Subtle shadow for depth
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE0), // Parchment/vintage paper color at top
              Color(0xFFE8DFC9), // Slightly darker vintage color at bottom
            ],
          ),
        ),
        child: Column(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513), // Saddle brown
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFD2B48C), width: 2), // Tan border
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF5F4B32).withOpacity(0.5),
                ),
                child: const Text('Luzon', style: TextStyle(fontWeight: FontWeight.bold)),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513), // Saddle brown
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFD2B48C), width: 2), // Tan border
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF5F4B32).withOpacity(0.5),
                ),
                child: const Text('Visayas', style: TextStyle(fontWeight: FontWeight.bold)),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513), // Saddle brown
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFD2B48C), width: 2), // Tan border
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF5F4B32).withOpacity(0.5),
                ),
                child: const Text('Mindanao', style: TextStyle(fontWeight: FontWeight.bold)),
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
    ));
  }
}
