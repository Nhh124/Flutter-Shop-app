import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product.dart';

import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.id,
  }) : super(key: key);

  final String title;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
