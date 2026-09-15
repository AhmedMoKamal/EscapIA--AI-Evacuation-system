class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://mariamrishdi67-001-site1.ltempurl.com';

  static const String buildApiUrl = '$baseUrl/api/Build';
  static const String hubUrl = '$baseUrl/buildingHub';
  static const String incidentsEndpoint = '$baseUrl/api/Incidents/incidents';
  static String incidentReportEndpoint(String incidentId) =>
      '$baseUrl/api/Incidents/$incidentId/report';
  static const String authEndpoint = '$baseUrl/api/Auth';
  static const String profileEndpoint = '$baseUrl/api/Auth/profile';
}
