// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'globals.dart' as globals;
import 'globals.dart';
import 'networking.dart';

void main() => runApp(MyApp());

void generateNewNumbers() {
  for (int i = 0; i < 100; i++) {
    fetchRandomPhoto().then((value) {
      arr[i] = int.parse(value['args'][1]);
      //debugPrint('$i done');
    });
  }

  fetchPhotoIds().then((value) {
    var tmp = value['args'];
    photoIds = List<int>.filled(tmp.length - 1, 0);
    for (int i = 1; i < tmp.length; i++) {
      photoIds[i-1] = int.parse(value['args'][i]);
    }
  }).whenComplete(() {
    allPhotos = List<MyPhoto>.filled(photoIds.length, null);

    for (int i = 0; i < photoIds.length; i++) {
      bool ok;
      var val;

      fetchOriginalPhoto(photoIds[i], globals.id).then((value) {
        ok = value['args'][0] == 'Ok';
        val = value;
        var photo;

        if (ok) {
          int likes = int.parse(value['args'][1]);
          bool liked = value['args'][2] == '1';
          int authorId = int.parse(value['args'][3]);
          String authorName = value['args'][4];
          String text = value['args'][5];
          String data = value['args'][6];
          var image = decodeImage(data);
          photo = globals.MyPhoto(authorId, image, likes, text, photoIds[i], authorName, null, null, liked);
          allPhotos[i] = photo;


          if (globals.isLoggedIn) {
            if (allPhotos[i].authorId == globals.id) {
                myPhotos.add(allPhotos[i]);
                debugPrint('[MyPhoto found: ${allPhotos[i].id}]');
            }
          }

          fetch240Photo(photoIds[i]).then((vv) {
            ok = vv['args'][0] == 'Ok';
            if (ok) {
              while(allPhotos[i] == null)
                continue;
              allPhotos[i].image240 = decodeImage(vv['args'][1]);
              debugPrint('[Image240 init: ${allPhotos[i].id}]');
            }
          });
          fetchAvatar(authorId, 120).then((vvv) {
            ok = vvv['args'][0] == 'Ok';
            if (ok) {
              while(allPhotos[i] == null)
                continue;
              allPhotos[i].authorAvatar = decodeImage(vvv['args'][1]);
              debugPrint('[Avatar init: ${allPhotos[i].id}]');
            }
          });
        }
      });
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //generateNewNumbers();

    return MaterialApp(
      title: 'Geogram',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        OnboardingFirst(_controller),
        OnboardingSecond(),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/home.jpg'),
            fit: BoxFit.cover,
          ),
          color: const Color(0xff7c94b6),
        ),
        child: Column(
          children: [
            MyBox(
              height: 50,
            ),
            Image.asset('images/geogram.png'),
            MyBox(
              edge: 10,
            ),
            MyBox(
              edge: 20,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 25.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageViewDemo()));
                      },
                      child: Container(
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Text('Хочу инструктаж',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors
                                .white; // Us Use the component's default.
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnonTest()));
                      },
                      child: Container(
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Text('Я всё знаю',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingFirst extends StatelessWidget {
  final PageController _ctrl;
  OnboardingFirst(this._ctrl);
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: 30.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        child: Text('НАХОДИТЕ КРАСИВЫЕ МЕСТА',
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/silouette.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                          child: Text(
                        'Делайте фото красивых мест и загружайте их в Geogram',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                height: 30.0,
                                width: 120.0,
                                alignment: Alignment.center,
                                child: Text('Пропустить',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Authorization()));
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                width: 120.0,
                                height: 30.0,
                                alignment: Alignment.center,
                                child: Text('Далее',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                _ctrl.nextPage(
                                    duration: _kDuration, curve: _kCurve);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class OnboardingSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: 30.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          'ПРОСМАТРИВАЙТЕ ФОТОГРАФИИ ДРУГИХ ЛЮДЕЙ',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/phoneOnb.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Container(
                          child: Text(
                        'Отмечайте понравившиеся фото',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    Expanded(
                      child: Container(
                          child: Text(
                        'Возможно, чьи-то фото помогут     выбрать Вам место для отпуска',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                height: 30.0,
                                width: 120.0,
                                alignment: Alignment.center,
                                child: Text('Понятно',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnonTest()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

Future<void> _showMyDialog(
    BuildContext context, Text title, String message, Widget ch,
    [String okText = 'Ок', Widget okBtn]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(message), ch != null ? ch : Container()],
          ),
        ),
        actions: <Widget>[
          okBtn == null
              ? TextButton(
                  child: Text(
                    okText,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : okBtn,
        ],
      );
    },
  );
}

class Authorization extends StatefulWidget {
  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  double _bigTextSize = 36;
  double _littleTextSize = 24;
  double _contHeight = 30;
  double _inpHeight = 30;
  int _delay = 300;

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).viewInsets.bottom;

    final loginController = TextEditingController();
    loginController.text = 'zsa';
    final passController = TextEditingController();
    passController.text = 'zsa';

    int state = 0;

    setState(() {
      if (a > 1) {
        _bigTextSize = 18;
        _littleTextSize = 12;
        _contHeight = 15;
      } else {
        _bigTextSize = 36;
        _littleTextSize = 24;
        _contHeight = 30;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: _contHeight,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      //child: AnimatedContainer(
                      //   duration: Duration(seconds: 1),
                      //  curve: Curves.fastOutSlowIn,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(),
                            flex: 1,
                          ),
                          Expanded(
                            child: AnimatedContainer(
                                duration: Duration(milliseconds: _delay),
                                curve: Curves.linear,
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: _delay),
                                  curve: Curves.linear,
                                  child: Text('АВТОРИЗАЦИЯ'),
                                  style: TextStyle(
                                    fontSize: _bigTextSize,
                                    fontFamily: 'Comfortaa',
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            flex: 1,
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: _delay),
                              curve: Curves.linear,
                              margin: EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/anon.png'),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                              flex: 2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                        duration:
                                            Duration(milliseconds: _delay),
                                        curve: Curves.linear,
                                        child: AnimatedDefaultTextStyle(
                                          duration:
                                              Duration(milliseconds: _delay),
                                          curve: Curves.linear,
                                          child: Text('Новый пользователь?'),
                                          style: TextStyle(
                                            fontSize: _littleTextSize,
                                            fontFamily: 'Roboto',
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                    AnimatedContainer(
                                        duration:
                                            Duration(milliseconds: _delay),
                                        curve: Curves.linear,
                                        margin: EdgeInsets.only(top: 10),
                                        child: InkWell(
                                          child: AnimatedDefaultTextStyle(
                                            duration:
                                                Duration(milliseconds: _delay),
                                            curve: Curves.linear,
                                            child: Text('Регистрация'),
                                            style: TextStyle(
                                              fontSize: _littleTextSize,
                                              fontFamily: 'Roboto',
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacement(_createRoute(
                                                    Registration()));
                                          },
                                        )),
                                  ])),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                  duration: Duration(milliseconds: _delay),
                                  curve: Curves.linear,
                                  child: SizedBox(
                                      height: 60.0,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Row(children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: Icon(Icons
                                                    .account_circle_rounded)),
                                            Expanded(
                                                child: TextField(
                                              controller: loginController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder()),
                                            ))
                                          ])))),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                  height: 60.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(Icons.lock)),
                                        Expanded(
                                            child: TextField(
                                          obscureText: true,
                                          controller: passController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ))
                                      ]))),
                            ])),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                height: _inpHeight,
                                width: 120.0,
                                alignment: Alignment.center,
                                child: Text('Войти',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                var login = loginController.text;
                                var password = passController.text;

                                debugPrint(login);
                                var ok = false;

                                isNetworkAvailable()
                                    .then((value) => ok = value)
                                    .whenComplete(() {
                                  if (ok) {
                                    fetchAuth(login, password).then((value) {
                                      ok = value['args'][0] == 'Ok';
                                      if (ok) {
                                        globals.id =
                                            int.parse(value['args'][1]);
                                        globals.username = value['args'][2];
                                      }

                                      fetchAvatar(globals.id, 0)
                                          .then((value) =>
                                              globals.avatarOriginal =
                                                  decodeImage(value['args'][1]))
                                          .whenComplete(() {
                                        debugPrint('Original done');
                                        globals.avOrigLoaded = true;
                                      });
                                      fetchAvatar(globals.id, 20)
                                          .then((value) => globals.avatar20px =
                                              decodeImage(value['args'][1]))
                                          .whenComplete(() {
                                        debugPrint('20px done');
                                        globals.av20Loaded = true;
                                      });
                                      fetchAvatar(globals.id, 120)
                                          .then((value) => globals.avatar120px =
                                              decodeImage(value['args'][1]))
                                          .whenComplete(() {
                                        debugPrint('120px done');
                                        globals.av120Loaded = true;
                                      });
                                    }).whenComplete(() {
                                      if (ok) {
                                        //delayFunc(login, password, id);
                                        debugPrint("${globals.id}");
                                        globals.isLoggedIn = true;
                                        Navigator.of(context).pushReplacement(
                                            _createRoute(AnonTest()));
                                      } else
                                        _showMyDialog(
                                            context,
                                            Text('Ошибка',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            'Неверный логин или пароль.',
                                            null);
                                    });
                                  } else {
                                    _showMyDialog(
                                        context,
                                        Text(
                                          "Отсутствует подключение к сети",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        "Невозможно проверить введенные данные",
                                        null);
                                  }
                                });
                                //delayFunc(login, password);
                                //todo: sas
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: a,
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }

  Future<Null> delayFunc(String login, String password, int id) async {
    await Future.delayed(Duration(seconds: 3));
    debugPrint("$id");
    if (login == 'zsa' && password == 'zsa') {
      globals.isLoggedIn = true;

      Navigator.of(context).pushReplacement(_createRoute(AnonTest()));
    } else {
      _showMyDialog(
          context,
          Text('Ошибка', style: TextStyle(color: Colors.red)),
          'Неверный логин или пароль.',
          null);
    }
    setState(() {
      //todo: list = List.generate(random.nextInt(10), (i) => "Item $i");
    });

    return null;
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  double _bigTextSize = 36;
  double _littleTextSize = 24;
  double _contHeight = 30;
  double _inset = 10;
  double _radius = 70;
  int _delay = 300;

  File _image;
  Image _img;
  final picker = ImagePicker();

  Future getPhotoImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageLoaded = true;
      } else {
        print('Отсутствует фото');
      }
    });
  }

  Future getFileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageLoaded = true;
      } else {
        print('Фото не выбрано');
      }
    });
  }

  bool imageLoaded = false;

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).viewInsets.bottom;
    _img = Image.asset('images/anon.png');
    setState(() {
      if (a > 1) {
        _bigTextSize = 18;
        _littleTextSize = 12;
        _contHeight = 15;
        _radius = 45;
        _inset = 5;
      } else {
        _bigTextSize = 36;
        _littleTextSize = 24;
        _contHeight = 30;
        _radius = 70;
        _inset = 10;
      }
      _img =
          _image == null ? Image.asset('images/anon.png') : Image.file(_image);
    });

    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: _contHeight,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: _delay),
                          curve: Curves.linear,
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: _delay),
                            curve: Curves.linear,
                            child: Text('РЕГИСТРАЦИЯ'),
                            style: TextStyle(
                              fontSize: _bigTextSize,
                              fontFamily: 'Comfortaa',
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.all(0.0),
                          child: CircleAvatar(
                            backgroundImage: _img.image,
                            radius: _radius,
                          ),
                        ),
                        onTap: () {
                          _showMyDialog(
                              context,
                              Text('Откуда загрузить фото?'),
                              '',
                              Column(children: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(Icons.camera),
                                      ),
                                      Expanded(
                                        child: InkWell(child: Text('С камеры')),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    getPhotoImage();
                                    Navigator.pop(context);
                                  },
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child:
                                            Icon(Icons.photo_library_outlined),
                                      ),
                                      Expanded(child: Text('Из системы'))
                                    ],
                                  ),
                                  onTap: () {
                                    getFileImage();
                                    Navigator.pop(context);
                                  },
                                )
                              ]),
                              'Отмена');
                        },
                      ),
                      flex: 2,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: _inset),
                        child: Text('Нажмите на аватарку и загрузите своё фото',
                            style: TextStyle(fontSize: 12))),
                    Expanded(
                        flex: 2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                  duration: Duration(milliseconds: _delay),
                                  curve: Curves.linear,
                                  child: AnimatedDefaultTextStyle(
                                    duration: Duration(milliseconds: _delay),
                                    curve: Curves.linear,
                                    child: Text('Уже зарегистрированы?'),
                                    style: TextStyle(
                                      fontSize: _littleTextSize,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    child: AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: _delay),
                                      curve: Curves.linear,
                                      child: Text('Авторизация'),
                                      style: TextStyle(
                                        fontSize: _littleTextSize,
                                        fontFamily: 'Roboto',
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          _createRoute(Authorization())); //
                                    },
                                  )),
                            ])),
                    Expanded(
                        flex: 4,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 45.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                                Icons.account_circle_rounded)),
                                        Expanded(
                                            child: TextField(
                                          controller: loginController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ))
                                      ]))),
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                  height: 45.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(Icons.lock)),
                                        Expanded(
                                            child: TextField(
                                          controller: passController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ))
                                      ]))),
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                  height: 45.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(Icons.mail)),
                                          Expanded(
                                              child: TextField(
                                            key: Key('EmailTextField'),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: emailController,
                                            onChanged: (enteredEmail) =>
                                                validateEmail(enteredEmail),
                                            decoration: InputDecoration(
                                                labelText: message,
                                                labelStyle: TextStyle(
                                                    color: Colors.red),
                                                border: OutlineInputBorder()),
                                          ))
                                        ],
                                      )))
                            ])),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                height: 30.0,
                                alignment: Alignment.center,
                                child: Text('Зарегистрироваться',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                bool ok = false;

                                var login = loginController.text;
                                var pass = passController.text;
                                if (login.isEmpty) {
                                  _showMyDialog(
                                      context,
                                      Text('Ошибка',
                                          style: TextStyle(color: Colors.red)),
                                      'Не введен логин.',
                                      null);
                                } else if (pass.isEmpty) {
                                  _showMyDialog(
                                      context,
                                      Text('Ошибка',
                                          style: TextStyle(color: Colors.red)),
                                      'Не введен пароль.',
                                      null);
                                } else if (message != '') {
                                  _showMyDialog(
                                      context,
                                      Text('Ошибка',
                                          style: TextStyle(color: Colors.red)),
                                      'Неверная почта.',
                                      null);
                                }
                                //todo: sas
                                else if (!imageLoaded) {
                                  _showMyDialog(
                                      context,
                                      Text('Ошибка',
                                          style: TextStyle(color: Colors.red)),
                                      'Отсутствует фото.',
                                      null);
                                } else {
                                  fetchRegister(login, pass).then((value) {
                                    debugPrint('1241');
                                    ok = value['args'][0] == 'Ok';
                                    if (ok) {
                                      debugPrint('1244');
                                      globals.id = int.parse(value['args'][1]);
                                      debugPrint('Value ${value['args']}');
                                      debugPrint('Author id ${globals.id}');
                                    }
                                  }).whenComplete(() {
                                    if (ok) {
                                      debugPrint('1251');
                                      SendImage si = SendImage(
                                          id: globals.id,
                                          data: encodeImage(_image),
                                          text: 'Аватар',
                                          ext: 'jpg');

                                      fetchAddAvatar(si).then((value) {
                                        debugPrint(
                                            'Set avatar ${value['args'][0]}');
                                      }).whenComplete(() {
                                        fetchAuth(login, pass).then((value) {
                                          ok = value['args'][0] == 'Ok';
                                          if (ok) {
                                            globals.username = value['args'][2];
                                          }

                                          fetchAvatar(globals.id, 0)
                                              .then((value) => globals
                                                      .avatarOriginal =
                                                  decodeImage(value['args'][1]))
                                              .whenComplete(() {
                                            debugPrint('Original done');
                                            globals.avOrigLoaded = true;
                                          });

                                          fetchAvatar(globals.id, 20)
                                              .then((value) => globals
                                                      .avatar20px =
                                                  decodeImage(value['args'][1]))
                                              .whenComplete(() {
                                            debugPrint('20px done');
                                            globals.av20Loaded = true;
                                          });
                                          fetchAvatar(globals.id, 120)
                                              .then((value) => globals
                                                      .avatar120px =
                                                  decodeImage(value['args'][1]))
                                              .whenComplete(() {
                                            debugPrint('120px done');
                                            globals.av120Loaded = true;
                                          });
                                          globals.isLoggedIn = true;
                                          Navigator.of(context).pushReplacement(
                                              _createRoute(AnonTest()));
                                        });
                                      });
                                    } else {
                                      _showMyDialog(
                                          context,
                                          Text('Ошибка',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          'Такой пользователь уже существует.',
                                          null);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }

  final emailController = TextEditingController();

  final loginController = TextEditingController();
  final passController = TextEditingController();

  String message = '';
  void validateEmail(String enteredEmail) {
    if (EmailValidator.validate(enteredEmail)) {
      setState(() {
        message = '';
      });
    } else {
      setState(() {
        message = 'Неверный адрес почты';
      });
    }
  }
}

class MyBox extends StatelessWidget {
  final double height;
  final Widget child;
  final double edge;

  MyBox({this.height, this.child, this.edge});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          margin: (edge == null) ? EdgeInsets.zero : EdgeInsets.all(edge),
          height: (height == null) ? 150 : height,
          child: child),
    );
  }
}

class MyLeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/geogram.png'),
              fit: BoxFit.fitWidth,
            ),
            color: Colors.amber,
          ),
          child: null,
        ),
        ListTile(
            title: Text(
                'Настоящая Политика конфиденциальности распространяется на данные, полученные на этих сайтах и любых других сайтах или мобильных приложениях, используемых или принадлежащих Geogram™®©  (совместно именуются «сайты»). Сайты включают в себя любые веб-страницы, интерактивные функции, приложения, виджеты, блоги, плагины социальных сетей, а также онлайн и оффлайн предложения, которые ссылаются на настоящую Политику конфиденциальности.')),
        ListTile(
            title: Text(
                'Для предоставления услуг и, как подробнее изложено ниже, мы можем собирать персональные данные пользователя и его подписчиков.')),
        ListTile(
            title: Text(
                'Настоящая Политика конфиденциальности объясняет, как Geogram™®©  обращается с персональными данными, собранными при использовании наших сайтов и сервисов. Действие настоящей Политики не распространяется на действие компаний, которыми мы не владеем или не контролируем, или лиц, которые не управляются нами.')),
        Container(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(title: Text('')),
                    ListTile(title: Text('Версия приложения 1.3.37'))
                  ],
                ))),
      ],
    ));
  }
}

