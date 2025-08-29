import 'package:flutter/material.dart';
import 'package:flutter_sleep_calculator/utils/responsive_utils.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final responsivePadding = ResponsiveUtils.getResponsivePadding(context);
    final maxWidth = ResponsiveUtils.getMaxWidth(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F0F23)
          : const Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            title: FittedBox(
              child: Text(
                'Sleep Science',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              colorScheme.secondary.withOpacity(0.1),
              colorScheme.tertiary.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: responsivePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Header
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: _buildAnimatedHeader(context),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      height: ResponsiveUtils.getScreenHeight(context) * 0.04,
                    ),

                    // Info Cards with staggered animation
                    ...List.generate(4, (index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 600 + (index * 200)),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(30 * (1 - value), 0),
                            child: Opacity(
                              opacity: value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      ResponsiveUtils.getScreenHeight(context) *
                                      0.025,
                                ),
                                child: _buildInfoCards(context)[index],
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    SizedBox(
                      height: ResponsiveUtils.getScreenHeight(context) * 0.04,
                    ),

                    // Disclaimer
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Opacity(
                            opacity: value,
                            child: _buildDisclaimer(context),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
            colorScheme.tertiaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.secondary.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.psychology_rounded,
              size: ResponsiveUtils.getResponsiveIconSize(context, 64),
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          FittedBox(
            child: Text(
              'The Science of Sleep',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32),
                letterSpacing: -0.5,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'Understanding how sleep cycles work to optimize your rest',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoCards(BuildContext context) {
    return [
      _buildEnhancedInfoCard(
        context,
        Icons.schedule_rounded,
        '90-Minute Sleep Cycles',
        'Sleep occurs in repeating cycles of approximately 90 minutes. Each cycle includes light sleep, deep sleep, and REM (Rapid Eye Movement) phases. Waking at the end of a cycle helps you feel refreshed and alert.',
        const Color(0xFF6366F1),
      ),
      _buildEnhancedInfoCard(
        context,
        Icons.timer_rounded,
        'Sleep Onset Time',
        'Most people take 10-20 minutes to fall asleep. Our calculator uses 15 minutes as the average. This "sleep latency" is factored into bedtime calculations to ensure you get complete sleep cycles.',
        const Color(0xFF8B5CF6),
      ),
      _buildEnhancedInfoCard(
        context,
        Icons.energy_savings_leaf_rounded,
        'REM & Deep Sleep',
        'Deep sleep restores your body, while REM sleep consolidates memories and supports brain health. Both phases are crucial and occur in specific patterns throughout each 90-minute cycle.',
        const Color(0xFF06B6D4),
      ),
      _buildEnhancedInfoCard(
        context,
        Icons.favorite_rounded,
        'Optimal Sleep Duration',
        'Adults typically need 4-6 complete cycles (6-9 hours) nightly. Quality matters more than quantity - waking between cycles feels more refreshing than sleeping longer but waking mid-cycle.',
        const Color(0xFFEC4899),
      ),
    ];
  }

  Widget _buildEnhancedInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isSmallScreen
          ? _buildCompactInfoCard(
              context,
              theme,
              colorScheme,
              icon,
              title,
              description,
              accentColor,
            )
          : _buildRegularInfoCard(
              context,
              theme,
              colorScheme,
              icon,
              title,
              description,
              accentColor,
            ),
    );
  }

  Widget _buildCompactInfoCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.2),
                    accentColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRegularInfoCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.2),
                accentColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: ResponsiveUtils.getResponsiveIconSize(context, 28),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.errorContainer.withOpacity(0.1),
            colorScheme.tertiaryContainer.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: colorScheme.primary,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Text(
                  'Important Disclaimer',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'This calculator provides general guidance based on average sleep cycle research. Individual sleep patterns, chronotypes, and needs vary significantly. For persistent sleep issues, unusual sleep patterns, or sleep disorders, please consult with a healthcare professional or certified sleep specialist.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              height: 1.6,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  color: colorScheme.primary,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    'Pro tip: Track your sleep for a week to find your personal optimal cycle count!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        12,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
