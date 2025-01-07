import 'package:Ezgiler/app_state.dart';
import 'package:Ezgiler/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SettingsPage());
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: const Scaffold(
        appBar: MySettingsAppBar(),
        extendBodyBehindAppBar: true,
        body: BlurredBackgroundForSettings(),
      ),
    );
  }
}

class BlurredBackgroundForSettings extends StatefulWidget {
  const BlurredBackgroundForSettings({super.key});

  @override
  _BlurredBackgroundForSettingsState createState() {
    return _BlurredBackgroundForSettingsState();
  }
}

class _BlurredBackgroundForSettingsState
    extends State<BlurredBackgroundForSettings> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        settingsList(context),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_settings.png'),
          // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<Color> colorOptions = [
    const Color(0xFFCD5D5C),
    const Color(0xFFFEA501),
    const Color(0xFF90EE90),
    const Color(0xFF3FE0D0),
    const Color(0xFFAED8E6),
    const Color(0xFFC0C0C0),
    const Color(0xFF9470DC),
    const Color(0xFFFFFFFF),
  ];

  //get the selected color from shared preferences
  Future<void> _loadSelectedColor() async {
    final appState = context.read<AppState>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appState.updateColor(Color(prefs.getInt('selectedColor') ?? 0xFFFEA501));
  }

  Future<void> _loadScrollDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scrollDuration = prefs.getInt('scrollDuration') ?? 120;
  }

  Widget settingsList(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF121C2F),
          // Set your desired background color
          borderRadius: BorderRadius.circular(25),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(15),
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/metronome.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(width: 6),
              // Adjust the spacing between the icon and text
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Metronom Hızı",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Metronom Hızını Ayarlayın",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          shape: const Border(),
          trailing:
              Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
          onExpansionChanged: (bool expansion) {
            setState(
              () {
                _loadScrollDuration();
                isExpanded = expansion;
              },
            );
          },
          children: [
            //dialog to select the set the scroll duration with right and left arrow buttons
            Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 15, top: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1C273D),
                // Set your desired background color
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(
                        () {
                          metronomeBpm = metronomeBpm - 1;
                          if (metronomeBpm < 10) {
                            metronomeBpm = 10;
                          }
                          SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                        },
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121C2F),
                      // Set your desired background color
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "$metronomeBpm BPM",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(
                        () {
                          metronomeBpm = metronomeBpm + 1;
                          if (metronomeBpm > 200) {
                            metronomeBpm = 200;
                          }
                          SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF121C2F),
          // Set your desired background color
          borderRadius: BorderRadius.circular(25),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(15),
          title: const Row(
            children: [
              Image(
                image: AssetImage('assets/ChordColor.png'),
                height: 40,
                width: 40,
              ),
              SizedBox(width: 8),
              // Adjust the spacing between the icon and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Akor Rengi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Akor rengini seçin",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          shape: const Border(),
          trailing:
              Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
          onExpansionChanged: (bool expansion) {
            // Update the expansion state when the tile is expanded or collapsed
            setState(
              () {
                _loadSelectedColor();
                isExpanded = expansion;
              },
            );
          },
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1C273D),
                // Set your desired background color
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 70, // Set a fixed height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: colorOptions.length,
                      itemBuilder: (context, index) {
                        Color color = colorOptions[index];
                        return InkWell(
                          onTap: () {
                            final appState = context.read<AppState>();
                            appState.updateColor(color);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: context.watch<AppState>().selectedColor ==
                                      color
                                  ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black38,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF121C2F),
          // Set your desired background color
          borderRadius: BorderRadius.circular(25),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/arrow_downward_circle.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 30.0,
                width: 30.0,
              ),
              const SizedBox(width: 15),
              // Adjust the spacing between the icon and text
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Yavaş Kaydırma",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Kaydırma Süresini Ayarlayın",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          shape: const Border(),
          trailing:
              Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
          onExpansionChanged: (bool expansion) {
            setState(
              () {
                _loadScrollDuration();

                isExpanded = expansion;
              },
            );
          },
          children: [
            //dialog to select the set the scroll duration with right and left arrow buttons

            Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 15, top: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1C273D),
                // Set your desired background color
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(
                        () {
                          scrollDuration = scrollDuration - 10;
                          if (scrollDuration < 10) {
                            scrollDuration = 10;
                          }
                          SaveScrollDuration.saveScrollDuration(scrollDuration);
                        },
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121C2F),
                      // Set your desired background color
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "$scrollDuration Saniye",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(
                        () {
                          scrollDuration = scrollDuration + 10;
                          if (scrollDuration > 900) {
                            scrollDuration = 900;
                          }
                          SaveScrollDuration.saveScrollDuration(scrollDuration);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF121C2F),
          // Set your desired background color
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/info.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 30.0,
                width: 30.0,
              ),
              const SizedBox(width: 15),
              // Adjust the spacing between the icon and text
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hakkında",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Uygulama Hakkında Bilgi",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            // Handle the tap event
            context.go('/about');
          },
        ),
      ),
      const SizedBox(height: 20)
    ]);
  }
}

class SaveSelectedColor {
  static const String _selectedColorKey = "selectedColor";

  SaveSelectedColor(Color color);

  // Save the selected color to shared preferences
  static Future<void> saveColor(int selectedColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedColorKey, selectedColor);
  }

  // Retrieve the selected color from shared preferences
  static Future<String?> getSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedColorKey);
  }
}

class SaveScrollDuration {
  static const String scrollDurationKey = "scrollDuration";

  SaveScrollDuration(int scrollDuration);

  // Save the selected color to shared preferences
  static Future<void> saveScrollDuration(int scrollDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scrollDurationKey, scrollDuration);
  }
}

class SaveMetronomeBpm {
  static const String metronomeBpmKey = "metronomeBpm";

  SaveMetronomeBpm(int metronomeBpm);

  // Save the selected color to shared preferences
  static Future<void> saveMetronomeBpm(int metronomeBpm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(metronomeBpmKey, metronomeBpm);
  }
}

class MySettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MySettingsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ayarlar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () async {
          final appState = context.read<AppState>();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          appState.updateColor(Color(prefs.getInt('selectedColor') ?? 0xFFFEA501));
          metronomeBpm = prefs.getInt('metronomeBpm') ?? 120;
          
          // Get the current location to determine where to go back to
          final location = GoRouterState.of(context).uri.path;
          if (location.startsWith('/settings')) {
            final previousPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
            if (previousPath.startsWith('/song/')) {
              context.go(previousPath);
            } else {
              context.go('/');
            }
          }
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
