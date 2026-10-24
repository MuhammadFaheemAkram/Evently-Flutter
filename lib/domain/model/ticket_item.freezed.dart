// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketItem {

 Ticket get ticket; Event get event; String get organizerName;
/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketItemCopyWith<TicketItem> get copyWith => _$TicketItemCopyWithImpl<TicketItem>(this as TicketItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketItem&&(identical(other.ticket, _this.ticket) || other.ticket == _this.ticket)&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.organizerName, _this.organizerName) || other.organizerName == _this.organizerName));
}


@override
int get hashCode {
  final _this = this as TicketItem;
  return Object.hash(runtimeType,_this.ticket,_this.event,_this.organizerName);
}

@override
String toString() {
  final _this = this as TicketItem;
  return 'TicketItem(ticket: ${_this.ticket}, event: ${_this.event}, organizerName: ${_this.organizerName})';
}


}

/// @nodoc
abstract mixin class $TicketItemCopyWith<$Res>  {
  factory $TicketItemCopyWith(TicketItem value, $Res Function(TicketItem) _then) = _$TicketItemCopyWithImpl;
@useResult
$Res call({
 Ticket ticket, Event event, String organizerName
});


$TicketCopyWith<$Res> get ticket;$EventCopyWith<$Res> get event;

}
/// @nodoc
class _$TicketItemCopyWithImpl<$Res>
    implements $TicketItemCopyWith<$Res> {
  _$TicketItemCopyWithImpl(this._self, this._then);

  final TicketItem _self;
  final $Res Function(TicketItem) _then;

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticket = null,Object? event = null,Object? organizerName = null,}) {
  return _then(TicketItem(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as Ticket,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketCopyWith<$Res> get ticket {
  
  return $TicketCopyWith<$Res>(_self.ticket, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketItem].
extension TicketItemPatterns on TicketItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketItem value)  $default,){
final _that = this;
switch (_that) {
case _TicketItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketItem value)?  $default,){
final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Ticket ticket,  Event event,  String organizerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that.ticket,_that.event,_that.organizerName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Ticket ticket,  Event event,  String organizerName)  $default,) {final _that = this;
switch (_that) {
case _TicketItem():
return $default(_that.ticket,_that.event,_that.organizerName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Ticket ticket,  Event event,  String organizerName)?  $default,) {final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that.ticket,_that.event,_that.organizerName);case _:
  return null;

}
}

}

/// @nodoc


class _TicketItem extends TicketItem {
  const _TicketItem({required this.ticket, required this.event, required this.organizerName}): super._();
  

@override final  Ticket ticket;
@override final  Event event;
@override final  String organizerName;

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketItemCopyWith<_TicketItem> get copyWith => __$TicketItemCopyWithImpl<_TicketItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketItem&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.event, event) || other.event == event)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ticket,event,organizerName);
}

@override
String toString() {
    return 'TicketItem(ticket: $ticket, event: $event, organizerName: $organizerName)';
}


}

/// @nodoc
abstract mixin class _$TicketItemCopyWith<$Res> implements $TicketItemCopyWith<$Res> {
  factory _$TicketItemCopyWith(_TicketItem value, $Res Function(_TicketItem) _then) = __$TicketItemCopyWithImpl;
@override @useResult
$Res call({
 Ticket ticket, Event event, String organizerName
});


@override $TicketCopyWith<$Res> get ticket;@override $EventCopyWith<$Res> get event;

}
/// @nodoc
class __$TicketItemCopyWithImpl<$Res>
    implements _$TicketItemCopyWith<$Res> {
  __$TicketItemCopyWithImpl(this._self, this._then);

  final _TicketItem _self;
  final $Res Function(_TicketItem) _then;

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? event = null,Object? organizerName = null,}) {
  return _then(_TicketItem(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as Ticket,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketCopyWith<$Res> get ticket {
  
  return $TicketCopyWith<$Res>(_self.ticket, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
