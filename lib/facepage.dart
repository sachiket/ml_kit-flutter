import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

class facepage extends StatefulWidget {
  @override
  createState() => _facepagestate();
}

class _facepagestate extends State<facepage>{

  File _imageFile;
  List<Face> _faces;
  void _getImageAndDetectFaces() async{
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    List<Face> faces = await faceDetector.processImage(image);
    if(mounted){
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: new Text('Face Detector'),
      ),
      body: imageandface(faces: _faces,imageFile: _imageFile),

      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo ),
      ),
    );
  }
}

class imageandface extends StatelessWidget{
  imageandface({this.imageFile,this.faces});
  final File imageFile;
  final List<Face> faces;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: ListView(
            children: faces.map<Widget>((f) => facecordinates(f)).toList(),
          ),
        ),
      ],
    );
  }
}

class facecordinates extends StatelessWidget{
  facecordinates(this.face);
  final Face face;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final pos = face.boundingBox;
    return ListTile(
      title: Text('${pos.bottom}, ${pos.left}, ${pos.bottom}, ${pos.right}'),
    );
  }
}