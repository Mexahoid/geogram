
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'globals.dart' as globals;
import 'globals.dart';


class SendImage {
  final int id;
  final String data;
  final String ext;
  final String text;

  SendImage(
      {@required this.id,
        @required this.data,
        @required this.text,
        @required this.ext});

  factory SendImage.fromJson(Map<String, dynamic> json) {
    return SendImage(
      id: json['Id'],
      data: json['Data'],
      ext: json['Extension'],
      text: json['Text'],
    );
  }
}

Future<Map<String, dynamic>> fetchAddPhoto(SendImage si) async {
  final url = Uri.parse(globals.address + 'photo/addphoto');

  var tstt = jsonEncode({
    "Id": si.id,
    "Data": '${si.data}',
    "Extension": '${si.ext}',
    "Text": '${si.text}',
  });
  Response response = await post(
    url,
    body: tstt,
    headers: {
      //"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      "Content-Type": "application/json; charset=utf-8",
    },
  );
  //debugPrint('Send Image');
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint("[Fetched add photo]");
  return test;
}

Future<Map<String, dynamic>> fetchAddAvatar(SendImage si) async {
  final url = Uri.parse(globals.address + 'author/setavatar');
  debugPrint('523');
  debugPrint('si id ${si.id}');
  var tstt = jsonEncode({
    "Id": si.id,
    "Data": '${si.data}',
    "Extension": '${si.ext}',
    "Text": '${si.text}',
  });
  Response response = await post(
    url,
    body: tstt,
    headers: {
      //"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      "Content-Type": "application/json; charset=utf-8",
    },
  );
  debugPrint('Send Image');
  //debugPrint(tstt);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint(json);
  debugPrint(test['args'][0]);
  return test;
}

Future<Map<String, dynamic>> fetchAvatar(int id, int px) async {
  final url = Uri.parse(globals.address + 'author/getavatar/id/$id/px/$px');
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  //debugPrint("[Fetched $px avatar]");
  return test;
}

Future<Map<String, dynamic>> fetchAuth(String login, String pass) async {
  debugPrint('[start fetch auth]');
  final url = Uri.parse(
      globals.address + 'author/auth/login/' + login + '/pass/' + pass);
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint('[fetched auth]');
  return test;
}

Future<Map<String, dynamic>> fetchRandomPhoto(int count) async {
  //debugPrint('[start fetch random photo]');
  final url = Uri.parse(globals.address + 'photo/getrandomphoto/$count');
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  //debugPrint(json);
  //debugPrint('[fetched random photo]');
  return test;
}

Future<Map<String, dynamic>> fetchPhotoIds() async {
  //debugPrint('[start fetch photo count]');
  final url = Uri.parse(globals.address + 'photo/getphotoids');
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  //debugPrint(json);
  debugPrint('[Fetched photo ids]');
  return test;
}

Future<Map<String, dynamic>> fetchLikeDislike(int photoId, int userId) async {
  final url =
  Uri.parse(globals.address + 'photo/likephoto/pid/$photoId/aid/$userId');
  Response response = await get(url);

  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint('fetch likeDislike');
  debugPrint(test['args'][0]);
  debugPrint(test['args'][1]);
  return test;
}

Future<Map<String, dynamic>> fetchOriginalPhoto(int photoId, int userId) async {
  //debugPrint('[start fetch original photo]');
  //debugPrint('[${globals.address + 'photo/getphoto/pid/$photoId/aid/$userId'}]');
  final url =
  Uri.parse(globals.address + 'photo/getphoto/pid/$photoId/aid/$userId');
  Response response = await get(url);

  String json = response.body;
  //debugPrint(json);
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint('[Fetched original photo]');
  return test;
}

Future<Map<String, dynamic>> fetch240Photo(int photoId) async {
  //debugPrint('[start fetch 240 photo]');
  final url = Uri.parse(globals.address + 'photo/getphoto240/pid/$photoId');
  Response response = await get(url);

  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint('[Fetched 240 photo]');
  return test;
}

Future<Map<String, dynamic>> fetchRegister(String login, String pass) async {
  //debugPrint('[start fetch register]');
  final url =
  Uri.parse(globals.address + 'author/register/login/$login/pass/$pass');
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint('[Fetched register]');
  return test;
}

Future<Map<String, dynamic>> fetchSetName(int id, String name) async {
  final url = Uri.parse(globals.address + 'author/setname/id/$id/name/$name');
  Response response = await get(url);
  String json = response.body;
  Map<String, dynamic> test = jsonDecode(json);
  debugPrint(json);
  debugPrint(test['args'][1]);
  return test;
}
