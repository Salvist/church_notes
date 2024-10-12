class InMemoryCache<T> {
  InMemoryCache();

  final _cache = <String, T?>{};

  void add(String key, T? value) {
    _cache[key] = value;
  }

  T? read(String key) {
    return _cache[key];
  }

  bool contains(String key) {
    return _cache.containsKey(key);
  }

  void delete(String key) {
    _cache.remove(key);
  }
}
