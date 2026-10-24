import 'package:evently/domain/calculation/ticket_rules.dart' as rules;
import 'package:evently/domain/model/ticket_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_detail_state.freezed.dart';

enum TicketDetailStatus { loading, ready, notFound }

@freezed
abstract class TicketDetailState with _$TicketDetailState {
  const factory TicketDetailState({
    @Default(TicketDetailStatus.loading) TicketDetailStatus status,
    TicketItem? item,

    /// What "can I still cancel" is judged against.
    DateTime? now,

    /// Waiting for the server to cancel.
    @Default(false) bool cancelling,

    /// A one-time SnackBar; [messageSerial] makes each one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _TicketDetailState;

  const TicketDetailState._();

  /// Why the ticket can't be cancelled (`null`: it can).
  rules.CancelBlock? get cancelBlock {
    final item = this.item;
    final now = this.now;
    if (item == null || now == null) return null;
    return rules.cancelBlock(item, now: now);
  }
}
