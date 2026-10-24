import 'dart:developer';

import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/result.dart';
import 'package:json_annotation/json_annotation.dart';

/// Runs [work], a fetch from the API and its write to the database, and
/// turns any failure into an [AppException] the UI can show:
/// - the app's own exceptions pass through (a [NetworkException]);
/// - malformed data becomes [DataFormatException];
/// - anything else (a database error) is logged and becomes
///   [UnknownException].
///
/// [what] names the work in the log ("Refreshing the catalog").
Future<Result<T>> guardApiCall<T>(
  String what,
  Future<T> Function() work,
) async {
  try {
    return Ok(await work());
  } on AppException catch (exception) {
    return Err(exception);
  } on FormatException catch (error, stackTrace) {
    log('$what failed', error: error, stackTrace: stackTrace);
    return const Err(DataFormatException());
  } on CheckedFromJsonException catch (error, stackTrace) {
    log('$what failed', error: error, stackTrace: stackTrace);
    return const Err(DataFormatException());
  } on Object catch (error, stackTrace) {
    log('$what failed', error: error, stackTrace: stackTrace);
    return const Err(UnknownException());
  }
}
