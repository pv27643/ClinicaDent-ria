import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final bool showActive;
  final ValueChanged<bool> onChanged;
  final Color primaryGold;

  const FilterChips({super.key, required this.showActive, required this.onChanged, required this.primaryGold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _filterChip(label: 'Ativos', selected: showActive, onTap: () => onChanged(true)),
        const SizedBox(width: 8),
        _filterChip(label: 'Concluídos', selected: !showActive, onTap: () => onChanged(false)),
      ],
    );
  }

  Widget _filterChip({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3EDE7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: selected ? primaryGold : Colors.black54)),
            if (selected) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: primaryGold.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Text('Ativo', style: TextStyle(fontSize: 12)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
