// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    BuildContext context, String title, String message, Widget ch) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(message), ch != null ? ch : Container()],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ок',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
                                          child: TextField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Логин'),
                                          )))),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                  height: 60.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Пароль'),
                                      ))),
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
                                _showMyDialog(context, 'Ошибка',
                                    'Неверный логин или пароль.', null);
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
  double _inpHeight = 30;
  int _delay = 300;

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).viewInsets.bottom;
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
                      child: Container(
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
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Логин'),
                                      ))),
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                  height: 45.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Пароль'),
                                      ))),
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                  height: 45.0,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        onChanged: (enteredEmail) =>
                                            validateEmail(enteredEmail),
                                        decoration: InputDecoration(
                                            labelText: message,
                                            labelStyle:
                                                TextStyle(color: Colors.red),
                                            border: OutlineInputBorder(),
                                            hintText: 'Электронная почта'),
                                      ))),
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
                                _showMyDialog(context, 'Ошибка',
                                    'Неверные регистрационные данные.', null);
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

class MyRightDrawerAnon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/anon.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Center(
          child: Text('Анонимный режим'),
        ),
        Divider(),
        ListTile(
          title: Text('Авторизация'),
          leading: Icon(Icons.account_circle_rounded),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Authorization())); // close the drawer
          },
        ),
      ],
    ));
  }
}

class AnonTest extends StatefulWidget {
  @override
  _AnonTestState createState() => _AnonTestState();
}

class _AnonTestState extends State<AnonTest> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
            child: Icon(Icons.add),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPhoto()));
            }),
        actions: [
          IconButton(
            icon: Image.asset('images/anon.png'),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      drawer: MyLeftDrawer(),
      endDrawer: MyRightDrawerAnon(),
      body: Column(
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
    );
  }
}

class _Photo {
  _Photo({
    this.id,
    this.assetName,
    this.title,
    this.subtitle,
  });

  final int id;
  final String assetName;
  final String title;
  final String subtitle;
}

Future<bool> isNetworkAvailable() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //debugPrint('true');
      return true;
    }
  } on SocketException catch (e) {
    //debugPrint('exc: ${e.message}');
    return false;
  }
  //debugPrint('false');
  return false;
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
    img = Image.network('https://picsum.photos/50/50/?random',
      fit: BoxFit.cover,);
  } //on SocketException catch (e)
  else {
    img = Image.asset('images/anon.png',
      fit: BoxFit.scaleDown);
  }
  return img;
}

class _GridDemoPhotoItem extends StatelessWidget {
  _GridDemoPhotoItem({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final _Photo photo;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
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
                      builder: (context) => ViewPhoto(id: photo.id))),
              debugPrint('${photo.id} clicked')
            },
        child: GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child:
            SizedBox(
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
                    Text('Автор ${photo.id}'),
                  ],
                )
            ),
          )
          ),
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

class GridListDemo extends StatelessWidget {
  final _data = <String>[];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        // itemCount: _data.length,
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
            child: _GridDemoPhotoItem(
                photo: _Photo(assetName: _data[ii], id: index)),
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

  @override
  Widget build(BuildContext context) {
    var auth = false;

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
                            child: Icon(Icons.add_a_photo),
                          )),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 'loadPhoto',
                            onPressed: getFileImage,
                            tooltip: 'Загрузить фото',
                            child: Icon(Icons.library_add),
                          )),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () => {
                              if (_image == null)
                                {
                                  _showMyDialog(context, 'Ошибка',
                                      'Отсутствует фото для публикации', null),
                                }
                              else
                                {
                                  if (!auth)
                                    {
                                      _showMyDialog(
                                          context,
                                          'Ошибка',
                                          'Вы не авторизовались',
                                          Column(
                                            children: [
                                              Divider(),
                                              InkWell(
                                                  child: Text(
                                                    'Авторизация',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Authorization())); //
                                                  }),
                                            ],
                                          ))
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

class ViewPhoto extends StatefulWidget {
  ViewPhoto({
    Key key,
    @required this.id,
  }) : super(key: key);

  final int id;

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  String name;
  bool liked = false;
  int likes = -1;

  @override
  Widget build(BuildContext context) {
    name = generateNames(widget.id).take(1).first;
    if (likes == -1) likes = widget.id * 15;
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(name),
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
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Автор ${widget.id}')),
                              Expanded(child: Container()),
                              Expanded(
                                flex: 3,
                                child: ListTile(
                                    title: Text('Нравится: $likes'),
                                    trailing: IconButton(
                                      icon: Icon(liked
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      onPressed: () {
                                        setState(() {
                                          if (liked)
                                            likes--;
                                          else
                                            likes++;
                                          liked = !liked;
                                        });
                                      },
                                    )),
                              )
                            ],
                          ),
                        ),
                        ListTile(title: Text('Sample text'))
                      ],
                    )),

                    /*Container(
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
                    )*/
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
