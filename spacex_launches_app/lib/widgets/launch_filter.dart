import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/launches_provider.dart';

class LaunchFilter extends StatelessWidget {
  const LaunchFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LaunchesProvider>(context);
    final currentFilter = provider.currentFilter;
    final selectedYear = provider.selectedYear;
    final years = provider.availableYears;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'Filter Launches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _buildFilterChip(
                context,
                'All',
                currentFilter == LaunchFilter.all,
                () => provider.setFilter(LaunchFilter.all),
              ),
              _buildFilterChip(
                context,
                'Upcoming',
                currentFilter == LaunchFilter.upcoming,
                () => provider.setFilter(LaunchFilter.upcoming),
              ),
              _buildFilterChip(
                context,
                'Past',
                currentFilter == LaunchFilter.past,
                () => provider.setFilter(LaunchFilter.past),
              ),
              _buildFilterChip(
                context,
                'Successful',
                currentFilter == LaunchFilter.successful,
                () => provider.setFilter(LaunchFilter.successful),
              ),
              _buildFilterChip(
                context,
                'Failed',
                currentFilter == LaunchFilter.failed,
                () => provider.setFilter(LaunchFilter.failed),
              ),
              const SizedBox(width: 8),
              if (years.isNotEmpty) ...[
                const VerticalDivider(
                  width: 24,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                ),
                DropdownButton<int?>(
                  value: selectedYear,
                  hint: const Text('Year'),
                  onChanged: (int? year) {
                    provider.setYearFilter(year);
                  },
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Years'),
                    ),
                    ...years.map((year) {
                      return DropdownMenuItem<int?>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                  ],
                ),
              ],
              if (currentFilter != LaunchFilter.all || selectedYear != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => provider.clearFilters(),
                  tooltip: 'Clear filters',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }
} 