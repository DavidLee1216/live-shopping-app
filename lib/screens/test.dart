import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liveapp/config/constants.dart';
import 'package:liveapp/screens/video.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TestScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  TestScreen({Key key, this.cameras}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with WidgetsBindingObserver {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;
  String _videoPath;

  void _startRecording() async {
    try {
      if (!_cameraController.value.isRecordingVideo) {
        await _initializeCameraControllerFuture;

        final path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.mp4',
        );

        await _cameraController.startVideoRecording(path);
        setState(() {
          _videoPath = path;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _stopRecording() async {
    try {
      if (_cameraController.value.isRecordingVideo) {
        await _cameraController.stopVideoRecording();
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _changeCemera() {
    final camera = _cameraController.description == widget.cameras.first
        ? widget.cameras.last
        : widget.cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: true,
    );

    setState(() {
      _initializeCameraControllerFuture = _cameraController.initialize();
    });
  }

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.max,
      enableAudio: true,
    );
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Transform.scale(
                  scale: _cameraController.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 7, right: 15),
                        child: Icon(
                          Icons.close,
                          color: kButtonTextColor,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 25,
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kPrimaryTextColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Test',
                        style: TextStyle(
                          color: kButtonTextColor,
                          fontSize: kH2FontSize,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 200),
                        child: Center(
                          child: Text(
                            '테스트 방송 시작하기',
                            style: TextStyle(
                              color: kButtonTextColor,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '아래 버튼을 누리시면 라이브 방송이 시작됩니다.\n시작을 원하신다면 버튼을 눌러주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kButtonTextColor,
                          fontSize: kH4FontSize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 30, 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (_videoPath == null ||
                              _cameraController.value.isRecordingVideo)
                            SizedBox(width: 50),
                          if (_cameraController.value.isRecordingVideo)
                            Container(
                              height: 50,
                              width: _videoPath == null ? 180 : 140,
                              child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                borderSide: BorderSide(
                                  color: kButtonTextColor,
                                  width: 2,
                                ),
                                onPressed: _stopRecording,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kButtonTextColor,
                                          ),
                                        ),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          margin: const EdgeInsets.all(15 / 2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: kPrimaryTextColor,
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '녹화 종료',
                                      style: TextStyle(
                                        color: kButtonTextColor,
                                        fontSize: kH2FontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (!_cameraController.value.isRecordingVideo)
                            Container(
                              height: 50,
                              width: _videoPath == null ? 180 : 140,
                              child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                borderSide: BorderSide(
                                  color: kButtonTextColor,
                                  width: 2,
                                ),
                                onPressed: _startRecording,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kButtonTextColor,
                                          ),
                                        ),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          margin: const EdgeInsets.all(15 / 2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kPrimaryButtonColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '녹화 시작',
                                      style: TextStyle(
                                        color: kButtonTextColor,
                                        fontSize: kH2FontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (_videoPath != null &&
                              !_cameraController.value.isRecordingVideo)
                            Container(
                              height: 50,
                              width: _videoPath == null ? 180 : 140,
                              child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                borderSide: BorderSide(
                                  color: kButtonTextColor,
                                  width: 2,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                        videoPath: _videoPath,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          padding: const EdgeInsets.all(15 / 2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kButtonTextColor,
                                          ),
                                        ),
                                        Icon(
                                          Icons.play_arrow,
                                          size: 30,
                                          color: kPrimaryButtonColor,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '녹화 보기',
                                      style: TextStyle(
                                        color: kButtonTextColor,
                                        fontSize: kH2FontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: _changeCemera,
                            child: Container(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/icons/camerachange.svg',
                                color: kButtonTextColor,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
