import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main(){
  group('Mock Auhtentication',(){
    final provider=MockAuthProvider();

    test('Should not be initialized at the start',(){
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized',(){
      expect(provider.logOut(),
      throwsA(const TypeMatcher<NotInitializedEception>()));
    });

    test('Should be able to initialize',()async{
      await provider.initialize();
      expect(provider.isInitialized,true);
    });

    test('User should be null after initialization',(){
      expect(provider.currentUser,null);
    },timeout:const Timeout(Duration(seconds:2)),
    );

    test('Should be able to initialize in less than 2 seconds',() async {
      await provider.initialize();
      expect(provider.isInitialized,true);
    });

    test('Create user should delegate to login funtion',()async{
      final bademailuser=provider.createUser(
        email: 'example@ex.com', 
        password: 'anypass');
      expect(bademailuser,throwsA(const TypeMatcher<Usernotfoundauthexception>()));

      final badpassworduser=provider.createUser(email: 'anyemail', password: 'example');
      expect(badpassworduser, throwsA(const TypeMatcher<Wrongpasswordauthexception>()));

      final user=await provider.createUser(email: 'exam', password: 'ple');
      expect(provider.currentUser,user);
      expect(user.isEmailVerified,false);
    });

    test('Logged in user should be able to get verified',(){
      provider.sendEmailVerification();
      final user=provider.currentUser;
      expect(user,isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in', () async{
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user=provider.currentUser;
      expect(user,isNotNull);
    });
  });
}

class NotInitializedEception implements Exception{}

class MockAuthProvider implements AuthProvider{

  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized=> _isInitialized;

  @override
  Future<AuthUser> createUser({required String email, required String password})async {
     
    await Future.delayed(const Duration(seconds:1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds:1));
    _isInitialized=true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if(!isInitialized) throw NotInitializedEception();
    if(email=='example@ex.com') throw Usernotfoundauthexception();
    if(password=='example') throw Wrongpasswordauthexception();
    const user=AuthUser(isEmailVerified: false);
    _user=user;
    return Future.value(user);
  }

  @override
  Future<void> logOut()async {
    if(!isInitialized) throw NotInitializedEception();
    if(_user==null) throw Usernotfoundauthexception();
    await Future.delayed(const Duration(seconds: 1));
    _user=null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialized) throw NotInitializedEception();
    final user=_user;
    if(user==null) throw Usernotfoundauthexception();
    const newuser=AuthUser(isEmailVerified: true);
    _user=newuser;
  }
  
}