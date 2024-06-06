import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialbox/Models/friend_model.dart';
import 'package:socialbox/Models/request_model.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/Models/users_model.dart';
import 'package:socialbox/UI_Design/home.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  //This is for login and creat user  just login not set data
  Future<String?> registration({
    required String Name,
    required String Email,
    required String Phone,
    required String Password,
    required XFile img,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: Email,
        password: Password,
      )
          ///////call this function for Set data of Users from Creat Acount screen
          .then((value) {
        if (value.user != null) {
          SetData(Name, Email, Phone, Password, value.user!.uid, img);
        }
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String Email,
    required String Password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: Email,
        password: Password,
      )
          /////////Call the function getuses in signin to get for user id
          .then((value) {
        GetUser(
          id: value.user!.uid,
        );
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  ///Set users data in database with to model collection name is "Users"
  SetData(String name, String gmail, String phone, String password, String Id,
      XFile image) async {
    String? imgurl;
    if (image.path != "null") {
      await uploadphoto(img: image).then((value) {
        if (value.isNotEmpty) {
          imgurl = value;
        }
      });
    }

    UsersModel usersmodel = UsersModel(
      Name: name,
      Gmail: gmail,
      Phone: phone,
      Password: password,
      UserId: Id,
      profile: imgurl ?? "null",
    );

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(Id)
        .set(usersmodel.toMap());
    GetUser(id: Id);
  }

  Future<String> uploadphoto({required XFile img}) async {
    var ref = FirebaseStorage.instance.ref().child("image/${img.name}");
    var uploadtask = await ref.putData(
      await img.readAsBytes(),
      SettableMetadata(contentType: "image/jpeg"),
    );
    String url = await uploadtask.ref.getDownloadURL();
    return url;
  }

  // get all users in list without me
  GetUser({required String id}) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .get()
        .then((value) {
      if (value.data() != null) {
        StaticUser.my_model = UsersModel.fromMap(value.data()!);
        FirebaseFirestore.instance
            .collection("Users")
            .doc(id)
            .update({"token": StaticUser.my_token});
        Get.to(() => HomeScreen());
      }
    });
  }

  ///// getRequest complete process in which 3 phases
  SetRequest({required String receiverid, required String requestid}) async {
    /// koi same request to nhi hy bs yhi check krna hy
    /// ye query es liy lgaii hy kkoi request phly sy to nhi aii hwii bs es ko check krna
    QuerySnapshot<Map<String, dynamic>> getmyrequest = await FirebaseFirestore
        .instance
        .collection("Requests")
        .where("receiverId", isEqualTo: receiverid)
        .where("senderId", isEqualTo: StaticUser.my_model!.UserId.toString())
        .get();

    /// ya use hum k hamny us user ny phly request to ni ki hwi

    QuerySnapshot<Map<String, dynamic>> getuserrequest = await FirebaseFirestore
        .instance
        .collection("Requests")
        .where("senderId", isEqualTo: receiverid)
        .where("receiverId", isEqualTo: StaticUser.my_model!.UserId.toString())
        .get();
    if (getmyrequest.docs.isNotEmpty || getuserrequest.docs.isNotEmpty) {
    } else {
      RequestModel request = RequestModel(
          receiverId: receiverid,
          requestId: requestid,
          status: false,
          senderGmail: StaticUser.my_model!.Gmail.toString(),
          senderName: StaticUser.my_model!.Name.toString(),
          Senderprofile: StaticUser.my_model!.profile.toString(),
          senderId: StaticUser.my_model!.UserId.toString());
      await FirebaseFirestore.instance
          .collection("Requests")
          .doc(requestid)
          .set(request.toMap());
    }
  }

  //////Accept Request function complete
  AcceptRequest({required RequestModel requestModel}) async {
    ///Reciever side
    var friend1Id = Uuid().v4();
    FriendsModel mysidemodel = FriendsModel(
      Name: requestModel.senderName,
      Gmail: requestModel.senderGmail,
      id: requestModel.senderId,
      FriendId: friend1Id,
      profile: requestModel.Senderprofile,
    );
    await FirebaseFirestore.instance
        .collection("Friends")
        .doc(StaticUser.my_model!.UserId)
        .collection("List")
        .doc(friend1Id)
        .set(mysidemodel.toMap());

    ///sender side

    var freind2Id = Uuid().v4();
    FriendsModel senderside = FriendsModel(
      Name: StaticUser.my_model!.Name,
      Gmail: StaticUser.my_model!.Gmail,
      id: StaticUser.my_model!.UserId,
      profile: StaticUser.my_model!.profile,
      FriendId: freind2Id,
    );
    await FirebaseFirestore.instance
        .collection("Friends")
        .doc(requestModel.senderId)
        .collection("List")
        .doc(freind2Id)
        .set(senderside.toMap());

    /// friend bnjay ga lkn request model ma resruest pri rhy ge sirf status chage ho ga
    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(requestModel.requestId)
        .update({"status": true});
  }

  ////////Delete request
  DeleteRequest({required RequestModel requestModel}) async {
    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(requestModel.requestId)
        .delete();
  }
}
