import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const ProductsGrid(),
    );
  }
}
