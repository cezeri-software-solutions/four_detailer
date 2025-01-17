// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchace_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PurchaceEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String url) urlChanged,
    required TResult Function(bool isLoading) loadingChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String url)? urlChanged,
    TResult? Function(bool isLoading)? loadingChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String url)? urlChanged,
    TResult Function(bool isLoading)? loadingChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UrlChanged value) urlChanged,
    required TResult Function(_LoadingChanged value) loadingChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UrlChanged value)? urlChanged,
    TResult? Function(_LoadingChanged value)? loadingChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UrlChanged value)? urlChanged,
    TResult Function(_LoadingChanged value)? loadingChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaceEventCopyWith<$Res> {
  factory $PurchaceEventCopyWith(PurchaceEvent value, $Res Function(PurchaceEvent) then) = _$PurchaceEventCopyWithImpl<$Res, PurchaceEvent>;
}

/// @nodoc
class _$PurchaceEventCopyWithImpl<$Res, $Val extends PurchaceEvent> implements $PurchaceEventCopyWith<$Res> {
  _$PurchaceEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UrlChangedImplCopyWith<$Res> {
  factory _$$UrlChangedImplCopyWith(_$UrlChangedImpl value, $Res Function(_$UrlChangedImpl) then) = __$$UrlChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$UrlChangedImplCopyWithImpl<$Res> extends _$PurchaceEventCopyWithImpl<$Res, _$UrlChangedImpl> implements _$$UrlChangedImplCopyWith<$Res> {
  __$$UrlChangedImplCopyWithImpl(_$UrlChangedImpl _value, $Res Function(_$UrlChangedImpl) _then) : super(_value, _then);

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
  }) {
    return _then(_$UrlChangedImpl(
      null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UrlChangedImpl implements _UrlChanged {
  const _$UrlChangedImpl(this.url);

  @override
  final String url;

  @override
  String toString() {
    return 'PurchaceEvent.urlChanged(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UrlChangedImpl && (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UrlChangedImplCopyWith<_$UrlChangedImpl> get copyWith => __$$UrlChangedImplCopyWithImpl<_$UrlChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String url) urlChanged,
    required TResult Function(bool isLoading) loadingChanged,
  }) {
    return urlChanged(url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String url)? urlChanged,
    TResult? Function(bool isLoading)? loadingChanged,
  }) {
    return urlChanged?.call(url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String url)? urlChanged,
    TResult Function(bool isLoading)? loadingChanged,
    required TResult orElse(),
  }) {
    if (urlChanged != null) {
      return urlChanged(url);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UrlChanged value) urlChanged,
    required TResult Function(_LoadingChanged value) loadingChanged,
  }) {
    return urlChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UrlChanged value)? urlChanged,
    TResult? Function(_LoadingChanged value)? loadingChanged,
  }) {
    return urlChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UrlChanged value)? urlChanged,
    TResult Function(_LoadingChanged value)? loadingChanged,
    required TResult orElse(),
  }) {
    if (urlChanged != null) {
      return urlChanged(this);
    }
    return orElse();
  }
}

abstract class _UrlChanged implements PurchaceEvent {
  const factory _UrlChanged(final String url) = _$UrlChangedImpl;

  String get url;

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UrlChangedImplCopyWith<_$UrlChangedImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingChangedImplCopyWith<$Res> {
  factory _$$LoadingChangedImplCopyWith(_$LoadingChangedImpl value, $Res Function(_$LoadingChangedImpl) then) =
      __$$LoadingChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isLoading});
}

/// @nodoc
class __$$LoadingChangedImplCopyWithImpl<$Res> extends _$PurchaceEventCopyWithImpl<$Res, _$LoadingChangedImpl>
    implements _$$LoadingChangedImplCopyWith<$Res> {
  __$$LoadingChangedImplCopyWithImpl(_$LoadingChangedImpl _value, $Res Function(_$LoadingChangedImpl) _then) : super(_value, _then);

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
  }) {
    return _then(_$LoadingChangedImpl(
      null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LoadingChangedImpl implements _LoadingChanged {
  const _$LoadingChangedImpl(this.isLoading);

  @override
  final bool isLoading;

  @override
  String toString() {
    return 'PurchaceEvent.loadingChanged(isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingChangedImpl &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading);

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingChangedImplCopyWith<_$LoadingChangedImpl> get copyWith => __$$LoadingChangedImplCopyWithImpl<_$LoadingChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String url) urlChanged,
    required TResult Function(bool isLoading) loadingChanged,
  }) {
    return loadingChanged(isLoading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String url)? urlChanged,
    TResult? Function(bool isLoading)? loadingChanged,
  }) {
    return loadingChanged?.call(isLoading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String url)? urlChanged,
    TResult Function(bool isLoading)? loadingChanged,
    required TResult orElse(),
  }) {
    if (loadingChanged != null) {
      return loadingChanged(isLoading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UrlChanged value) urlChanged,
    required TResult Function(_LoadingChanged value) loadingChanged,
  }) {
    return loadingChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UrlChanged value)? urlChanged,
    TResult? Function(_LoadingChanged value)? loadingChanged,
  }) {
    return loadingChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UrlChanged value)? urlChanged,
    TResult Function(_LoadingChanged value)? loadingChanged,
    required TResult orElse(),
  }) {
    if (loadingChanged != null) {
      return loadingChanged(this);
    }
    return orElse();
  }
}

abstract class _LoadingChanged implements PurchaceEvent {
  const factory _LoadingChanged(final bool isLoading) = _$LoadingChangedImpl;

  bool get isLoading;

  /// Create a copy of PurchaceEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingChangedImplCopyWith<_$LoadingChangedImpl> get copyWith => throw _privateConstructorUsedError;
}
