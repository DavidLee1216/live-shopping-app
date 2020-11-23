import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:liveapp/config/constants.dart';
import 'package:liveapp/screens/test.dart';
import 'package:liveapp/screens/signin.dart';
import 'package:liveapp/ui/confirm.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>> _liveNow;
  Future<List<dynamic>> _liveList;
  String _nickName = '';
  String _token;
  Timer _timer;
  int _activeTime;
  DateTime _liveDate;
  bool canStartStreaming = false;

  void _startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!canStartStreaming && _activeTime != null && _liveDate != null) {
        final startingTime = _liveDate.subtract(Duration(minutes: _activeTime));
        if (startingTime.isBefore(DateTime.now())) {
          setState(() {
            canStartStreaming = true;
          });
        }
      }
    });
  }


  static const platformMethodChannel = const MethodChannel('com.connectionsoft.liveapp/cast');

  _nativeTest(BuildContext context, int liveId, String solutionId) async {
    try {
      final channelId = 'com.connectionsoft.liveapp/cast/test';
      final result = await platformMethodChannel.invokeMethod(
        'startStreaming',
        {"channelId": channelId},
      );
      print(result);
    } on PlatformException catch (e) {
      // TODO: error
      print(e);
    }
  }

  String _dateToLocalString(String dateString) {
    final liveDateTime = DateTime.parse(dateString);
    return '${liveDateTime.year}년 ${liveDateTime.month}월 ${liveDateTime.day}일 ${liveDateTime.hour}시 ${liveDateTime.minute}분 방송시작';
  }


  Future<List<dynamic>> _startStreaming(BuildContext context, int liveId, int solutionId) async {
    try {
      // TODO: solution id
      final response = await http.post(
        '$apiHost/liveStart',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
        body: {'liveId': liveId.toString(), 'solutionId': 1.toString()},
      );

      if (response.statusCode != 200) {
        throw Exception('네트워크 오류');
      }

      final payload = json.decode(response.body)['payload'];

      return payload;
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
      return null;
    }
  }


  Future<List<dynamic>> _fetchLiveNow() async {
    try {
      final response = await http.get(
        '$apiHost/liveNow',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        throw Exception('네트워크 오류');
      }

      final payload = json.decode(response.body)['payload'];

      return payload;
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
      return null;
    }
  }


  Future<List<dynamic>> _fetchLiveList() async {
    try {
      final response = await http.get(
        '$apiHost/liveList',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        throw Exception('네트워크 오류');
      }

      final payload = json.decode(response.body)['payload'];

      return payload;
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
      return null;
    }
  }


  Future<SharedPreferences> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: SignInScreen(),
          ),
        ),
      );
    }
    return prefs;
  }


  Future<void> _signOut() async {
    final confirmed = await showConfirmDialog(context);
    if (confirmed) {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushNamed(context, '/signin');
    }
  }

  @override
  void initState() {
    super.initState();

    _startTimer();
    _getUserInfo().then((prefs) {
      setState(() {
        _token = prefs.getString('token');
        _nickName = prefs.getString('nickName');
      });
      _liveNow = _fetchLiveNow();
      _liveList = _fetchLiveList();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            // header
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 62),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo_dark.png',
                    width: 60,
                    height: 24,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          _nickName,
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: kH2FontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' 님',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: kH2FontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // live item header
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/red_dot.png', width: 10, height: 10),
                SizedBox(width: 5),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: kPrimaryButtonColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GmarketSans',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '예정 상품',
                  style: TextStyle(
                    color: kPrimaryButtonColor,
                    fontSize: kH1FontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NEXONLv2Gothic',
                  ),
                ),
              ],
            ),
            // divider
            Container(
              height: 2,
              margin: const EdgeInsets.only(top: 5.0, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [kPrimaryTextColor, kPrimaryButtonColor],
                ),
              ),
            ),
            // streaming item
            FutureBuilder<List<dynamic>>(
              future: _liveNow,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('예정 방송이 없습니다.'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final liveItem = snapshot.data[0];
                final liveId = liveItem['liveId'];
                final solutionId = liveItem['solutionId'];
                final imageUrl = liveItem['imgMainUrl'];
                final title =
                    liveItem['liveName'] + '\n' + liveItem['liveSlogan'];

                final liveDateTime = DateTime.parse(liveItem['liveDate']);
                final startTime =
                    '${liveDateTime.year}년 ${liveDateTime.month}월 ${liveDateTime.day}일\n${liveDateTime.hour}시 ${liveDateTime.minute}분 방송시작';

                _activeTime = liveItem['activeTime'];
                _liveDate = liveDateTime;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // image
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.width * 0.43,
                      child: Image.network(imageUrl),
                    ),
                    // description
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            startTime,
                            style: TextStyle(
                              color: kPrimaryButtonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              fontSize: kH2FontSize,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: ButtonTheme(
                              child: RaisedButton(
                                color: kPrimaryButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),


                                // onPressed: canStartStreaming
                                //     ? () => _startStreaming(
                                //   context,
                                //   liveId,
                                //   solutionId,
                                // )
                                //     : null,

                                onPressed: canStartStreaming
                                    ? () => _nativeTest(
                                  context,
                                  liveId,
                                  solutionId,
                                )
                                    : null,

                                child: Text(
                                  '방송 시작하기',
                                  style: TextStyle(
                                    color: kButtonTextColor,
                                    fontSize: kH2FontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Divider(thickness: 1, color: kPrimaryTextColor.withOpacity(0.5)),
            SizedBox(height: 50),
            // later header
            Text(
              '이후 방송 상품',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: kH1FontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NEXONLv2Gothic',
              ),
            ),
            Divider(thickness: 2, color: kPrimaryTextColor),
            // later items
            FutureBuilder<List<dynamic>>(
              future: _liveList,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('준비된 방송이 없습니다.'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final items = snapshot.data;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Image.network(items[index]['imgMainUrl']),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  items[index]['liveName'] +
                                      '\n' +
                                      items[index]['liveSlogan'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: kH4FontSize,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  _dateToLocalString(items[index]['liveDate']),
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: kH3FontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1, color: kPrimaryTextColor),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          backgroundColor: kBackgroundColor,
          selectedItemColor: kPrimaryButtonColor,
          unselectedItemColor: kPrimaryTextColor.withOpacity(0.5),
          onTap: (index) async {
            if (index == 0) {
              final cameras = await availableCameras();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestScreen(
                    cameras: cameras,
                  ),
                ),
              );
            } else if (index == 2) {
              Navigator.pushNamed(context, '/changepass');
            } else if (index == 3) {
              await _signOut();
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/test.svg',
                color: kPrimaryTextColor.withOpacity(0.5),
                width: 24,
                height: 24,
              ),
              label: '테스트 방송',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/list.svg',
                color: kPrimaryButtonColor,
                width: 24,
                height: 24,
              ),
              label: '방송 목록',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/pass.svg',
                color: kPrimaryTextColor.withOpacity(0.5),
                width: 24,
                height: 24,
              ),
              label: '비밀번호 변경',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/logout.svg',
                color: kPrimaryTextColor.withOpacity(0.5),
                width: 24,
                height: 24,
              ),
              label: '로그아웃',
            ),
          ],
        ),
      ),
    );
  }
}
