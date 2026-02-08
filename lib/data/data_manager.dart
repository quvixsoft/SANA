import 'package:sana/data/models/consultation.dart';
import 'package:sana/data/models/lab_result.dart';
import 'package:sana/data/models/user_profile.dart';

import '../models/models.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal() {
    _initializeData();
  }

  List<Consultation> history = [];
  List<LabResult> labHistory = [];
  UserProfile? userProfile;

  void _initializeData() {
    // Mock Profile
    // userProfile = UserProfile(
    //   name: "Usuario Sana",
    //   age: 34,
    //   bloodType: "O+",
    //   height: 175,
    //   weight: 70,
    //   allergies: ["Penicilina", "Polen"],
    //   conditions: ["Hipertensión leve"],
    // );

    // Mock History (Consultations) - Sorted by date (newest first)
    history = [
      Consultation(
        id: "c1",
        title: "Dolor de cabeza recurrente",
        date: DateTime.now().subtract(const Duration(days: 2)),
        snippet:
            "El paciente reporta migrañas frecuentes en el lado derecho...",
        type: ConsultationType.chat,
      ),
      Consultation(
        id: "c2",
        title: "Análisis de hemoglobina",
        date: DateTime.now().subtract(const Duration(days: 5)),
        snippet:
            "Resultados dentro del rango normal. Se recomienda dieta rica en...",
        type: ConsultationType.labAnalysis,
      ),
      Consultation(
        id: "c3",
        title: "Consulta general",
        date: DateTime.now().subtract(const Duration(days: 12)),
        snippet: "Chequeo rutinario. Presión arterial estable.",
        type: ConsultationType.chat,
      ),
    ];

    // Mock Lab History
    labHistory = [
      LabResult(
        id: "l1",
        category: "Hematología",
        name: "Hemoglobina",
        value: "14.5",
        unit: "g/dL",
        status: "Normal",
        referenceRange: "13.5 - 17.5",
        color: "#1BA63D",
      ),
      LabResult(
        id: "l2",
        category: "Química Sanguínea",
        name: "Glucosa",
        value: "92",
        unit: "mg/dL",
        status: "Normal",
        referenceRange: "70 - 100",
        color: "#1BA63D",
      ),
      LabResult(
        id: "l3",
        category: "Lípidos",
        name: "Colesterol Total",
        value: "210",
        unit: "mg/dL",
        status: "Alto",
        referenceRange: "< 200",
        color: "#D91E1E",
      ),
    ];
  }

  // Helper Methods
  void addConsultation(Consultation consultation) {
    history.insert(0, consultation);
  }

  void addLabResult(LabResult result) {
    labHistory.add(result);
  }
}
