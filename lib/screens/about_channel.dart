import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChannelAbout extends StatefulWidget {
  const ChannelAbout({Key? key}) : super(key: key);

  @override
  State<ChannelAbout> createState() => _ChannelAboutState();
}

class _ChannelAboutState extends State<ChannelAbout> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: Colors.purple,
        actions: [
          Row(
            children: [
              const Text(
                'About Channel',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 7, top: 1, bottom: 1),
                child: Container(
                  height: 70,
                  width: 70,
                  child: const CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://picsum.photos/500/300"),
                    maxRadius: 15,
                    minRadius: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: size.width,
            color: Colors.purple,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                  child: Row(
                    children: const [
                      Text('مسیری برای #برنامه_نویس شدن',textAlign: TextAlign.end,style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(
                  endIndent: 55,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 17),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.toggle_off_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      Spacer(),
                      Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Expanded(
            child: Container(
              height: Size.infinite.height,
              width: size.width,
              color: Colors.purple,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 10, right: 17),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                          Spacer(),
                          Text(
                            '2 MEMBERS',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          subtitle: const Text(
                            'last seen recently',
                            textAlign: TextAlign.right,
                          ),
                          title: const Text(
                            'Amir',
                            textAlign: TextAlign.right,
                          ),
                          trailing: const CircleAvatar(
                            backgroundImage:
                                NetworkImage("https://picsum.photos/500/300"),
                            maxRadius: 20,
                            minRadius: 20,
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        ListTile(
                          onTap: () {},
                          subtitle: const Text(
                            'last seen recently',
                            textAlign: TextAlign.right,
                          ),
                          title: const Text(
                            'Erfan',
                            textAlign: TextAlign.right,
                          ),
                          trailing: const CircleAvatar(
                            backgroundImage:
                                NetworkImage("https://picsum.photos/500/300"),
                            maxRadius: 20,
                            minRadius: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
