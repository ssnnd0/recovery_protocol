import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onVoiceSearch;
  final List<String> suggestions;

  const ExerciseSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onVoiceSearch,
    this.suggestions = const [],
  });

  @override
  State<ExerciseSearchBar> createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
    setState(() {
      _showSuggestions = value.isNotEmpty && widget.suggestions.isNotEmpty;
    });
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    widget.onSearchChanged(suggestion);
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                    ),
                  if (widget.onVoiceSearch != null)
                    GestureDetector(
                      onTap: widget.onVoiceSearch,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ),
        if (_showSuggestions)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  widget.suggestions.length > 5 ? 5 : widget.suggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                final suggestion = widget.suggestions[index];
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () => _selectSuggestion(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
