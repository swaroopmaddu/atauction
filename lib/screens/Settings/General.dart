import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool isNotificationEnable = true;
  String? _currency = "INR";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allow Push Notifications",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Switch(
                    onChanged: changeNotificationSettings,
                    value: isNotificationEnable,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Default Currency",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _currency,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'USD',
                      'INR',
                      'EUR',
                      'CHF',
                      'CAD',
                      'AUD',
                      'JPY',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _currency = value;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeNotificationSettings(bool value) {
    isNotificationEnable = value;
  }
}
