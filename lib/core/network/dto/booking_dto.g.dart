// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingDto', json, ($checkedConvert) {
      final val = BookingDto(
        ticket: $checkedConvert(
          'ticket',
          (v) => TicketDto.fromJson(v as Map<String, dynamic>),
        ),
        event: $checkedConvert(
          'event',
          (v) => EventDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });
