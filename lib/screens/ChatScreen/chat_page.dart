import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/chat_room_model.dart';
import 'package:flutter_amplify_demo/notifiers/providers.dart';
import 'package:flutter_amplify_demo/notifiers/update_user_data_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_amplify_demo/screens/ChatScreen/chat_detail_page.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future _onRefresh() async {
    await context.read(updateUserDataProvider).getUser();
    _refreshController.refreshCompleted();
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
          padding: EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: TextStyle(
                    fontSize: 23, color: white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: textfieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  style: TextStyle(color: white),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(LineIcons.search, color: white.withOpacity(0.3)),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle:
                        TextStyle(color: white.withOpacity(0.3), fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
          child: Divider(color: white.withOpacity(0.3)),
        ),
        SizedBox(
          height: 10,
        ),
        Consumer(
          builder: (_, watch, __) {
            final state = watch(updateUserDataProvider.state);
            if (state
                is UpdateUserDataSuccess) if (state.user.chatRooms.length > 0) {
              return buildUserChatCards(state.user.chatRooms);
            } else if (state is UpdateUserDataLoading)
              return Center(child: CircularProgressIndicator());
            return Container();
          },
        ),
      ],
    );
  }

  Column buildUserChatCards(List<ChatRoomModel> chatRooms) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: chatRooms
          .map((chatRoom) => UserChatCard(
                context: context,
                size: size,
                name: chatRoom.otherUserName,
                chatId: chatRoom.chatId,
              ))
          .toList(),
    );
  }
}

class UserChatCard extends StatelessWidget {
  const UserChatCard({
    Key key,
    @required this.context,
    @required this.size,
    @required this.name,
    this.chatId,
  }) : super(key: key);

  final BuildContext context;
  final Size size;
  final String name;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              name: name,
              chatId: chatId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/user_placeholder.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  width: (size.width - 40) * 0.6,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white.withOpacity(0.5))
          ],
        ),
      ),
    );
  }
}
