import 'package:flutter/material.dart';

import '../../model/repository/repository_result.dart';
import '../components/snack_bar.dart';

class OnResultHandler<T> {
  final RepositoryResult<T> result;
  final Function(T result)? onSuccess;
  OnResultHandler(this.result, {this.onSuccess});
}

class RepositoryHandler {
  static T? getSuccessOrNull<T>(RepositoryResult<T> result) {
    if (result is RepositorySuccessResult) {
      return (result as RepositorySuccessResult).data;
    }
    return null;
  }

  static handleRepositoryResult<T>(
      BuildContext context, RepositoryResult<T> result,
      {Function(T? result, RepositoryResultMisc? misc)? onSuccess,
      Function(int? statusCode, String? errorMessage)? onError,
      bool showErrorMessage = true}) {
    if (result is RepositoryErrorResult) {
      final error = (result as RepositoryErrorResult<T>?)?.error;
      if (showErrorMessage) {
        if (error == null) {
          showErrorSnackBar(context, text: '予期せぬエラーが発生しました。時間をあけておためしください。');
        } else {
          showErrorSnackBar(context, text: error.message);
        }
      }

      if (onError != null) {
        onError(error?.errorCode, error?.message);
      }
      return;
    }

    if (result is RepositorySuccessResult) {
      final successResult = result as RepositorySuccessResult<T>;
      if (onSuccess != null) onSuccess(successResult.data, successResult.misc);
    }
  }

  // 全てのresultが成功である場合、全てのresultに対してonSuccessを実行する
  // 1つでもエラーが発生した場合、最初に見つけたエラーに対してonErrorを実行する
  static handleMultipleRepositoryResult(
      BuildContext context, List<OnResultHandler<dynamic>> onResultHandlerList,
      {Function(int? statusCode, String? errorMessage)? onError,
      bool showErrorMessage = true}) {
    List<Function> onSuccessList = [];

    onResultHandlerList.forEach((OnResultHandler<dynamic> handler) {
      final result = handler.result;
      if (result is RepositoryErrorResult) {
        final error = result.error;
        if (showErrorMessage) {
          if (error == null) {
            showErrorSnackBar(context, text: '予期せぬエラーが発生しました。時間をあけておためしください。');
          } else {
            showErrorSnackBar(context, text: error.message);
          }
        }

        if (onError != null) {
          onError(error.errorCode, error.message);
        }
        return;
      }

      if (result is RepositorySuccessResult) {
        onSuccessList.add(() {
          handler.onSuccess?.call(result.data);
        });
      }
    });

    // onSuccessを一気に実行
    onSuccessList.forEach((f) {
      f.call();
    });
  }
}
