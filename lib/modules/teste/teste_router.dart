import 'package:BACKEND_CUIDAPET_DART/application/routers/i_router_config.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/teste/teste_controller.dart';
import 'package:shelf_router/src/router.dart';

class TesteRouter implements IRouter {
  @override
  void configure(Router router) {
    router.mount('/hello/', TesteController().router);
  }
}
