import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class VersionAndProgress extends StatelessWidget {
  const VersionAndProgress({super.key});

  final v1_0 = """
Note , Group Task ,Customized Notificatoin System are added.
""";

  final v2_0 = """
Floppy Note , Cancel Notifications , Themes , New Language are added.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Release Version'),
      ),
      body: ListView(
        children: [
          ListTile(
              title: const Text(
                "Version 1.0",
                style: TextStyle(color: Colors.grey),
              ),
              subtitle: Text(
                v1_0,
                style: secondaryTextStyle(size: 13),
              )),
          ListTile(
              title: Text(
                "Version 2.0",
                style: TextStyle(color: Colors.grey),
              ),
              subtitle: Text(
                v2_0,
                style: secondaryTextStyle(size: 13),
              )),
        ],
      ),
    );
  }
}
