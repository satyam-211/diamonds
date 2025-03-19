import 'package:diamonds/presentation/pages/cart_page.dart';
import 'package:diamonds/presentation/pages/filter_page.dart';
import 'package:diamonds/presentation/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/diamond/diamond_bloc.dart';
import 'bloc/filter/filter_bloc.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/diamond_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repositories
    final diamondRepository = DiamondRepository();
    final cartRepository = CartRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<FilterBloc>(
          create: (context) => FilterBloc(),
        ),
        BlocProvider<DiamondBloc>(
          create: (context) => DiamondBloc(
            diamondRepository: diamondRepository,
          )..add(DiamondLoadRequested()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            cartRepository: cartRepository,
          )..add(CartStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Diamond Selection App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const FilterPage(),
          '/results': (context) => const ResultPage(),
          '/cart': (context) => const CartPage(),
        },
      ),
    );
  }
}
