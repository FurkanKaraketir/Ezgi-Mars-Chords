import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AboutPage());
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAboutAppBar(),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForAbout(),
    );
  }
}

class BlurredBackgroundForAbout extends StatelessWidget {
  const BlurredBackgroundForAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        aboutList(),
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

  Widget aboutList() {
    Future<void> launchUri(Uri url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: const Center(
          //make text center

          child: Text(
            'Grup İslami Direniş',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: const Center(
          //make text center

          child: Text(
            'Ezgi ve Marş Uygulaması',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: const Text(
          'İlk ve tek albümünü 1992 yılında Özgürlük İçin İslami Direniş adıyla yayınlayan grup, yeni üyeleriyle 2013 yılından beri çalışmalarına devam etmektedir.',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: const Text(
          'Linkler',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://instagram.com/grupislamidirenis'));
              },
              child: Image.asset(
                'assets/instagram_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://instagram.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'Instagram',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://instagram.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'instagram.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
              },
              child: Image.asset(
                'assets/x_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
                  },
                  child: const Text(
                    'Twitter',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
                  },
                  child: const Text(
                    'twitter.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://facebook.com/grupislamidirenis'));
              },
              child: Image.asset(
                'assets/facebook_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://facebook.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'Facebook',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://facebook.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'facebook.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class MyAboutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAboutAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Hakkında',
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
        onPressed: () {
          context.go('/settings');
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
