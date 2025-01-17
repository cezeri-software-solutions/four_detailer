// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchace_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PurchaceState {
  String get currentUrl => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of PurchaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaceStateCopyWith<PurchaceState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaceStateCopyWith<$Res> {
  factory $PurchaceStateCopyWith(PurchaceState value, $Res Function(PurchaceState) then) = _$PurchaceStateCopyWithImpl<$Res, PurchaceState>;
  @useResult
  $Res call({String currentUrl, bool isLoading});
}

/// @nodoc
class _$PurchaceStateCopyWithImpl<$Res, $Val extends PurchaceState> implements $PurchaceStateCopyWith<$Res> {
  _$PurchaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUrl = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      currentUrl: null == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaceStateImplCopyWith<$Res> implements $PurchaceStateCopyWith<$Res> {
  factory _$$PurchaceStateImplCopyWith(_$PurchaceStateImpl value, $Res Function(_$PurchaceStateImpl) then) = __$$PurchaceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentUrl, bool isLoading});
}

/// @nodoc
class __$$PurchaceStateImplCopyWithImpl<$Res> extends _$PurchaceStateCopyWithImpl<$Res, _$PurchaceStateImpl>
    implements _$$PurchaceStateImplCopyWith<$Res> {
  __$$PurchaceStateImplCopyWithImpl(_$PurchaceStateImpl _value, $Res Function(_$PurchaceStateImpl) _then) : super(_value, _then);

  /// Create a copy of PurchaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUrl = null,
    Object? isLoading = null,
  }) {
    return _then(_$PurchaceStateImpl(
      currentUrl: null == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PurchaceStateImpl implements _PurchaceState {
  const _$PurchaceStateImpl({this.currentUrl = 'https://ccf-autopflege.at', this.isLoading = false});

  @override
  @JsonKey()
  final String currentUrl;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'PurchaceState(currentUrl: $currentUrl, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaceStateImpl &&
            (identical(other.currentUrl, currentUrl) || other.currentUrl == currentUrl) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentUrl, isLoading);

  /// Create a copy of PurchaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaceStateImplCopyWith<_$PurchaceStateImpl> get copyWith => __$$PurchaceStateImplCopyWithImpl<_$PurchaceStateImpl>(this, _$identity);
}

abstract class _PurchaceState implements PurchaceState {
  const factory _PurchaceState({final String currentUrl, final bool isLoading}) = _$PurchaceStateImpl;

  @override
  String get currentUrl;
  @override
  bool get isLoading;

  /// Create a copy of PurchaceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaceStateImplCopyWith<_$PurchaceStateImpl> get copyWith => throw _privateConstructorUsedError;
}
