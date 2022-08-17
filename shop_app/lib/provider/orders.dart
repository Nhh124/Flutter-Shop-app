// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import '/provider/cart.dart';

class OrderItem {
  final String id;
  final double amout;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amout,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  final List<OrderItem> _order = [];

  List<OrderItem> get orders {
    return [..._order];
  }

  void addOrder(List<CartItem> cartproduct, double total) {
    _order.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amout: total,
        products: cartproduct,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
