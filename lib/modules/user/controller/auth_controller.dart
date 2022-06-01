import 'dart:async';
import 'dart:convert';

import 'package:BACKEND_CUIDAPET_DART/application/exceptions/user_exists_exceptions.dart';
import 'package:BACKEND_CUIDAPET_DART/application/logger/i_loger.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/service/i_use_service.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUseService userService;
  ILogger log;
  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(
          jsonEncode({'message': 'Cadastro realizado com sucesso'}));
    } on UserExistsException {
      return Response(400,
          body: jsonEncode(
              {'message': 'Usuário já cadastrado na base de dados'}));
    } catch (e) {
      log.error(
        'Erro ao cadastrar usuario',
        e,
      );
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
