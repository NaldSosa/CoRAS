import 'package:coras/mobile/controller/bhw_view_encoded_assessment_controller.dart';
import 'package:flutter/material.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final api = BhwViewEncodedAssessmentController();
  List patients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await api.fetchPatients();
    setState(() {
      patients = data;
      loading = false;
    });
  }

  Color riskColor(dynamic riskLevel) {
    if (riskLevel == null) return Colors.grey;
    final hex = riskLevel["risk_color"];
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }

  void showPatientDetails(int id) async {
    final data = await api.fetchPatientDetail(id);
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text("Age: ${data["age"]}"),
                  Text("Sex: ${data["sex"]}"),
                  Text("Civil Status: ${data["civil_status"]}"),
                  Divider(),

                  Text(
                    "Intake Records",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...(data["intake_records"] ?? [])
                      .map<Widget>(
                        (ir) => Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "BMI: ${ir["bmi"]} (${ir["bmi_category"]})",
                            ),
                            subtitle: Text(
                              "BP: ${ir["avg_sbp"]}/${ir["avg_dbp"]} (${ir["bp_category"]})",
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  SizedBox(height: 12),
                  Text(
                    "Screenings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...(data["screenings"] ?? [])
                      .map<Widget>(
                        (s) => Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "Diagnosed Diabetes: ${s["is_diagnosed_diabetes"]}",
                            ),
                            subtitle: Text(
                              "Polyuria: ${s["have_polyuria"]}, "
                              "Polydipsia: ${s["have_polydipsia"]}, "
                              "Polyphagia: ${s["have_polyphagia"]}",
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  SizedBox(height: 12),
                  Text(
                    "Assessments & Results",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...(data["assessments"] ?? [])
                      .map<Widget>(
                        (a) => Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date: ${a["assessment_date_time"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ...(a["results"] ?? [])
                                    .map<Widget>(
                                      (r) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Risk: ${r["risk_result"]["risk_percentage"]}% ",
                                              ),
                                              Chip(
                                                label: Text(
                                                  r["risk_result"]["risk_level"]["risk_level"],
                                                ),
                                                backgroundColor: riskColor(
                                                  r["risk_result"]["risk_level"],
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Recommendation: ${r["recommendation"]}",
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Patients")),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, i) {
          final p = patients[i];
          final risk = p["latest_result"]?["risk_result"];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(p["name"]),
              subtitle: Text("${p["age"]} yrs • ${p["sex"]}"),
              trailing:
                  risk != null
                      ? Chip(
                        label: Text(
                          "${risk["risk_percentage"]}% ${risk["risk_level"]["risk_level"]}",
                        ),
                        backgroundColor: riskColor(risk["risk_level"]),
                        labelStyle: TextStyle(color: Colors.white),
                      )
                      : Text("No Result"),
              onTap: () => showPatientDetails(p["id"]),
            ),
          );
        },
      ),
    );
  }
}
