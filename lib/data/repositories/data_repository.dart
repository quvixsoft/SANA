import 'package:flutter/material.dart';
import '../models/consultation.dart';
import '../models/lab_result.dart';
import '../models/user_profile.dart';

/// Data repository - Singleton pattern
/// Manages all app data with database-ready structure
class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal() {
    _initializeData();
  }

  // Data stores
  List<Consultation> _consultations = [];
  List<LabResult> _labResults = [];
  UserProfile? _userProfile;
  
  // Getters
  List<Consultation> get consultations => List.unmodifiable(_consultations);
  List<LabResult> get labResults => List.unmodifiable(_labResults);
  UserProfile? get userProfile => _userProfile;
  
  /// Initialize with mock data
  /// TODO: Replace with database calls
  void _initializeData() {
    _userProfile = UserProfile(
      id: 'user_1',
      name: "Usuario Sana",
      age: 34,
      bloodType: "O+",
      height: 175,
      weight: 70,
      allergies: ["Penicilina", "Polen"],
      conditions: ["Hipertensión leve"],
    );

    _consultations = [
      Consultation(
        id: "c1",
        title: "Dolor de cabeza recurrente",
        date: DateTime.now().subtract(const Duration(days: 2)),
        snippet: "El paciente reporta migrañas frecuentes en el lado derecho...",
        type: ConsultationType.chat,
      ),
      Consultation(
        id: "c2",
        title: "Análisis de hemoglobina",
        date: DateTime.now().subtract(const Duration(days: 5)),
        snippet: "Resultados dentro del rango normal. Se recomienda dieta rica en...",
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

    _labResults = [
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

  // CRUD Operations - Database-ready interface
  
  /// Add consultation
  Future<void> addConsultation(Consultation consultation) async {
    // TODO: Save to database
    _consultations.insert(0, consultation);
  }
  
  /// Add lab result
  Future<void> addLabResult(LabResult result) async {
    // TODO: Save to database
    _labResults.add(result);
  }
  
  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    // TODO: Save to database
    _userProfile = profile;
  }
  
  /// Get consultations by type
  List<Consultation> getConsultationsByType(ConsultationType type) {
    return _consultations.where((c) => c.type == type).toList();
  }
  
  /// Get abnormal lab results
  List<LabResult> getAbnormalLabResults() {
    return _labResults.where((r) => r.status != 'Normal').toList();
  }
  
  /// Clear all data (for logout)
  Future<void> clearData() async {
    // TODO: Clear database
    _consultations.clear();
    _labResults.clear();
    _userProfile = null;
  }
}
