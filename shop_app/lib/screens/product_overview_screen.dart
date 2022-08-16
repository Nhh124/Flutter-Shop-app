import 'package:flutter/material.dart';

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
          )
        ],
      ),
      body: ProductsGrid(showFavoritesOnly: _showFavoritesOnly),
    );
  }
}
