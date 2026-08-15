import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable Sliver header featuring a gradient background, title, icon, total badge, and search bar.
class SliverGradientSearchHeader extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final int totalCount;
  final String countLabel;
  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onClearSearch;

  const SliverGradientSearchHeader({
    super.key,
    required this.gradient,
    required this.icon,
    required this.title,
    required this.totalCount,
    this.countLabel = 'total',
    required this.searchController,
    required this.searchHint,
    required this.onSearchChanged,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearchText = searchController.text.isNotEmpty;

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$totalCount $countLabel',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: const TextStyle(
                        color: AppTheme.textHint,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppTheme.textHint,
                        size: 22,
                      ),
                      suffixIcon: hasSearchText
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppTheme.textHint,
                                size: 20,
                              ),
                              onPressed: () {
                                searchController.clear();
                                onSearchChanged('');
                                onClearSearch?.call();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
