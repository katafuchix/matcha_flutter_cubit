import 'dart:convert';

import '../api/api_response.dart';
import 'error_result.dart';

class RepositoryResultMisc {
  String? requiredAppVersion;
  ApiMeta? apiMeta;
  int? loadedPageIndex;
  int? totalCount;
  int? badgeCount;
  RepositoryResultMisc(this.requiredAppVersion, this.loadedPageIndex,
      this.totalCount, this.badgeCount);

  @override
  String toString() =>
      '{requiredAppVersion : $requiredAppVersion, apiMeta : $apiMeta}';
}

class RepositoryResult<T> {
  RepositoryResult._();

  factory RepositoryResult.success(T? t, RepositoryResultMisc? misc) =
      RepositorySuccessResult;
  factory RepositoryResult.error(ErrorResult error, RepositoryResultMisc misc) =
      RepositoryErrorResult;

  bool isError() => this is RepositoryErrorResult;
  String? getErrorMessage() {
    if (isError()) {
      String apiErrorMessage = (this as RepositoryErrorResult).error.message;
      return apiErrorMessage.isEmpty
          ? '予期せぬエラーが発生しました。時間をあけてお試しください。'
          : apiErrorMessage;
    }
    return null;
  }

  T? getData() {
    if (this is RepositorySuccessResult)
      return (this as RepositorySuccessResult).data;
    return null;
  }
}

class RepositorySuccessResult<T> extends RepositoryResult<T> {
  final T? data;
  final RepositoryResultMisc? misc;
  RepositorySuccessResult(this.data, this.misc) : super._();

  @override
  String toString() => jsonEncode(this);
}

class RepositoryErrorResult<T> extends RepositoryResult<T> {
  final ErrorResult error;
  final RepositoryResultMisc misc;
  RepositoryErrorResult(this.error, this.misc) : super._();

  @override
  String toString() => jsonEncode(this);
}
