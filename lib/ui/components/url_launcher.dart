import 'package:url_launcher/url_launcher.dart';

import '../../core/my_logger.dart';

class UrlLauncher {
  static openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      MyLogger.e('Could not launch $url');
    }
  }
}
