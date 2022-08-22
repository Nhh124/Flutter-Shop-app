import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/auth.dart';
import '/screens/product_overview_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/edit_product.dart';
import '/screens/user_products_screen.dart';
import '/screens/order_screen.dart';
import 'helpers/custom_route.dart';
import 'provider/orders.dart';
import 'provider/cart.dart';
import 'screens/cart_screen.dart';
import 'provider/products_provider.dart';
import 'screens/product_detail_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', [], ''),
            update: (context, auth, previousItem) => Products(
              auth.token,
              previousItem == null ? [] : previousItem.items,
              auth.userId,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order('', [], ''),
            update: (context, auth, previousOrders) => Order(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
              auth.userId,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }),
                textTheme: Typography.blackHelsinki,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple,
                ).copyWith(secondary: Colors.deepOrange),
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? const ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, authsnapshot) =>
                          authsnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                UserProductsScreen.routeName: ((context) =>
                    const UserProductsScreen()),
                EditProductScreen.routeName: ((context) =>
                    const EditProductScreen()),
              },
            );
          },
        ));
  }
}
