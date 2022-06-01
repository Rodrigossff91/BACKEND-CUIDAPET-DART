import 'package:BACKEND_CUIDAPET_DART/entities/user.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/data/i_user_repository.dart';
import 'package:BACKEND_CUIDAPET_DART/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_use_service.dart';

@LazySingleton(as: IUseService)
class UseService implements IUseService {
  IUserRepository userRepository;
  UseService({
    required this.userRepository,
  });
  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEtity = User(
        email: user.email,
        password: user.password,
        registerType: 'App',
        supplierId: user.supplierId);

    return userRepository.createUser(userEtity);
  }
}
