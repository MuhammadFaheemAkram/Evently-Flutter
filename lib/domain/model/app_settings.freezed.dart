// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

/// Whether the user has left Welcome (with the demo, or fresh).
 bool get onboarded;/// The city Discover leads with; `null` is "Anywhere".
 String? get preferredCity; AppThemeMode get themeMode;/// Colors from the wallpaper (Android 12+). On by default, as Material
/// You apps are; ignored where the device has none.
 bool get dynamicColor;/// Off until the user turns them on, so the system's permission prompt
/// comes with a reason. Reads "on" only while the system allows them:
/// a sync that finds the permission gone turns it off.
 bool get notificationsEnabled; ReminderLead get reminderLead;/// "Today: Flutter London at 18:30, and 1 more", at [summaryTime] on
/// days with events you're going to.
 bool get summaryEnabled;/// The user's local time.
 TimeOfDayValue get summaryTime;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.onboarded, _this.onboarded) || other.onboarded == _this.onboarded)&&(identical(other.preferredCity, _this.preferredCity) || other.preferredCity == _this.preferredCity)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.dynamicColor, _this.dynamicColor) || other.dynamicColor == _this.dynamicColor)&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled)&&(identical(other.reminderLead, _this.reminderLead) || other.reminderLead == _this.reminderLead)&&(identical(other.summaryEnabled, _this.summaryEnabled) || other.summaryEnabled == _this.summaryEnabled)&&(identical(other.summaryTime, _this.summaryTime) || other.summaryTime == _this.summaryTime));
}


@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.onboarded,_this.preferredCity,_this.themeMode,_this.dynamicColor,_this.notificationsEnabled,_this.reminderLead,_this.summaryEnabled,_this.summaryTime);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(onboarded: ${_this.onboarded}, preferredCity: ${_this.preferredCity}, themeMode: ${_this.themeMode}, dynamicColor: ${_this.dynamicColor}, notificationsEnabled: ${_this.notificationsEnabled}, reminderLead: ${_this.reminderLead}, summaryEnabled: ${_this.summaryEnabled}, summaryTime: ${_this.summaryTime})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 bool onboarded, String? preferredCity, AppThemeMode themeMode, bool dynamicColor, bool notificationsEnabled, ReminderLead reminderLead, bool summaryEnabled, TimeOfDayValue summaryTime
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? onboarded = null,Object? preferredCity = freezed,Object? themeMode = null,Object? dynamicColor = null,Object? notificationsEnabled = null,Object? reminderLead = null,Object? summaryEnabled = null,Object? summaryTime = null,}) {
  return _then(AppSettings(
onboarded: null == onboarded ? _self.onboarded : onboarded // ignore: cast_nullable_to_non_nullable
as bool,preferredCity: freezed == preferredCity ? _self.preferredCity : preferredCity // ignore: cast_nullable_to_non_nullable
as String?,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,dynamicColor: null == dynamicColor ? _self.dynamicColor : dynamicColor // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderLead: null == reminderLead ? _self.reminderLead : reminderLead // ignore: cast_nullable_to_non_nullable
as ReminderLead,summaryEnabled: null == summaryEnabled ? _self.summaryEnabled : summaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,summaryTime: null == summaryTime ? _self.summaryTime : summaryTime // ignore: cast_nullable_to_non_nullable
as TimeOfDayValue,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool onboarded,  String? preferredCity,  AppThemeMode themeMode,  bool dynamicColor,  bool notificationsEnabled,  ReminderLead reminderLead,  bool summaryEnabled,  TimeOfDayValue summaryTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.onboarded,_that.preferredCity,_that.themeMode,_that.dynamicColor,_that.notificationsEnabled,_that.reminderLead,_that.summaryEnabled,_that.summaryTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool onboarded,  String? preferredCity,  AppThemeMode themeMode,  bool dynamicColor,  bool notificationsEnabled,  ReminderLead reminderLead,  bool summaryEnabled,  TimeOfDayValue summaryTime)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.onboarded,_that.preferredCity,_that.themeMode,_that.dynamicColor,_that.notificationsEnabled,_that.reminderLead,_that.summaryEnabled,_that.summaryTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool onboarded,  String? preferredCity,  AppThemeMode themeMode,  bool dynamicColor,  bool notificationsEnabled,  ReminderLead reminderLead,  bool summaryEnabled,  TimeOfDayValue summaryTime)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.onboarded,_that.preferredCity,_that.themeMode,_that.dynamicColor,_that.notificationsEnabled,_that.reminderLead,_that.summaryEnabled,_that.summaryTime);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.onboarded = false, this.preferredCity, this.themeMode = AppThemeMode.system, this.dynamicColor = true, this.notificationsEnabled = false, this.reminderLead = ReminderLead.oneHour, this.summaryEnabled = true, this.summaryTime = TimeOfDayValue.eightAm});
  

