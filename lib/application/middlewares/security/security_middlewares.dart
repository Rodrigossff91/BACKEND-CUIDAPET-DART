import 'dart:convert';

import 'package:BACKEND_CUIDAPET_DART/application/helpers/jwt_helper.dart';
import 'package:BACKEND_CUIDAPET_DART/application/logger/i_loger.dart';
import 'package:BACKEND_CUIDAPET_DART/application/middlewares/middlewares.dart';
import 'package:BACKEND_CUIDAPET_DART/application/middlewares/security/security_skip_url.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

class SecurityMiddlewares extends Middlewares {
  final ILogger log;
  final skypUrl = <SecuritySkipUrl>[
    SecuritySkipUrl(method: 'POST', url: '/auth/register')
  ];

  SecurityMiddlewares(this.log);

  @override
  Future<Response> execute(Request request) async {
    try {
      if (skypUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }
      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');

      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];
      var claims = JwtHelper.getClaims(authorizationToken);

      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }

      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'];
      final supplierId = claimsMap['supplier'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
        'supplier': supplierId
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log.error('Erro ao validar token Jwt', e, s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      log.error('Interna Server Error', e, s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
