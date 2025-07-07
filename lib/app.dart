import 'dart:isolate';
import 'dart:math';
import 'package:android_window/android_window.dart';
import 'package:clipboard/clipboard.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/common/colors.dart';
import 'package:notetask/common/constants.dart';
import 'package:notetask/notetask/note/screens/archieve_notes.dart';
import 'package:notetask/notetask/note/screens/favourite_notes.dart';
import 'package:notetask/notetask/settings/screens/setting_page.dart';
import 'package:notetask/services/admob_services.dart';
import 'package:notetask/components/rounded_indicator.dart';
import 'package:notetask/splash_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'common/themes.dart';
import 'components/democracy_widget.dart';
import 'components/theme_switcher.dart';
import 'main.dart';
import 'notetask/note/model/note.dart';
import 'notetask/note/screens/note_list_page.dart';
import 'notetask/task/model/task.dart';
import 'notetask/task/screens/task_list_page.dart';
import 'states/app_controller.dart';
import 'package:android_window/main.dart' as android_window;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  AppOpenAd? appOpenAD;

  void loadAppOpen() {
    AdmobServices.instance
        .loadAppOpen(onSuccessfullLoaded: (ads) => appOpenAD = ads);
  }

  @override
  void initState() {
    super.initState();
    loadAppOpen();

    AdmobServices.instance.appOpenAddListener(appOpenAD);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Get.put(AppController());

    return Obx(
      () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:
              appState.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          darkTheme: darkTheme,
          theme: lightTheme,
          // localizationsDelegates: [
          //   // My Delegate

          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate
          // ],
          // locale: Locale(appState.languageCode.value),
          // localeResolutionCallback: (locale, supportedLocales) =>
          //     Locale(appState.languageCode.value),
          builder: (BuildContext context, Widget? widget) {
            final data = MediaQuery.of(context);
            return GetX<AppController>(
              builder: (appState2) => MediaQuery(
                data: data.copyWith(textScaleFactor: appState2.textScale.value),
                child: widget!,
              ),
            );
          },
          home: const SplashScreen()),
    );
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController tabController;

  bool isNoteSide = true;
  bool isEditMode = false;

  bool isFloatAppOpening = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    addTabBarListener();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkFloppyIsActivated();
    });
  }

  void addTabBarListener() {
    tabController.addListener(() {
      setState(() {
        tabController.index == 0 ? isNoteSide = true : isNoteSide = false;
      });
    });
  }

  void checkFloppyIsActivated() async {
    final isOpened = await android_window.isRunning();
    setState(() {
      isFloatAppOpening = isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    android_window.setHandler(
      (String name, data) async {
        switch (name) {
          case "copyThis":
            await FlutterClipboard.copy(data as String);
            break;
          case "giveMeCopy":
            android_window.post("giveMeCopy", await FlutterClipboard.paste());
            break;
          case "floppyData":
            setValue("floppyText", data as String);
            setState(() {});
            break;
          case "deactivated":
            setState(() {
              isFloatAppOpening = false;
            });
            break;
        }
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        isFloatAppOpening: isFloatAppOpening,
        onFloatTileActivated: (bool isFloatActivated) {
          setState(() {
            isFloatAppOpening = isFloatActivated;
          });
        },
      ),
      body: GetX<AppController>(
        builder: (controller) => Stack(
          fit: StackFit.expand,
          children: [
            if (controller.withBackground.value)
              Image.asset(controller.backgroundImage.value, fit: BoxFit.fill),
            NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                    [_buildAppBar()],
                body: TabBarView(controller: tabController, children: [
                  NoteListPage(
                      isInEditMode: isEditMode,
                      onEditStatusChanged: (editMode) {
                        setState(() {
                          isEditMode = editMode;
                        });
                      }),
                  const TaskListPage()
                ]))
          ],
        ),
      ),
    );
  }

  void showFloppyDataDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Floppy Note Data',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      FlutterClipboard.copy(getStringAsync("floppyText"));
                      toast("Text Copied");
                    },
                    icon: const Icon(Icons.copy, size: 20))
              ],
            ),
            content: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SelectableText(getStringAsync("floppyText")))));
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor:
          appState.withBackground.value ? Colors.black.withOpacity(0.6) : null,
      elevation: 0,
      foregroundColor: appState.withBackground.value ? Colors.white : null,
      title: const Text("Study Ease",
          style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        if (getStringAsync("floppyText").isNotEmpty)
          IconButton(
              onPressed: () {
                showFloppyDataDialog();
              },
              icon: const Icon(FontAwesomeIcons.bookBookmark, size: 20)),
        IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.segment_rounded)),
      ],
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(45, 0, 0, 0))),
      bottom: TabBar(
          controller: tabController,
          labelPadding: const EdgeInsets.only(bottom: 0),
          indicator: RoundedTabIndicator(
              width: 60, color: Colors.amberAccent, height: 2, bottomMargin: 1),
          labelStyle: const TextStyle(fontSize: 12),
          labelColor: Colors.grey,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: language.keepNote,
            ),
            Tab(
              text: language.todo,
            ),
          ]),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer(
      {super.key,
      required this.isFloatAppOpening,
      required this.onFloatTileActivated});

  final bool isFloatAppOpening;
  final Function(bool isFloatActivated) onFloatTileActivated;

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(
      builder: (app) => Container(
        width: 250,
        height: double.maxFinite,
        color: appState.withBackground.value
            ? const Color(0xff0F0F0F)
            : app.isDarkMode.value
                ? Colors.black
                : Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildIconBoard(app.isDarkMode.value),
              const DemocracyWidget(),
              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: Icons.archive,
                  title: language.archieves,
                  onTap: () {
                    const ArchieveNotes().launch(context);
                  }),
              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: Icons.favorite_rounded,
                  title: language.favourite,
                  onTap: () {
                    const FavouriteNotes().launch(context);
                  }),
              buildFloatTile(app.isDarkMode.value),
              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: FontAwesomeIcons.crown,
                  title: language.premium,
                  onTap: () {
                    // Premium Implementation
                  }),

              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: Icons.settings,
                  title: language.settings,
                  onTap: () {
                    const Settings().launch(context);
                  }),
              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: FontAwesomeIcons.share,
                  title: language.share,
                  onTap: () {
                    Share.share(
                        "For your well noted days, you will be never regret for the days you passed !\n\nhttps://play.google.com/store/apps/details?id=com.successtechnology.notetask");
                  }),
              DrawerTile(
                  isDarkMode: app.isDarkMode.value,
                  icon: Icons.shield_outlined,
                  title: language.pravicy,
                  onTap: () {
                    launchUrlString(
                        "https://sailinhtut.github.io/notetask_pravicy.html",
                        mode: LaunchMode.externalApplication);
                  }),
              // DrawerTile(
              //   isDarkMode: app.isDarkMode.value,
              //   icon: Icons.insert_drive_file,
              //   title: language.terms,
              //   onTap: () {
              //     launchUrlString(
              //         "https://sailinhtut.github.io/notetask_terms.html",mode : LaunchMode.externalApplication);
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFloatTile(bool isDarkMode) {
    return ListTile(
      title: Text(language.floppyNote),
      leading: Icon(
        FontAwesomeIcons.bookBookmark,
        color: isDarkMode ? null : Colors.black,
      ),
      trailing: Text(
        isFloatAppOpening ? language.activated : "",
        style: secondaryTextStyle(color: Colors.amberAccent, size: 10),
      ),
      onTap: () {
        if (isFloatAppOpening) {
          android_window.close();
        } else {
          android_window.open(size: const Size(130, 130), focusable: true);
          onFloatTileActivated(true);
        }
        onFloatTileActivated(!isFloatAppOpening);
      },
    );
  }

  Widget buildIconBoard(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          height: 200,
          color: appState.withBackground.value
              ? Colors.black.withOpacity(0.8)
              : isDarkMode
                  ? Colors.blueGrey
                  : const Color(0xfff1f2f3),
          child: Center(
              child: Image.asset(
            appIconOnly,
            height: 100,
          )),
        ),
        if (!appState.withBackground.value)
          const Positioned(right: 20, top: 20, child: ThemeSwitcher()),
      ],
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.isDarkMode,
      required this.icon,
      required this.title,
      required this.onTap});

  final bool isDarkMode;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: Icon(
          icon,
          color: isDarkMode ? null : Colors.black,
        ),
        onTap: onTap);
  }
}
