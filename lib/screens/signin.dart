import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:liveapp/config/constants.dart';
import 'package:liveapp/utils/encrypt.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;
  final _usernameInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      final username = _usernameInputController.text;
      final password = _passwordInputController.text;

      final hashedPassword = hashString(password);

      final response = await http.post(
        '$apiHost/login',
        body: {'username': username, 'password': hashedPassword},
      );

      if (response.statusCode != 200) {
        throw Exception('아이디와 비밀번호를 확인해 주세요.');
      }

      final payload = json.decode(response.body)['payload'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nickName', payload['nickName']);
      await prefs.setString('token', payload['token']);
      Navigator.pop(context, payload);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kPrimaryTextColor,
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            child: VerticalDivider(
              thickness: 1,
              color: kButtonTextColor.withOpacity(0.4),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/login.png',
                  height: MediaQuery.of(context).size.height * 0.55,
                  fit: BoxFit.fitHeight,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55 * 0.14,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 72,
                      height: 30,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '어서오세요.\n라이브쇼핑 방송용 어플입니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kButtonTextColor,
                              fontSize: kH2FontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(
                      '쉽고 재밋는 방송 되시길 바라겠습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: kButtonTextColor,
                      ),
                    ),
                    SizedBox(height: 50),
                    // email field
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // label
                          Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: Text(
                              'ID',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kButtonTextColor,
                                fontSize: kH3FontSize,
                              ),
                            ),
                          ),
                          // email input field
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: TextField(
                              controller: _usernameInputController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: kButtonTextColor,
                                fontSize: kH3FontSize,
                              ),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kPrimaryButtonColor,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kDisabledButtonColor,
                                  ),
                                ),
                                hintText: '아이디를 입력해주세요.',
                                hintStyle: TextStyle(
                                  color: kDisabledButtonColor,
                                  fontSize: kH3FontSize,
                                ),
                                suffixIcon: _isUsernameValid == true
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Image.asset(
                                          'assets/images/accept.png',
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Image.asset(
                                          'assets/images/decline.png',
                                        ),
                                      ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  _isUsernameValid = text.length > 3;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    // password field
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // label
                          Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: Text(
                              'PW',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kButtonTextColor,
                                fontSize: kH3FontSize,
                              ),
                            ),
                          ),
                          // password input field
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: TextField(
                              controller: _passwordInputController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: kButtonTextColor,
                                fontSize: kH3FontSize,
                              ),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kPrimaryButtonColor,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kDisabledButtonColor,
                                  ),
                                ),
                                hintText: '비밀번호를 입력해주세요.',
                                hintStyle: TextStyle(
                                  color: kDisabledButtonColor,
                                  fontSize: kH3FontSize,
                                ),
                                suffixIcon: _isPasswordValid == true
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Image.asset(
                                          'assets/images/accept.png',
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Image.asset(
                                          'assets/images/decline.png',
                                        ),
                                      ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  _isPasswordValid = text.length > 3;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // button
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonTheme(
              child: RaisedButton(
                color: kSignInButtonColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: _isUsernameValid && _isPasswordValid
                    ? () => _signIn(context)
                    : null,
                child: Text(
                  '로그인하기',
                  style: TextStyle(
                    color: kPrimaryButtonColor,
                    fontSize: kH4FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(top: 35),
              child: Text(
                '|     계정 찾기     |',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: kButtonTextColor,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/forgot');
            },
          ),
        ],
      ),
    );
  }
}
