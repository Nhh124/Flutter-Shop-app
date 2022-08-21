// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
  List<OrderItem> _order = [];

  Order(this.authToken, this._order);

  List<OrderItem> get orders {
    return [..._order];
  }

  final String authToken;

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extracedData = json.decode(response.body) as Map<String, dynamic>;
    if (extracedData == null) {
      return;
    }
    extracedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amout: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      },
    );
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproduct, double total) async {
    final url =
        'https://flutter-shop-app-48645-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken';
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartproduct
                .map(
                  (cprod) => {
                    'id': cprod.id,
                    'title': cprod.title,
                    'quantity': cprod.quantity,
                    'price': cprod.price,
                  },
                )
                .toList(),
          },
        ),
      );
      _order.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amout: total,
          products: cartproduct,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
