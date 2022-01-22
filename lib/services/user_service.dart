import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:refriend/database/database_user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all user Information
  Future logedInUserInfo(int index) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    dynamic result = await DatabaseServiceUser().getUserInfos(uid);

    if (index == 1) {
      String username = result["name"];
      return username;
    } else if (index == 2) {
      return result["email"];
    }
  }

  //get profil Picture
//get profil Picture
  Future getProfilPicture() async {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final ref = FirebaseStorage.instance.ref("Profil/$uid/");
    final result = await ref.listAll();

    final before = DateTime.now();
    final urls = await _getDownloadLinks(result.items);
    final difference = DateTime.now().difference(before);
    print(difference);
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
