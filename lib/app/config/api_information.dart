class ApiInformation {
  // Base URL
  String baseUrl = 'http://212.87.212.106:3000';

  // Auth Endpoints
  String auth = '/auth';
  String login = '/login';
  String register = '/register';

  //Audio Endpoints
  String audio = '/audio';
  String getAudioSafe = '/allaudioguids';
  String getAudiobyPostion = '/audioGuid';

//BugReport Endpoints
String bug = '/bug';

  //AudioVideo Endpoints
  String audiovideo = '/getvideoInfo';
}
