import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController scaleController;
  Animation<double> scaleAnimation;

  AnimationController whiteOpacityController;
  Animation<double> whiteOpacityAnimation;

  bool isSplashFinished = false;

  @override
  void initState() {
    scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0,
    ).animate(scaleController);

    whiteOpacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    whiteOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(whiteOpacityController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        scaleController.forward();
        whiteOpacityController.forward();
      }).then((value) {
        setState(() {
          isSplashFinished = true;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.greenAccent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Test',
                    style: TextStyle(fontSize: 150),
                  ),
                  TextButton(
                    onPressed: () {
                      print('button pressed');
                    },
                    child: Text('Button'),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: isSplashFinished,
            child: AnimatedBuilder(
              animation: whiteOpacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: whiteOpacityAnimation.value,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            ignoring: isSplashFinished,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset(
                  'images/splash.svg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
