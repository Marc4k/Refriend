import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:refriend/database/database_user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all user Information
  Future logedInUserInfo() async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    dynamic result = await DatabaseServiceUser().getUserInfos(uid);
    String userName = result["name"];
    return userName;
  }

  Future chanceProfilPicture(String newUrl) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    dynamic userData = await DatabaseServiceUser(uid: uid).getUserInfos(uid);

    DateTime birthday = DateTime.fromMicrosecondsSinceEpoch(
        userData["birthday"].microsecondsSinceEpoch);

    DatabaseServiceUser(uid: uid)
        .updateUserData(userData["email"], userData["name"], birthday, newUrl);
  }

  Future chanceName(String userName) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    dynamic userData = await DatabaseServiceUser(uid: uid).getUserInfos(uid);

    DateTime birthday = DateTime.fromMicrosecondsSinceEpoch(
        userData["birthday"].microsecondsSinceEpoch);

    DatabaseServiceUser(uid: uid)
        .updateUserData(userData["email"], userName, birthday, userData["url"]);
  }

  Future getProfilPictureWithLink() async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    dynamic profilUrl = await DatabaseServiceUser().getUserProfilUrl(uid);

    return profilUrl;
  }

//get profil Picture
  Future getProfilPicture() async {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final ref = FirebaseStorage.instance.ref("Profil/$uid/");
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);

    String stringUrl = urls[0];
    return stringUrl;
  }

//get profil Picture
  Future getProfilPictureWithUserId(String userId) async {
    final ref = FirebaseStorage.instance.ref("Profil/$userId/");
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    String stringUrl = urls[0];
    return stringUrl;
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
}
