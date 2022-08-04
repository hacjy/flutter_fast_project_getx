const isProd = bool.fromEnvironment('dart.vm.product');

class Server {
  ///测试
  //// test-scope-start
  static const String serverUrl = 'https://api.testenjoyfujitech.com/';
  //// test-scope-end

  ///生产
  //// prod-scope-start
  // static const String serverUrl = "https://api.enjoyfujitech.com/";
  //// prod-scope-end

  static const String baseUrl = '${Server.serverUrl}v1/';
}
