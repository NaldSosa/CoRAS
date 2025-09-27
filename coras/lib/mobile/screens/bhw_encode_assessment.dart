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
                    controller: AssessmentController.nameController,
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
                        AssessmentController.sexController.text.isNotEmpty
                            ? AssessmentController.sexController.text
                            : null,
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text("Male")),
                      DropdownMenuItem(value: 'F', child: Text("Female")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        AssessmentController.sexController.text = value;
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
                    controller: AssessmentController.birthdateController,
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
                        AssessmentController.birthdateController.text =
                            pickedDate.toString().split(' ')[0];
                        _controller.calculateAgeFromBirthdate(pickedDate);
                        setState(() {});
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: AssessmentController.ageController,
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
                        AssessmentController
                                .civilStatusController
                                .text
                                .isNotEmpty
                            ? AssessmentController.civilStatusController.text
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
                        AssessmentController.civilStatusController.text = value;
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
                    controller: AssessmentController.contactController,
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
                    controller: AssessmentController.addressController,
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
                    value: AssessmentController.yesNoAnswers["Hypertension"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Hypertension"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Stroke",
                    value: AssessmentController.yesNoAnswers["Stroke"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Stroke"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Heart Attack",
                    value: AssessmentController.yesNoAnswers["Heart Attack"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Heart Attack"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Diabetes",
                    value: AssessmentController.yesNoAnswers["Diabetes"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Diabetes"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Asthma",
                    value: AssessmentController.yesNoAnswers["Asthma"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Asthma"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Cancer",
                    value: AssessmentController.yesNoAnswers["Cancer"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Cancer"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Kidney Disease",
                    value: AssessmentController.yesNoAnswers["Kidney Disease"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Kidney Disease"] = val;
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
                    value: AssessmentController.yesNoAnswers["Obesity"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Obesity"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.heightController,
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
                          double.tryParse(
                            AssessmentController.heightController.text,
                          ) ??
                          0.0;
                      final weight =
                          double.tryParse(
                            AssessmentController.weightController.text,
                          ) ??
                          0.0;
                      _controller.calculateBMI(height, weight);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.weightController,
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
                          double.tryParse(
                            AssessmentController.heightController.text,
                          ) ??
                          0.0;
                      final weight =
                          double.tryParse(
                            AssessmentController.weightController.text,
                          ) ??
                          0.0;
                      _controller.calculateBMI(height, weight);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.bmiController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "BMI",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.bmiCategoryController,
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
                    value:
                        AssessmentController.yesNoAnswers["Central Adiposity"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Central Adiposity"] =
                          val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.waistController,
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
                          double.tryParse(
                            AssessmentController.waistController.text,
                          ) ??
                          0.0;
                      final hip =
                          double.tryParse(
                            AssessmentController.hipController.text,
                          ) ??
                          0.0;
                      _controller.calculateWaistHipRatio(waist, hip);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.hipController,
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
                          double.tryParse(
                            AssessmentController.waistController.text,
                          ) ??
                          0.0;
                      final hip =
                          double.tryParse(
                            AssessmentController.hipController.text,
                          ) ??
                          0.0;
                      _controller.calculateWaistHipRatio(waist, hip);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.ratioController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Waist-to-Hip Ratio",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.ratioCategoryController,
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
                    controller: AssessmentController.sbp1Controller,
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
                          int.tryParse(
                            AssessmentController.sbp1Controller.text,
                          ) ??
                          0;
                      final dia1 =
                          int.tryParse(
                            AssessmentController.dbp1Controller.text,
                          ) ??
                          0;
                      final sys2 =
                          int.tryParse(
                            AssessmentController.sbp2Controller.text,
                          ) ??
                          0;
                      final dia2 =
                          int.tryParse(
                            AssessmentController.dbp2Controller.text,
                          ) ??
                          0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.dbp1Controller,
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
                          int.tryParse(
                            AssessmentController.sbp1Controller.text,
                          ) ??
                          0;
                      final dia1 =
                          int.tryParse(
                            AssessmentController.dbp1Controller.text,
                          ) ??
                          0;
                      final sys2 =
                          int.tryParse(
                            AssessmentController.sbp2Controller.text,
                          ) ??
                          0;
                      final dia2 =
                          int.tryParse(
                            AssessmentController.dbp2Controller.text,
                          ) ??
                          0;
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
                    controller: AssessmentController.sbp2Controller,
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
                          int.tryParse(
                            AssessmentController.sbp1Controller.text,
                          ) ??
                          0;
                      final dia1 =
                          int.tryParse(
                            AssessmentController.dbp1Controller.text,
                          ) ??
                          0;
                      final sys2 =
                          int.tryParse(
                            AssessmentController.sbp2Controller.text,
                          ) ??
                          0;
                      final dia2 =
                          int.tryParse(
                            AssessmentController.dbp2Controller.text,
                          ) ??
                          0;
                      _controller.getBpAvg(sys1, dia1, sys2, dia2);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.dbp2Controller,
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
                          int.tryParse(
                            AssessmentController.sbp1Controller.text,
                          ) ??
                          0;
                      final dia1 =
                          int.tryParse(
                            AssessmentController.dbp1Controller.text,
                          ) ??
                          0;
                      final sys2 =
                          int.tryParse(
                            AssessmentController.sbp2Controller.text,
                          ) ??
                          0;
                      final dia2 =
                          int.tryParse(
                            AssessmentController.dbp2Controller.text,
                          ) ??
                          0;
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
                    controller: AssessmentController.sbpAvgController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Average Systolic BP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.dbpAvgController,
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
                    value: AssessmentController.yesNoAnswers["Raised BP"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Raised BP"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.bpCategoryController,
                    readOnly: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getBPCategoryColor(
                        AssessmentController.bpCategoryController.text,
                      ),
                    ),
                    decoration: const InputDecoration(
                      labelText: "BP Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.bpMedicineController,
                    decoration: const InputDecoration(
                      labelText: "Medicine",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: AssessmentController.medMilligramsController,
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
                    label: "4. Smoking Status",
                    options: [
                      "Never Smoked",
                      "Current Smoker",
                      "Passive Smoker",
                      "Stopped > 1 year",
                      "Stopped < 1 year",
                    ],
                    value: AssessmentController.radioAnswers["Smoking Status"],
                    onChanged: (val) {
                      AssessmentController.radioAnswers["Smoking Status"] = val;
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
                    value: AssessmentController.yesNoAnswers["Drinks Alcohol"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Drinks Alcohol"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "In past months, had 5 drinks in one occasion",
                    value:
                        AssessmentController.yesNoAnswers["5 Drinks Occasion"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["5 Drinks Occasion"] =
                          val;
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
                    value: AssessmentController.yesNoAnswers["Processed Foods"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Processed Foods"] =
                          val;
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
                    value: AssessmentController.yesNoAnswers["Vegetables"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Vegetables"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  YesNoField(
                    label: "3 Servings of Fruits Daily",
                    value: AssessmentController.yesNoAnswers["Fruits"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Fruits"] = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Physical Activity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  YesNoField(
                    label:
                        "Does at least 2 1/2 hours a week of moderate intensity physical activity?",
                    value:
                        AssessmentController.yesNoAnswers["Physical Activity"],
                    required: true,
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Physical Activity"] =
                          val;
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
                    value: AssessmentController.yesNoAnswers["Q1"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q1"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q2. Ang sakit ba ay nasa gitna ng dibdib, sa kaliwang bahagi ng dibdib, o sa kaliwang braso? (If NO, skip to Question 8)",
                    value: AssessmentController.yesNoAnswers["Q2"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q2"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q3. Nararamdaman mo ba ito kung ikaw ay nagmamadali o naglalakad nang mabilis?",
                    value: AssessmentController.yesNoAnswers["Q3"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q3"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q4. Timitigil ka ba sa paglalakad kapag sumakit ang iyong dibdib?",
                    value: AssessmentController.yesNoAnswers["Q4"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q4"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q5. Nawawala ba ang sakit kapag ikaw ay di kumikilos o kapag naglagay ng gamot sa ilalim ng dila?",
                    value: AssessmentController.yesNoAnswers["Q5"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q5"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Q6. Nawawala ba ang sakit sa loob ng 10 minuto?",
                    value: AssessmentController.yesNoAnswers["Q6"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q6"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label:
                        "Q7. Nakaramdam ka na ba ng pananakit ng dibdib na tumagal ng kalahating oras o higit pa?",
                    value: AssessmentController.yesNoAnswers["Q7"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q7"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Possible Angina or Heart Attack",
                    value: AssessmentController.yesNoAnswers["Possible Angina"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Possible Angina"] =
                          val;
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
                    value: AssessmentController.yesNoAnswers["Possible Stroke"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Possible Stroke"] =
                          val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  YesNoField(
                    label:
                        "Q8. Nakakaramdam ka na ba ng mga sumusunod:\n- Hirap sa pagsasalita, panghihina ng braso at/o ng binti o pamamanhid sa kalahating bahagi ng katawan?",
                    required: true,
                    value: AssessmentController.yesNoAnswers["Q8"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Q8"] = val;
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
                    value:
                        AssessmentController
                            .radioAnswers["Diagnosed with Diabetes?"],
                    onChanged: (val) {
                      AssessmentController
                              .radioAnswers["Diagnosed with Diabetes?"] =
                          val;
                      setState(() {}); // para mag-refresh ang UI
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value:
                        AssessmentController
                                .diabetesMedicationController
                                .text
                                .isNotEmpty
                            ? AssessmentController
                                .diabetesMedicationController
                                .text
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
                        AssessmentController.diabetesMedicationController.text =
                            val;
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
                        AssessmentController
                            .diabetesExistingMedicationController,
                    decoration: const InputDecoration(
                      labelText: "Medicine",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: AssessmentController.diabetesMedMgController,
                    decoration: const InputDecoration(
                      labelText: "Milligrams",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  YesNoField(
                    label: "Polyphagia (Palaging Gutom)",
                    required: true,
                    value: AssessmentController.yesNoAnswers["Polyphagia"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Polyphagia"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Polydipsia (Palaging Nauuhaw)",
                    required: true,
                    value: AssessmentController.yesNoAnswers["Polydipsia"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Polydipsia"] = val;
                      setState(() {});
                    },
                  ),
                  YesNoField(
                    label: "Polyuria (Palaging Naiihi)",
                    required: true,
                    value: AssessmentController.yesNoAnswers["Polyuria"],
                    onChanged: (val) {
                      AssessmentController.yesNoAnswers["Polyuria"] = val;
                      setState(() {});
                    },
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
                  onPressed: () async {
                    final controller = AssessmentController();
                    final patientData = AssessmentController.toJson();

                    try {
                      // 1. AI Recommendation
                      final result = await controller.submitAssessment(
                        patientData,
                      );

                      // 2. Risk Assessment
                      final risk = await controller.fetchRiskAssessment(
                        patientData,
                      );

                      // 3. Extract results
                      final recommendations =
                          result["ai_recommendations"] ?? "";
                      final summary = result["summary"] ?? "";

                      // 4. Show Dialog
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("AI Health Recommendations"),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Risk Assessment:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${risk["risk_percentage"]}% - ${risk["risk_level"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          int.parse(
                                            "0xFF${risk["risk_color"].substring(1)}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "AI Recommendations:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      recommendations,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Summary:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      summary,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
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
