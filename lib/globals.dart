import 'dart:io';

import 'package:flutter/material.dart';

int id;
bool isLoggedIn = false;
String username = 'Вася Пупкин';
String address = 'https://geogramserver.conveyor.cloud/';

MemoryImage avatarOriginal;
bool avOrigLoaded = false;
MemoryImage avatar20px;
bool av20Loaded = false;
MemoryImage avatar120px;
bool av120Loaded = false;


void logout()
{
  isLoggedIn = false;
  avatarOriginal = null;
  avOrigLoaded = false;
  avatar20px = null;
  av20Loaded = false;
  avatar120px = null;
  av120Loaded = false;
}


/*
(() {
if (globals.isLoggedIn) {
return
}
return Container();
} ()),*/