class MyRightDrawerAnon extends StatefulWidget {
  @override
  _MyRightDrawerAnonState createState() => _MyRightDrawerAnonState();
}

class _MyRightDrawerAnonState extends State<MyRightDrawerAnon> {
  @override
  Widget build(BuildContext context) {
    var _img;
    var _name;

    setState(() {
      _img = globals.isLoggedIn && globals.avOrigLoaded
          ? globals.avatarOriginal
          : AssetImage('images/anon.png');
      _name = globals.isLoggedIn ? globals.username : 'Анонимный режим';
    });

    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          margin: EdgeInsets.all(10),
          child: Column(children: [
            CircleAvatar(
              backgroundImage: _img, //),
              radius: 65,
            )
          ]),
        ),
        Center(
          child: Text(_name),
        ),
        Divider(),
        ListTile(
          title: Text(globals.isLoggedIn ? 'Мои фото' : 'Авторизация'),
          leading: Icon(Icons.account_circle_rounded),
          onTap: () {
            if (globals.isLoggedIn)
              Navigator.of(context).push(_createRoute(Personal()));
            //_showMyDialog(context, Text('Ошибка'), 'Еще не реализовано', null);
            else
              Navigator.of(context).pushReplacement(
                  _createRoute(Authorization())); // close the drawer
          },
        ),
        (() {
          if (globals.isLoggedIn) {
            return ListTile(
              title: Text('Выйти из профиля'),
              leading: Icon(Icons.logout),
              onTap: () {
                globals.logout();

                Navigator.of(context).pushReplacement(_createRoute(AnonTest()));
              },
            );
          }
          return Container();
        }()),
        (() {
          if (globals.isLoggedIn) {
            return Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    ListTile(title: Text('')),
                    Divider(),
                    ListTile(
                      title: Text('Удалить аккаунт',
                          style: TextStyle(color: Colors.red)),
                      onTap: () {
                        _showMyDialog(
                            context,
                            Text('Удалить аккаунт?'),
                            'Это действие нельзя отменить!',
                            Column(children: [
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    //todo: удаление акка
                                    globals.isLoggedIn = false;
                                    Navigator.of(context).pushReplacement(
                                        _createRoute(AnonTest()));
                                  },
                                  child: Text('Я понимаю',
                                      style: TextStyle(color: Colors.red))),
                            ]),
                            'Я не хочу',
                            Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Я не хочу, отмена',
                                        style:
                                            TextStyle(color: Colors.black)))));
                      },
                    )
                  ],
                ));
          }
          return Container();
        }()),
      ],
    ));
  }
}

