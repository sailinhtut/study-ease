import 'dart:math';

import "package:flutter/material.dart";
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> bulbAnimation;
  late Animation<double> opacityAnimation;

  bool showStickyNotes = false;
  bool showName = false;
  bool showLoading = false;

  String quote = "";

  List<String> quotes = [
    "Never Give Up",
    "No Pain , No Gain",
    "Failure is piller of Success",
    "If You Wanna Strong , Walk Alone",
    "Without Goals, Dream are Just Dream",
    "Just Believe In",
    "Rome was not built in one day !",
    "Slow and Steady , Wins The Race",
    "Success is not final\nFailure is not fatal\nIt is courage to continue\n that counts",
    "Think Big\nTrust Yourself\nAnd\nMake It Happen",
    "Dreams don't work,\nUnless You Work !",
    "To Be The Best,\n You Must Be Able To\nHandle The Worst",
    "Good Things Take Time",
    "Don't talk, Just Act\nDon't say, Just show\nDon't promise, Just prove",
    "Don't stop until you are proud !!",
    "The Best Fighter Is Never Angry",
    "It always seems impossible \nuntil it is Done ..",
    "If you can dream it ,\n you can do it",
    "Focus On The Outcomes\nNot The Obstacles",
    "Be So Good They Can't Ignore You",
    "You can't cross the Sea,\nmerely by standing and,\nstaring at the water",
    "It might not be easy because\n It will be worth it",
    "Discipline is doing what need to be done,\neven if you don't want to",
    "Keep Going",
    "Never Understimate The Investment\n You Make In Yourself",
    "You only fail when you stop trying"
  ];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    bulbAnimation = CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.bounceOut));

    final random = Random().nextInt(quotes.length);

    quote = quotes[random];

    opacityAnimation = CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.7, 1, curve: Curves.ease));

    animationController.forward();

    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        setState(() {
          showStickyNotes = true;
          showLoading = true;
        });
      }
      if (animationController.status == AnimationStatus.forward) {
        setState(() {
          showName = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 10)).then((value) {
      const MainFrame().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: bulbAnimation,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0)
                        .animate(opacityAnimation),
                    child: Image.asset(
                      "assets/bulb.gif",
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                AnimatedOpacity(
                    opacity: showStickyNotes ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      "assets/sticky_notes.gif",
                      height: 200,
                      width: 200,
                    )),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 900),
                  bottom: showName ? 240 : 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedCrossFade(
                        crossFadeState: showLoading
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        sizeCurve: Curves.bounceInOut,
                        alignment: Alignment.bottomLeft,
                        duration: const Duration(seconds: 1),
                        firstChild: Text(
                          quote,
                          key: UniqueKey(),
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: boldTextStyle(size: 15),
                        ),
                        secondChild: Text(
                          "Study Ease",
                          key: UniqueKey(),
                          style: boldTextStyle(size: 25),
                        )),
                  ),
                )
              ],
            )));
  }
}
