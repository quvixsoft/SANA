import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sana/data/data_manager.dart';
import 'package:sana/data/models/consultation.dart';

class HistoryScreen extends StatefulWidget {
  static const String routePath = '/history';
  static const String routeName = 'history';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Filter / Header (Optional)

            // List of Consultations
            ListView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Scroll handled by parent
              shrinkWrap: true,
              itemCount: _dataManager.history.length,
              itemBuilder: (context, index) {
                final consultation = _dataManager.history[index];
                return _buildConsultationCard(consultation);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(Consultation consultation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: consultation.type == ConsultationType.chat
                      ? const Color(0xFF1E82D9).withOpacity(0.1)
                      : const Color(0xFF1BA63D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  consultation.type == ConsultationType.chat
                      ? "Chat Clínico"
                      : "Laboratorio",
                  style: TextStyle(
                    color: consultation.type == ConsultationType.chat
                        ? const Color(0xFF1E82D9)
                        : const Color(0xFF1BA63D),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(consultation.date),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            consultation.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF122640),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            consultation.snippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Divider(),
          InkWell(
            onTap: () {
              // Open detailed view (if implied) or just show snackbar "Detalle no disponible en Demo"
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Ver Detalle",
                    style: TextStyle(
                      color: Color(0xFF1E82D9),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF1E82D9),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
