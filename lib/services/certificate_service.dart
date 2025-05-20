import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/achievement_models.dart';

class CertificateService {
  /// Generates a PDF certificate with a summary of achievements
  static Future<Uint8List> generateCertificate(String userName, List<AchievementCluster> clusters) async {
    // Create a PDF document
    final pdf = pw.Document();
    
    // Load KulturaQuest logo for the certificate
    final ByteData logoData = await rootBundle.load('assets/images/kul.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);
    
    // Calculate achievement statistics
    int totalCompletedAchievements = 0;
    int totalAchievements = 0;
    
    for (final cluster in clusters) {
      for (final subcat in cluster.subcategories) {
        totalAchievements += subcat.achievements.length;
        totalCompletedAchievements += subcat.achievements.where((a) => a.isCompleted).length;
      }
    }
    
    final achievementPercentage = totalAchievements > 0 
        ? ((totalCompletedAchievements / totalAchievements) * 100).toStringAsFixed(1) 
        : "0.0";
    
    // Add a page to the PDF document
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo at the top middle
              pw.Center(
                child: pw.SizedBox(
                  width: 150,
                  height: 150,
                  child: pw.Image(logoImage),
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Certificate title
              pw.Text(
                'CERTIFICATE OF ACHIEVEMENT',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              
              pw.SizedBox(height: 10),
              
              pw.Text(
                'This certificate is presented to',
                style: pw.TextStyle(fontSize: 16),
              ),
              
              pw.SizedBox(height: 10),
              
              // User name
              pw.Text(
                userName.isEmpty ? 'Valued KulturaQuest Explorer' : userName,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              
              pw.SizedBox(height: 20),
              
              pw.Text(
                'for their dedication to learning about Filipino culture and heritage',
                style: pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.center,
              ),
              
              pw.SizedBox(height: 40),
              
              // Achievement summary
              pw.Container(
                padding: pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.orange),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ACHIEVEMENT SUMMARY',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    
                    pw.SizedBox(height: 10),
                    
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Overall Progress:'),
                        pw.Text('$achievementPercentage%',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    
                    pw.SizedBox(height: 5),
                    
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Achievements Completed:'),
                        pw.Text('$totalCompletedAchievements / $totalAchievements',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    
                    pw.Divider(thickness: 1),
                    
                    // Category breakdown
                    ...clusters.map((cluster) {
                      int categoryCompleted = 0;
                      int categoryTotal = 0;
                      
                      for (final subcat in cluster.subcategories) {
                        categoryTotal += subcat.achievements.length;
                        categoryCompleted += subcat.achievements.where((a) => a.isCompleted).length;
                      }
                      
                      final categoryPercentage = categoryTotal > 0 
                          ? ((categoryCompleted / categoryTotal) * 100).toStringAsFixed(1) 
                          : "0.0";
                      
                      return pw.Padding(
                        padding: pw.EdgeInsets.only(top: 8),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(cluster.title + ':'),
                            pw.Text('$categoryPercentage% ($categoryCompleted/$categoryTotal)',
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              
              pw.Spacer(),
              
              // Current date
              pw.Text(
                'Issued on: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: pw.TextStyle(fontSize: 12),
              ),
              
              pw.SizedBox(height: 10),
              
              // KulturaQuest attribution
              pw.Text(
                'KulturaQuest - Celebrating Filipino Culture and Heritage',
                style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );
    
    // Return the PDF document as a byte array
    return pdf.save();
  }
}
