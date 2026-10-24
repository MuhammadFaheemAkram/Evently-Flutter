/// The app's error vocabulary.
///
/// Every failure that can reach the UI is one of these types, and each carries
/// a user-facing [message], so screens render a small, stable set of error
/// states instead of raw exceptions.
///
/// `sealed` lets the compiler check that a `switch` over an [AppException]
/// handles every subtype.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Copy that is safe to show to the user.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The (fake) network call failed.
final class NetworkException extends AppException {
  const NetworkException()
    : super("Couldn't reach the server. Check your connection and try again.");
}

/// The data could not be decoded (malformed JSON, unexpected types, or a
/// record that breaks the app's rules, such as an event that ends before it
/// starts).
final class DataFormatException extends AppException {
  const DataFormatException()
    : super('The event data looks damaged. Please try again.');
}

/// The item no longer exists (or never did: a stale link).
final class NotFoundException extends AppException {
  /// [what] names the record: "That event doesn't exist any more."
  const NotFoundException([String what = 'item'])
    : super("That $what doesn't exist any more.");
}

/// Input that breaks a rule, with what to fix ([message]). The forms show
/// the same rules under their fields; this is what a use case answers when
/// something slips past them.
final class InvalidInputException extends AppException {
  const InvalidInputException(super.message);
}

/// The server has no places left for the chosen ticket type.
final class SoldOutException extends AppException {
  const SoldOutException()
    : super('Sold out: no places left for that ticket type.');
}

/// The server already has a booking of yours for this event.
final class AlreadyBookedException extends AppException {
  const AlreadyBookedException() : super("You're already going.");
}

/// The server no longer takes bookings (or cancellations) for the event:
/// it was cancelled, or has started.
final class BookingClosedException extends AppException {
  const BookingClosedException([
    super.message = 'Bookings for this event are closed.',
  ]);
}

/// A link that isn't `https` (from the catalog, so never trusted blindly).
final class UnsafeLinkException extends AppException {
  const UnsafeLinkException()
    : super('Only secure (https) links can be opened.');
}

/// The system couldn't open a link (no browser or maps app took it).
final class LinkOpenFailedException extends AppException {
  const LinkOpenFailedException() : super("Couldn't open the link.");
}

/// Anything unexpected that isn't one of the cases above.
final class UnknownException extends AppException {
  const UnknownException() : super('Something went wrong. Please try again.');
}
