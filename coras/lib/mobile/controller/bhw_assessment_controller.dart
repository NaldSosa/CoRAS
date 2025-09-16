import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AssessmentController {
  // =================== FORM FIELDS ===================
  Map<String, bool?> yesNoAnswers = {}; // pang store ng yes or no answers
  Map<String, String?> radioAnswers = {
    "Smoking Status": null,
    "Diagnosed with Diabetes?": null,
  };

  Map<String, String?> textAnswers = {};
  TextStyle? textStyle;

  // Section 1: Personal Info
  static final nameController =
      TextEditingController(); // controller ng isang text field, pang store ng value ng text field
  static final sexController = TextEditingController();
  static final birthdateController = TextEditingController();
  static final ageController = TextEditingController();
  static final civilStatusController = TextEditingController();
  static final contactController = TextEditingController();
  static final addressController = TextEditingController();

  // Section 3: Obesity & Blood Pressure
  static final heightController = TextEditingController();
  static final weightController = TextEditingController();
  static final bmiController = TextEditingController();
  static final bmiCategoryController = TextEditingController();
  static final obesityController = TextEditingController();
  static final waistController = TextEditingController();
  static final hipController = TextEditingController();
  static final ratioController = TextEditingController();
  static final ratioCategoryController = TextEditingController();
  static final adiposityController = TextEditingController();
  static final sbp1Controller = TextEditingController();
  static final dbp1Controller = TextEditingController();
  static final sbp2Controller = TextEditingController();
  static final dbp2Controller = TextEditingController();
  static final sbpAvgController = TextEditingController();
  static final dbpAvgController = TextEditingController();
  static final raisedBPController = TextEditingController();
  static final bpCategoryController = TextEditingController();
  static final bpMedicineController = TextEditingController();
  static final medMilligramsController = TextEditingController();

  // Section 4: Smoking
  static String smokingStatus = '';

  // Section 5: Alcohol
  static final drinksAlcoholController = TextEditingController();
  static final excessiveAlcoholController = TextEditingController();

  // Section 6: Lifestyle
  static final highFatSaltController = TextEditingController();
  static final vegController = TextEditingController();
  static final fruitController = TextEditingController();
  static final physicalActivityController = TextEditingController();

  // Section 7: Questionnaire
  static Map<String, bool?> anginaQuestions = {
    'Q1. Nakakaramdam ka ba ng pananakit o kabigatan sa iyong dibdib? (If NO, skip to Question 8)':
        null,
    'Q2. Ang sakit ba ay nasa gitna ng dibdib, sa kaliwang bahagi ng dibdib, o sa kaliwang braso? (If NO, skip to Question 8)':
        null,
    'Q3. Nararamdaman mo ba ito kung ikaw ay nagmamadali o naglalakad nang mabilis?':
        null,
    'Q4. Timitigil ka ba sa paglalakad kapag sumakit ang iyong dibdib?': null,
    'Q5. Nawawala ba ang sakit kapag ikaw ay di kumikilos o kapag naglagay ng gamot sa ilalim ng dila?':
        null,
    'Q6. Nawawala ba ang sakit sa loob ng 10 minuto?': null,
    'Q7. Nakaramdam ka na ba ng pananakit ng dibdib na tumagal ng kalahating oras o higit pa?':
        null,
    'Q8. Nakakaramdam ka na ba ng mga sumusunod:\n- Hirap sa pagsasalita, panghihina ng braso at/o ng binti o pamamanhid sa kalahating bahagi ng katawan?':
        null,
  };

  static final anginaResultController = TextEditingController();

  // Section 8: Diabetes
  static final diabetesMedicationController = TextEditingController();
  static final diabetesExistingMedicationController = TextEditingController();
  static final diabetesMedMgController = TextEditingController();

  static Map<String, bool?> diabetesSymptoms = {
    'Polyphagia (Palaging Gutom)': null,
    'Polydipsia (Palaging Nauuhaw)': null,
    'Polyuria (Palaging Naiihi)': null,
  };

  // Section 9: Remarks
  static final remarksController = TextEditingController();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Map<String, dynamic>> submitAssessment(
    Map<String, dynamic> patientData,
  ) async {
    try {
      final response = await _dio.post("/risk-assessment/", data: patientData);
      return response.data;
    } catch (e) {
      throw Exception("Error submitting assessment: $e");
    }
  }

  // =================== CALCULATION LOGIC ===================
  void calculateAgeFromBirthdate(DateTime birthdate) {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    ageController.text = age.toString();
  }

  String? validateBirthdate() {
    final age = int.tryParse(ageController.text) ?? 0;
    if (age < 20) return 'Must be at least 20 years old';
    return null;
  }

  void calculateBMI(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) {
      bmiController.text = '';
      bmiCategoryController.text = '';
      yesNoAnswers["Obesity"] = null;
      return;
    }
    final bmi = (weightKg / heightCm / heightCm) * 10000;
    bmiController.text = bmi.toStringAsFixed(1);
    final category = getBMICategory(bmi);
    bmiCategoryController.text = category;
    obesityController.text = (bmi >= 23) ? 'Yes' : 'No';
    yesNoAnswers["Obesity"] = (bmi >= 23);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal';
    if (bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  void calculateWaistHipRatio(double waistCm, double hipCm) {
    if (waistCm <= 0 || hipCm <= 0) {
      ratioController.text = '';
      ratioCategoryController.text = '';
      adiposityController.text = '';
      yesNoAnswers["Central Adiposity"] = null;
      return;
    }
    final ratio = waistCm / hipCm;
    final sex = sexController.text.trim().toUpperCase();
    ratioController.text = ratio.toStringAsFixed(2);
    final category = getWaistHipRiskLevel(waistCm, hipCm);
    ratioCategoryController.text = category;
    if ((sex == 'M' && ratio > 0.95) || (sex == 'F' && ratio > 0.85)) {
      yesNoAnswers["Central Adiposity"] = true;
    } else {
      yesNoAnswers["Central Adiposity"] = false;
    }
  }

  String getWaistHipRiskLevel(double waistCm, double hipCm) {
    if (waistCm <= 0 || hipCm <= 0) return 'Invalid';
    final whr = waistCm / hipCm;
    final sex = sexController.text.trim().toUpperCase();
    if (sex == 'M') {
      if (whr < 0.85) return 'Excellent';
      if (whr >= 0.85 && whr < 0.90) return 'Good';
      if (whr >= 0.90 && whr <= 0.95) return 'Average';
      if (whr > 0.95) return 'At Risk';
    } else if (sex == 'F') {
      if (whr < 0.75) return 'Excellent';
      if (whr >= 0.75 && whr < 0.80) return 'Good';
      if (whr >= 0.80 && whr <= 0.85) return 'Average';
      if (whr > 0.85) return 'At Risk';
    }
    return 'Unknown';
  }

  void getBpAvg(int sys1, int dia1, int sys2, int dia2) {
    if (sys1 <= 0 || dia1 <= 0 || sys2 <= 0 || dia2 <= 0) {
      sbpAvgController.text = '';
      dbpAvgController.text = '';
      bpCategoryController.text = '';
      raisedBPController.text = '';
      yesNoAnswers["Raised BP"] = null;
      return;
    }
    int avgSys = (sys1 + sys2) ~/ 2;
    int avgDia = (dia1 + dia2) ~/ 2;
    sbpAvgController.text = '$avgSys';
    dbpAvgController.text = '$avgDia';
    final category = getBPCategory(avgSys, avgDia);
    bpCategoryController.text = category;
    if (category.startsWith("High Blood Pressure") ||
        category == "Hypertensive Crisis") {
      raisedBPController.text = 'Yes';
      yesNoAnswers["Raised BP"] = true;
    } else {
      raisedBPController.text = 'No';
      yesNoAnswers["Raised BP"] = false;
    }
  }

  String getBPCategory(int sys, int dia) {
    if (sys > 180 || dia > 120) {
      return 'Hypertensive Crisis';
    } else if (sys >= 140 || dia >= 90) {
      return 'High Blood Pressure Stage 2';
    } else if ((sys >= 130 && sys <= 139) || (dia >= 80 && dia <= 89)) {
      return 'High Blood Pressure Stage 1';
    } else if (sys >= 120 && sys <= 129 && dia < 80) {
      return 'Elevated';
    } else if (sys < 120 && dia < 80) {
      return 'Normal';
    } else {
      return 'Unknown';
    }
  }

  bool isPersonalInfoComplete() {
    return nameController.text.isNotEmpty &&
        sexController.text.isNotEmpty &&
        birthdateController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        civilStatusController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        addressController.text.isNotEmpty;
  }

  void dispose() {
    for (var controller in [
      nameController,
      sexController,
      birthdateController,
      ageController,
      civilStatusController,
      contactController,
      addressController,
      heightController,
      weightController,
      bmiController,
      bmiCategoryController,
      obesityController,
      waistController,
      ratioController,
      adiposityController,
      sbp1Controller,
      dbp1Controller,
      sbp2Controller,
      dbp2Controller,
      sbpAvgController,
      dbpAvgController,
      raisedBPController,
      bpCategoryController,
      bpMedicineController,
      medMilligramsController,
      drinksAlcoholController,
      excessiveAlcoholController,
      highFatSaltController,
      vegController,
      fruitController,
      physicalActivityController,
      anginaResultController,
      remarksController,
      diabetesMedicationController,
      diabetesExistingMedicationController,
      diabetesMedMgController,
    ]) {
      controller.dispose();
    }
  }
}
