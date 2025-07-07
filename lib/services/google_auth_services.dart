// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthProvider {
//   GoogleAuthProvider._private();
//   static GoogleAuthProvider? _instance;
//   static GoogleAuthProvider get instance =>
//       _instance ??= GoogleAuthProvider._private();

//   // Google Sign In
//   Future<GoogleUser?> googleSignIn() async {
//     final googleSignIn = GoogleSignIn();
//     final signedAccount = await googleSignIn.signIn();
//     if (signedAccount != null) {
//       final signedAccountAuthentication = await signedAccount.authentication;

//       // Your Can Get Token Here

//       final googleUser = GoogleUser(
//           name: signedAccount.displayName,
//           profile: signedAccount.photoUrl?.replaceAll("s96-c", "s192-c"),
//           email: signedAccount.email);

//       return googleUser;
//     } else {
//       return null;
//     }
//   }

//   // Google Sign Out
//   Future<void> googleSignOut() async {
//     await GoogleSignIn().signOut();
//   }
// }

// class GoogleUser {
//   final String? name;
//   final String? profile;
//   final String? email;

//   GoogleUser({this.name, this.profile, this.email});
// }
