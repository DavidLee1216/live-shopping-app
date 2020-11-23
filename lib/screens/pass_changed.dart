import 'package:flutter/material.dart';
import 'package:liveapp/config/constants.dart';

class PassChangedScreen extends StatefulWidget {
  @override
  _PassChangedScreenState createState() => _PassChangedScreenState();
}

class _PassChangedScreenState extends State<PassChangedScreen> {
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
            SizedBox(height: 90),
            Text(
              '비밀번호가 정상적으로 변경되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: kH3FontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '원활한 사용을 위해 다시 로그인 하시길 바랍니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kForgotDescriptionTextColor,
                fontSize: kH5FontSize,
              ),
            ),
            SizedBox(height: 100),
            Container(
              height: 45,
              child: RaisedButton(
                color: kPrimaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text(
                  '로그인 하기',
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
