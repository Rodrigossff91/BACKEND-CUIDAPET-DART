import 'package:BACKEND_CUIDAPET_DART/application/database/i_database_connection.dart';
import 'package:BACKEND_CUIDAPET_DART/application/exceptions/database_exceptions.dart';
import 'package:BACKEND_CUIDAPET_DART/application/exceptions/user_exists_exceptions.dart';
import 'package:BACKEND_CUIDAPET_DART/application/exceptions/user_notfound_exceptions.dart';
import 'package:BACKEND_CUIDAPET_DART/application/helpers/cripty_helper.dart';
import 'package:BACKEND_CUIDAPET_DART/application/logger/i_loger.dart';
import 'package:BACKEND_CUIDAPET_DART/entities/user.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;
  UserRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query =
          '''insert usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id , social_id) 
       values(?,?,?,?,?,?)''';

      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        CriptyHelper.generateSha256Hash(user.password ?? ''),
        user.supplierId,
        user.socialKey
      ]);

      final userId = result.insertId;

      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Usuario ja cadastrado na base de dados', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseExceptions(message: 'Erro ao criar usuario', exception: e);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      var query =
          '''
      select *
      from usuario
      where email = ? and senha = ?''';

      if (supplierUser) {
        query += 'and fornecedor_id is not null';
      } else {
        query += 'and fornecedor_id is null';
      }

      final result = await conn.query(query,
          [email, CriptyHelper.generateSha256Hash(password), supplierUser]);

      if (result.isEmpty) {
        log.error('usuario ou senha invalidos!!!');
        throw UserNotFoundException(message: 'Usuário ou senha inválidos');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?)?.toString(),
          supplierId: userSqlData['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao realiar login', e, s);
      throw DatabaseExceptions(
        message: e.message,
      );
    } finally {
      await conn?.close();
    }
  }
}
