import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/notifiers/all_other_user_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/providers.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/screens/SettingsScreen/components/image_picker.dart';
import 'package:flutter_amplify_demo/screens/SettingsScreen/components/users_list.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingsPage extends StatefulWidget {
  final Function updateHomeScreen;

  const SettingsPage({Key key, this.updateHomeScreen}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future _onRefresh() async {
    await context.read(userRepositoryProvider).getCurrUser();
    await context.read(userRepositoryProvider).getAllOtherUser();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    context.read(allOtherUserProvider).getAllOtherUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(color: Colors.white),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: getBody(),
        ),
      ),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text(
            "Settings",
            style: TextStyle(
                fontSize: 23, color: white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        UserSection(),
        SizedBox(
          height: 30,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Users List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Consumer(builder: (_, watch, __) {
            final currUser = watch(currUserProvider);
            final state = watch(allOtherUserProvider.state);
            if (state is AllOtherUserSuccess) {
              return Column(
                children: [
                  ...state.allOtherUser.map((user) {
                    bool hasAdded = false;
                    if (currUser.chatRooms.length > 0) {
                      int index = currUser.chatRooms.indexWhere(
                          (element) => element.otherUserId == user.id);
                      if (index == -1)
                        hasAdded = false;
                      else
                        hasAdded = true;
                    }
                    return UsersList(hasAdded: hasAdded, user: user);
                  }).toList()
                ],
              );
            } else if (state is AllOtherUserLoading)
              return Center(child: CircularProgressIndicator());
            return Container();
          }),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: textfieldColor),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: Column(
                children: [
                  buildListItem(
                    title: "Logout",
                    icon: Icons.logout,
                    onTap: () async {
                      await Amplify.Auth.signOut();
                      _navigationService.popAllAndReplace(RoutePath.Wrapper);
                    },
                  )
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }

  GestureDetector buildListItem({String title, IconData icon, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: white.withOpacity(0.2),
            size: 15,
          )
        ],
      ),
    );
  }
}

class UserSection extends ConsumerWidget {
  const UserSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userRepo = watch(userRepositoryProvider);
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(color: textfieldColor),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/user_placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (userRepo.currUser == null) buildNameWidget("N/A"),
                if (userRepo.currUser != null)
                  buildNameWidget(userRepo.currUser.username),
              ],
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: white.withOpacity(0.1), shape: BoxShape.circle),
              child: ImagePickerButton(),
            )
          ],
        ),
      ),
    );
  }

  Text buildNameWidget(String name) {
    return Text(
      name,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: white),
    );
  }
}
