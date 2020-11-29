import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:liveapp/config/constants.dart';
import 'package:liveapp/utils/encrypt.dart';

class ChangePassScreen extends StatefulWidget {
  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  bool _isPasswordValid = false;
  bool _isNewPasswordValid = false;
  bool _isConfirmValid = false;
  final _passwordInputController = TextEditingController();
  final _newPasswordInputController = TextEditingController();
  final _confirmInputController = TextEditingController();

  Future<void> _changePass(BuildContext context) async {
    try {
      final password = _passwordInputController.text;
      final newPassword = _newPasswordInputController.text;

      final hashedPassword = hashString(password);
      final hashedNewPassword = hashString(newPassword);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        '$apiHost/changePass',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: {'oldPassword': hashedPassword, 'newPassword': hashedNewPassword},
      );

      if (response.statusCode != 200) {
        throw Exception('네트워크 오류');
      }

      final payload = json.decode(response.body)['payload'];
      if (payload == 2) {
        throw Exception('현재 비밀번호가 올바르지 않습니다.');
      } else if (payload == 0) {
        throw Exception('비밀번호가 변경되지 않았습니다.');
      } else {
        Fluttertoast.showToast(
          msg: '비밀번호가 변경되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      Navigator.pushReplacementNamed(context, '/passchanged');
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
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Text(
                      '비밀번호 변경',
                      style: TextStyle(
                        color: kPrimaryTextColor.withOpacity(0.5),
                        fontSize: kH2FontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryTextColor.withOpacity(0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Image.asset(
                        'assets/images/x.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 80),
            Text(
              '비밀번호 변경',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: kH3FontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                Divider(
                  thickness: 3,
                  color: kPrimaryTextColor,
                  indent: MediaQuery.of(context).size.width * 0.25,
                  endIndent: MediaQuery.of(context).size.width * 0.25,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  child: Divider(
                    thickness: 1,
                    color: kPrimaryTextColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '신규 비밀번호를 입력해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: kH3FontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '안전한 사용을 위해 비밀번호를 주기적으로 변경해주세요.\n변경한 비밀번호로 다시 로그인해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kForgotDescriptionTextColor,
                fontSize: kH5FontSize,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 30,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.text,
                controller: _passwordInputController,
                onChanged: (text) {
                  setState(() {
                    _isPasswordValid = text.length > 3;
                  });
                },
                style: TextStyle(
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
                      color: kDisabledButtonColor.withOpacity(0.5),
                    ),
                  ),
                  hintText: '현재 비밀번호',
                  hintStyle: TextStyle(
                    color: kDisabledButtonColor.withOpacity(0.5),
                    fontSize: kH3FontSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 30,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.text,
                controller: _newPasswordInputController,
                onChanged: (text) {
                  setState(() {
                    var matchPoint = 0;
                    if (text.contains(new RegExp(r'[A-Z]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[0-9]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[0-9]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      matchPoint += 1;
                    }
                    final length = text.length >= 8 && text.length <= 12;
                    final match = text == _confirmInputController.text;
                    _isNewPasswordValid = length && match && matchPoint >= 3;
                  });
                },
                style: TextStyle(
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
                      color: kDisabledButtonColor.withOpacity(0.5),
                    ),
                  ),
                  hintText: '새 비밀번호',
                  hintStyle: TextStyle(
                    color: kDisabledButtonColor.withOpacity(0.5),
                    fontSize: kH3FontSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 30,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.text,
                controller: _confirmInputController,
                onChanged: (text) {
                  setState(() {
                    var matchPoint = 0;
                    if (text.contains(new RegExp(r'[A-Z]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[0-9]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[0-9]'))) {
                      matchPoint += 1;
                    }
                    if (text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      matchPoint += 1;
                    }
                    final length = text.length >= 8 && text.length <= 12;
                    final match = text == _newPasswordInputController.text;
                    _isConfirmValid = length && match && matchPoint >= 3;
                  });
                },
                style: TextStyle(
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
                      color: kDisabledButtonColor.withOpacity(0.5),
                    ),
                  ),
                  hintText: '새 비밀번호 확인',
                  hintStyle: TextStyle(
                    color: kDisabledButtonColor.withOpacity(0.5),
                    fontSize: kH3FontSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '비밀번호는 8~12자 이내로 영문(대,소문자), 숫자, 특수문자 3가지 조합 중\n2가지 이상을 조합하셔서 만드시면 됩니다.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: kPrimaryTextColor.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
            SizedBox(height: 60),
            Container(
              height: 45,
              child: RaisedButton(
                color: kPrimaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed:
                    _isPasswordValid && _isNewPasswordValid && _isConfirmValid
                        ? () => _changePass(context)
                        : null,
                child: Text(
                  '변경하기',
                  style: TextStyle(
                    color: kButtonTextColor,
                    fontSize: kH4FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
