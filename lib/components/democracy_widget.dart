import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DemocracyWidget extends StatelessWidget {
  const DemocracyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: radius(10),
                      side: BorderSide(color: Colors.amber.withOpacity(0.2))),
                  title: Row(
                    children: [
                      const Expanded(child: Text("Dear User")),
                      ClipRRect(
                        borderRadius: radius(5),
                        child: Image.asset(
                          "assets/ukrine.png",
                          width: 30,
                          height: 19,
                          fit: BoxFit.fill,
                        ),
                      ),
                      5.width,
                      ClipRRect(
                        borderRadius: radius(5),
                        child: Image.asset(
                          "assets/myanmar.png",
                          width: 30,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                      "Be Safe all the World 🙏.Please stand with Ukrine and Myanmar ..."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          finish(context);
                        },
                        child: const Text("Democracy"))
                  ],
                ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
            color: Colors.white12,
            border: Border.symmetric(
                horizontal: BorderSide(color: Colors.white10))),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              15.width,
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  "assets/ukrine.png",
                  height: 18,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ),
              10.width,
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  "assets/myanmar.png",
                  height: 18,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ),
              10.width,
              Text(
                "Proud Of You Living Under Democracy Countries",
                style: secondaryTextStyle(size: 10),
              ),
              10.width
            ],
          ),
        ),
      ),
    );
  }
}
