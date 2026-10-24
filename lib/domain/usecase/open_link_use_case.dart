import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/service/link_opener.dart';
import 'package:injectable/injectable.dart';

/// Opens a link outside the app, `https` only.
///
/// Join links come from the catalog, so anything else (`http:`,
/// `javascript:`, `file:`, an app's own scheme) is refused here, before the
/// platform sees it. Directions are https maps links too.
@injectable
class OpenLinkUseCase {
  const OpenLinkUseCase(this._opener);

  final LinkOpener _opener;

  Future<Result<void>> call(Uri url) async {
    if (!url.isScheme('https') || url.host.isEmpty) {
      return const Err(UnsafeLinkException());
    }
    return await _opener.open(url)
        ? const Ok(null)
        : const Err(LinkOpenFailedException());
  }
}
