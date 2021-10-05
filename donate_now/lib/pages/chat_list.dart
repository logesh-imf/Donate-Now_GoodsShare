import 'package:donate_now/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:donate_now/firestore/chatslistFirestore.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/class/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate_now/firestore/Chat_History.dart';

// getChatsList(String id) {
//   List<Widget> chats = [];

//   try {
//     FirebaseFirestore.instance.collection('chat_history').get().then((value) {
//       value.docs.forEach((element) {
//         chats.add(Text('Hello world'));
//       });
//     });
//   } catch (e) {
//     print(e.toString());
//   }

//   return chats;
// }

Future setConversation(BuildContext context, String id) async {
  final currentUser = Provider.of<CurrentUser>(context, listen: false);
  final chat_provider = Provider.of<Chat_Histroy>(context, listen: false);
  await chat_provider.setUser(currentUser.email, id);
  await chat_provider.prepareChat(context);
}

Scaffold ChatList(BuildContext context) {
  final currentUser = Provider.of<CurrentUser>(context, listen: false);
  final chatListProvider = Provider.of<chatsListFirestore>(context);
  final chat_provider = Provider.of<Chat_Histroy>(context, listen: false);

  List<ListTile> chatSListTile() {
    List<ListTile> chats = [];

    chatListProvider.chatList.forEach((element) {
      chats.add(ListTile(
        title: Text(element),
        onTap: () async {
          await setConversation(context, element);
          Navigator.push(
              context, MaterialPageRoute(builder: (con) => ChatPage(context)));
        },
      ));
    });

    // chatListProvider.chatTile.forEach((element) {
    //   chats.add(ListTile(
    //     leading: (element.imageURL.isNotEmpty)
    //         ? CircleAvatar(backgroundImage: NetworkImage(element.imageURL))
    //         : CircleAvatar(
    //             backgroundColor: Colors.green,
    //             child: Text(
    //               element.name[0].toString().toUpperCase(),
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //           ),
    //     title: Text(element.name),
    //     onTap: () async {
    //       await setConversation(context, element.email);
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (con) => ChatPage(context)));
    //     },
    //   ));
    // });

    return chats;
  }

  SingleChildScrollView getChats(CurrentUser currentUser) {
    return SingleChildScrollView(
      child: Column(
        children: chatSListTile(),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Design.backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('All Chats'),
    ),
    body: Stack(children: [
      (chat_provider.isLoading) ? CircularProgressIndicator() : Container(),
      StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('chat_history').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            chatListProvider.getChats(currentUser.email, context);
            return getChats(currentUser);
          } else
            return Text('No data');
        },
      ),
    ]),
  );
}
