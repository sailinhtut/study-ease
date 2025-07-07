import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:notetask/notetask/settings/screens/about.dart';
import 'package:notetask/notetask/settings/screens/background_images_page.dart';
import 'package:notetask/notetask/settings/screens/faq_page.dart';
import 'package:notetask/notetask/settings/screens/versions_progress.dart';
import 'package:notetask/services/admob_services.dart';
import 'package:notetask/services/notification_services.dart';
import 'package:notetask/states/app_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  BannerAd? bannerAd;
  bool showBanner = false;

  @override
  void initState() {
    super.initState();
    initAdvertise();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();
  }

  Future<void> initAdvertise() async {
    bannerAd = AdmobServices.instance.loadBanner(AdSize.fullBanner);
    bool isInternetConnection = await isNetworkAvailable();
    if (bannerAd != null && isInternetConnection) {
      await bannerAd!.load();
      setState(() {
        showBanner = true;
        print("output : Here set state");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(language.settings),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  About().launch(context);
                },
                icon: const Icon(Icons.info_outline_rounded))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            ListTile(
                title: Text("General",
                    style: boldTextStyle(
                        color: appState.isDarkMode.value
                            ? Colors.white
                            : Colors.black))),
            buildLanguagePicker(),
            buildTextScalePicker(),
            Card(
              elevation: 1,
              child: ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(language.palette),
                  trailing: buildPalette(context)),
            ),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.eco),
                title: Text(language.themes),
                onTap: () => const ThemeSelector().launch(context),
              ),
            ),
            ListTile(
                title: Text("System",
                    style: boldTextStyle(
                        color: appState.isDarkMode.value
                            ? Colors.white
                            : Colors.black))),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(language.notificationSetting),
                onTap: () {
                  AppSettings.openNotificationSettings();
                },
              ),
            ),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.notifications_off_rounded),
                title: const Text("Cancel All Notifications"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text("Confirm"),
                            shape: dialogShape(14),
                            content: const Text(
                                "Are you sure to cancel all notifications ?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    finish(context);
                                  },
                                  child: const Text('Rethink')),
                              TextButton(
                                  onPressed: () {
                                    NotificationServices.instance
                                        .deleteAllScheduledNotifications();
                                    finish(context);
                                  },
                                  child: const Text('Confirm'))
                            ],
                          ));
                },
              ),
            ),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.soundcloud),
                title: Text(language.sound),
                onTap: () {
                  AppSettings.openSoundSettings();
                },
              ),
            ),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.layers),
                title: Text(language.overlay),
                onTap: () {
                  AppSettings.openAppSettings();
                },
              ),
            ),
            ListTile(
                title: Text("Help & Supports",
                    style: boldTextStyle(
                        color: appState.isDarkMode.value
                            ? Colors.white
                            : Colors.black))),
            ListTile(
              leading: const Icon(FontAwesomeIcons.question),
              title: const Text("FAQ"),
              onTap: () => FAQ().launch(context),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Versions & Progresss"),
              onTap: () => const VersionAndProgress().launch(context),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: showBanner
                ? SizedBox(
                    height: bannerAd!.size.height.toDouble(),
                    width: bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: bannerAd!))
                : const SizedBox()));
  }

  Widget buildLanguagePicker() {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(language.language),
        trailing: GetX<AppController>(
            builder: (app) => PopupMenuButton(
                  child: Text(
                      app.languageCode.value == "my" ? "မြန်မာ" : "English"),
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        app.setLanguageCode("my");
                        break;
                      case 1:
                        app.setLanguageCode("en");
                        break;
                    }
                    setState(() {});
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 0, child: Text("မြန်မာ")),
                    PopupMenuItem(value: 1, child: Text("English")),
                  ],
                )),
      ),
    );
  }

  Widget buildTextScalePicker() {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.text_increase),
        title: Text(language.textScale),
        trailing: GetX<AppController>(
            builder: (app) => PopupMenuButton(
                  child: Text(app.textScale.toString()),
                  onSelected: (value) {
                    double scale = app.textScale.value;
                    switch (value) {
                      case 0:
                        scale = 0.8;
                        break;
                      case 1:
                        scale = 0.9;
                        break;
                      case 2:
                        scale = 1.0;
                        break;
                      case 3:
                        scale = 1.1;
                        break;
                      case 4:
                        scale = 1.2;
                        break;
                    }
                    app.setTextScale(scale);
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 0, child: Text("Tiny")),
                    PopupMenuItem(value: 1, child: Text("Small")),
                    PopupMenuItem(value: 2, child: Text("Normal")),
                    PopupMenuItem(value: 3, child: Text("Big")),
                    PopupMenuItem(value: 4, child: Text("Huge")),
                  ],
                )),
      ),
    );
  }

  Widget buildPalette(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (ctx) => StatefulBuilder(
                  builder: (ctx, setSt) => Dialog(
                      shape: dialogShape(15),
                      child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text("Color Palette",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    Color? pickedColor;
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Pick a color!'),
                                        content: SingleChildScrollView(
                                          child: MaterialPicker(
                                            pickerColor: context.primaryColor,
                                            onColorChanged: (color) {
                                              pickedColor = color;
                                            },

                                            // only on portrait mode
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Pick'),
                                            onPressed: () {
                                              if (pickedColor != null) {
                                                appState.addColor(pickedColor!);
                                                setSt(() {});
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              15.height,
                              SizedBox(
                                height: 120,
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    scrollDirection: Axis.horizontal,
                                    childAspectRatio: 2 / 3,
                                    children: appState.availableColors
                                        .map(
                                          (element) => Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: ShapeDecoration(
                                                  shape: const StadiumBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black12)),
                                                  color: element),
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(
                                                  right: 3),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog<bool>(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                "Confirm"),
                                                            shape:
                                                                dialogShape(15),
                                                            content: const Text(
                                                                "Are you sure to delete  ?"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    appState.removeColor(
                                                                        element);
                                                                    setSt(
                                                                        () {});
                                                                    finish(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Confirm",
                                                                  )),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Cancel",
                                                                  )),
                                                            ],
                                                          ));
                                                },
                                                child: const Card(
                                                  color: Colors.white,
                                                  elevation: 4,
                                                  child: Icon(
                                                    Icons.clear_rounded,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ),
                                                ),
                                              )),
                                        )
                                        .toList()),
                              )
                            ],
                          )))));
        },
        child: const Icon(
          Icons.colorize_sharp,
          color: Colors.amber,
        ));
  }
}
