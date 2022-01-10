import 'package:todo/data/models/user.dart';
import 'package:todo/data/repo/user_repo.dart';

class UserCreationService {
  final UserRepo _userRepo;
  UserCreationService(this._userRepo);

  Future<void> createUser(
      {String? id, String name = "", String email = ""}) async {
    await _userRepo.saveUser(
      User(
        email: email,
        username: createUsername(email),
        name: name,
      ),
    );
  }

  String createUsername(String email) {
    String username = email.split("@")[0];
    if (username.length <= 7) return username;
    return username.substring(0, 7);
  }
}
