import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    //DUMMY_Data test
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return items.where((proItem) => proItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items
        .where(
          (prodItem) => prodItem.isFavorite,
        )
        .toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fecthAndSetProducts() async {
    final urllogin =
        'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(urllogin));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty || extractedData['error'] != null) {
        return;
      }
      final urlfavorites =
          'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(urlfavorites));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favoriteData == null
                ? false
                : favoriteData[prodId]['isFavorite'] ?? false,
            imageUrl: prodData['imageUrl']));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //then : đợi hàm post thực hiện xong thực hiện các funtion trong then
  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
      try {
        http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price
            }));
        _items[prodIndex] = newProduct;
      } catch (e) {
        rethrow;
      }
    } else {
      print('...........');
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}
