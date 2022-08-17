import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/app_drawer.dart';
import '/provider/cart.dart';
import '/screens/cart_screen.dart';
import '/widgets/badge.dart';

import '../widgets/product_grid.dart';

enum FillterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FillterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FillterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              })
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FillterOptions.Favorites,
                child: Text(
                  'Only Favorites',
                ),
              ),
              const PopupMenuItem(
                value: FillterOptions.All,
                child: Text(
                  'Show All',
                ),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(showFavoritesOnly: _showFavoritesOnly),
    );
  }
}