/// Whether the user has left Welcome (with the demo, or fresh).
@override@JsonKey() final  bool onboarded;
/// The city Discover leads with; `null` is "Anywhere".
@override final  String? preferredCity;
@override@JsonKey() final  AppThemeMode themeMode;
/// Colors from the wallpaper (Android 12+). On by default, as Material
/// You apps are; ignored where the device has none.
@override@JsonKey() final  bool dynamicColor;
/// Off until the user turns them on, so the system's permission prompt
/// comes with a reason. Reads "on" only while the system allows them:
/// a sync that finds the permission gone turns it off.
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  ReminderLead reminderLead;
/// "Today: Flutter London at 18:30, and 1 more", at [summaryTime] on
/// days with events you're going to.
@override@JsonKey() final  bool summaryEnabled;
/// The user's local time.
@override@JsonKey() final  TimeOfDayValue summaryTime;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.onboarded, onboarded) || other.onboarded == onboarded)&&(identical(other.preferredCity, preferredCity) || other.preferredCity == preferredCity)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.dynamicColor, dynamicColor) || other.dynamicColor == dynamicColor)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.reminderLead, reminderLead) || other.reminderLead == reminderLead)&&(identical(other.summaryEnabled, summaryEnabled) || other.summaryEnabled == summaryEnabled)&&(identical(other.summaryTime, summaryTime) || other.summaryTime == summaryTime));
}


@override
int get hashCode {
    return Object.hash(runtimeType,onboarded,preferredCity,themeMode,dynamicColor,notificationsEnabled,reminderLead,summaryEnabled,summaryTime);
}

@override
String toString() {
    return 'AppSettings(onboarded: $onboarded, preferredCity: $preferredCity, themeMode: $themeMode, dynamicColor: $dynamicColor, notificationsEnabled: $notificationsEnabled, reminderLead: $reminderLead, summaryEnabled: $summaryEnabled, summaryTime: $summaryTime)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool onboarded, String? preferredCity, AppThemeMode themeMode, bool dynamicColor, bool notificationsEnabled, ReminderLead reminderLead, bool summaryEnabled, TimeOfDayValue summaryTime
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? onboarded = null,Object? preferredCity = freezed,Object? themeMode = null,Object? dynamicColor = null,Object? notificationsEnabled = null,Object? reminderLead = null,Object? summaryEnabled = null,Object? summaryTime = null,}) {
  return _then(_AppSettings(
onboarded: null == onboarded ? _self.onboarded : onboarded // ignore: cast_nullable_to_non_nullable
as bool,preferredCity: freezed == preferredCity ? _self.preferredCity : preferredCity // ignore: cast_nullable_to_non_nullable
as String?,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,dynamicColor: null == dynamicColor ? _self.dynamicColor : dynamicColor // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderLead: null == reminderLead ? _self.reminderLead : reminderLead // ignore: cast_nullable_to_non_nullable
as ReminderLead,summaryEnabled: null == summaryEnabled ? _self.summaryEnabled : summaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,summaryTime: null == summaryTime ? _self.summaryTime : summaryTime // ignore: cast_nullable_to_non_nullable
as TimeOfDayValue,
  ));
}


}

// dart format on
