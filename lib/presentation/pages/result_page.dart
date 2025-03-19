// result_page.dart
import 'package:diamonds/bloc/cart/cart_bloc.dart';
import 'package:diamonds/bloc/diamond/diamond_bloc.dart';
import 'package:diamonds/data/models/diamond.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diamond Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sorting controls
          _buildSortingControls(context),

          // Results count
          _buildResultsCount(),

          // Diamond list
          Expanded(
            child: _buildDiamondList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSortingControls(BuildContext context) {
    return BlocBuilder<DiamondBloc, DiamondState>(
      builder: (context, state) {
        if (state is DiamondLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildSortButton(
                  context,
                  'Price ↑',
                  SortOption.priceAsc,
                  state.currentSortOption == SortOption.priceAsc,
                ),
                const SizedBox(width: 4),
                _buildSortButton(
                  context,
                  'Price ↓',
                  SortOption.priceDesc,
                  state.currentSortOption == SortOption.priceDesc,
                ),
                const SizedBox(width: 4),
                _buildSortButton(
                  context,
                  'Carat ↑',
                  SortOption.caratAsc,
                  state.currentSortOption == SortOption.caratAsc,
                ),
                const SizedBox(width: 4),
                _buildSortButton(
                  context,
                  'Carat ↓',
                  SortOption.caratDesc,
                  state.currentSortOption == SortOption.caratDesc,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSortButton(
      BuildContext context,
      String label,
      SortOption sortOption,
      bool isSelected
      ) {
    return ElevatedButton(
      onPressed: () {
        context.read<DiamondBloc>().add(DiamondSorted(sortOption));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 36),
      ),
      child: Text(label),
    );
  }

  Widget _buildResultsCount() {
    return BlocBuilder<DiamondBloc, DiamondState>(
      builder: (context, state) {
        if (state is DiamondLoaded) {
          final count = state.filteredDiamonds.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Found $count diamonds',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDiamondList() {
    return BlocBuilder<DiamondBloc, DiamondState>(
      builder: (context, state) {
        if (state is DiamondLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DiamondLoaded) {
          final diamonds = state.filteredDiamonds;
          if (diamonds.isEmpty) {
            return const Center(
              child: Text(
                'No diamonds match your filters',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: diamonds.length,
            itemBuilder: (context, index) {
              final diamond = diamonds[index];
              return _buildDiamondCard(context, diamond);
            },
          );
        } else if (state is DiamondError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return const Center(child: Text('Select filters to see results'));
      },
    );
  }

  Widget _buildDiamondCard(BuildContext context, Diamond diamond) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        bool isInCart = false;

        if (cartState is CartLoaded) {
          isInCart = cartState.items.any((item) => item.lotId == diamond.lotId);
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lot ID: ${diamond.lotId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildCartButton(context, diamond, isInCart),
                  ],
                ),
                const SizedBox(height: 8),

                // Primary details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailChip('${diamond.carat} CT', Colors.blue.shade100),
                    _buildDetailChip(diamond.shape, Colors.green.shade100),
                    _buildDetailChip(diamond.color, Colors.amber.shade100),
                    _buildDetailChip(diamond.clarity, Colors.purple.shade100),
                  ],
                ),

                const SizedBox(height: 12),

                // Secondary details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow('Cut', diamond.cut),
                    ),
                    Expanded(
                      child: _buildDetailRow('Polish', diamond.polish),
                    ),
                    Expanded(
                      child: _buildDetailRow('Symmetry', diamond.symmetry),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow('Lab', diamond.lab),
                    ),
                    Expanded(
                      child: _buildDetailRow('Fluorescence', diamond.fluorescence),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Price details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Per Carat: '),
                            Text(
                              '\$${diamond.perCaratRate.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Discount: '),
                            Text(
                              '${diamond.discount.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: diamond.discount > 0 ? Colors.green : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '\$${diamond.finalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),

                if (diamond.keyToSymbol.isNotEmpty || diamond.labComment.isNotEmpty)
                  const Divider(height: 24),

                // Comments and symbols
                if (diamond.keyToSymbol.isNotEmpty)
                  _buildDetailRow('Symbols', diamond.keyToSymbol),
                if (diamond.labComment.isNotEmpty)
                  _buildDetailRow('Lab Comment', diamond.labComment),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context, Diamond diamond, bool isInCart) {
    return ElevatedButton.icon(
      onPressed: () {
        if (isInCart) {
          context.read<CartBloc>().add(CartItemRemoved(diamond.lotId));
        } else {
          context.read<CartBloc>().add(CartItemAdded(diamond));
        }
      },
      icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
      label: Text(isInCart ? 'Remove' : 'Add to Cart'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isInCart ? Colors.red : Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}