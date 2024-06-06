import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:icon_craft/icon_craft.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialbox/Controllers/upload_photo.dart';
import 'package:socialbox/Models/friend_model.dart';
import 'package:socialbox/Models/message_model.dart';
import 'package:socialbox/Models/notification_save.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/Models/users_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ChatsRoom extends StatefulWidget {
  String? chatRoomId;
  FriendsModel? model;
  ChatsRoom({super.key, required this.chatRoomId, required this.model});

  @override
  State<ChatsRoom> createState() => _ChatsRoomState();
}

class _ChatsRoomState extends State<ChatsRoom> {
  String? _audioFilePath;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _path;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isUploaded = false;
  bool _isUploading = false;

  //Function to scroll to the bottom of the chat
  ScrollController _scrollController = ScrollController();
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    Get.put(UploadPhotoControler());
    getUserProfileToken();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
  }

  @override
  void dispose() {
    _recorder?.closeAudioSession();
    _player?.closeAudioSession();
    super.dispose();
  }  
  ///////Save Notification code in this function
  
  SaveNotification({required FriendsModel friendsModel,required MessageModel messageModel})async{
    var id =Uuid().v4();
    NotificationModel notificationModel =NotificationModel(
      title: widget.model!.Name,
      profile: widget.model!.profile,
      body: messageModel.msg,
      nid: id,
    );
    await FirebaseFirestore.instance.collection("Notification").doc(friendsModel.FriendId).collection("List").doc(id).set(notificationModel.toMap());
  }

  Future<void> _startRecording() async {
    PermissionStatus status = await Permission.microphone.status;

    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isDenied) {
      // Handle the microphone permission denial
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission denied.')));
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    _path = '${directory.path}/audio.mp4';

    await _recorder?.openAudioSession();
    await _recorder?.startRecorder(toFile: _path, codec: Codec.aacMP4);

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    await _recorder?.closeAudioSession();
    setState(() {
      _isRecording = false;
      _isUploaded = false;
    });
    _uploadAudio();
  }

  Future<void> _startPlaying() async {
    if (_path != null) {
      await _player?.openAudioSession();
      await _player?.startPlayer(
          fromURI: _path!,
          codec: Codec.aacMP4,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          });
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _stopPlaying() async {
    await _player?.stopPlayer();
    await _player?.closeAudioSession();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _uploadAudio() async {
    if (_path != null) {
      File file = File(_path!);
      try {
        setState(() {
          _isUploading = true;
        });
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final fileName = 'audio_messages/audio_$timestamp.mp4';

        await FirebaseStorage.instance.ref(fileName).putFile(file);

        // Get the download URL
        String? downloadUrl =
            await FirebaseStorage.instance.ref(fileName).getDownloadURL();

        // FFAppState().filePath = downloadUrl ?? '';

        setState(() {
          _audioFilePath = downloadUrl;
          _isUploaded = true;
          _isUploading = false;
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      print('Failed to read the recorded audio file');
    }
  }
  //////end voice code

  XFile? img;
  // Function to pick image from gallery
  pickImage() async {
    ImagePicker picker = ImagePicker();
    var pickedImg = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      setState(() {
        img = pickedImg;
      });
    }
  }

  TextEditingController controller = TextEditingController();

  //////this is notification API and start code from here
  http.Response? response;
  sendNotifcation(String msg) async {
    var body = {
      "registration_ids": [myUserToken],
      "notification": {
        "body": msg,
        "title": '${StaticUser.my_model!.Name} ',
        "android_channel_id": "pushnotificationapp",
        "sound": true,
      },
      "data": {
        "source": "chat",
      }
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization':
          'key=AAAAodWgQEQ:APA91bHGir4zjIgW9vTMUxGhLRJM-CTVSWJmrpRZmz9aMibz8FoRzNd-wJMQx-mjwnu0FkGGrz3DkD5r3iwNIEluNJ8lOC6NSVFVPImxWF_LH3a2-DqgW5yccytzhK4aVR5MXNc58n4h'
    };
    response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers, body: jsonEncode(body));
    if (response!.statusCode == 200) {
      print(response!.body);
    }
  }

  String myUserToken = "";
  getUserProfileToken() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.model!.id!)
        .get()
        .then((value) {
      if (value.data() != null) {
        UsersModel model = UsersModel.fromMap(value.data()!);
        setState(() {
          myUserToken = model.token!;
        });
      }
    });
  }

  ///end notification

  sendMessage() async {
    if (controller.text.isNotEmpty || _audioFilePath != null || img != null) {
      if (_audioFilePath != null) {
        await sendMessageToFirestore(message: "", audioUrl: _audioFilePath);
        _isRecording = false;
        _isUploaded = false;
      } else if (img != null) {
        String? imageurl = await UploadPhotoControler.to.uploadphoto(img: img!);
        if (imageurl != null) {
          await sendMessageToFirestore(message: "", imageUrl: imageurl);
        }
      } else {
        await sendMessageToFirestore(message: controller.text);
      }
      controller.clear();
      _scrollToBottom();

      setState(() {
        img = null;
        _audioFilePath = null;
      });
    }
  }

  sendMessageToFirestore(
      {required String message, String? audioUrl, String? imageUrl}) async {
    var msgid = Uuid().v4();
    var now = Timestamp.now();
    MessageModel messageModel = MessageModel(
        msg: message,
        msgID: msgid,
        time: now,
        audioUrl: audioUrl,
        imageUrl: imageUrl,
        type:
            imageUrl != null ? "image" : (audioUrl != null ? "voice" : "Text"),
        senderID: StaticUser.my_model!.UserId.toString());
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(widget.chatRoomId)
        .collection("Chats")
        .doc(msgid)
        .set(messageModel.toMap());
    sendNotifcation(message);
    SaveNotification(friendsModel:widget.model!, messageModel: messageModel);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 66,
        actions: [
          Row(children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 27,
              ),
            ),
            SizedBox(
              width: width * 0.03,
            ),
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(widget.model!.profile.toString()),
            ),
            SizedBox(
              width: width * 0.05,
            ),
            Container(
                width: width * 0.35,
                child: Text(
                  widget.model!.Name.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            SizedBox(
              width: width * 0.05,
            ),
            IconCraft(
              secondaryIconSizeFactor: height * 0.0007,
              Icon(
                Icons.video_call_sharp,
                size: 30,
              ),
              Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 159, 44, 10),
              ),
              alignment: Alignment.topRight,
            ),
            SizedBox(
              width: width * 0.05,
            ),
            Icon(
              Icons.call,
              size: 28,
            ),
            SizedBox(
              width: width * 0.05,
            ),
          ]),
        ],
      ),
      body: SingleChildScrollView(
        ///this code is for chat room

        child: Container(
          child: Column(children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("ChatRoom")
                    .doc(widget.chatRoomId)
                    .collection("Chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          height: height * 0.80,
                          width: width,
                          color: Color.fromARGB(255, 208, 208, 208),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel model = MessageModel.fromMap(
                                  snapshot.data!.docs[index].data());
                              return messages(
                                  MediaQuery.of(context).size, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text("data"),
                        );
                }),

            // Preview selected image
            if (img != null)
              Container(
                width: width,
                height: height * 0.50,
                child: Image.file(
                  File(img!.path),
                  fit: BoxFit.cover,
                ),
              ),

            Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    // maxLength: 170,
                    controller: controller,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () => pickImage(),
                              child: Icon(Icons.attachment)),
                          SizedBox(
                            width: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: _isUploading
                                ? CircularProgressIndicator(
                                    color: Color(0xffD8AD6F),
                                    strokeWidth: 2.0,
                                  )
                                : IconButton(
                                    icon: _isUploaded
                                        ? (_isPlaying
                                            ? Icon(Icons.stop)
                                            : Icon(Icons.play_arrow))
                                        : (_isRecording
                                            ? Icon(Icons.stop)
                                            : Icon(Icons.mic)),
                                    color: Color(0xffD8AD6F),
                                    iconSize: 30.0,
                                    onPressed: _isUploaded
                                        ? (_isPlaying
                                            ? _stopPlaying
                                            : _startPlaying)
                                        : (_isRecording
                                            ? _stopRecording
                                            : _startRecording),
                                  ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      prefixIcon: Icon(Icons.mood),
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.all(12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    size: 32,
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget messages(Size size, MessageModel model) {
    return Container(
      width: size.width,
      alignment: model.senderID == StaticUser.my_model!.UserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: model.senderID == StaticUser.my_model!.UserId
              ? Color.fromARGB(255, 49, 81, 128)
              : const Color.fromARGB(255, 231, 51, 69),
        ),
        child: model.type == "voice" && model.audioUrl != null
            ? GestureDetector(
                onTap: () {
                  // Play audio message
                  _playAudioMessage(model.audioUrl!);
                },
                child: Container(
                  height: 20,
                  width: 50,
                  child: Icon(Icons.play_arrow),
                ),
              )
            : model.type == "image" && model.imageUrl != null
                ? Image.network(
                    model.imageUrl!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : Text(
                    model.msg.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: model.senderID == StaticUser.my_model!.UserId
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Colors.black,
                    ),
                  ),
      ),
    );
  }

  void _playAudioMessage(String audioUrl) async {
    // Play audio message using Flutter Sound
    final player = FlutterSoundPlayer();
    await player.openAudioSession();
    await player.startPlayer(fromURI: audioUrl);
  }
}
