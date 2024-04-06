//login view excpetions
class Usernotfoundauthexception implements Exception{}
class Wrongpasswordauthexception implements Exception{}

//register view exceptions
class WeakPasswordAuthException implements Exception{}
class Emailalreadyinuseauthexception implements Exception{}
class InvalidEmailAuthException implements Exception{}

//generic exception
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}