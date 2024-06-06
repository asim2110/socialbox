import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoControler extends GetxController {
  static UploadPhotoControler get to => Get.find();
  Future<String> uploadphoto({required XFile img}) async {
    var ref = FirebaseStorage.instance.ref().child("image/${img.name}");
    var uploadtask = await ref.putData(
      await img.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String url = await uploadtask.ref.getDownloadURL();
    return url;
  }
}
