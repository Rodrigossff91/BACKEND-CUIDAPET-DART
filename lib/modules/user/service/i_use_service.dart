import 'package:BACKEND_CUIDAPET_DART/entities/user.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/view_models/user_save_input_model.dart';

abstract class IUseService {
  Future<User> createUser(UserSaveInputModel user);

  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser);
}
