import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';

class DogsPage extends StatefulWidget {
  const DogsPage({super.key});

  @override
  State<DogsPage> createState() => _DogsPageState();
}

class _DogsPageState extends State<DogsPage> {
  static const _katipunanBarangays = [
    'All Barangays',
    'Uno (Poblacion)',
    'Dos (Poblacion)',
    'San Antonio',
    'Matam',
    'Matingao',
    'Sitio Tuburan',
    'Basagan',
    'Pangian',
  ];

  @override
  void initState() {
    super.initState();
    context.read<DogsBloc>().add(const FetchDogsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppDimensions.spacing20),
            BlocBuilder<DogsBloc, DogsState>(
              builder: (context, state) {
                final total = state is DogsLoaded ? state.dogs.length : 0;
                final vaccinated = state is DogsLoaded
                    ? state.dogs.where((d) => d.isVaccinated).length
                    : 0;
                final unvaccinated = total - vaccinated;

                return _buildMetricCards(
                  context,
                  total: total,
                  vaccinated: vaccinated,
                  unvaccinated: unvaccinated,
                  isDark: isDark,
                );
              },
            ),
            const SizedBox(height: AppDimensions.spacing20),
            _buildFilterBar(context, isDark),
            const SizedBox(height: AppDimensions.spacing16),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: BlocBuilder<DogsBloc, DogsState>(
                  builder: (context, state) {
                    if (state is DogsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is DogsError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is DogsLoaded) {
                      if (state.filteredDogs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No dog records found matching criteria.',
                          ),
                        );
                      }
                      return _buildDogsTable(
                        context,
                        state.filteredDogs,
                        isDark,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dogs', style: Theme.of(context).textTheme.headlineMedium),
            Text(
              'Total Dogs Registered',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing20,
              vertical: AppDimensions.spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Register Dog'),
        ),
      ],
    );
  }

  Widget _buildMetricCards(
    BuildContext context, {
    required int total,
    required int vaccinated,
    required int unvaccinated,
    required bool isDark,
  }) {
    final coverageRate = total > 0
        ? ((vaccinated / total) * 100).toStringAsFixed(1)
        : '0.0';

    return Row(
      children: [
        _MetricCard(
          title: 'Total Registered',
          value: '$total',
          subtitle: 'Active dog profiles',
          icon: Icons.pets,
          color: AppColors.primary,
          isDark: isDark,
        ),
        const SizedBox(width: AppDimensions.spacing16),
        _MetricCard(
          title: 'Vaccinated',
          value: '$vaccinated',
          subtitle: 'Up-to-date Rabies protection',
          icon: Icons.verified_outlined,
          color: Colors.green,
          isDark: isDark,
        ),
        const SizedBox(width: AppDimensions.spacing16),
        _MetricCard(
          title: 'Unvaccinated / Due',
          value: '$unvaccinated',
          subtitle: 'Requires vaccination drive',
          icon: Icons.warning_amber_rounded,
          color: Colors.orange,
          isDark: isDark,
        ),
        const SizedBox(width: AppDimensions.spacing16),
        _MetricCard(
          title: 'Vaccination Coverage',
          value: '$coverageRate%',
          subtitle: 'LGU Target: 80.0%',
          icon: Icons.pie_chart_outline_rounded,
          color: double.parse(coverageRate) >= 80.0
              ? Colors.teal
              : Colors.deepOrange,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 42,
            child: TextField(
              onChanged: (val) {
                context.read<DogsBloc>().add(SearchDogsQueryChanged(val));
              },
              decoration: InputDecoration(
                hintText:
                    'Search by dog name, breed, registration ID, or owner...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacing16),
        SizedBox(
          width: 200,
          height: 42,
          child: DropdownButtonFormField<String>(
            value: 'All Barangays',
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),
            items: _katipunanBarangays
                .map(
                  (b) => DropdownMenuItem(
                    value: b,
                    child: Text(b, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (val) {
              final selected = (val == 'All Barangays') ? null : val;
              context.read<DogsBloc>().add(
                FilterDogsByBarangayChanged(selected),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDogsTable(BuildContext context, List<Dog> dogs, bool isDark) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Registration ID')),
            DataColumn(label: Text('Dog Name')),
            DataColumn(label: Text('Breed & Color')),
            DataColumn(label: Text('Owner Info')),
            DataColumn(label: Text('Barangay')),
            DataColumn(label: Text('Rabies Tag')),
            DataColumn(label: Text('Actions')),
          ],
          rows: dogs.map((dog) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    dog.id,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryContainer,
                        child: const Icon(
                          Icons.pets,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(dog.name),
                    ],
                  ),
                ),
                DataCell(Text('${dog.breed} (${dog.color})')),
                DataCell(Text('${dog.ownerName}\n${dog.ownerContact}')),
                DataCell(Text(dog.barangay)),
                DataCell(
                  Chip(
                    label: Text(
                      dog.isVaccinated ? 'Vaccinated' : 'Unvaccinated',
                      style: TextStyle(
                        fontSize: 11,
                        color: dog.isVaccinated
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                      ),
                    ),
                    backgroundColor: dog.isVaccinated
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'View Health Records',
                        icon: const Icon(
                          Icons.medical_information_outlined,
                          size: 18,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.error,
                        ),
                        onPressed: () {
                          context.read<DogsBloc>().add(
                            DeleteDogRequested(dog.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
