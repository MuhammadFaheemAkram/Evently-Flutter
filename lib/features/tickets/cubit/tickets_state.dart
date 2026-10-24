import 'package:evently/domain/model/ticket_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tickets_state.freezed.dart';

enum TicketsStatus { loading, ready }

@freezed
abstract class TicketsState with _$TicketsState {
  const factory TicketsState({
    @Default(TicketsStatus.loading) TicketsStatus status,

    /// Tickets whose event hasn't ended, soonest first.
    @Default(<TicketItem>[]) List<TicketItem> upcoming,

    /// Tickets whose event is over, most recent first.
    @Default(<TicketItem>[]) List<TicketItem> past,
  }) = _TicketsState;
}