String encodeImage(File image) {
  final bytes = image.readAsBytesSync();
  return base64Encode(bytes);
}

MemoryImage decodeImage(String cipher) {
  final decodedBytes = base64Decode(cipher);
  var file = MemoryImage(decodedBytes);
  return file;
}

class AnonTest extends StatefulWidget {
  @override
  _AnonTestState createState() => _AnonTestState();
}

class _AnonTestState extends State<AnonTest> {
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var _img;

  @override
  void initState() {
    super.initState();
    _img = globals.isLoggedIn && globals.av120Loaded
        ? globals.avatar120px
        : AssetImage('images/anon.png');
    random = math.Random();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      generateNewNumbers();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: InkWell(
              child: Icon(Icons.add),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPhoto()));
              }),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: InkWell(
                  child: Row(children: [
                    CircleAvatar(
                      backgroundImage: globals.isLoggedIn && globals.av120Loaded
                          ? globals.avatar120px
                          : AssetImage('images/anon.png'), //),
                      radius: 20,
                    )
                  ]),
                  onTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                    setState(() {
                      _img = globals.isLoggedIn && globals.av120Loaded
                          ? globals.avatar120px
                          : AssetImage('images/anon.png');
                    });
                  },
                ))
          ],
        ),
        drawer: MyLeftDrawer(),
        endDrawer: MyRightDrawerAnon(),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text('Что сегодня нового',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'roboto', fontSize: 20))),
                Expanded(flex: 100, child: Container(child: GridListDemo()))
              ]),
        ));
  }
}

