// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_leads.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NewLeads _$NewLeadsFromJson(Map<String, dynamic> json) {
  return _NewLeads.fromJson(json);
}

/// @nodoc
mixin _$NewLeads {
  @HiveField(0)
  int get ThisWeekLeads => throw _privateConstructorUsedError;
  @HiveField(1)
  int get ThisMonthLeads => throw _privateConstructorUsedError;
  @HiveField(2)
  int get ThisYearLeads => throw _privateConstructorUsedError;
  @HiveField(3)
  String get message => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewLeadsCopyWith<NewLeads> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewLeadsCopyWith<$Res> {
  factory $NewLeadsCopyWith(NewLeads value, $Res Function(NewLeads) then) =
      _$NewLeadsCopyWithImpl<$Res, NewLeads>;
  @useResult
  $Res call(
      {@HiveField(0) int ThisWeekLeads,
      @HiveField(1) int ThisMonthLeads,
      @HiveField(2) int ThisYearLeads,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class _$NewLeadsCopyWithImpl<$Res, $Val extends NewLeads>
    implements $NewLeadsCopyWith<$Res> {
  _$NewLeadsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ThisWeekLeads = null,
    Object? ThisMonthLeads = null,
    Object? ThisYearLeads = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      ThisWeekLeads: null == ThisWeekLeads
          ? _value.ThisWeekLeads
          : ThisWeekLeads // ignore: cast_nullable_to_non_nullable
              as int,
      ThisMonthLeads: null == ThisMonthLeads
          ? _value.ThisMonthLeads
          : ThisMonthLeads // ignore: cast_nullable_to_non_nullable
              as int,
      ThisYearLeads: null == ThisYearLeads
          ? _value.ThisYearLeads
          : ThisYearLeads // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NewLeadsCopyWith<$Res> implements $NewLeadsCopyWith<$Res> {
  factory _$$_NewLeadsCopyWith(
          _$_NewLeads value, $Res Function(_$_NewLeads) then) =
      __$$_NewLeadsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int ThisWeekLeads,
      @HiveField(1) int ThisMonthLeads,
      @HiveField(2) int ThisYearLeads,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class __$$_NewLeadsCopyWithImpl<$Res>
    extends _$NewLeadsCopyWithImpl<$Res, _$_NewLeads>
    implements _$$_NewLeadsCopyWith<$Res> {
  __$$_NewLeadsCopyWithImpl(
      _$_NewLeads _value, $Res Function(_$_NewLeads) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ThisWeekLeads = null,
    Object? ThisMonthLeads = null,
    Object? ThisYearLeads = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_$_NewLeads(
      ThisWeekLeads: null == ThisWeekLeads
          ? _value.ThisWeekLeads
          : ThisWeekLeads // ignore: cast_nullable_to_non_nullable
              as int,
      ThisMonthLeads: null == ThisMonthLeads
          ? _value.ThisMonthLeads
          : ThisMonthLeads // ignore: cast_nullable_to_non_nullable
              as int,
      ThisYearLeads: null == ThisYearLeads
          ? _value.ThisYearLeads
          : ThisYearLeads // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 5, adapterName: 'NewLeadsClassAdapter')
class _$_NewLeads implements _NewLeads {
  const _$_NewLeads(
      {@HiveField(0) required this.ThisWeekLeads,
      @HiveField(1) required this.ThisMonthLeads,
      @HiveField(2) required this.ThisYearLeads,
      @HiveField(3) required this.message,
      @HiveField(4) required this.success});

  factory _$_NewLeads.fromJson(Map<String, dynamic> json) =>
      _$$_NewLeadsFromJson(json);

  @override
  @HiveField(0)
  final int ThisWeekLeads;
  @override
  @HiveField(1)
  final int ThisMonthLeads;
  @override
  @HiveField(2)
  final int ThisYearLeads;
  @override
  @HiveField(3)
  final String message;
  @override
  @HiveField(4)
  final bool success;

  @override
  String toString() {
    return 'NewLeads(ThisWeekLeads: $ThisWeekLeads, ThisMonthLeads: $ThisMonthLeads, ThisYearLeads: $ThisYearLeads, message: $message, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NewLeads &&
            (identical(other.ThisWeekLeads, ThisWeekLeads) ||
                other.ThisWeekLeads == ThisWeekLeads) &&
            (identical(other.ThisMonthLeads, ThisMonthLeads) ||
                other.ThisMonthLeads == ThisMonthLeads) &&
            (identical(other.ThisYearLeads, ThisYearLeads) ||
                other.ThisYearLeads == ThisYearLeads) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ThisWeekLeads, ThisMonthLeads,
      ThisYearLeads, message, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NewLeadsCopyWith<_$_NewLeads> get copyWith =>
      __$$_NewLeadsCopyWithImpl<_$_NewLeads>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NewLeadsToJson(
      this,
    );
  }
}

abstract class _NewLeads implements NewLeads {
  const factory _NewLeads(
      {@HiveField(0) required final int ThisWeekLeads,
      @HiveField(1) required final int ThisMonthLeads,
      @HiveField(2) required final int ThisYearLeads,
      @HiveField(3) required final String message,
      @HiveField(4) required final bool success}) = _$_NewLeads;

  factory _NewLeads.fromJson(Map<String, dynamic> json) = _$_NewLeads.fromJson;

  @override
  @HiveField(0)
  int get ThisWeekLeads;
  @override
  @HiveField(1)
  int get ThisMonthLeads;
  @override
  @HiveField(2)
  int get ThisYearLeads;
  @override
  @HiveField(3)
  String get message;
  @override
  @HiveField(4)
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$_NewLeadsCopyWith<_$_NewLeads> get copyWith =>
      throw _privateConstructorUsedError;
}
