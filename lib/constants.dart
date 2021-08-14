import 'package:flutter/material.dart';

var myLinearGradient = LinearGradient(
  colors: [Color(0XFFFF7C22), Color(0XFFFFE600)],
);

var myAppBar = AppBar(
  centerTitle: true,
  flexibleSpace: Container(
    decoration: BoxDecoration(gradient: myLinearGradient),
  ),
);
