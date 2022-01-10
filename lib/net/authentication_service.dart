import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/net/auth_state.dart';
import 'package:todo/net/user_creation.dart';

class AuthService {
  final FirebaseAuth _firebaseauth;
  final _auth = GoogleSignIn();
  final UserCreationService _userCreationService;
  AuthService(this._firebaseauth, this._userCreationService);

  Stream<User?> get authStateChanges => _firebaseauth.authStateChanges();

  Future<AuthState> signIn(String email, String password) async {
    try {
      await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthState(AuthStatus.authed, null);
    } on FirebaseAuthException catch (e) {
      return AuthState(AuthStatus.error, e.message.toString());
    }
  }

  Future<AuthState> signUp(String name, String email, String password) async {
    try {
      await _firebaseauth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _userCreationService.createUser(name: name, email: email);
      return AuthState(AuthStatus.authed, null);
    } on FirebaseAuthException catch (e) {
      return AuthState(AuthStatus.error, e.message.toString());
    }
  }

  Future<AuthState> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _auth.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      final UserCredential authResult =
          await _firebaseauth.signInWithCredential(credential);
      final User? user = authResult.user;
      if (authResult.additionalUserInfo!.isNewUser) {
        if (user != null) {
          await _userCreationService.createUser(
            name: user.displayName.toString(),
            email: user.email.toString(),
          );
        }
      }
      return AuthState(AuthStatus.authed, null);
    } catch (e) {
      return AuthState(AuthStatus.error, e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _firebaseauth.signOut();
  }
}
