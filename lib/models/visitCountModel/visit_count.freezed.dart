// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VisitsCount _$VisitsCountFromJson(Map<String, dynamic> json) {
  return _VisitsCount.fromJson(json);
}

/// @nodoc
mixin _$VisitsCount {
  @HiveField(0)
  int get TotalVisitsPerThisWeek => throw _privateConstructorUsedError;
  @HiveField(1)
  int get TotalVisitsPerThisMonth => throw _privateConstructorUsedError;
  @HiveField(2)
  int get TotalVisitsThisYear => throw _privateConstructorUsedError;
  @HiveField(3)
  String get message => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VisitsCountCopyWith<VisitsCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitsCountCopyWith<$Res> {
  factory $VisitsCountCopyWith(
          VisitsCount value, $Res Function(VisitsCount) then) =
      _$VisitsCountCopyWithImpl<$Res, VisitsCount>;
  @useResult
  $Res call(
      {@HiveField(0) int TotalVisitsPerThisWeek,
      @HiveField(1) int TotalVisitsPerThisMonth,
      @HiveField(2) int TotalVisitsThisYear,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class _$VisitsCountCopyWithImpl<$Res, $Val extends VisitsCount>
    implements $VisitsCountCopyWith<$Res> {
  _$VisitsCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? TotalVisitsPerThisWeek = null,
    Object? TotalVisitsPerThisMonth = null,
    Object? TotalVisitsThisYear = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      TotalVisitsPerThisWeek: null == TotalVisitsPerThisWeek
          ? _value.TotalVisitsPerThisWeek
          : TotalVisitsPerThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      TotalVisitsPerThisMonth: null == TotalVisitsPerThisMonth
          ? _value.TotalVisitsPerThisMonth
          : TotalVisitsPerThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      TotalVisitsThisYear: null == TotalVisitsThisYear
          ? _value.TotalVisitsThisYear
          : TotalVisitsThisYear // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_VisitsCountCopyWith<$Res>
    implements $VisitsCountCopyWith<$Res> {
  factory _$$_VisitsCountCopyWith(
          _$_VisitsCount value, $Res Function(_$_VisitsCount) then) =
      __$$_VisitsCountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int TotalVisitsPerThisWeek,
      @HiveField(1) int TotalVisitsPerThisMonth,
      @HiveField(2) int TotalVisitsThisYear,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class __$$_VisitsCountCopyWithImpl<$Res>
    extends _$VisitsCountCopyWithImpl<$Res, _$_VisitsCount>
    implements _$$_VisitsCountCopyWith<$Res> {
  __$$_VisitsCountCopyWithImpl(
      _$_VisitsCount _value, $Res Function(_$_VisitsCount) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? TotalVisitsPerThisWeek = null,
    Object? TotalVisitsPerThisMonth = null,
    Object? TotalVisitsThisYear = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_$_VisitsCount(
      TotalVisitsPerThisWeek: null == TotalVisitsPerThisWeek
          ? _value.TotalVisitsPerThisWeek
          : TotalVisitsPerThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      TotalVisitsPerThisMonth: null == TotalVisitsPerThisMonth
          ? _value.TotalVisitsPerThisMonth
          : TotalVisitsPerThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      TotalVisitsThisYear: null == TotalVisitsThisYear
          ? _value.TotalVisitsThisYear
          : TotalVisitsThisYear // ignore: cast_nullable_to_non_nullable
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
@HiveType(typeId: 8, adapterName: 'VisitCountClassAdapter')
class _$_VisitsCount implements _VisitsCount {
  const _$_VisitsCount(
      {@HiveField(0) required this.TotalVisitsPerThisWeek,
      @HiveField(1) required this.TotalVisitsPerThisMonth,
      @HiveField(2) required this.TotalVisitsThisYear,
      @HiveField(3) required this.message,
      @HiveField(4) required this.success});

  factory _$_VisitsCount.fromJson(Map<String, dynamic> json) =>
      _$$_VisitsCountFromJson(json);

  @override
  @HiveField(0)
  final int TotalVisitsPerThisWeek;
  @override
  @HiveField(1)
  final int TotalVisitsPerThisMonth;
  @override
  @HiveField(2)
  final int TotalVisitsThisYear;
  @override
  @HiveField(3)
  final String message;
  @override
  @HiveField(4)
  final bool success;

  @override
  String toString() {
    return 'VisitsCount(TotalVisitsPerThisWeek: $TotalVisitsPerThisWeek, TotalVisitsPerThisMonth: $TotalVisitsPerThisMonth, TotalVisitsThisYear: $TotalVisitsThisYear, message: $message, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VisitsCount &&
            (identical(other.TotalVisitsPerThisWeek, TotalVisitsPerThisWeek) ||
                other.TotalVisitsPerThisWeek == TotalVisitsPerThisWeek) &&
            (identical(
                    other.TotalVisitsPerThisMonth, TotalVisitsPerThisMonth) ||
                other.TotalVisitsPerThisMonth == TotalVisitsPerThisMonth) &&
            (identical(other.TotalVisitsThisYear, TotalVisitsThisYear) ||
                other.TotalVisitsThisYear == TotalVisitsThisYear) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, TotalVisitsPerThisWeek,
      TotalVisitsPerThisMonth, TotalVisitsThisYear, message, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VisitsCountCopyWith<_$_VisitsCount> get copyWith =>
      __$$_VisitsCountCopyWithImpl<_$_VisitsCount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VisitsCountToJson(
      this,
    );
  }
}

abstract class _VisitsCount implements VisitsCount {
  const factory _VisitsCount(
      {@HiveField(0) required final int TotalVisitsPerThisWeek,
      @HiveField(1) required final int TotalVisitsPerThisMonth,
      @HiveField(2) required final int TotalVisitsThisYear,
      @HiveField(3) required final String message,
      @HiveField(4) required final bool success}) = _$_VisitsCount;

  factory _VisitsCount.fromJson(Map<String, dynamic> json) =
      _$_VisitsCount.fromJson;

  @override
  @HiveField(0)
  int get TotalVisitsPerThisWeek;
  @override
  @HiveField(1)
  int get TotalVisitsPerThisMonth;
  @override
  @HiveField(2)
  int get TotalVisitsThisYear;
  @override
  @HiveField(3)
  String get message;
  @override
  @HiveField(4)
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$_VisitsCountCopyWith<_$_VisitsCount> get copyWith =>
      throw _privateConstructorUsedError;
}
