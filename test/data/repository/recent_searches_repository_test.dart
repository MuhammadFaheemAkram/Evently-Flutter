import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() {
    stack = DataStack();
    addTearDown(stack.close);
  });

  test('a search is remembered trimmed', () async {
    expect(await stack.saveRecentSearch('  jazz  '), isOk());

    expect(await stack.watchRecentSearches().first, ['jazz']);
  });

  test('too short to be a search: not remembered', () async {
    await stack.saveRecentSearch(' j ');
    await stack.saveRecentSearch('');

    expect(await stack.watchRecentSearches().first, isEmpty);
  });

  test('clear all', () async {
    await stack.saveRecentSearch('jazz');

    expect(await stack.clearRecentSearches(), isOk());
    expect(await stack.watchRecentSearches().first, isEmpty);
  });
}
