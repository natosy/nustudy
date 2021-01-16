import 'package:flutter/material.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Components/history_section.dart';
import 'package:nus_study/components/header.dart';
import 'package:nus_study/Components/description_card.dart';
import '../Components/profile_card.dart';
import 'package:nus_study/Views/user_profile_options.dart';

///Shows users current profile. Comes under Tabs.
class UserProfilePage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Profile userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = widget.account.profile;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: width * 15),
            Header(title: 'My Profile'),
            IconButton(
                icon: Icon(Icons.menu),
                iconSize: width * 6,
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileOptions()))
                      .then((value) {
                    setState(() {});
                  });
                })
          ],
        ),
        ProfileCard(
          clickable: false,
          profile: userProfile,
        ),
        DescriptionCard(
          title: 'About me',
          description: userProfile.getBiography(),
        ),
        HistorySection(profile: userProfile),
      ],
    );
  }
}
