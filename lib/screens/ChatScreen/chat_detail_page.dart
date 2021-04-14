import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/show_snackbar.dart';
import 'package:flutter_amplify_demo/components/update_message_bottom_sheet.dart';
import 'package:flutter_amplify_demo/models/chat_model.dart';
import 'package:flutter_amplify_demo/notifiers/chat_data_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/providers.dart';
import 'package:flutter_amplify_demo/screens/ChatScreen/ChatDetails/appbar.dart';
import 'package:flutter_amplify_demo/services/api_service/queries.dart';
import 'package:flutter_amplify_demo/services/helper.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String chatId;

  const ChatDetailPage({
    Key key,
    this.name,
    this.chatId,
  }) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController messageCtrl = TextEditingController();
  GraphQLSubscriptionOperation<dynamic> createOperation;
  GraphQLSubscriptionOperation<dynamic> updateOperation;
  GraphQLSubscriptionOperation<dynamic> deleteOperation;

  bool inSelectMode = false;
  List<String> selectedChats = [];

  @override
  void initState() {
    super.initState();
    context.read(chatDataProvider).getChatData(widget.chatId);
    onCreateChat();
    onUpdateChat();
    onDeleteChat();
  }

  @override
  void dispose() {
    createOperation.cancel();
    updateOperation.cancel();
    deleteOperation.cancel();
    super.dispose();
  }

  addToSelectedChats(String messageId) {
    if (selectedChats.contains(messageId)) {
      selectedChats.remove(messageId);
      if (selectedChats.length == 0) {
        setState(() {
          inSelectMode = false;
        });
      }
    } else
      selectedChats.add(messageId);
  }

  closeSelectionModel() {
    setState(() {
      inSelectMode = false;
      selectedChats = [];
    });
  }

  deleteSelectedChats() async {
    selectedChats.forEach((chatId) {
      List<ChatModel> chatDataTemp =
          context.read(chatRepositoryProvider).chatData;
      int index = chatDataTemp.indexWhere((element) => element.id == chatId);
      context.read(chatDataProvider).deleteChatData(
            chatDataTemp[index].id,
            chatDataTemp[index].version,
          );
      setState(() {
        inSelectMode = false;
        selectedChats = [];
      });
    });
  }

  openUpdateMessageSheet() async {
    if (selectedChats.length > 1) {
      showSnackBar(context, "Please select only one message to update.");
    } else {
      List<ChatModel> chatDataTemp =
          context.read(chatRepositoryProvider).chatData;
      int index =
          chatDataTemp.indexWhere((element) => element.id == selectedChats[0]);
      updateMessageBottomSheet(
        context,
        chatDataTemp[index].message,
        chatDataTemp[index].id,
        widget.chatId,
        chatDataTemp[index].version,
        closeSelectionModel,
      );
    }
  }

  onCreateChat() {
    createOperation = Amplify.API.subscribe(
      request: GraphQLRequest(document: Queries.onCreateChatData),
      onData: (event) {
        context.read(chatDataProvider).getChatData(widget.chatId);
      },
      onEstablished: () {
        print('Subscription established');
      },
      onError: (e) {
        print('Subscription failed with error: $e');
      },
      onDone: () {
        print('Subscription has been closed successfully');
      },
    );
  }

  onUpdateChat() {
    updateOperation = Amplify.API.subscribe(
      request: GraphQLRequest(document: Queries.onUpdateChatData),
      onData: (event) {
        print(event);
        context.read(chatDataProvider).getChatData(widget.chatId);
      },
      onEstablished: () {
        print('Subscription established');
      },
      onError: (e) {
        print('Subscription failed with error: $e');
      },
      onDone: () {
        print('Subscription has been closed successfully');
      },
    );
  }

  onDeleteChat() {
    deleteOperation = Amplify.API.subscribe(
      request: GraphQLRequest(document: Queries.onDeleteChatData),
      onData: (event) {
        context.read(chatDataProvider).getChatData(widget.chatId);
      },
      onEstablished: () {
        print('Subscription established');
      },
      onError: (e) {
        print('Subscription failed with error: $e');
      },
      onDone: () {
        print('Subscription has been closed successfully');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: getChatDetailsAppBar(
          context: context,
          name: widget.name,
          inSelectMode: inSelectMode,
          selectedChatCount: selectedChats.length,
          closeSelectionModel: closeSelectionModel,
          deleteSelectedChats: deleteSelectedChats,
          openUpdateMessageSheet: openUpdateMessageSheet,
        ),
        bottomSheet: getBottomSheet(),
        body: getBody(),
        // body: getBody(),
      ),
    );
  }

  Widget getBottomSheet() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      // height: 60,
      decoration: BoxDecoration(color: greyColor),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.toWidth),
              child: Icon(
                Icons.add,
                color: primary,
                size: 30,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: messageCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  hintText: "",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: primary,
                  size: 30,
                ),
                onPressed: () async {
                  context
                      .read(chatDataProvider)
                      .addChatData(widget.chatId, messageCtrl.text);
                  messageCtrl.text = "";
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg_chat.jpg"), fit: BoxFit.cover),
      ),
      child: Consumer(
        builder: (_, watch, __) {
          final state = watch(chatDataProvider.state);
          if (state is ChatDataSuccess)
            return buildChatList(chatData: state.chatData);
          return Container();
        },
      ),
    );
  }

  Widget buildChatList({List<ChatModel> chatData}) {
    return ListView(
      reverse: true,
      padding: EdgeInsets.only(top: 20, bottom: 80),
      children: List.generate(
        chatData.length,
        (index) {
          return buildChatBubble(
            message: chatData[index].message,
            isMe: chatData[index].senderId == context.read(currUserProvider).id,
            time: formatDate(chatData[index].createdAt),
            messageId: chatData[index].id,
          );
        },
      ),
    );
  }

  Widget buildChatBubble({
    Key key,
    bool isMe,
    String message,
    String time,
    String messageId,
  }) {
    if (isMe) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onLongPress: () {
            if (!inSelectMode)
              setState(() {
                inSelectMode = true;
                addToSelectedChats(messageId);
              });
            else
              setState(() {
                addToSelectedChats(messageId);
              });
          },
          onTapUp: (TapUpDetails tapUpDetails) {
            if (inSelectMode)
              setState(() {
                addToSelectedChats(messageId);
              });
          },
          child: Container(
            color: inSelectMode && selectedChats.contains(messageId)
                ? chatBoxMe.withOpacity(0.4)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 14,
                        bottom: 2,
                        top: 2,
                      ),
                      child: Bubble(
                        nip: BubbleNip.rightTop,
                        color: chatBoxMe,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message,
                              style: TextStyle(fontSize: 16, color: white),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 12, color: white.withOpacity(0.4)),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.done_all_outlined,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 14, bottom: 10),
                child: Bubble(
                  nip: BubbleNip.leftTop,
                  color: chatBoxOther,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      );
    }
  }
}
