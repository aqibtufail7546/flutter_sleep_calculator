import 'package:flutter/material.dart';
import 'package:flutter_sleep_calculator/main.dart';
import 'package:flutter_sleep_calculator/utils/responsive_utils.dart';
import 'package:flutter_sleep_calculator/utils/sleep_calculator.dart';
import 'package:flutter_sleep_calculator/widgets/custom_time_picker.dart';
import 'package:flutter_sleep_calculator/widgets/time_result_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime? _selectedTime;
  List<DateTime> _calculatedTimes = [];
  bool _isCalculatingBedtimes = true;
  bool _showResults = false;

  late AnimationController _animationController;
  late AnimationController _floatingAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  void _calculateTimes() {
    if (_selectedTime == null) return;

    setState(() {
      if (_isCalculatingBedtimes) {
        _calculatedTimes = SleepCalculator.calculateBedtimes(_selectedTime!);
      } else {
        _calculatedTimes = SleepCalculator.calculateWakeUpTimes(_selectedTime!);
      }
      _showResults = true;
    });

    _animationController.forward(from: 0);
  }

  void _selectCurrentTime() {
    setState(() {
      _selectedTime = DateTime.now();
    });
    _calculateTimes();
  }

  void _resetCalculation() {
    setState(() {
      _showResults = false;
      _selectedTime = null;
      _calculatedTimes = [];
    });
    _animationController.reset();
  }

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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8FAFF))
                      .withOpacity(0.9),
                  (isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8FAFF))
                      .withOpacity(0.0),
                ],
              ),
            ),
            child: AppBar(
              title: FittedBox(
                child: Text(
                  'DreamTime',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      24,
                    ),
                    letterSpacing: -0.5,
                    foreground: Paint()
                      ..shader =
                          LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                          ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                          ),
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: responsivePadding.right / 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAppBarButton(
                        context,
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        widget.onThemeToggle,
                      ),
                      SizedBox(width: responsivePadding.right / 4),
                      _buildAppBarButton(
                        context,
                        Icons.info_rounded,
                        () => Navigator.pushNamed(context, '/about'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.secondary.withOpacity(0.05),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: ResponsiveUtils.getScreenHeight(context) * 0.02,
                    ),

                    // Animated Header Section
                    AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatingAnimation.value),
                          child: _buildHeaderSection(context),
                        );
                      },
                    ),

                    SizedBox(
                      height: ResponsiveUtils.getScreenHeight(context) * 0.05,
                    ),

                    // Mode Selection with enhanced design
                    if (!_showResults) ...[
                      _buildModeSelection(context),
                      SizedBox(
                        height: ResponsiveUtils.getScreenHeight(context) * 0.04,
                      ),
                      _buildTimePicker(context),
                      SizedBox(
                        height: ResponsiveUtils.getScreenHeight(context) * 0.04,
                      ),
                      _buildActionButtons(context),
                    ],

                    // Enhanced Results Section
                    if (_showResults) ...[
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _buildResultsSection(context),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = ResponsiveUtils.getResponsiveIconSize(context, 24);

    return Container(
      width: iconSize + 16,
      height: iconSize + 16,
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize * 0.8),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.15),
            colorScheme.secondary.withOpacity(0.1),
            colorScheme.tertiary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 24),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
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
            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.secondary.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 20),
            ),
            child: Icon(
              Icons.bedtime_rounded,
              size: ResponsiveUtils.getResponsiveIconSize(context, 64),
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          FittedBox(
            child: Text(
              'Sleep Better Tonight',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
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
            'Optimize your sleep cycles for maximum rest and energy',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          FittedBox(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '90-minute cycles • 15-min fall asleep time',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Column(
      children: [
        Text(
          'What would you like to calculate?',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: ResponsiveUtils.isSmallScreen(context)
              ? Column(
                  children: [
                    _buildModeButton(
                      context,
                      true,
                      'Sleep Times',
                      Icons.bedtime_rounded,
                      'When to sleep',
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 4),
                    _buildModeButton(
                      context,
                      false,
                      'Wake Times',
                      Icons.wb_sunny_rounded,
                      'When to wake',
                      isFullWidth: true,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildModeButton(
                        context,
                        true,
                        'Sleep Times',
                        Icons.bedtime_rounded,
                        'When to sleep',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildModeButton(
                        context,
                        false,
                        'Wake Times',
                        Icons.wb_sunny_rounded,
                        'When to wake',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    bool isBedtime,
    String title,
    IconData icon,
    String subtitle, {
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _isCalculatingBedtimes == isBedtime;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isCalculatingBedtimes = isBedtime;
              _selectedTime = null;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: isFullWidth ? double.infinity : null,
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 28),
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                FittedBox(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        12,
                      ),
                      color: isSelected
                          ? colorScheme.onPrimary.withOpacity(0.8)
                          : colorScheme.onSurface.withOpacity(0.6),
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

  Widget _buildTimePicker(BuildContext context) {
    return CustomTimePicker(
      selectedTime: _selectedTime,
      label: _isCalculatingBedtimes
          ? 'What time do you want to wake up?'
          : 'What time do you want to go to bed?',
      onTimeChanged: (DateTime time) {
        setState(() {
          _selectedTime = time;
        });
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _selectedTime != null ? _calculateTimes : null,
            icon: Icon(
              _isCalculatingBedtimes
                  ? Icons.bedtime_rounded
                  : Icons.wb_sunny_rounded,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            label: FittedBox(
              child: Text(
                _isCalculatingBedtimes
                    ? 'Calculate Sleep Times'
                    : 'Calculate Wake Times',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        if (!_isCalculatingBedtimes) ...[
          SizedBox(height: isSmallScreen ? 12 : 16),
          OutlinedButton.icon(
            onPressed: _selectCurrentTime,
            icon: Icon(
              Icons.access_time_rounded,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            label: FittedBox(
              child: Text(
                'Go to bed now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
              side: BorderSide(color: colorScheme.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer.withOpacity(0.3),
                colorScheme.secondaryContainer.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _isCalculatingBedtimes
                      ? Icons.bedtime_rounded
                      : Icons.wb_sunny_rounded,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 32),
                  color: colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              FittedBox(
                child: Text(
                  _isCalculatingBedtimes
                      ? 'Optimal Sleep Times'
                      : 'Perfect Wake Times',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      24,
                    ),
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                _isCalculatingBedtimes
                    ? 'To wake up refreshed at ${SleepCalculator.formatTime(_selectedTime!)}'
                    : 'If you sleep at ${SleepCalculator.formatTime(_selectedTime!)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: isSmallScreen ? 16 : 24),

        ...List.generate(_calculatedTimes.length, (index) {
          final time = _calculatedTimes[index];
          final cycles = SleepCalculator.getCycleCount(
            _isCalculatingBedtimes ? time : _selectedTime!,
            _isCalculatingBedtimes ? _selectedTime! : time,
            _isCalculatingBedtimes,
          );

          return Padding(
            padding: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
            child: TimeResultCard(
              time: time,
              cycles: cycles,
              index: index,
              animationDelay: Duration(milliseconds: index * 100),
            ),
          );
        }),

        SizedBox(height: isSmallScreen ? 24 : 32),

        OutlinedButton.icon(
          onPressed: _resetCalculation,
          icon: Icon(
            Icons.refresh_rounded,
            size: ResponsiveUtils.getResponsiveIconSize(context, 20),
          ),
          label: FittedBox(
            child: Text(
              'Calculate Again',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              ),
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
            side: BorderSide(color: colorScheme.primary, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
