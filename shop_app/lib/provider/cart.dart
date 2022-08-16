import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

/* {...} là toán tử spread
  vd: 
  var initial = [0, 1];  
  var numbers1 = [...initial, 5, 7]; 
*/
class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmout {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  /*
    containsKey trả về kết quả trong mảng (true, false)
    putIfAbsent nếu key chưa tồn tại thì thêm mới, đã tồn tại thì update lại để truyền vào
   */
  void addItem(String productid, double price, String title) {
    if (_items.containsKey(productid)) {
      //change quantity
      _items.update(
        productid,
        (exitstingCartItem) => CartItem(
          id: exitstingCartItem.id,
          title: exitstingCartItem.title,
          quantity: exitstingCartItem.quantity + 1,
          price: exitstingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productid,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          //quantity là 1 vì khi thêm mới thì số lượng là 1,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }
}
