// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:coras/mobile/controller/bhw_assessment_controller.dart';
import '../widgets/bhw_yes_no.dart';
import '../widgets/bhw_radio_list.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _controller = AssessmentController();
  final _formKey = GlobalKey<FormState>();

  Color getBPCategoryColor(String category) {
    switch (category) {
      case 'Hypertensive Crisis':
        return const Color.fromARGB(255, 114, 0, 0);
      case 'High Blood Pressure Stage 2':
        return const Color.fromARGB(255, 255, 17, 0);
      case 'High Blood Pressure Stage 1':
        return const Color.fromARGB(255, 255, 123, 0);
      case 'Elevated':
        return Colors.yellow.shade700;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assessment"),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      "NCD Risk Assessment Form",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Non-Laboratory-Based",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "(For adults 20 years old and above)",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Section 1: Personal Information ---
              _buildSectionCard(
                title: "1. Personal Information",
                children: [
                  TextFormField(
                    controller: _controller.nameController,
                    cursorColor: Color(0xFF2E7D32), // cursor color
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter patient's name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value:
                        _controller.sexController.text.isNotEmpty
                            ? _controller.sexController.text
                            : null,
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text("Male")),
                      DropdownMenuItem(value: 'F', child: Text("Female")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _controller.sexController.text = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Sex",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select patient's sex";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _controller.birthdateController,
                    readOnly: true,
                    cursorColor: Color(0xFF2E7D32), // custom cursor color
                    decoration: InputDecoration(
                      labelText: "Birthdate",
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select patient's birthdate";
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        _controller.birthdateController.text =
                            pickedDate.toString().split(' ')[0];
                        _controller.calculateAgeFromBirthdate(pickedDate);
                        setState(() {});
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _controller.ageController,
                    readOnly: true,
                    cursorColor: Color(0xFF2E7D32),
                    decoration: InputDecoration(
                      labelText: "Age",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (_) => _controller.validateBirthdate(),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value:
                        _controller.civilStatusController.text.isNotEmpty
                            ? _controller.civilStatusController.text
                            : null,
                    items: const [
                      DropdownMenuItem(value: 'Single', child: Text("Single")),
                      DropdownMenuItem(
                        value: 'Married',
                        child: Text("Married"),
                      ),
                      DropdownMenuItem(
                        value: 'Widowed',
                        child: Text("Widowed"),
                      ),
                      DropdownMenuItem(
                        value: 'Separated',
                        child: Text("Separated"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _controller.civilStatusController.text = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Civil Status",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select patient's civil status";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.contactController,
                    cursorColor: Color(0xFF2E7D32),
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter patient's contact number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.addressController,
                    cursorColor: Color(0xFF2E7D32),
                    decoration: InputDecoration(
                      labelText: "Address",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter patient's address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Color(0xFF2E7D32),
                    decoration: InputDecoration(
                      labelText: "Barangay",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF2E7D32),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              // --- Section 2: Family History ---
              _buildSectionCard(
                title: "2. Family History",
                children: [
                  const Text("Does Patient have 1st degree relative with:"),
                  YesNoField(
                    label: "Hypertension",
                    value: _controller.yesNoAnswers["Hypertension"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Hypertension"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Stroke",
                    value: _controller.yesNoAnswers["Stroke"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Stroke"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Heart Attack",
                    value: _controller.yesNoAnswers["Heart Attack"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Heart Attack"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Diabetes",
                    value: _controller.yesNoAnswers["Diabetes"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Diabetes"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Asthma",
                    value: _controller.yesNoAnswers["Asthma"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Asthma"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Cancer",
                    value: _controller.yesNoAnswers["Cancer"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Cancer"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Kidney Disease",
                    value: _controller.yesNoAnswers["Kidney Disease"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Kidney Disease"] = val;
                      setState(() {});
                    },
                  ),
                ],
              ),

              // --- Section 3: Obesity & Blood Pressure ---
              _buildSectionCard(
                title: "3. Anthropometrics & Physiological Risk Factors",
                children: [
                  YesNoField(
                    label: "Obesity",
                    readOnly: true,
                    value: _controller.yesNoAnswers["Obesity"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Obesity"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Height (cm)",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter height"
                                : null,
                    onChanged: (_) {
                      final height =
                          double.tryParse(_controller.heightController.text) ??
                          0.0;
                      final weight =
                          double.tryParse(_controller.weightController.text) ??
                          0.0;
                      _controller.calculateBMI(height, weight);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Weight (kg)",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter weight"
                                : null,
                    onChanged: (_) {
                      final height =
                          double.tryParse(_controller.heightController.text) ??
                          0.0;
                      final weight =
                          double.tryParse(_controller.weightController.text) ??
                          0.0;
                      _controller.calculateBMI(height, weight);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.bmiController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "BMI",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.bmiCategoryController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "BMI Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  YesNoField(
                    label: "Central Adiposity",
                    readOnly: true,
                    value: _controller.yesNoAnswers["Central Adiposity"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Central Adiposity"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.waistController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Waist Circumference (cm)",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter waist circumference"
                                : null,
                    onChanged: (_) {
                      final waist =
                          double.tryParse(_controller.waistController.text) ??
                          0.0;
                      final hip =
                          double.tryParse(_controller.hipController.text) ??
                          0.0;
                      _controller.calculateWaistHipRatio(waist, hip);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.hipController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Hip Circumference (cm)",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter hip circumference"
                                : null,
                    onChanged: (_) {
                      final waist =
                          double.tryParse(_controller.waistController.text) ??
                          0.0;
                      final hip =
                          double.tryParse(_controller.hipController.text) ??
                          0.0;
                      _controller.calculateWaistHipRatio(waist, hip);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.ratioController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Waist-to-Hip Ratio",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.ratioCategoryController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "WHR Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Blood Pressure (1st Reading)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _controller.sbp1Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Systolic BP",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter systolic BP"
                                : null,
                    onChanged: (_) {
                      final sys1 =
                          int.tryParse(_controller.sbp1Controller.text) ?? 0;
                      final dia1 =
                          int.tryParse(_controller.dbp1Controller.text) ?? 0;
                      final sys2 =
                          int.tryParse(_controller.sbp2Controller.text) ?? 0;
                      final dia2 =
                          int.tryParse(_controller.dbp2Controller.text) ?? 0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.dbp1Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Diastolic BP",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter diastolic BP"
                                : null,
                    onChanged: (_) {
                      final sys1 =
                          int.tryParse(_controller.sbp1Controller.text) ?? 0;
                      final dia1 =
                          int.tryParse(_controller.dbp1Controller.text) ?? 0;
                      final sys2 =
                          int.tryParse(_controller.sbp2Controller.text) ?? 0;
                      final dia2 =
                          int.tryParse(_controller.dbp2Controller.text) ?? 0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Blood Pressure (2nd Reading)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _controller.sbp2Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Systolic BP",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter systolic BP"
                                : null,
                    onChanged: (_) {
                      final sys1 =
                          int.tryParse(_controller.sbp1Controller.text) ?? 0;
                      final dia1 =
                          int.tryParse(_controller.dbp1Controller.text) ?? 0;
                      final sys2 =
                          int.tryParse(_controller.sbp2Controller.text) ?? 0;
                      final dia2 =
                          int.tryParse(_controller.dbp2Controller.text) ?? 0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.dbp2Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Diastolic BP",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Please enter diastolic BP"
                                : null,
                    onChanged: (_) {
                      final sys1 =
                          int.tryParse(_controller.sbp1Controller.text) ?? 0;
                      final dia1 =
                          int.tryParse(_controller.dbp1Controller.text) ?? 0;
                      final sys2 =
                          int.tryParse(_controller.sbp2Controller.text) ?? 0;
                      final dia2 =
                          int.tryParse(_controller.dbp2Controller.text) ?? 0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Average Blood Pressure",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _controller.sbpAvgController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Average Systolic BP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.dbpAvgController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Average Diastolic BP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  YesNoField(
                    label: "Raised BP",
                    readOnly: true,
                    value: _controller.yesNoAnswers["Raised BP"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Raised BP"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.bpCategoryController,
                    readOnly: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getBPCategoryColor(
                        _controller.bpCategoryController.text,
                      ),
                    ),
                    decoration: const InputDecoration(
                      labelText: "BP Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.bpMedicineController,
                    decoration: const InputDecoration(
                      labelText: "Medicine",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _controller.medMilligramsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Milligrams",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              // --- Section 4: Smoking Status ---
              _buildSectionCard(
                title: "4. Smoking Status",
                children: [
                  RadioGroupField(
                    label: "Smoking Status",
                    options: [
                      "Never Smoked",
                      "Current Smoker",
                      "Passive Smoker",
                      "Stopped > 1 year",
                      "Stopped < 1 year",
                    ],
                    value: _controller.radioAnswers["Smoking Status"],
                    onChanged: (val) {
                      _controller.radioAnswers["Smoking Status"] = val!;
                      setState(() {});
                    },
                  ),
                ],
              ),

              // --- Section 5: Alcohol Intake ---
              _buildSectionCard(
                title: "5. Alcohol Intake",
                children: [
                  YesNoField(
                    label: "Drinks Alcohol",
                    value: _controller.yesNoAnswers["Drinks Alcohol"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Drinks Alcohol"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Had 5 drinks in one occasion (last month)",
                    value: _controller.yesNoAnswers["5 Drinks Occasion"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["5 Drinks Occasion"] = val;
                      setState(() {});
                    },
                  ),
                ],
              ),

              // --- Section 6: Lifestyle ---
              _buildSectionCard(
                title: "6. Lifestyle",
                children: [
                  const Text(
                    "High Fat / High Salt Intake",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  YesNoField(
                    label:
                        "Eats Processed / Fast Foods (e.g Instant Noodles, Hamburgers, Fries, etc.)",
                    value: _controller.yesNoAnswers["Processed Foods"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Processed Foods"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Dietary Fiber Intake",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  YesNoField(
                    label: "3 Servings of Vegetables Daily",
                    value: _controller.yesNoAnswers["Vegetables"],
                    required: true,
                    onChanged: (val) {
                      _controller.yesNoAnswers["Vegetables"] = val;
                      setState(() {});
                    },
                  ),
                ],
              ),

              // --- Section 7: Questionnaires ---
              _buildSectionCard(
                title: "7. Questionnaires",
                children: [
                  const Text(
                    "To Determine Probable Angina, Heart Attack, Stroke, or TIA",
                  ),
                  const SizedBox(height: 12),

                  YesNoField(
                    label:
                        "Q1. Nakakaramdam ka ba ng pananakit o kabigatan sa iyong dibdib? (If NO, skip to Question 8)",
                    required: true,
                    value: _controller.yesNoAnswers["Q1"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q1"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q2. Ang sakit ba ay nasa gitna ng dibdib, sa kaliwang bahagi ng dibdib, o sa kaliwang braso? (If NO, skip to Question 8)",
                    value: _controller.yesNoAnswers["Q2"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q2"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q3. Nararamdaman mo ba ito kung ikaw ay nagmamadali o naglalakad nang mabilis?",
                    value: _controller.yesNoAnswers["Q3"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q3"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q4. Timitigil ka ba sa paglalakad kapag sumakit ang iyong dibdib?",
                    value: _controller.yesNoAnswers["Q4"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q4"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q5. Nawawala ba ang sakit kapag ikaw ay di kumikilos o kapag naglagay ng gamot sa ilalim ng dila?",
                    value: _controller.yesNoAnswers["Q5"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q5"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Q6. Nawawala ba ang sakit sa loob ng 10 minuto?",
                    value: _controller.yesNoAnswers["Q6"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q6"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q7. Nakaramdam ka na ba ng pananakit ng dibdib na tumagal ng kalahating oras o higit pa?",
                    value: _controller.yesNoAnswers["Q7"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q7"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Possible Angina or Heart Attack",
                    value: _controller.yesNoAnswers["Possible Angina"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Possible Angina"] = val;
                      setState(() {});
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "IF the answer to Question 3 or 4 or 5 or 6 or 7 is YES, patient MAY HAVE Angina or Heart Attack and NEEDS TO SEE THE DOCTOR.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  YesNoField(
                    label: "Possible Stroke or Transient Ischemic Attack (TIA)",
                    value: _controller.yesNoAnswers["Possible Stroke"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Possible Stroke"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  YesNoField(
                    label:
                        "Q8. Nakakaramdam ka na ba ng mga sumusunod:\n- Hirap sa pagsasalita, panghihina ng braso at/o ng binti o pamamanhid sa kalahating bahagi ng katawan?",
                    required: true,
                    value: _controller.yesNoAnswers["Q8"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Q8"] = val;
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "IF the answer to Question 8 is YES, patient MAY HAVE Stroke or TIA NEEDS TO SEE THE DOCTOR.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // --- Section 8: Diabetes Screening ---
              _buildSectionCard(
                title: "8. Diabetes Screening",
                children: [
                  RadioGroupField(
                    label: "Diagnosed with Diabetes?",
                    options: ["YES", "NO", "DO NOT KNOW"],
                    value: _controller.radioAnswers["Diagnosed with Diabetes?"],
                    onChanged: (val) {
                      _controller.radioAnswers["Diagnosed with Diabetes?"] =
                          val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value:
                        _controller.diabetesMedicationController.text.isNotEmpty
                            ? _controller.diabetesMedicationController.text
                            : null,
                    items: const [
                      DropdownMenuItem(
                        value: "With Medication",
                        child: Text("With Medication"),
                      ),
                      DropdownMenuItem(
                        value: "Without Medication",
                        child: Text("Without Medication"),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        _controller.diabetesMedicationController.text = val;
                        setState(() {});
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Medication Type",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller:
                        _controller.diabetesExistingMedicationController,
                    decoration: const InputDecoration(
                      labelText: "Medicine",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _controller.diabetesMedMgController,
                    decoration: const InputDecoration(
                      labelText: "Milligrams",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  YesNoField(
                    label: "Polyphagia (Palaging Gutom)",
                    required: true,
                    value: _controller.yesNoAnswers["Polyphagia"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Polyphagia"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Polydipsia (Palaging Nauuhaw)",
                    required: true,
                    value: _controller.yesNoAnswers["Polydipsia"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Polydipsia"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Polyuria (Palaging Naiihi)",
                    required: true,
                    value: _controller.yesNoAnswers["Polyuria"],
                    onChanged: (val) {
                      _controller.yesNoAnswers["Polyuria"] = val;
                      setState(() {});
                    },
                  ),
                ],
              ),

              // --- Section 9: Remarks ---
              _buildSectionCard(
                title: "9. Remarks",
                children: [
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Remarks",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Assessment",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {}, // 👈 empty, just UI
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
