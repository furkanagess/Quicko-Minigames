import 'package:flutter/material.dart';
import '../../../core/utils/favorites_utils.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favorites = [];
  bool _isLoading = true;

  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;

  /// Favorileri yükle
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await FavoritesUtils.loadFavorites();
    } catch (e) {
      print('Favoriler yüklenirken hata: $e');
      _favorites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Oyunu favorilere ekle
  Future<void> addToFavorites(String gameId) async {
    if (!_favorites.contains(gameId)) {
      _favorites.add(gameId);
      await FavoritesUtils.addToFavorites(gameId);
      notifyListeners();
    }
  }

  /// Oyunu favorilerden çıkar
  Future<void> removeFromFavorites(String gameId) async {
    if (_favorites.contains(gameId)) {
      _favorites.remove(gameId);
      await FavoritesUtils.removeFromFavorites(gameId);
      notifyListeners();
    }
  }

  /// Oyun favori mi kontrol et
  bool isFavorite(String gameId) {
    return _favorites.contains(gameId);
  }

  /// Favori durumunu değiştir (toggle)
  Future<void> toggleFavorite(String gameId) async {
    if (isFavorite(gameId)) {
      await removeFromFavorites(gameId);
    } else {
      await addToFavorites(gameId);
    }
  }

  /// Tüm favorileri temizle
  Future<void> clearFavorites() async {
    _favorites.clear();
    await FavoritesUtils.clearFavorites();
    notifyListeners();
  }

  /// Favori sayısını al
  int get favoritesCount => _favorites.length;

  /// Favori var mı kontrol et
  bool get hasFavorites => _favorites.isNotEmpty;
}
