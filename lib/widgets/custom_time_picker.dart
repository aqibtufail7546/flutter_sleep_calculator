import 'package:flutter/material.dart';
import 'package:flutter_sleep_calculator/utils/responsive_utils.dart';

class CustomTimePicker extends StatelessWidget {
  final DateTime? selectedTime;
  final String label;
  final ValueChanged<DateTime> onTimeChanged;

  const CustomTimePicker({
    super.key,
    required this.selectedTime,
    required this.label,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime != null
          ? TimeOfDay.fromDateTime(selectedTime!)
          : TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      onTimeChanged(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = ResponsiveUtils.getScreenWidth(context) < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectTime(context),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              decoration: BoxDecoration(
                gradient: selectedTime != null
                    ? LinearGradient(
                        colors: [
                          colorScheme.primaryContainer.withOpacity(0.3),
                          colorScheme.secondaryContainer.withOpacity(0.2),
                        ],
                      )
                    : null,
                color: selectedTime == null
                    ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                    : null,
                border: Border.all(
                  color: selectedTime != null
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.3),
                  width: selectedTime != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: selectedTime != null
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            selectedTime != null
                                ? TimeOfDay.fromDateTime(
                                    selectedTime!,
                                  ).format(context)
                                : 'Select time',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: selectedTime != null
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                24,
                              ),
                            ),
                          ),
                        ),
                        if (selectedTime != null) ...[
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            'Tap to change',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                    decoration: BoxDecoration(
                      color: selectedTime != null
                          ? colorScheme.primary.withOpacity(0.1)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: selectedTime != null
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.6),
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