class Personal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: 30.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: CircleAvatar(
                          backgroundImage:
                              globals.isLoggedIn && globals.avOrigLoaded
                                  ? globals.avatarOriginal
                                  : AssetImage('images/anon.png'), //),
                          radius: 80,
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: InkWell(
                            child: Text(
                              globals.username,
                              style: TextStyle(fontSize: 24),
                            ),
                            onTap: () {
                              TextEditingController textController =
                                  TextEditingController();

                              _showMyDialog(
                                  context,
                                  Text('Смена имени'),
                                  'Какое новое имя предпочитаете?',
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                          width: 300,
                                          height: 100,
                                          child: TestAnimWidget(
                                            textController: textController,
                                            context: context,
                                          ))),
                                  "",
                                  Row(children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Отменить',
                                            style:
                                                TextStyle(color: Colors.black)))
                                  ]));
                            })),
                    Divider(
                      thickness: 4,
                    ),
                    Expanded(
                      child: GridListAuthorDemo(),
                      flex: 10,
                    ),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class TestAnimWidget extends StatefulWidget {
  @override
  TestAnimWidget({this.textController, this.context});
  final BuildContext context;
  final TextEditingController textController;
  State<StatefulWidget> createState() => _TestAnimWidgetState();
}

class _TestAnimWidgetState extends State<TestAnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
              animation: offsetAnimation,
              builder: (buildContext, child) {
                if (offsetAnimation.value < 0.0)
                  print('${offsetAnimation.value + 8.0}');
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  padding: EdgeInsets.only(
                      left: offsetAnimation.value + 24.0,
                      right: 24.0 - offsetAnimation.value),
                  child: Center(
                      child: TextField(
                    controller: widget.textController,
                  )),
                );
              }),
          TextButton(
            onPressed: () {
              if (widget.textController.value.text.isEmpty)
                controller.forward(from: 0.0);
              else {
                bool ok = false;
                isNetworkAvailable()
                    .then((value) => ok = value)
                    .whenComplete(() {
                  if (ok) {
                    fetchSetName(globals.id, widget.textController.value.text)
                        .then((value) {
                      ok = value['args'][0] == 'Ok';
                      if (ok) {
                        globals.username = value['args'][1];
                        Navigator.of(widget.context).pop();
                        Navigator.of(widget.context)
                            .pushReplacement(_createRoute(Personal()))
                            .then((value) => setState(() {}));
                      }
                    });
                  }
                });
              }
            },
            child: Text('Сменить', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}

class _Photo {
  _Photo({this.id, this.assetName, this.title, this.subtitle, this.liked});

  final int id;
  final String assetName;
  final String title;
  final String subtitle;
  bool liked;
}

Future<bool> isNetworkAvailable() async {
  try {
    Uri.parse(globals.address + 'author/auth');
    debugPrint('true');
    return true;
  } on SocketException catch (e) {
    debugPrint('exc: ${e.message}');
    return false;
  }
}

bool checkNetwork() {
  bool res = false;
  isNetworkAvailable().then((internet) {
    if (internet != null) {
      res = true;
      debugPrint('!!res: $res');
    }
  });
  debugPrint('res: $res');
  return res;
}

Image getAvatarImage() {
  bool flag = false;
  Image img;
  if (flag) {
    img = Image.network(
      'https://picsum.photos/50/50/?random',
      fit: BoxFit.cover,
    );
  } //on SocketException catch (e)
  else {
    img = Image.asset('images/anon.png', fit: BoxFit.scaleDown);
  }
  return img;
}

class _GridDemoPhotoItem extends StatelessWidget {
  _GridDemoPhotoItem({
    Key key,
    @required this.photo,
  }) : super(key: key);

  //todo: ...
  final _Photo photo;
  //final MyPhoto photo;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      /* child: Image.memory(
        photo.image240.bytes, //todo: sas
        fit: BoxFit.cover,
      ),*/
      child: Image.asset(
        photo.assetName,
        fit: BoxFit.cover,
      ),
    );

    return InkResponse(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewPhoto(
                          photo:
                              photo))), //id: photo.id, liked: photo.liked,))),
              debugPrint('${photo.id} clicked')
            },
        child: GridTile(
          footer: Material(
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 30,
                child: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: getAvatarImage().image,
                          radius: 10,
                        ),
                        Expanded(child: Container()),
                        Text('Автор ${photo.id % 13 + 1}'),
//todo:                 Text(photo.authorName),
                        (() {
                          if (globals.isLoggedIn) {
                            return Expanded(child: Container());
                          }
                          return Container();
                        }()),
                        (() {
                          if (globals.isLoggedIn) {
                            return IconButton(
                              padding: new EdgeInsets.all(0.0),
                              iconSize: 20,
                              icon: photo.liked
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.favorite_border),
                              onPressed: () {},
                            );
                          }
                          return Container();
                        }()),
                      ],
                    )),
              )),
          child: image,
        ));
  }
}

