import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/empty_search_state.dart';
import './widgets/exercise_filter_chips.dart';
import './widgets/exercise_filter_modal.dart';
import './widgets/exercise_grid_item.dart';
import './widgets/exercise_quick_actions.dart';
import './widgets/exercise_search_bar.dart';

class ExerciseLibrary extends StatefulWidget {
  const ExerciseLibrary({super.key});

  @override
  State<ExerciseLibrary> createState() => _ExerciseLibraryState();
}

class _ExerciseLibraryState extends State<ExerciseLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedCategory;
  Map<String, dynamic> _activeFilters = {
    'equipment': <String>[],
    'bodyAreas': <String>[],
    'difficulty': null,
    'duration': null,
  };

  List<String> _searchSuggestions = [
    'Shoulder stretches',
    'Core strengthening',
    'Hip mobility',
    'Foam rolling',
    'Back exercises',
    'Leg recovery',
  ];

  Set<String> _favoriteExercises = {};
  Map<String, dynamic>? _selectedExerciseForActions;
  bool _isRefreshing = false;

  // Mock exercise data
  final List<Map<String, dynamic>> _allExercises = [
    {
      "id": 1,
      "name": "Shoulder Blade Squeeze",
      "category": "mobility",
      "difficulty": "beginner",
      "duration": "2:30",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["none"],
      "targetAreas": ["Shoulders", "Upper Back"],
      "description":
          "Improve shoulder mobility and posture with controlled blade squeezes."
    },
    {
      "id": 2,
      "name": "Hip Flexor Stretch",
      "category": "stretching",
      "difficulty": "beginner",
      "duration": "3:00",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["yoga mat"],
      "targetAreas": ["Hips", "Lower Body"],
      "description":
          "Release tight hip flexors with this gentle stretching routine."
    },
    {
      "id": 3,
      "name": "Foam Roll IT Band",
      "category": "foam rolling",
      "difficulty": "intermediate",
      "duration": "4:15",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["foam roller"],
      "targetAreas": ["Legs", "IT Band"],
      "description":
          "Target IT band tension with controlled foam rolling technique."
    },
    {
      "id": 4,
      "name": "Resistance Band Pull-Apart",
      "category": "strength",
      "difficulty": "beginner",
      "duration": "2:45",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["resistance band"],
      "targetAreas": ["Shoulders", "Upper Back"],
      "description":
          "Strengthen posterior deltoids and improve shoulder stability."
    },
    {
      "id": 5,
      "name": "Cat-Cow Stretch",
      "category": "mobility",
      "difficulty": "beginner",
      "duration": "3:30",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["yoga mat"],
      "targetAreas": ["Back", "Core"],
      "description":
          "Improve spinal mobility with this flowing movement pattern."
    },
    {
      "id": 6,
      "name": "Glute Bridge",
      "category": "strength",
      "difficulty": "intermediate",
      "duration": "5:00",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["none"],
      "targetAreas": ["Glutes", "Core"],
      "description": "Activate glutes and strengthen posterior chain muscles."
    },
    {
      "id": 7,
      "name": "Thoracic Spine Rotation",
      "category": "mobility",
      "difficulty": "intermediate",
      "duration": "4:00",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["none"],
      "targetAreas": ["Back", "Core"],
      "description":
          "Improve thoracic spine mobility and reduce upper back stiffness."
    },
    {
      "id": 8,
      "name": "Calf Foam Roll",
      "category": "foam rolling",
      "difficulty": "beginner",
      "duration": "3:15",
      "thumbnail":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800",
      "equipment": ["foam roller"],
      "targetAreas": ["Legs", "Calves"],
      "description": "Release calf muscle tension with targeted foam rolling."
    },
  ];

  final List<String> _categories = [
    'mobility',
    'strength',
    'stretching',
    'foam rolling',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredExercises {
    var exercises = _allExercises.where((exercise) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = (exercise['name'] as String).toLowerCase();
        final category = (exercise['category'] as String).toLowerCase();
        final targetAreas = (exercise['targetAreas'] as List<dynamic>)
            .map((area) => area.toString().toLowerCase())
            .join(' ');

        if (!name.contains(query) &&
            !category.contains(query) &&
            !targetAreas.contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null) {
        if (exercise['category'] != _selectedCategory) {
          return false;
        }
      }

      // Equipment filter
      final equipmentFilter = _activeFilters['equipment'] as List<String>;
      if (equipmentFilter.isNotEmpty) {
        final exerciseEquipment = exercise['equipment'] as List<dynamic>;
        final hasMatchingEquipment = equipmentFilter.any((filter) =>
            exerciseEquipment.any((eq) =>
                eq.toString().toLowerCase().contains(filter.toLowerCase()) ||
                (filter.toLowerCase() == 'none' &&
                    eq.toString().toLowerCase() == 'none')));
        if (!hasMatchingEquipment) return false;
      }

      // Body areas filter
      final bodyAreasFilter = _activeFilters['bodyAreas'] as List<String>;
      if (bodyAreasFilter.isNotEmpty) {
        final exerciseAreas = exercise['targetAreas'] as List<dynamic>;
        final hasMatchingArea = bodyAreasFilter.any((filter) =>
            exerciseAreas.any((area) =>
                area.toString().toLowerCase().contains(filter.toLowerCase())));
        if (!hasMatchingArea) return false;
      }

      // Difficulty filter
      if (_activeFilters['difficulty'] != null) {
        if (exercise['difficulty'] !=
            _activeFilters['difficulty'].toString().toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();

    return exercises;
  }

  Map<String, int> get _categoryCounts {
    final counts = <String, int>{};
    for (final category in _categories) {
      counts[category] =
          _allExercises.where((ex) => ex['category'] == category).length;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            CustomTabBar(
              controller: _tabController,
              tabs: const [
                TabItem(
                    label: 'Check-in', icon: Icons.health_and_safety_outlined),
                TabItem(label: 'Recovery', icon: Icons.psychology_outlined),
                TabItem(label: 'Library', icon: Icons.fitness_center_outlined),
                TabItem(label: 'Workout', icon: Icons.play_circle_outline),
                TabItem(label: 'Progress', icon: Icons.analytics_outlined),
              ],
              onTap: _handleTabChange,
              dividerHeight: 1,
            ),
            // Search bar
            ExerciseSearchBar(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onVoiceSearch: _handleVoiceSearch,
              suggestions: _searchSuggestions,
            ),
            // Filter chips and filter button row
            Row(
              children: [
                Expanded(
                  child: ExerciseFilterChips(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    categoryCounts: _categoryCounts,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _hasActiveFilters
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _hasActiveFilters
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'tune',
                        color: _hasActiveFilters
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Exercise grid
            Expanded(
              child: _buildExerciseGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }

  Widget _buildExerciseGrid() {
    if (_isRefreshing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final exercises = _filteredExercises;

    if (exercises.isEmpty) {
      return EmptySearchState(
        searchQuery: _searchQuery,
        onClearSearch: () {
          setState(() {
            _searchQuery = '';
          });
        },
        onSuggestionTap: (suggestion) {
          setState(() {
            _searchQuery = suggestion;
          });
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(4.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 0.75,
            ),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              final exerciseId = exercise['id'].toString();

              return ExerciseGridItem(
                exercise: exercise,
                isFavorite: _favoriteExercises.contains(exerciseId),
                onTap: () => _handleExerciseTap(exercise),
                onLongPress: () => _showQuickActions(exercise),
              );
            },
          ),
          // Quick actions overlay
          if (_selectedExerciseForActions != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _dismissQuickActions,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: ExerciseQuickActions(
                        exercise: _selectedExerciseForActions!,
                        onAddToFavorites: () =>
                            _addToFavorites(_selectedExerciseForActions!),
                        onShare: () =>
                            _shareExercise(_selectedExerciseForActions!),
                        onAddToCustomPlan: () =>
                            _addToCustomPlan(_selectedExerciseForActions!),
                        onDismiss: _dismissQuickActions,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _hasActiveFilters {
    final equipment = _activeFilters['equipment'] as List<String>;
    final bodyAreas = _activeFilters['bodyAreas'] as List<String>;
    return equipment.isNotEmpty ||
        bodyAreas.isNotEmpty ||
        _activeFilters['difficulty'] != null ||
        _activeFilters['duration'] != null;
  }

  void _handleTabChange(int index) {
    final routes = [
      '/wellness-check-in-dashboard',
      '/ai-recovery-plan',
      '/exercise-library',
      '/guided-workout-player',
      '/progress-analytics-dashboard',
    ];

    if (index != 2) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _handleVoiceSearch() {
    // Voice search implementation would go here
    // For now, we'll show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseFilterModal(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleExerciseTap(Map<String, dynamic> exercise) {
    // Navigate to exercise detail view
    // For now, we'll show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${exercise['name']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> exercise) {
    setState(() {
      _selectedExerciseForActions = exercise;
    });
  }

  void _dismissQuickActions() {
    setState(() {
      _selectedExerciseForActions = null;
    });
  }

  void _addToFavorites(Map<String, dynamic> exercise) {
    final exerciseId = exercise['id'].toString();
    setState(() {
      if (_favoriteExercises.contains(exerciseId)) {
        _favoriteExercises.remove(exerciseId);
      } else {
        _favoriteExercises.add(exerciseId);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favoriteExercises.contains(exerciseId)
              ? 'Added to favorites'
              : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareExercise(Map<String, dynamic> exercise) {
    // Share exercise implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${exercise['name']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCustomPlan(Map<String, dynamic> exercise) {
    // Add to custom plan implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${exercise['name']} to custom plan'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
