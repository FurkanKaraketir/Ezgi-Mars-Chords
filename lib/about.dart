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
    return WillPopScope(
      onWillPop: () async {
        context.go('/settings');
        return false; // Prevent app from closing
      },
      child: const Scaffold(
        appBar: MyAboutAppBar(),
        extendBodyBehindAppBar: true,
        body: BlurredBackgroundForAbout(),
      ),
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
        SingleChildScrollView(
          child: aboutList(),
        ),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_settings.png'),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            width: double.infinity,
            child: const Text(
              'Grup İslami Direniş',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: double.infinity,
            child: const Text(
              'Ezgi ve Marş Uygulaması',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
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
            child: const Text(
              'Linkler',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          _buildSocialLink(
            'Instagram',
            'instagram.com/grupislamidirenis',
            'assets/instagram_icon.png',
            () => launchUri(Uri.parse('https://instagram.com/grupislamidirenis')),
          ),
          _buildSocialLink(
            'Twitter',
            'twitter.com/gislamidirenis',
            'assets/x_icon.png',
            () => launchUri(Uri.parse('https://twitter.com/gislamidirenis')),
          ),
          _buildSocialLink(
            'Facebook',
            'facebook.com/grupislamidirenis',
            'assets/facebook_icon.png',
            () => launchUri(Uri.parse('https://facebook.com/grupislamidirenis')),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: const Text(
              'Geliştiriciler',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          _buildSocialLink(
            'Enderun Mühendislik Klübü',
            'instagram.com/enderunmuhendislikkulubu',
            'assets/instagram_icon.png',
            () => launchUri(Uri.parse('https://www.instagram.com/enderunmuhendislikkulubu/')),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40.0, top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSocialLink(
                  'Furkan Karaketir',
                  'linkedin.com/in/furkankaraketir',
                  'assets/linkedin_icon.png',
                  () => launchUri(Uri.parse('https://www.linkedin.com/in/furkankaraketir/')),
                ),
                _buildSocialLink(
                  'Halit Başbuğ',
                  'linkedin.com/in/halit-başbuğ-a63510167',
                  'assets/linkedin_icon.png',
                  () => launchUri(Uri.parse('https://www.linkedin.com/in/halit-ba%C5%9Fbu%C4%9F-a63510167/')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSocialLink(String title, String url, String iconPath, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              iconPath,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    url,
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