Iterable<String> generateNames(int index) sync* {
  int i = index;
  while (true) {
    String name;
    i++;
    int ii = i % 13 + 1;
    name = 'images/photo$ii.jpg';
    //name = 'images/anon.png';
    yield name;
  }
}

Iterable<MyPhoto> generatePhotos() sync* {
  while (true) {
    int id;
    var photo;
    fetchRandomPhoto().then((value) {
      id = int.parse(value['args'][0]);
    }).whenComplete(() {
      int likes;
      bool liked;
      int authorId;
      String authorName;
      String text;
      MemoryImage orig;
      MemoryImage im240;
      MemoryImage authAvatar;

      bool ok = false;
      var val;
      fetchOriginalPhoto(id, globals.isLoggedIn ? globals.id : -1)
          .then((value) {
        ok = value['args'][0] == 'Ok';
        val = value;
      }).whenComplete(() {
        if (ok) {
          likes = int.parse(val['args'][1]);
          liked = val['args'][2] == '1';
          authorId = int.parse(val['args'][3]);
          authorName = val['args'][4];
          text = val['args'][5];
          orig = decodeImage(val['args'][6]);

          fetch240Photo(id).then((value) {
            ok = value['args'][0] == 'Ok';
            val = value;
          }).whenComplete(() {
            if (ok) {
              im240 = decodeImage(val['args'][1]);

              fetchAvatar(authorId, 120).then((value) {
                ok = value['args'][0] == 'Ok';
                val = value;
              }).whenComplete(() {
                authAvatar = decodeImage(val['args'][1]);

                photo = MyPhoto(authorId, orig, likes, text, id, authorName,
                    im240, authAvatar, liked);
              });
            }
          });
        }
      });
    });
    yield photo;
  }
}

