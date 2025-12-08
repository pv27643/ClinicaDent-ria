import 'package:flutter/material.dart';

class MedicoEspecialidade extends StatelessWidget {
  final Color primaryGold;
  final List<Map<String, dynamic>> doctors;
  final int selectedDoctorId;
  final String selectedDoctorName;
  final ValueChanged<int> onDoctorSelected;
  final VoidCallback? onSpecialtyTap;

  const MedicoEspecialidade({
    super.key,
    required this.primaryGold,
    required this.doctors,
    required this.selectedDoctorId,
    required this.selectedDoctorName,
    required this.onDoctorSelected,
    this.onSpecialtyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2. Médico e Especialidade',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSpecialtyTap ?? () {},
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.06),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFF7EE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.medical_services_outlined,
                                color: primaryGold,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Especialidade',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Higiene Oral',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Show a simple dialog to pick a doctor and report selection
                    final pick = await showDialog<int>(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                        title: const Text('Escolha o médico'),
                        children: doctors
                            .map((d) => SimpleDialogOption(
                                  onPressed: () => Navigator.pop(ctx, d['id'] as int),
                                  child: Text(d['name'] as String),
                                ))
                            .toList(),
                      ),
                    );
                    if (pick != null) onDoctorSelected(pick);
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.06),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_outline,
                                color: Color(0xFF334155),
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Médico',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedDoctorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
