import 'package:coras/config/app_config.dart';

class BhwViewEncodedAssessmentController {
  Future<List<dynamic>> fetchPatients() async {
    final response = await ApiClient.dio.get("/view/patients/");
    return response.data;
  }

  Future<Map<String, dynamic>> fetchPatientDetail(int id) async {
    final response = await ApiClient.dio.get("/view/patients/$id/");
    return response.data;
  }
}
