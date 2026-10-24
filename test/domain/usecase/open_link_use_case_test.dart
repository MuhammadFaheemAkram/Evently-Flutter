import 'package:evently/core/common/app_exception.dart';
import 'package:evently/domain/usecase/open_link_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/recording_link_opener.dart';
import '../../helpers/result_matchers.dart';

void main() {
  late RecordingLinkOpener opener;
  late OpenLinkUseCase openLink;

  setUp(() {
    opener = RecordingLinkOpener();
    openLink = OpenLinkUseCase(opener);
  });

  test('opens an https link', () async {
    final url = Uri.parse('https://meet.example/a');

    expect(await openLink(url), isOk());
    expect(opener.opened, [url]);
  });

  test('refuses anything else, before the platform sees it', () async {
    for (final link in [
      'http://meet.example/a',
      'javascript:alert(1)',
      'file:///etc/hosts',
      'zoommtg://join',
      'https:///nohost',
    ]) {
      expect(
        await openLink(Uri.parse(link)),
        isErr<UnsafeLinkException>(),
        reason: link,
      );
    }
    expect(opener.opened, isEmpty);
  });

  test("says so when the system can't open it", () async {
    opener.succeeds = false;

    expect(
      await openLink(Uri.parse('https://meet.example/a')),
      isErr<LinkOpenFailedException>(),
    );
  });
}
