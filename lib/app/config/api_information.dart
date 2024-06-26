class ApiInformation {
  // Base URL
  String baseUrl = 'http://api.ruhrkulturerlebnis.de';

  // Auth Endpoints
  String auth = '/auth';
  String login = '/login';
  String register = '/register';

  //Audio Endpoints
  String audio = '/audio';
  String getAudioSafe = '/allaudioguids';
  String getAudio = '/';

  //AudioVideo Endpoints
  String audiovideo = '/getvideoInfo';
}
