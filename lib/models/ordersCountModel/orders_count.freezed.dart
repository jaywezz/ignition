// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OrdersCount _$OrdersCountFromJson(Map<String, dynamic> json) {
  return _OrdersCount.fromJson(json);
}

/// @nodoc
mixin _$OrdersCount {
  @HiveField(0)
  int get CustomerOrderCountThisWeek => throw _privateConstructorUsedError;
  @HiveField(1)
  int get CustomerOrderCountThisMonth => throw _privateConstructorUsedError;
  @HiveField(2)
  int get CustomersOrderCountThisYear => throw _privateConstructorUsedError;
  @HiveField(3)
  String get message => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersCountCopyWith<OrdersCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersCountCopyWith<$Res> {
  factory $OrdersCountCopyWith(
          OrdersCount value, $Res Function(OrdersCount) then) =
      _$OrdersCountCopyWithImpl<$Res, OrdersCount>;
  @useResult
  $Res call(
      {@HiveField(0) int CustomerOrderCountThisWeek,
      @HiveField(1) int CustomerOrderCountThisMonth,
      @HiveField(2) int CustomersOrderCountThisYear,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class _$OrdersCountCopyWithImpl<$Res, $Val extends OrdersCount>
    implements $OrdersCountCopyWith<$Res> {
  _$OrdersCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CustomerOrderCountThisWeek = null,
    Object? CustomerOrderCountThisMonth = null,
    Object? CustomersOrderCountThisYear = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      CustomerOrderCountThisWeek: null == CustomerOrderCountThisWeek
          ? _value.CustomerOrderCountThisWeek
          : CustomerOrderCountThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      CustomerOrderCountThisMonth: null == CustomerOrderCountThisMonth
          ? _value.CustomerOrderCountThisMonth
          : CustomerOrderCountThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      CustomersOrderCountThisYear: null == CustomersOrderCountThisYear
          ? _value.CustomersOrderCountThisYear
          : CustomersOrderCountThisYear // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_OrdersCountCopyWith<$Res>
    implements $OrdersCountCopyWith<$Res> {
  factory _$$_OrdersCountCopyWith(
          _$_OrdersCount value, $Res Function(_$_OrdersCount) then) =
      __$$_OrdersCountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int CustomerOrderCountThisWeek,
      @HiveField(1) int CustomerOrderCountThisMonth,
      @HiveField(2) int CustomersOrderCountThisYear,
      @HiveField(3) String message,
      @HiveField(4) bool success});
}

/// @nodoc
class __$$_OrdersCountCopyWithImpl<$Res>
    extends _$OrdersCountCopyWithImpl<$Res, _$_OrdersCount>
    implements _$$_OrdersCountCopyWith<$Res> {
  __$$_OrdersCountCopyWithImpl(
      _$_OrdersCount _value, $Res Function(_$_OrdersCount) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CustomerOrderCountThisWeek = null,
    Object? CustomerOrderCountThisMonth = null,
    Object? CustomersOrderCountThisYear = null,
    Object? message = null,
    Object? success = null,
  }) {
    return _then(_$_OrdersCount(
      CustomerOrderCountThisWeek: null == CustomerOrderCountThisWeek
          ? _value.CustomerOrderCountThisWeek
          : CustomerOrderCountThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      CustomerOrderCountThisMonth: null == CustomerOrderCountThisMonth
          ? _value.CustomerOrderCountThisMonth
          : CustomerOrderCountThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      CustomersOrderCountThisYear: null == CustomersOrderCountThisYear
          ? _value.CustomersOrderCountThisYear
          : CustomersOrderCountThisYear // ignore: cast_nullable_to_non_nullable
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
@HiveType(typeId: 6, adapterName: 'OrdersCountClassAdapter')
class _$_OrdersCount implements _OrdersCount {
  const _$_OrdersCount(
      {@HiveField(0) required this.CustomerOrderCountThisWeek,
      @HiveField(1) required this.CustomerOrderCountThisMonth,
      @HiveField(2) required this.CustomersOrderCountThisYear,
      @HiveField(3) required this.message,
      @HiveField(4) required this.success});

  factory _$_OrdersCount.fromJson(Map<String, dynamic> json) =>
      _$$_OrdersCountFromJson(json);

  @override
  @HiveField(0)
  final int CustomerOrderCountThisWeek;
  @override
  @HiveField(1)
  final int CustomerOrderCountThisMonth;
  @override
  @HiveField(2)
  final int CustomersOrderCountThisYear;
  @override
  @HiveField(3)
  final String message;
  @override
  @HiveField(4)
  final bool success;

  @override
  String toString() {
    return 'OrdersCount(CustomerOrderCountThisWeek: $CustomerOrderCountThisWeek, CustomerOrderCountThisMonth: $CustomerOrderCountThisMonth, CustomersOrderCountThisYear: $CustomersOrderCountThisYear, message: $message, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OrdersCount &&
            (identical(other.CustomerOrderCountThisWeek,
                    CustomerOrderCountThisWeek) ||
                other.CustomerOrderCountThisWeek ==
                    CustomerOrderCountThisWeek) &&
            (identical(other.CustomerOrderCountThisMonth,
                    CustomerOrderCountThisMonth) ||
                other.CustomerOrderCountThisMonth ==
                    CustomerOrderCountThisMonth) &&
            (identical(other.CustomersOrderCountThisYear,
                    CustomersOrderCountThisYear) ||
                other.CustomersOrderCountThisYear ==
                    CustomersOrderCountThisYear) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      CustomerOrderCountThisWeek,
      CustomerOrderCountThisMonth,
      CustomersOrderCountThisYear,
      message,
      success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OrdersCountCopyWith<_$_OrdersCount> get copyWith =>
      __$$_OrdersCountCopyWithImpl<_$_OrdersCount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OrdersCountToJson(
      this,
    );
  }
}

abstract class _OrdersCount implements OrdersCount {
  const factory _OrdersCount(
      {@HiveField(0) required final int CustomerOrderCountThisWeek,
      @HiveField(1) required final int CustomerOrderCountThisMonth,
      @HiveField(2) required final int CustomersOrderCountThisYear,
      @HiveField(3) required final String message,
      @HiveField(4) required final bool success}) = _$_OrdersCount;

  factory _OrdersCount.fromJson(Map<String, dynamic> json) =
      _$_OrdersCount.fromJson;

  @override
  @HiveField(0)
  int get CustomerOrderCountThisWeek;
  @override
  @HiveField(1)
  int get CustomerOrderCountThisMonth;
  @override
  @HiveField(2)
  int get CustomersOrderCountThisYear;
  @override
  @HiveField(3)
  String get message;
  @override
  @HiveField(4)
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$_OrdersCountCopyWith<_$_OrdersCount> get copyWith =>
      throw _privateConstructorUsedError;
}
