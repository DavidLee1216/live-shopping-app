import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:liveapp/config/constants.dart';
import 'package:liveapp/utils/encrypt.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmValid = false;
  final _usernameInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  final _confirmInputController = TextEditingController();

  Future<void> _resetPass(BuildContext context) async {
    try {
      final username = _usernameInputController.text;
      final password = _passwordInputController.text;

      final hashedPassword = hashString(password);

      final response = await http.post(
        '$apiHost/resetPass',
        body: {'username': username, 'password': hashedPassword},
      );

      if (response.statusCode != 200) {
        throw Exception('네트워크 오류');
      }

      final payload = json.decode(response.body)['payload'];
      if (payload != 1) {
        throw Exception('비밀번호가 초기화되지 않았습니다.');
      }

      Fluttertoast.showToast(
        msg: '비밀번호가 초기화 되었습니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context);
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
                      '계정 찾기',
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
              '계정 찾기',
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
              '회원가입 시 등록된 연락처를 입력해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: kH3FontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '해당 연락처로 인증번호를 발송하였습니다.\n3분내로 인증번호를 올바르게 입력해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kForgotDescriptionTextColor,
                fontSize: kH5FontSize,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.phone,
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
                hintText: '핸드폰 번호',
                hintStyle: TextStyle(
                  color: kDisabledButtonColor.withOpacity(0.5),
                  fontSize: kH3FontSize,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 30,
                    child: OutlineButton(
                      textColor: kPrimaryTextColor,
                      color: kBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: kPrimaryTextColor),
                      ),
                      onPressed: () {},
                      child: Text(
                        '인증하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kH4FontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
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
                hintText: '인증번호 입력',
                hintStyle: TextStyle(
                  color: kDisabledButtonColor.withOpacity(0.5),
                  fontSize: kH3FontSize,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 30,
                    child: OutlineButton(
                      textColor: kPrimaryTextColor,
                      color: kBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: kPrimaryTextColor),
                      ),
                      onPressed: () {},
                      child: Text(
                        '확인하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kH4FontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            Text(
              '계정 재등록',
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
              '비밀번호 재설정을 위한 본인 확인이 완료되었습니다.\n새로운 비밀번호를 등록 후 사용해주세요.',
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
                keyboardType: TextInputType.text,
                controller: _usernameInputController,
                onChanged: (text) {
                  setState(() {
                    _isUsernameValid = text.length > 3;
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
                  hintText: 'ID',
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
                  hintText: 'PW',
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
                    _isConfirmValid = text.length > 3 &&
                        text == _passwordInputController.text;
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
                  hintText: 'PW 확인',
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
                    _isUsernameValid && _isPasswordValid && _isConfirmValid
                        ? () => _resetPass(context)
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
