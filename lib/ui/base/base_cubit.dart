import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../core/app_info.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(State initialState) : super(initialState);

  bool needForceUpdate(String requiredVersion) {
    String currentVersion = AppInfo.appVersion;

    final SemanticVersioning? required =
        BaseCubitUtils.stringToSemanticVersioning(requiredVersion);
    final SemanticVersioning? current =
        BaseCubitUtils.stringToSemanticVersioning(currentVersion);

    if (required == null || current == null) return false;

    return BaseCubitUtils.greaterThan(current, required);
  }
}

class SemanticVersioning {
  int major;
  int minor;
  int patch;
  SemanticVersioning(this.major, this.minor, this.patch);

  bool validateSelf() {
    if (major == null || minor == null || patch == null) return false;
    return true;
  }
}

class BaseCubitUtils {
  static bool greaterThan(SemanticVersioning src, SemanticVersioning target) {
    if (src == null || target == null) return false;

    if (!src.validateSelf() || !target.validateSelf()) return false;

    if (src.major < target.major) return true;
    if (src.minor < target.minor) return true;
    if (src.patch < target.patch) return true;
    return false;
  }

  static SemanticVersioning? stringToSemanticVersioning(
      String? semanticVersion) {
    if (semanticVersion == null) return null;

    final versions = semanticVersion.split('.');
    if (versions.length != 3) return null;
    final v0 = stringToInt(versions[0]);
    final v1 = stringToInt(versions[1]);
    final v2 = stringToInt(versions[2]);

    if (v0 == null || v1 == null || v2 == null) return null;

    return SemanticVersioning(v0, v1, v2);
  }

  @visibleForTesting
  static int? stringToInt(String str) {
    try {
      return int.parse(str);
    } on FormatException catch (e) {
      return null;
    }
  }
}
