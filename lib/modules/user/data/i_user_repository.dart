import 'package:BACKEND_CUIDAPET_DART/entities/user.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
}
