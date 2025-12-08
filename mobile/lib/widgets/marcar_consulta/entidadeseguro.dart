import 'package:flutter/material.dart';

class EntidadeSeguro extends StatelessWidget {
  final String? selectedInsurance;
  final ValueChanged<String> onInsuranceSelected;
  final Color cardBg;

  const EntidadeSeguro({
    super.key,
    required this.selectedInsurance,
    required this.onInsuranceSelected,
    required this.cardBg,
  });

  Widget _insuranceButton(BuildContext context, String label, IconData icon) {
    final selected = selectedInsurance == label;
    final double availableWidth = MediaQuery.of(context).size.width;
    final double itemWidth = (availableWidth - 32 - 12) / 2;
    return GestureDetector(
      onTap: () => onInsuranceSelected(label),
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF6F6F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFD7B77D) : const Color(0xFFF0ECE8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            '4. Entidade/Seguro',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _insuranceButton(context, 'ADSE', Icons.shield_outlined),
              _insuranceButton(context, 'Multicare', Icons.health_and_safety_outlined),
              _insuranceButton(context, 'Particular', Icons.credit_card_outlined),
              _insuranceButton(context, 'Médis', Icons.local_hospital_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
