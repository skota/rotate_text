import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(AnimationPage());

class AnimationPage extends StatefulWidget {
  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animCtrl;

  Animation<double> textSizeAnimation;

  // since we add the mixin SingleTickerProviderStateMixin. The current class
  // _AnimationPageState becomes the "ticker" provider
  @override
  void initState() {
    super.initState();

    animCtrl = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    //now setup a curve
    final curvedAnimation = CurvedAnimation(
      parent: animCtrl,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOut,
    );

    //setup tween- range of values
    // use tween to animate animCtrl
    //animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(animCtrl);

    // use tween to animate curves -
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation);

    // textSizeAnimation =
    //     Tween<double>(begin: 16, end: 64).animate(curvedAnimation);

    //setstate is the listener..when animation values change --rebuild
    animCtrl.addListener(() {
      setState(() {});
    });

    //we also want to listen to when the animation status changes
    // status cane be - dismissed, forward, completed, reversed
    animCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animCtrl.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animCtrl.forward();
      }
    });

    //start the animation
    animCtrl.forward();
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Rotate text"),
                  SizedBox(
                    height: 40,
                  ),
                  Transform.rotate(
                    angle: animation.value,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Flutter",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
