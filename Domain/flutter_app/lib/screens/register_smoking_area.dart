import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter_app/screens/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/globals.dart' as globals;


class RegisterSmokingAreaScreen extends StatefulWidget {
  @override
  _RegisterSmokingAreaScreenState createState() => _RegisterSmokingAreaScreenState();
}

class _RegisterSmokingAreaScreenState extends State<RegisterSmokingAreaScreen> {
  final AuthService _auth = AuthService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  final TextEditingController _textController = TextEditingController();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String url;
  @override

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<LocationData> getLatLong() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return _locationData = null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return _locationData = null;
      }
    }

    return _locationData = await location.getLocation();
  }

  Widget build(BuildContext context) {  //context는 앱이 돌아가고 있는 정보
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          body: Container(
            color: globals.isDarkMode ? Colors.black87 : Colors.white70,
            child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget> [
                  showImage(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Stack(
                          children: <Widget> [
                            _inputForm(size),
                            _authButton(size),
                          ],
                        ),
                        Container(height: size.height*0.07,),
                      ]
                  )
                ]
            ),
          )
      ),
    );
  }

  displayUploadScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: globals.isDarkMode ? Color.fromARGB(255, 15, 15, 15) : Colors.grey,
            size: 150,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton( shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10),
              ),
                child: Text(
                    'Upload Image',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    )
                ),
                color: globals.isDarkMode ? Color.fromARGB(150, 70, 170, 70) : Color.fromARGB(255, 70, 170, 70),
                onPressed: () => takeImage(context),
              )
          ),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('사진 업로드', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text('카메라', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  }
              ),
              SimpleDialogOption(
                  child: Text('갤러리', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  }
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  Widget showImage() {
    if(_imageFile == null)
      return displayUploadScreen();
    else
      return displayPicture();
  }

  displayPicture() {
    return Container(
        child: Padding(
          padding: const EdgeInsets.only(top:70.0),
          child: Stack(
            children: <Widget>[
              Image.file(File(_imageFile.path), width: 300, height:400, fit:BoxFit.fill),
              Positioned(
                child: IconButton(
                  onPressed: () {
                    _imageFile = null;
                    setState(() {});
                  },
                  icon: Icon(Icons.cancel, color: Colors.blueGrey,),
                ),
                right: 0,
                left: 250,
                bottom: 350,
              ),
            ],
          ),
        )
    );
  }

  Future getImage(ImageSource imageSource) async{
    Navigator.pop(context);
    PickedFile image = await _picker.getImage(source: imageSource);

    await setState((){
      _imageFile = image;
    });
    File imgfile = File(_imageFile.path);
    String filename = imgfile.path.split('/').last;
    StorageReference storageReference = _firebaseStorage.ref().child("image/${filename}");
    StorageUploadTask storageUploadTask = storageReference.putFile(File(_imageFile.path));
    await storageUploadTask.onComplete;

    url = await storageReference.getDownloadURL();
  }

  Widget _authButton(Size size) {
    getLatLong();
    return Positioned(
      left: size.width * 0.1,
      right: size.width * 0.1,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            var latitude = _locationData.latitude;
            var longitude = _locationData.longitude;
            _auth.addArea(_auth.SetSmokingArea(_textController.text, latitude, longitude, url));
            Navigator.pop(context);
            flutterToast("등록되었습니다.");
          },
          child: Text(
              "등록",
              style: TextStyle(
                  fontSize: 20,
                  color: globals.isDarkMode ? Colors.white70 : Color.fromARGB(255, 70, 70, 70)
              )
          ),
          style: ElevatedButton.styleFrom(
            primary: globals.isDarkMode ? Colors.black54 : Colors.white60,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width*0.1),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right:12.0, top:12.0, bottom:32),
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _textController, //텍스트를 가져옴
                    decoration: InputDecoration(
                        icon: Icon(Icons.message),
                        labelText: "간략한 설명"
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                  Container(height: 8),
                ]
            )

        ),
      ),
    );

  }

  void flutterToast(String text){
    Fluttertoast.showToast(msg: text,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        toastLength: Toast.LENGTH_SHORT
    );
  }


}