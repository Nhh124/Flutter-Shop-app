import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '/provider/orders.dart' show Order;
import '/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _orderFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Order>(context, listen: true).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
          future: _orderFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return Consumer<Order>(
                  builder: (context, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) => OrderItem(
                        order: orderData.orders[index],
                      ),
                    );
                  },
                );
              }
            }
          }),
        ),
      ),
    );
  }
}
