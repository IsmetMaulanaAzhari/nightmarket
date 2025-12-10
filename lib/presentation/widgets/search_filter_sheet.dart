import 'package:flutter/material.dart';
import 'package:nightmarket/core/constants/app_constants.dart';

class SearchFilterSheet extends StatefulWidget {
  final Function(String query, String category, String? condition, double? minPrice, double? maxPrice) onApplyFilters;

  const SearchFilterSheet({super.key, required this.onApplyFilters});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  String _selectedCategory = 'All';
  String? _selectedCondition;
  int _selectedPriceRangeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: theme.textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedCondition = null;
                        _selectedPriceRangeIndex = 0;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Section
                    Text(
                      'Category',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.categories.map((category) {
                        final isSelected = category == _selectedCategory;
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Condition Section
                    Text(
                      'Condition',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedCondition == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCondition = null;
                            });
                          },
                        ),
                        ...AppConstants.bookConditions.map((condition) {
                          final isSelected = condition == _selectedCondition;
                          return FilterChip(
                            label: Text(condition),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCondition = selected ? condition : null;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Price Range Section
                    Text(
                      'Price Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(
                        AppConstants.priceRanges.length,
                        (index) {
                          final range = AppConstants.priceRanges[index];
                          return RadioListTile<int>(
                            title: Text(range['label'] as String),
                            value: index,
                            groupValue: _selectedPriceRangeIndex,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriceRangeIndex = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // Apply Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final priceRange = AppConstants.priceRanges[_selectedPriceRangeIndex];
                    widget.onApplyFilters(
                      '',
                      _selectedCategory,
                      _selectedCondition,
                      priceRange['min'] as double,
                      priceRange['max'] as double,
                    );
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Apply Filters'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
