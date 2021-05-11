import 'dart:io';

import 'package:flutter/material.dart';

class MyPhoto {
  MyPhoto(this.authorId, this.image, this.likes, this.text, this.id, this.authorName, this.image240, this.authorAvatar, this.liked);

  final int id;
  final int authorId;
  MemoryImage image;
  MemoryImage image240;
  int likes;
  final String authorName;
  bool liked;
  final String text;
  MemoryImage authorAvatar;

  bool isReady()
  {
    return image != null && image240 != null && authorAvatar != null;
  }
}

var arr = List<int>.filled(100, 0);
var photoIds;

var allPhotos;// = <MyPhoto>[];
var myPhotos = <MyPhoto>[];


int id = -1;
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
  id = -1;
  isLoggedIn = false;
  avatarOriginal = null;
  avOrigLoaded = false;
  avatar20px = null;
  av20Loaded = false;
  avatar120px = null;
  av120Loaded = false;
  myPhotos = <MyPhoto>[];
}


/*
(() {
if (globals.isLoggedIn) {
return
}
return Container();
} ()),*/