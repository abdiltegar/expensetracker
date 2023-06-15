import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';

final boxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const hintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const labelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const displayNameStyle = TextStyle(
  color: mainDarkBlue,
  fontSize: 14,
  fontFamily: 'OpenSans',
);

const displayEmailStyle = TextStyle(
  color: Colors.black54,
  fontSize: 11,
  fontFamily: 'OpenSans',
);

const incomeNumberStyle = TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
const outcomeNumberStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold);

const displayDayStyle = TextStyle(color: Colors.black, fontSize: 18);
const displayDateStyle = TextStyle(color: mainDarkBlue, fontSize: 15, fontWeight: FontWeight.bold);