class GridListDemo extends StatelessWidget {
  //final _data = <MyPhoto>[];
  final _data = <String>[];
  final random = math.Random();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: arr.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          final ii = index % 13;

          if (index >= _data.length) {
            //_data.addAll(generatePhotos().take(2)); /*4*/
            _data.addAll(generateNames(index).take(10)); /*4*/
          }

          return new Card(
            child: new GridTile(
              child: _GridDemoPhotoItem(
//todo:                photo: _data[index]
                  photo: _Photo(
                      assetName: _data[ii],
                      id: index,
                      liked: random.nextBool())),
            ),
          );
        });
  }
}

class _GridDemoAuthorPhotoItem extends StatelessWidget {
  _GridDemoAuthorPhotoItem({
    Key key,
    @required this.photo,
  }) : super(key: key);
  //todo: final MyPhoto photo;
  final _Photo photo;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      /* todo: child: Image.memory(
        photo.image240.bytes, //todo: sas
        fit: BoxFit.cover,
      ),*/
      child: Image.asset(
        photo.assetName,
        fit: BoxFit.cover,
      ),
    );

    return InkResponse(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewPhoto(
                          photo:
                              photo))), //id: photo.id, liked: photo.liked,))),
              debugPrint('${photo.id} clicked')
            },
        child: GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          child: image,
        ));
  }
}

