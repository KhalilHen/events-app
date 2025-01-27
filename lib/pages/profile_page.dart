import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 2;
  final authService = AuthService();
  String? username;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final fetchedUsername = await authService.getLoggedInUsername();
    setState(() {
      username = fetchedUsername ?? 'No user logged in';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Your Profile",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileHeader(),
            statistics(),
            settingsSection(),
            supportSection(),
            accountSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/homepage');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/event');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  icon: Icon(Icons.home),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  icon: Icon(Icons.event),
                ),
                label: 'Events'),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Icon(Icons.person_outline),
              ),
              label: "Profile",
            )
          ]),
    );
  }

  Widget profileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "$username " ?? "unknown user",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Edit profile"))
        ],
      ),
    );
  }

  Widget statistics() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Events\nAttended',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "10",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    // color: Theme.of(context).primaryColor,
                    fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Active\nRSVPs",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "10",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    // color: Theme.of(context).primaryColor,
                    fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Events\nOrganized",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "10",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    // color: Theme.of(context).primaryColor,
                    fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget settingsSection() {
    return section('Settings', [
      settingTile(Icons.notifications_outlined, "Notifications", "Manage notifications"),
      settingTile(
        Icons.lock_outline,
        'Privacy',
        'Control your privacy settings',
      ),
      settingTile(
        Icons.color_lens_outlined,
        'Appearance',
        'Customize app appearance',
      ),
    ]);
  }

  Widget settingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          // fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }

  Widget section(String title, List<Widget> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ]),
            child: Column(
              children: items,
            ),
          )
        ],
      ),
    );
  }

  Widget accountSection() {
    return section('Account', [
      settingTile(Icons.person_outline, "Personal information", "Update your personal information"),
      settingTile(Icons.email_outlined, "Email settings", "Manager your email settings"),
      settingTile(Icons.password_outlined, "Change password", "Update your password")
    ]);
  }

// Widget supportSection() {
//   return section(title, items)
// }
  Widget supportSection() {
    return section("Support", [
      settingTile(Icons.help_outline, "Help center", "Get help with a event"),
      settingTile(Icons.report_outlined, "Report a problem", "Contact us when there is something wrong"),
      settingTile(Icons.info_outline, "About us", "Learn more about us and the app!")
    ]);
  }
}
