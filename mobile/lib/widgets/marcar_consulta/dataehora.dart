// widgets/data_hora_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataHoraWidget extends StatefulWidget {
  final List<Map<String, String>> timeSlots;
  final int selectedDateIndex;
  final String? selectedTime;
  final ValueChanged<int> onDateChanged;
  final ValueChanged<String?> onTimeChanged;
  final bool initialShowCalendar;

  const DataHoraWidget({
    Key? key,
    required this.timeSlots,
    required this.selectedDateIndex,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
    this.initialShowCalendar = false,
  }) : super(key: key);

  @override
  State<DataHoraWidget> createState() => _DataHoraWidgetState();
}

class _DataHoraWidgetState extends State<DataHoraWidget> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  late int _selectedDateIndex;
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
    _selectedDateIndex = widget.selectedDateIndex;
    _selectedDate = DateTime.now().add(Duration(days: _selectedDateIndex));
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _showCalendar = widget.initialShowCalendar;
  }

  @override
  void didUpdateWidget(DataHoraWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDateIndex != oldWidget.selectedDateIndex) {
      _selectedDateIndex = widget.selectedDateIndex;
      _selectedDate = DateTime.now().add(Duration(days: _selectedDateIndex));
      _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    }
  }

  List<DateTime?> _generateCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startWeekday = firstDay.weekday;

    List<DateTime?> days = [];
    for (int i = 1; i < startWeekday; i++) {
      days.add(null);
    }
    for (int i = 0; i < lastDay.day; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }
    return days;
  }

  List<Map<String, String>> _generateNextSevenDays() {
    List<Map<String, String>> days = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      days.add({
        'weekday': DateFormat.E('pt_PT').format(date),
        'day': date.day.toString(),
        'month': DateFormat.MMM('pt_PT').format(date),
        'fullDate': date.toIso8601String(),
      });
    }
    return days;
  }

  List<Map<String, String>> _generateMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    List<Map<String, String>> days = [];
    for (int i = 0; i < last.day; i++) {
      final date = first.add(Duration(days: i));
      days.add({
        'weekday': DateFormat.E('pt_PT').format(date),
        'day': date.day.toString(),
        'month': DateFormat.MMM('pt_PT').format(date),
        'fullDate': date.toIso8601String(),
      });
    }
    return days;
  }

  Color _getDayAvailabilityColor(int index) {
    if (index % 3 == 0) return const Color(0xFFDFF5E9);
    if (index % 3 == 1) return const Color(0xFFFFF4E0);
    return const Color(0xFFF3F3F3);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = Colors.white;
    // Generate the horizontal list from the current month so the widget
    // displays a full-month view like a normal calendar.
    final dateOptions = _generateMonthDays(_currentMonth);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          
          // Título com botão de calendário
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '3. Data e Hora',
                style: TextStyle(color: Colors.black54),
              ),
              IconButton(
                icon: Icon(
                  _showCalendar ? Icons.view_list : Icons.calendar_month,
                  color: const Color(0xFFD7B77D),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _showCalendar = !_showCalendar;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Alternar entre lista horizontal e calendário
          if (!_showCalendar) ...[

            // LISTA HORIZONTAL DE DIAS (original)
            SizedBox(
              height: 92,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dateOptions.length,
                itemBuilder: (ctx, i) {
                  final d = dateOptions[i];
                  final dateFromOption = DateTime.parse(d['fullDate']!);
                  final selected = dateFromOption.day == _selectedDate.day &&
                      dateFromOption.month == _selectedDate.month &&
                      dateFromOption.year == _selectedDate.year;
                  final availColor = _getDayAvailabilityColor(dateFromOption.day);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = dateFromOption;
                          _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
                          final now = DateTime.now();
                          final diff = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
                              .difference(DateTime(now.year, now.month, now.day))
                              .inDays;
                          if (diff >= 0 && diff <= 365) {
                            _selectedDateIndex = diff;
                            widget.onDateChanged(_selectedDateIndex);
                          } else {
                            // if out of range, just update selection visually
                            _selectedDateIndex = -1;
                          }
                        });
                      },
                      child: Container(
                        width: 72,
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFF3EDE7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? const Color(0xFFD7B77D) : const Color(0xFFF0ECE8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              d['weekday'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: availColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                d['day'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            // CALENDÁRIO COMPLETO
            _buildCalendar(),
          ],

          const SizedBox(height: 12),

          // LEGENDA
          Row(
            children: [
              _buildLegendItem(const Color(0xFFDFF5E9), 'Disponível'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFFFFF4E0), 'Limitado'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFFF3F3F3), 'Esgotado'),
            ],
          ),

          const SizedBox(height: 12),

          // HORÁRIOS
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.timeSlots.map((ts) {
              final time = ts['time']!;
              final status = ts['status']!;
              final isSelected = widget.selectedTime == time;
              Color bgColor;
              Color textColor = Colors.black87;
              Border? border;

              if (status == 'available') {
                bgColor = const Color(0xFFDFF5E9);
                textColor = Colors.green.shade800;
                border = isSelected
                    ? Border.all(color: Colors.green.shade800, width: 2)
                    : null;
              } else if (status == 'limited') {
                bgColor = const Color(0xFFFFF4E0);
                textColor = Colors.orange.shade800;
                border = isSelected
                    ? Border.all(color: Colors.orange.shade800, width: 2)
                    : null;
              } else {
                bgColor = const Color(0xFFF3F3F3);
                textColor = Colors.black54;
              }

              final displayBg = isSelected ? Colors.white : bgColor;
              final displayTextColor = isSelected
                  ? (status == 'available'
                      ? Colors.green.shade800
                      : (status == 'limited' ? Colors.orange.shade800 : textColor))
                  : textColor;

              return GestureDetector(
                onTap: status == 'soldout' ? null : () => widget.onTimeChanged(time),
                child: Container(
                  width: 92,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: displayBg,
                    borderRadius: BorderRadius.circular(12),
                    border: border ?? Border.all(color: Colors.transparent),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        color: displayTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget _buildCalendar() {
    final days = _generateCalendarDays(_currentMonth);
    final monthName = DateFormat.yMMMM('pt_PT').format(_currentMonth);

    return Column(
      children: [

        // Header navegação
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFFD7B77D)),
              onPressed: _previousMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Text(
              monthName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFFD7B77D)),
              onPressed: _nextMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Dias da semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom']
              .map((day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),

        // Grid calendário
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];

            if (date == null) return const SizedBox();

            final isSelected = date.day == _selectedDate.day &&
                date.month == _selectedDate.month &&
                date.year == _selectedDate.year;

            final isToday = date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year;

            final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
            final availColor = _getDayAvailabilityColor(date.day);

            return GestureDetector(
              onTap: isPast
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = date;
                          final now = DateTime.now();
                          final diff = DateTime(date.year, date.month, date.day)
                              .difference(DateTime(now.year, now.month, now.day))
                              .inDays;
                          if (diff >= 0 && diff <= 365) {
                            // if within a reasonable range, update index if possible
                            _selectedDateIndex = diff;
                            widget.onDateChanged(_selectedDateIndex);
                          }
                        });
                      },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF3EDE7) : availColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD7B77D)
                        : isToday
                            ? const Color(0xFFD7B77D).withOpacity(0.5)
                            : Colors.transparent,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isPast
                          ? Colors.black26
                          : isSelected
                              ? const Color(0xFFD7B77D)
                              : Colors.black87,
                      fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}