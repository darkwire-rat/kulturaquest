import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CulturalHighlightContent extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? linkUrl;
  final String? linkLabel;
  final Widget? customContent;
  const CulturalHighlightContent({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.linkUrl,
    this.linkLabel,
    this.customContent,
  });

  @override
  State<CulturalHighlightContent> createState() => CulturalHighlightContentState();
}

class CulturalHighlightContentState extends State<CulturalHighlightContent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14),
            ),
            if (widget.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (widget.linkUrl != null && widget.linkLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(widget.linkUrl!))) {
                      await launchUrl(Uri.parse(widget.linkUrl!));
                    }
                  },
                  child: Text(
                    widget.linkLabel!,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            if (widget.customContent != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: widget.customContent!,
              ),
          ],
        ),
      ),
    );
  }
}
