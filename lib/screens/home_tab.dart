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
        child: Stack(
          children: [
            // Map in the center
            Positioned.fill(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/philmap.svg',
                  width: mapWidth,
                ),
              ),
            ),
            
            // Luzon button - positioned directly on the blue northern region
            Positioned(
              top: MediaQuery.of(context).size.height * 0.31,
              left: MediaQuery.of(context).size.width * 0.58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LuzonScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700], // Blue for Luzon
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Luzon', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_back, size: 10),
                  ],
                ),
              ),
            ),
            
            // Visayas button - positioned above the yellow central region
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              left: MediaQuery.of(context).size.width * 0.30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisayasScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600], // Yellow/Gold for Visayas
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Visayas', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_back, size: 10),
                  ],
                ),
              ),
            ),
            
            // Mindanao button - positioned in the lower part of the red southern region
            Positioned(
              top: MediaQuery.of(context).size.height * 0.60,
              left: MediaQuery.of(context).size.width * 0.39,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MindanaoScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700], // Red for Mindanao
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Mindanao', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_back, size: 10),
                  ],
                ),
              ),
            ),
            
            // Title at the top
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EFE0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD2B48C), width: 2),
                  ),
                  child: const Text(
                    'Explore the Philippine Archipelago',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5F4B32),
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