class GridListAuthorDemo extends StatelessWidget {
  final _data = <String>[];
  final random = math.Random();
  @override
  Widget build(BuildContext context) {
    /* return GridView.count(
      crossAxisCount: 2,
      children: List.generate(100, (index) {
        final ii = index % 13;
        if (index >= _data.length) {
          _data.addAll(generateNames(index).take(10)); /*4*/
        }
        return new GridTile(
          child: _GridDemoAuthorPhotoItem(
              photo: _Photo(
                  assetName: _data[ii], id: index, liked: random.nextBool())),
        );
      }),
    );*/

    return GridView.builder(
        itemCount: arr.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          final ii = index % 13;

          if (index >= _data.length) {
            _data.addAll(generateNames(index).take(10)); /*4*/
          }

          return new Card(
              child: new GridTile(
            child: _GridDemoAuthorPhotoItem(
                photo: _Photo(
                    assetName: _data[ii], id: index, liked: random.nextBool())),
          ));
        });
  }
}

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  File _image;
  final picker = ImagePicker();

  Future getPhotoImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Отсутствует фото');
      }
    });
  }

  Future getFileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Фото не выбрано');
      }
    });
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление фото'),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(243, 206, 160, 1.0),
                          Colors.white,
                        ]),
                  ),
                  height: 30.0,
                  alignment: Alignment.center,
                  child: Column(children: [
                    Expanded(
                        child: Center(
                      child: _image == null
                          ? Text('Загрузите фотографию для публикации.')
                          : Image.file(_image),
                    )),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 'takePhoto',
                            onPressed: getPhotoImage,
                            tooltip: 'Сделать фото',
                            child: Icon(Icons.camera),
                          )),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 'loadPhoto',
                            onPressed: getFileImage,
                            //onPressed: () => {getPhoto(false)},
                            tooltip: 'Загрузить фото',
                            child: Icon(Icons.photo_library_outlined),
                          )),
                    ]),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: controller,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        )),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () {
                              if (_image == null) {
                                _showMyDialog(
                                    context,
                                    Text('Ошибка',
                                        style: TextStyle(color: Colors.red)),
                                    'Отсутствует фото для публикации',
                                    null);
                              } else {
                                if (!globals.isLoggedIn) {
                                  showAuthError(context);
                                } else {
                                  debugPrint('2119');
                                  SendImage si = SendImage(
                                      id: globals.id,
                                      data: encodeImage(_image),
                                      text: controller.text,
                                      ext: 'jpeg');
                                  bool ok = false;
                                  fetchAddPhoto(si).then((value) {
                                    ok = value['args'][0] == 'Ok';
                                  }).whenComplete(() {
                                    if (ok) {
                                      _showMyDialog(
                                          context,
                                          Text("Успешно опубликовано"),
                                          '',
                                          null,
                                          '',
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        _createRoute(
                                                            AnonTest()));
                                              },
                                              child: Text(
                                                  'Ура, хочу посмотреть в ленте',
                                                  style: TextStyle(
                                                      color: Colors.black))));
                                    } else {
                                      _showMyDialog(context, Text("Ошибка"),
                                          'Что-то пошло не так', null);
                                    }
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 30.0,
                              //width: 120.0,
                              alignment: Alignment.center,
                              child: Text('Опубликовать',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return _image == null
                                      ? Colors.grey
                                      : Color.fromRGBO(173, 117, 90,
                                          1.0); // Use the component's default.
                                },
                              ),
                            ),
                          )),
                    ])
                  ])),
            )
          ]),
    );
  }
}

