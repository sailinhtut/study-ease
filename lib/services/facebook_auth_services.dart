// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:nb_utils/nb_utils.dart';

// class FacebookAuthProvider {
//   FacebookAuthProvider._private();
//   static FacebookAuthProvider? _instance;

//   static FacebookAuthProvider get instance =>
//       _instance ??= FacebookAuthProvider._private();

//   Future<FacebookUser?> logIn() async {
//     final loggingResult = await FacebookAuth.instance.login();
//     if (loggingResult.status == LoginStatus.success) {
//       // Successful
//       final loggedUserData = await FacebookAuth.instance.getUserData();
//       print("output : $loggedUserData");
//       return FacebookUser(
//           email: loggedUserData['email'],
//           profile: loggedUserData['picture']['data']['url'],
//           name : loggedUserData['name'],
//           uid: loggedUserData['id']);
//     } else {
//       // Failed
//       return null;
//     }
//   }

//   Future<void> logOut() async {
//     await FacebookAuth.instance.logOut();
//   }
// }

// class FacebookUser {
//   final String? email;
//   final String? uid;
//   final String? profile;
//   final String? name;

//   FacebookUser({this.email, this.uid, this.profile,this.name});
// }
