// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

void updateWebTitle(String title) {
  if (kIsWeb) {
    html.document.title = title;
  }
}

void updateMetaTags({
  required String title,
  required String description,
  String? imageUrl,
}) {
  if (!kIsWeb) return;

  // Update Open Graph meta tags
  _updateMetaTag('og:title', title);
  _updateMetaTag('og:description', description);
  if (imageUrl != null) {
    _updateMetaTag('og:image', imageUrl);
  }

  // Update Twitter meta tags
  _updateMetaTag('twitter:title', title);
  _updateMetaTag('twitter:description', description);
  if (imageUrl != null) {
    _updateMetaTag('twitter:image', imageUrl);
  }

  // Update regular meta tags
  _updateMetaTag('description', description);
}

void _updateMetaTag(String property, String content) {
  if (!kIsWeb) return;
  
  var elements = html.document.getElementsByTagName('meta');
  for (var element in elements) {
    if (element is html.Element) {
      if (element.attributes['property'] == property || 
          element.attributes['name'] == property) {
        element.attributes['content'] = content;
        return;
      }
    }
  }
} 