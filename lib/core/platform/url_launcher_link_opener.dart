import 'package:evently/domain/service/link_opener.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens links with `url_launcher`, outside the app: a maps link goes to
/// the maps app, a join link to the meeting app that claims it (or the
/// browser).
@LazySingleton(as: LinkOpener)
class UrlLauncherLinkOpener implements LinkOpener {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri url) async {
    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}