void showAuthError(BuildContext context) {
  _showMyDialog(
      context,
      Text('Ошибка', style: TextStyle(color: Colors.red)),
      'Вы не авторизовались',
      Column(
        children: [
          Divider(
            color: Colors.white,
          ),
          InkWell(
              child: Text(
                'Авторизация',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Authorization())); //
              }),
        ],
      ));
}

class ViewPhoto extends StatefulWidget {
  ViewPhoto(
      {Key key,
      //@required this.id,
      //@required this.liked,
      @required this.photo})
      : super(key: key);

  //final int id;
  //final bool liked;
  // todo:
  //final MyPhoto photo;
  final _Photo photo;

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  String name;
  int likes = -1;
  @override
  Widget build(BuildContext context) {
    //var likes = widget.photo.likes;
    name =
        widget.photo.assetName; //generateNames(widget.photo.id).take(1).first;
    if (likes == -1) likes = widget.photo.id * 15;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          (() {
            if (globals.isLoggedIn) {
              return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _showMyDialog(
                          context,
                          Text('Удалить фотографию?'),
                          'Это действие нельзя отменить!',
                          Column(children: [
                            Divider(),
                            TextButton(
                                onPressed: () {
                                  //todo: удаление фотографии
                                  Navigator.of(context).pushReplacement(
                                      _createRoute(AnonTest()));
                                },
                                child: Text('Я понимаю, хочу удалить',
                                    style: TextStyle(color: Colors.red))),
                          ]),
                          'Я не хочу, отмена');
                    },
                    child: Icon(Icons.delete_forever),
                  ));
            }
            return Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(),
                ));
          }())
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: 30.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(name),
// todo:                    image: widget.photo.image,
                            fit: BoxFit.cover,
                          ),
                          color: const Color(0xff7c94b6),
                        ),
                      ),
                      flex: 10,
                    ),
                    Container(
                        child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: getAvatarImage().image,
// todo:                        backgroundImage: widget.photo.authorAvatar,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                      'Автор ${widget.photo.id % 13 + 1}')),
//todo:                           child: Text(widget.photo.authorName)),
                              Expanded(child: Container()),
                              Expanded(
                                flex: 3,
                                child: ListTile(
                                    title: Text('Нравится: $likes'),
                                    trailing: IconButton(
                                      icon: Icon(widget.photo.liked
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      onPressed: () {
                                        setState(() {
                                          if (!globals.isLoggedIn) {
                                            showAuthError(context);
                                          } else {
//todo:                                            fetchLikeDislike(widget.photo.id, widget.photo.authorId).then((value) {
                                            if (widget.photo.liked)
                                              likes--;
                                            else
                                              likes++;
                                            widget.photo.liked =
                                                !widget.photo.liked;
//todo:                                             widget.photo.changeLike();
//                                            });
                                          }
                                        });
                                      },
                                    )),
                              )
                            ],
                          ),
                        ),
                        ListTile(
                            title: Text(
                                'Моя любимая фотка, Автор ${widget.photo.id % 13 + 1}™®©'))
                        //todo:                    title: Text(widget.photo.text))
                      ],
                    )),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class Template extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(243, 206, 160, 1.0),
                        Colors.white,
                      ]),
                ),
                height: 30.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color.fromRGBO(173, 117, 90,
                                        1.0); // Use the component's default.
                                  },
                                ),
                              ),
                              child: Container(
                                height: 30.0,
                                width: 120.0,
                                alignment: Alignment.center,
                                child: Text('Понятно',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OnboardingSecond()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }
}
