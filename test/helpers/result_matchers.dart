import 'package:evently/core/common/result.dart';
import 'package:flutter_test/flutter_test.dart';

/// An [Ok] holding [value] (anything `expect` accepts as a matcher).
Matcher isOk([Object? value = anything]) =>
    isA<Ok<Object?>>().having((ok) => ok.value, 'value', value);

/// An [Err] whose exception is a [E].
Matcher isErr<E>() =>
    isA<Err<Object?>>().having((err) => err.exception, 'exception', isA<E>());
