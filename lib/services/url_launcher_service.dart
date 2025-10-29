import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  const UrlLauncherService();

  Future<void> openEmail({
    String? toEmail = 'xnguyen.lam@gmail.com',
    String? subject,
    String? body,
  }) async {
    String query = '';
    if (subject != null) {
      query += 'subject=${Uri.encodeComponent(subject)}';
    }
    if (body != null) {
      if (query.isNotEmpty) query += '&';
      query += 'body=${Uri.encodeComponent(body)}';
    }

    final uri = Uri.parse(
      'mailto:$toEmail${query.isNotEmpty ? '?$query' : ''}',
    );

    await _launch(uri);
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await _launch(uri);
  }

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $uri');
    }
  }
}
