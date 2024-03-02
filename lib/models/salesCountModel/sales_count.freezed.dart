// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SalesCount _$SalesCountFromJson(Map<String, dynamic> json) {
  return _SalesCount.fromJson(json);
}

/// @nodoc
mixin _$SalesCount {
  @HiveField(0)
  int? get TotalSales => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get message => throw _privateConstructorUsedError;
  @HiveField(2)
  bool? get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesCountCopyWith<SalesCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesCountCopyWith<$Res> {
  factory $SalesCountCopyWith(
          SalesCount value, $Res Function(SalesCount) then) =
      _$SalesCountCopyWithImpl<$Res, SalesCount>;
  @useResult
  $Res call(
      {@HiveField(0) int? TotalSales,
      @HiveField(1) String? message,
      @HiveField(2) bool? success});
}

/// @nodoc
class _$SalesCountCopyWithImpl<$Res, $Val extends SalesCount>
    implements $SalesCountCopyWith<$Res> {
  _$SalesCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? TotalSales = freezed,
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_value.copyWith(
      TotalSales: freezed == TotalSales
          ? _value.TotalSales
          : TotalSales // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SalesCountCopyWith<$Res>
    implements $SalesCountCopyWith<$Res> {
  factory _$$_SalesCountCopyWith(
          _$_SalesCount value, $Res Function(_$_SalesCount) then) =
      __$$_SalesCountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int? TotalSales,
      @HiveField(1) String? message,
      @HiveField(2) bool? success});
}

/// @nodoc
class __$$_SalesCountCopyWithImpl<$Res>
    extends _$SalesCountCopyWithImpl<$Res, _$_SalesCount>
    implements _$$_SalesCountCopyWith<$Res> {
  __$$_SalesCountCopyWithImpl(
      _$_SalesCount _value, $Res Function(_$_SalesCount) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? TotalSales = freezed,
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_$_SalesCount(
      TotalSales: freezed == TotalSales
          ? _value.TotalSales
          : TotalSales // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 7, adapterName: 'SalesCountClassAdapter')
class _$_SalesCount implements _SalesCount {
  const _$_SalesCount(
      {@HiveField(0) this.TotalSales,
      @HiveField(1) this.message,
      @HiveField(2) this.success});

  factory _$_SalesCount.fromJson(Map<String, dynamic> json) =>
      _$$_SalesCountFromJson(json);

  @override
  @HiveField(0)
  final int? TotalSales;
  @override
  @HiveField(1)
  final String? message;
  @override
  @HiveField(2)
  final bool? success;

  @override
  String toString() {
    return 'SalesCount(TotalSales: $TotalSales, message: $message, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SalesCount &&
            (identical(other.TotalSales, TotalSales) ||
                other.TotalSales == TotalSales) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, TotalSales, message, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SalesCountCopyWith<_$_SalesCount> get copyWith =>
      __$$_SalesCountCopyWithImpl<_$_SalesCount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SalesCountToJson(
      this,
    );
  }
}

abstract class _SalesCount implements SalesCount {
  const factory _SalesCount(
      {@HiveField(0) final int? TotalSales,
      @HiveField(1) final String? message,
      @HiveField(2) final bool? success}) = _$_SalesCount;

  factory _SalesCount.fromJson(Map<String, dynamic> json) =
      _$_SalesCount.fromJson;

  @override
  @HiveField(0)
  int? get TotalSales;
  @override
  @HiveField(1)
  String? get message;
  @override
  @HiveField(2)
  bool? get success;
  @override
  @JsonKey(ignore: true)
  _$$_SalesCountCopyWith<_$_SalesCount> get copyWith =>
      throw _privateConstructorUsedError;
}
