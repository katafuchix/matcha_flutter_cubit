// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/purchase/local_receipt.dart';

/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class ConsumableStoreForIos {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(LocalReceipt localReceipt) {
    _writes = _writes.then((void _) => _doSave(localReceipt));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(LocalReceipt id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<LocalReceipt>> load() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKey)
            ?.map((e) => (LocalReceipt.fromJson(jsonDecode(e))))
            ?.toList() ??
        [];
  }

  static Future<void> _doSave(LocalReceipt localReceipt) async {
    List<String> cached = (await load()).map((e) => jsonEncode(e)).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(jsonEncode(localReceipt));
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(LocalReceipt id) async {
    List<LocalReceipt> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(
        _kPrefKey, cached.map((e) => jsonEncode(e)).toList());
  }
}
