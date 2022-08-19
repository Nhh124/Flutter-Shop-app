import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
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
  var _itInit = true;
  var _isLoading = false;
  @override
  void initState() {
    //Cach 1: dung future delayed sau đó chạy fecth
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fecthAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_itInit) {
      //Cach 2 Dung didChangeDependencies để call
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fecthAndSetProducts().then(
        (value) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _itInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavoritesOnly: _showFavoritesOnly),
    );
  }
}
