import 'package:BACKEND_CUIDAPET_DART/application/routers/i_router_config.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [UserRouter()];

  RouterConfigure(
    this._router,
  );

  void configure() => _routers.forEach((r) {
        r.configure(_router);
      });
}
