import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

void updateWebTitle(String title) {
  if (kIsWeb) {
    html.document.title = title;
  }
}
