import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:p_14_messanger/widgets/constants.dart';
import 'package:p_14_messanger/widgets/custom_item.dart';
import 'package:p_14_messanger/widgets/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                    ),
                    child: Text(auth.currentUser?.phoneNumber ?? ''),
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () {
                kNavigator(context, 'chat');
              },
              title: Text('Chat'),
              trailing: Icon(Icons.chat),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                kNavigator(context, 'SellScreen');
              },
              title: Text('Sell'),
              trailing: Icon(Icons.sell),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                auth.signOut();
                kNavigator(context, 'login');
              },
              title: Text('Exit'),
              trailing: Icon(Icons.exit_to_app),
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text('data'),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              child: Row(
                children: Categories.map(
                  (MultiSelectItem category) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(category.label),
                  ),
                ).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data!.docs.map(
                        (doc) {
                          String id = doc.id;
                          Map data = doc.data() as Map;
                          bool isMe = data['uid'] == auth.currentUser!.uid;
                          return CustomItem(
                            name: data['name'],
                            price: data['price'],
                            imageUrl: data['image'],
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
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> loadData() {
    return firestore.collection('product').snapshots();
  }
}
