import 'package:flutter/material.dart';
import 'package:liveapp/config/constants.dart';

Future<dynamic> showConfirmDialog(BuildContext context) {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Image.asset(
                    'assets/images/x.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Container(
                height: 140,
                padding: const EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: Text(
                  '정말로 로그아웃 하시겠습니까?',
                  style: TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.27,
            margin: const EdgeInsets.only(bottom: 15, left: 20),
            child: RaisedButton(
              color: kConfirmDisabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                '예',
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: kH4FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.27,
            margin: const EdgeInsets.only(bottom: 15, right: 20),
            child: RaisedButton(
              color: kPrimaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                '아니요',
                style: TextStyle(
                  color: kButtonTextColor,
                  fontSize: kH4FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
