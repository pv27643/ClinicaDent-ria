import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Botão e lógica de confirmação
class Confirmar extends StatefulWidget {
  final String day;
  final String month;
  final String? time;
  final String doctorName;
  final int doctorId;
  final String? selectedInsurance;

  const Confirmar({
    super.key,
    required this.day,
    required this.month,
    required this.time,
    required this.doctorName,
    required this.doctorId,
    required this.selectedInsurance,
  });

  @override
  State<Confirmar> createState() => _ConfirmarState();
}

class _ConfirmarState extends State<Confirmar> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.time == null || widget.selectedInsurance == null) return;
    setState(() => _isLoading = true);

    try {
      final day = widget.day;
      final month = widget.month;
      final year = '2025';

      final monthMap = {
        'Jan': '01',
        'Fev': '02',
        'Feb': '02',
        'Mar': '03',
        'Abr': '04',
        'Apr': '04',
        'Mai': '05',
        'May': '05',
        'Jun': '06',
        'Jul': '07',
        'Ago': '08',
        'Aug': '08',
        'Set': '09',
        'Sep': '09',
        'Out': '10',
        'Oct': '10',
        'Nov': '11',
        'Dez': '12',
        'Dec': '12',
      };
      final monthNum = monthMap[month] ?? '11';

      final timeParts = widget.time!.split(':');
      final hour = timeParts[0].padLeft(2, '0');
      final minute = timeParts[1].padLeft(2, '0');

      final dataHoraConsulta = DateTime(
        int.parse(year),
        int.parse(monthNum),
        int.parse(day),
        int.parse(hour),
        int.parse(minute),
      );

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('Usuário não identificado. Faça login novamente.');
      }

      String? horaPayload;
      if (widget.time != null) {
        final parts = widget.time!.split(':');
        horaPayload = (parts.length == 2) ? '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00' : widget.time;
      } else {
        horaPayload = null;
      }

      final consultaData = {
        'id': userId,
        'id_medico': widget.doctorId,
        'hora': horaPayload,
        'tipo_de_marcacao': 'Higiene Oral',
        'status': 'pendente',
        'data_consulta': dataHoraConsulta.toIso8601String(),
      };

      final res = await ApiService.createAppointment(consultaData);

      if (res['success'] == true) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirmação'),
            content: Text(
              'Consulta marcada com sucesso!\n\n'
              'Data: $day/$monthNum/$year\n'
              'Hora: ${widget.time}\n'
              'Especialidade: Higiene Oral\n'
              'Médico: ${widget.doctorName}\n'
              'Status: Pendente',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Erro ao marcar consulta: ${res['error'] ?? 'Erro desconhecido'}'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Erro ao conectar com o servidor:\n$e'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = Colors.white;
    final enabled = (widget.time != null && widget.selectedInsurance != null && !_isLoading);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('5. Confirmar', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black54),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${widget.day} ${widget.month} • ${widget.time ?? '—'} • Higiene Oral • ${widget.doctorName.split(' ').first}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA87B05),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: enabled ? _handleConfirm : null,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Confirmar Marcação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
