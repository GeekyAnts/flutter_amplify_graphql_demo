import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/user_model.dart';
import 'package:flutter_amplify_demo/notifiers/add_user_to_chatroom_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/providers.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersList extends StatefulWidget {
  final UserModel user;
  final bool hasAdded;
  UsersList({Key key, this.hasAdded, this.user}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                          image:
                              AssetImage("assets/images/user_placeholder.png"),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.user.username,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(
                    child: Consumer(
                      builder: (_, watch, __) {
                        final state = watch(addUserToChatRoomProvider.state);
                        // if (state is AddUserToChatRoomLoading)
                        //   return CircularProgressIndicator();
                        if (state is AddUserToChatRoomSuccess) {
                          return buildButton(true);
                        }
                        return buildButton(widget.hasAdded);
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(bool hasAdded) {
    if (isLoading)
      return CircularProgressIndicator();
    else
      return IconButton(
        icon: Icon(
          hasAdded ? Icons.check : Icons.add,
          size: 20,
        ),
        color: primary,
        onPressed: () async {
          if (!hasAdded) {
            setState(() {
              isLoading = true;
            });
            await context.read(addUserToChatRoomProvider).addUser(widget.user);
            setState(() {
              isLoading = false;
            });
          }
        },
      );
  }
}
