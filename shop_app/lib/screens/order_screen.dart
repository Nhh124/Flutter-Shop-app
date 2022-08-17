import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '/provider/orders.dart' show Order;
import '/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => OrderItem(
            order: orderData.orders[index],
          ),
        ),
      ),
    );
  }
}
