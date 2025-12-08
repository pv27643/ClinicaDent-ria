import 'package:flutter/material.dart';

class DataHoraWidget extends StatelessWidget {
  final List<Map<String, String>> dateOptions;
  final List<Map<String, String>> timeSlots;
  final int selectedDateIndex;
  final String? selectedTime;
  final ValueChanged<int> onDateChanged;
  final ValueChanged<String?> onTimeChanged;

  const DataHoraWidget({
    Key? key,
    required this.dateOptions,
    required this.timeSlots,
    required this.selectedDateIndex,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardBg = Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '3. Data e Hora',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),

          // dias
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dateOptions.length,
              itemBuilder: (ctx, i) {
                final d = dateOptions[i];
                final selected = selectedDateIndex == i;
                final availColor = (i % 3 == 0)
                    ? const Color(0xFFDFF5E9)
                    : (i % 3 == 1)
                        ? const Color(0xFFFFF4E0)
                        : const Color(0xFFF3F3F3);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onDateChanged(i),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                d['weekday'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
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

          const SizedBox(height: 12),

          // legenda
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF5E9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Disponível'),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Limitado'),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Esgotado'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // times
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: timeSlots.map((ts) {
              final time = ts['time']!;
              final status = ts['status']!;
              final isSelected = selectedTime == time;
              Color bgColor;
              Color textColor = Colors.black87;
              Border? border;
              if (status == 'available') {
                bgColor = const Color(0xFFDFF5E9);
                textColor = Colors.green.shade800;
                border = isSelected
                    ? Border.all(
                        color: Colors.green.shade800,
                        width: 2,
                      )
                    : null;
              } else if (status == 'limited') {
                bgColor = const Color(0xFFFFF4E0);
                textColor = Colors.orange.shade800;
                border = isSelected
                    ? Border.all(
                        color: Colors.orange.shade800,
                        width: 2,
                      )
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
                onTap: status == 'soldout' ? null : () => onTimeChanged(time),
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
}