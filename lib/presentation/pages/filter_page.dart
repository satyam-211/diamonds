// filter_page.dart
import 'package:diamonds/bloc/diamond/diamond_bloc.dart';
import 'package:diamonds/bloc/filter/filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _caratFromController = TextEditingController();
  final _caratToController = TextEditingController();

  // Selected filter values
  String? _selectedLab;
  String? _selectedShape;
  String? _selectedColor;
  String? _selectedClarity;

  // Filter options
  Map<String, List<String>> _filterOptions = {
    'labs': [],
    'shapes': [],
    'colors': [],
    'clarities': [],
  };

  @override
  void initState() {
    super.initState();
    context.read<DiamondBloc>().add(DiamondFilterOptionsRequested());
  }

  @override
  void dispose() {
    _caratFromController.dispose();
    _caratToController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      final double? caratFrom = _caratFromController.text.isNotEmpty
          ? double.tryParse(_caratFromController.text)
          : null;

      final double? caratTo = _caratToController.text.isNotEmpty
          ? double.tryParse(_caratToController.text)
          : null;

      // Update the filter state
      context.read<FilterBloc>().add(
        FilterUpdated(
          caratFrom: caratFrom,
          caratTo: caratTo,
          lab: _selectedLab,
          shape: _selectedShape,
          color: _selectedColor,
          clarity: _selectedClarity,
        ),
      );

      // Apply the filter to diamonds
      context.read<FilterBloc>().add(FilterApplied());

      // Filter the diamonds
      context.read<DiamondBloc>().add(
        DiamondFiltered(
          caratFrom: caratFrom,
          caratTo: caratTo,
          lab: _selectedLab,
          shape: _selectedShape,
          color: _selectedColor,
          clarity: _selectedClarity,
        ),
      );

      // Navigate to results page
      Navigator.pushNamed(context, '/results');
    }
  }

  void _resetFilters() {
    setState(() {
      _caratFromController.clear();
      _caratToController.clear();
      _selectedLab = null;
      _selectedShape = null;
      _selectedColor = null;
      _selectedClarity = null;
    });
    context.read<FilterBloc>().add(FilterReset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diamond Filter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<DiamondBloc, DiamondState>(
          listener: (context, diamondState) {
            if (diamondState is DiamondLoaded && diamondState.filterOptions != null) {
              setState(() {
                _filterOptions = diamondState.filterOptions!;
              });
            }
          },
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Carat Range
                      Text(
                        'Carat Range',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _caratFromController,
                              decoration: const InputDecoration(
                                labelText: 'From',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final number = double.tryParse(value);
                                  if (number == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (number < 0) {
                                    return 'Cannot be negative';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _caratToController,
                              decoration: const InputDecoration(
                                labelText: 'To',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final number = double.tryParse(value);
                                  if (number == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (number < 0) {
                                    return 'Cannot be negative';
                                  }

                                  if (_caratFromController.text.isNotEmpty) {
                                    final from = double.tryParse(_caratFromController.text);
                                    if (from != null && number < from) {
                                      return 'Must be >= From';
                                    }
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Lab Dropdown
                      Text(
                        'Lab',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedLab,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text('Select Lab'),
                        items: _filterOptions['labs']!.map((lab) {
                          return DropdownMenuItem<String>(
                            value: lab,
                            child: Text(lab),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLab = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Shape Dropdown
                      Text(
                        'Shape',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedShape,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text('Select Shape'),
                        items: _filterOptions['shapes']!.map((shape) {
                          return DropdownMenuItem<String>(
                            value: shape,
                            child: Text(shape),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedShape = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Color Dropdown
                      Text(
                        'Color',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedColor,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text('Select Color'),
                        items: _filterOptions['colors']!.map((color) {
                          return DropdownMenuItem<String>(
                            value: color,
                            child: Text(color),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedColor = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Clarity Dropdown
                      Text(
                        'Clarity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedClarity,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text('Select Clarity'),
                        items: _filterOptions['clarities']!.map((clarity) {
                          return DropdownMenuItem<String>(
                            value: clarity,
                            child: Text(clarity),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClarity = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _resetFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _applyFilters,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Search'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}