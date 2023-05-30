import 'dart:async';
import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_14_messanger/widgets/dialog_chat.dart';
import 'package:p_14_messanger/widgets/functions.dart';
import 'package:p_14_messanger/widgets/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messagecontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference collectionReference;
  ScrollController scrollController = ScrollController();

  bool isEditing = false;
  String updatingMessage = '';
  String updatingMessageID = '';
  late Size size;

  @override
  void initState() {
    super.initState();
  collectionReference = firestore.collection('messenger');
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    firestore.collection('messager');
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GestureDetector(onTap: () {
          kNavigator(context, 'ChannelAbout');
        },),
        backgroundColor: Colors.purple,
        leading: const Padding(
          padding: EdgeInsets.only(left: 2, top: 5, bottom: 5),
          child: CircleAvatar(
            backgroundImage:
            NetworkImage("https://picsum.photos/500/300"),
            maxRadius: 15,
            minRadius: 15,
          ),
        ),
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: collectionReference
                  .orderBy('date', descending: true)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // print('snapshot: ${snapshot}');
                  // print('snapshot.data: ${snapshot.data}');
                  // final temp = snapshot.data;
                  // print(temp!.docs[0].data());
                  return ListView(
                    reverse: true,
                    controller: scrollController,
                    children: snapshot.data!.docs.map(
                      (doc) {
                        String id = doc.id;
                        //تبدیل داکیومنت به مپ
                        Map data = doc.data() as Map;
                        bool isMe = data['sender'] == auth.currentUser!.uid;
                        return GestureDetector(
                          onTap: () {
                            if(isMe == true) {
                              onMessageTapped(data, id);
                            }else{}
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Bubble(
                              margin: BubbleEdges.only(
                                  top: 10,
                                  left: (isMe) ? 10 : 0,
                                  right: (!isMe) ? 10 : 0),
                              alignment:
                                  (isMe) ? Alignment.topRight : Alignment.topLeft,
                              nip:
                                  (isMe) ? BubbleNip.rightTop : BubbleNip.leftTop,
                              color: (isMe)
                                  ? Colors.purple[100]
                                  : Colors.purple[200],
                              child: Text(data['text']),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Visibility(
                    visible: isEditing,
                    child: Container(
                      width: size.width - 65,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(225, 255, 199, 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4),
                        ),
                      ),
                      child: Text(updatingMessage),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        onTap: () {
                          Timer(
                            const Duration(milliseconds: 300),
                                () {
                              scrollController.jumpTo(
                                  scrollController.position.minScrollExtent);
                            },
                          );
                        },
                        controller: messagecontroller,
                        decoration: kMyInputDecoration.copyWith(
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    String text = messagecontroller.text;
    print(text);


    // if(text.trim().isEmpty){
    //
    //   return;
    //
    // }

    Map<String, dynamic> newMap = Map();
    newMap['text'] = text;
    String dateTime = DateTime.now().toString();
    String date = dateTime.substring(0, 10);
    String time = dateTime.substring(11, 19);
    newMap['time'] = time;
    newMap['date'] = date;
    // edit
    if (isEditing == true) {
      DocumentReference doc = collectionReference.doc(updatingMessageID);
      doc.update({
        'text': text,
      });
    } // add
    else {
      newMap['sender'] = auth.currentUser!.uid;
      newMap['sender_phone'] = auth.currentUser!.phoneNumber;
      collectionReference.add(newMap).then((value) {
        print(value);
      });
    }
    resetValues();
  }

  onMessageTapped(Map data, String id) {
    showDialog(
      builder: (BuildContext context) {
        return ChatDialog(
          onDelete: () {
            onDelete(data, id);
          },
          onEdit: () {
            onEdit(data, id);
          },
        );
      },
      context: context,
    );
  }

  onDelete(Map data, String id) async {
    collectionReference.doc(id).delete();
    Navigator.pop(context);
  }

  onEdit(Map data, String id) async {
    setState(() {
      isEditing = true;
      updatingMessage = data['text'];
      messagecontroller.text = data['text'];
      updatingMessageID = id;
    });
    Navigator.pop(context);
  }

  resetValues() {
    messagecontroller.clear();
    setState(() {
      updatingMessageID = '';
      updatingMessage = '';
      isEditing = false;
    });
  }
}
