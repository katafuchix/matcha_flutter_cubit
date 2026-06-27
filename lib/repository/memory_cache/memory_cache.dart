// 各repositoryがメンバ変数でもつ想定
class MemoryCache<T> {
  // デフォルトキャッシュ有効時間 : 2時間
  int cacheValidTimeMillis = 2 * 60 * 60 * 1000;

  int? _savedTimeMillis;
  T? _data;
  List<T>? _listData;

  MemoryCache();
  MemoryCache.fromCacheValidateTime(this.cacheValidTimeMillis);

  void saveSingleData(T data) {
    this._data = data;
    _updateSavedTime();
  }

  void saveListData(List<T> listData) {
    this._listData = listData;
    _updateSavedTime();
  }

  T? getSingleData() {
    _validate();
    return _data;
  }

  List<T>? getListData() {
    _validate();
    return _listData;
  }

  void _validate() {
    if (_savedTimeMillis == null) {
      clear();
      return;
    }

    if (cacheValidTimeMillis == null) {
      clear();
      return;
    }

    if (cacheValidTimeMillis <
        DateTime.now().millisecondsSinceEpoch - _savedTimeMillis!) {
      clear();
      return;
    }
  }

  void clear() {
    _data = null;
    _listData = null;
  }

  void _updateSavedTime() {
    _savedTimeMillis = DateTime.now().millisecondsSinceEpoch;
  }
}
