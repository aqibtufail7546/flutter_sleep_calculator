import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sleep_calculator/main.dart';
import 'package:flutter_sleep_calculator/utils/responsive_utils.dart';
import 'package:flutter_sleep_calculator/utils/sleep_calculator.dart';

class TimeResultCard extends StatefulWidget {
  final DateTime time;
  final int cycles;
  final int index;
  final Duration animationDelay;

  const TimeResultCard({
    super.key,
    required this.time,
    required this.cycles,
    required this.index,
    this.animationDelay = Duration.zero,
  });

  @override
  State<TimeResultCard> createState() => _TimeResultCardState();
}

class _TimeResultCardState extends State<TimeResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRecommended = widget.index == 2; // Highlight middle option
    final isDark = theme.brightness == Brightness.dark;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
              decoration: BoxDecoration(
                gradient: isRecommended
                    ? LinearGradient(
                        colors: [
                          colorScheme.primary.withOpacity(0.15),
                          colorScheme.secondary.withOpacity(0.1),
                        ],
                      )
                    : null,
                color: !isRecommended
                    ? colorScheme.surface.withOpacity(isDark ? 0.5 : 0.8)
                    : null,
                borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                border: Border.all(
                  color: isRecommended
                      ? colorScheme.primary.withOpacity(0.3)
                      : colorScheme.outline.withOpacity(0.1),
                  width: isRecommended ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isRecommended
                        ? colorScheme.primary.withOpacity(0.15)
                        : colorScheme.shadow.withOpacity(0.05),
                    blurRadius: isRecommended ? 12 : 8,
                    offset: Offset(0, isRecommended ? 6 : 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Add haptic feedback or copy to clipboard functionality
                  },
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
                    child: isSmallScreen
                        ? _buildCompactLayout(
                            context,
                            theme,
                            colorScheme,
                            isRecommended,
                            isDark,
                          )
                        : _buildRegularLayout(
                            context,
                            theme,
                            colorScheme,
                            isRecommended,
                            isDark,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isRecommended,
    bool isDark,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Animated Icon Container
            _buildAnimatedIcon(context, colorScheme, isRecommended, true),

            const SizedBox(width: 12),

            // Time and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            SleepCalculator.formatTime(widget.time),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isRecommended
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                20,
                              ),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        _buildOptimalBadge(context, theme, colorScheme, true),
                      ],
                    ],
                  ),
                  const SizedBox(width: 4),
                  _buildCycleInfo(context, theme, colorScheme, true),
                ],
              ),
            ),

            // Quality Indicator
            _buildQualityIndicator(context, theme, colorScheme, true),
          ],
        ),
        if (isRecommended) ...[
          const SizedBox(height: 8),
          Text(
            _getRecommendationText(widget.cycles),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildRegularLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isRecommended,
    bool isDark,
  ) {
    return Row(
      children: [
        // Animated Icon Container
        _buildAnimatedIcon(context, colorScheme, isRecommended, false),

        const SizedBox(width: 16),

        // Time and Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        SleepCalculator.formatTime(widget.time),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isRecommended
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            24,
                          ),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 12),
                    _buildOptimalBadge(context, theme, colorScheme, false),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              _buildCycleInfo(context, theme, colorScheme, false),
              if (isRecommended) ...[
                const SizedBox(height: 8),
                Text(
                  _getRecommendationText(widget.cycles),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Quality Indicator
        _buildQualityIndicator(context, theme, colorScheme, false),
      ],
    );
  }

  Widget _buildAnimatedIcon(
    BuildContext context,
    ColorScheme colorScheme,
    bool isRecommended,
    bool isCompact,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (widget.index * 100)),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * math.pi * 2,
          child: Container(
            width: isCompact ? 40 : 50,
            height: isCompact ? 40 : 50,
            decoration: BoxDecoration(
              gradient: isRecommended
                  ? LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    )
                  : LinearGradient(
                      colors: [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerHigh,
                      ],
                    ),
              borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
              boxShadow: isRecommended
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getIconForCycles(widget.cycles),
              color: isRecommended
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                isCompact ? 20 : 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptimalBadge(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isCompact,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
      ),
      child: Text(
        'OPTIMAL',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveUtils.getResponsiveFontSize(
            context,
            isCompact ? 8 : 10,
          ),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCycleInfo(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isCompact,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Icons.refresh_rounded,
          size: ResponsiveUtils.getResponsiveIconSize(
            context,
            isCompact ? 14 : 16,
          ),
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.cycles} sleep cycles',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              isCompact ? 12 : 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.schedule_rounded,
          size: ResponsiveUtils.getResponsiveIconSize(
            context,
            isCompact ? 14 : 16,
          ),
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          _getSleepDuration(widget.cycles),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              isCompact ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualityIndicator(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isCompact,
  ) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 6 : 8),
      decoration: BoxDecoration(
        color: _getQualityColor(widget.cycles, colorScheme).withOpacity(0.1),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        border: Border.all(
          color: _getQualityColor(widget.cycles, colorScheme).withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getQualityIcon(widget.cycles),
            color: _getQualityColor(widget.cycles, colorScheme),
            size: ResponsiveUtils.getResponsiveIconSize(
              context,
              isCompact ? 16 : 20,
            ),
          ),
          SizedBox(height: isCompact ? 2 : 4),
          Text(
            _getQualityText(widget.cycles),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _getQualityColor(widget.cycles, colorScheme),
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                isCompact ? 9 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCycles(int cycles) {
    switch (cycles) {
      case 4:
        return Icons.battery_2_bar_rounded;
      case 5:
        return Icons.battery_3_bar_rounded;
      case 6:
        return Icons.battery_full_rounded;
      case 7:
        return Icons.battery_charging_full_rounded;
      case 8:
        return Icons.energy_savings_leaf_rounded;
      case 9:
        return Icons.spa_rounded;
      default:
        return Icons.bedtime_rounded;
    }
  }

  String _getSleepDuration(int cycles) {
    final hours = (cycles * 1.5).floor();
    final minutes = ((cycles * 1.5 - hours) * 60).round();
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  String _getRecommendationText(int cycles) {
    if (cycles < 5) return 'Minimal rest - consider sleeping earlier';
    if (cycles == 5) return 'Good balance of rest and productivity';
    if (cycles == 6) return 'Ideal sleep duration for most adults';
    if (cycles == 7) return 'Extended rest - great for recovery';
    return 'Maximum rest - perfect for weekends';
  }

  Color _getQualityColor(int cycles, ColorScheme colorScheme) {
    if (cycles < 5) return colorScheme.error;
    if (cycles == 5 || cycles == 6) return colorScheme.primary;
    if (cycles == 7) return colorScheme.tertiary;
    return colorScheme.secondary;
  }

  IconData _getQualityIcon(int cycles) {
    if (cycles < 5) return Icons.warning_rounded;
    if (cycles == 5 || cycles == 6) return Icons.check_circle_rounded;
    if (cycles == 7) return Icons.star_rounded;
    return Icons.favorite_rounded;
  }

  String _getQualityText(int cycles) {
    if (cycles < 5) return 'LOW';
    if (cycles == 5 || cycles == 6) return 'GOOD';
    if (cycles == 7) return 'GREAT';
    return 'MAX';
  }
}
