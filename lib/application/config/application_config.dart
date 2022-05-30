import 'package:dotenv/dotenv.dart' show load, env;

class ApplicationConfig {
  void loadConfigApplication() async {
    await _loadEnv();

    print(env['']);
  }

  Future<void> _loadEnv() async => load();
}
