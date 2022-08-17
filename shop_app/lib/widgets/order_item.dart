import 'package:flutter/material.dart';
import '/provider/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key, this.order}) : super(key: key);
  final ord.OrderItem? order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order?.amout}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order!.dateTime),
            ),
            trailing: IconButton(
                onPressed: () {}, icon: const Icon(Icons.expand_more)),
          )
        ],
      ),
    );
  }
}
