import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:p_14_messanger/widgets/constants.dart';
import 'package:p_14_messanger/widgets/custon_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  File file = File('-1');
  int itemcount = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  List<String> listCategory = [];
  bool showprogress = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showprogress,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: file.path == '-1'
                          ? Material(
                              shape: const CircleBorder(),
                              color: Colors.blue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  selectImage();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 50,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: FileImage(file),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      selectImage();
                                    },
                                    child: const CircleAvatar(
                                      child: Icon(Icons.add_a_photo),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  onAdd();
                                },
                                child: const Icon(Icons.add),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                itemcount.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  onRemove();
                                },
                                child: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Name',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptController,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    label: Text(
                      'Description',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    label: Text(
                      'Price',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        showMultiSelect(context);
                      },
                      child: const Text('Categories'),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      for (int i = 0; i < listCategory.length; i++) ...[
                        Text(listCategory[i]),
                        if (i != listCategory.length - 1) ...[
                          Text(' , '),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      onSave();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate(String uid, String name, String descript, String price) {
    if (uid != auth.currentUser!.uid) {
      return false;
    }

    if (name.length < 3) {
      return false;
    }
    if (descript.length < 3) {
      return false;
    }
    if (price.length < 0) {
      return false;
    }
    if (itemcount == 0) {
      return false;
    }
    if (listCategory.length == []) {
      return false;
    }
    return true;
  }

  onSave() async {
    String uid = auth.currentUser!.uid;
    String name = nameController.text;
    String descript = descriptController.text;
    String price = priceController.text;
    setState(() {
      showprogress = true;
    });
    bool status = validate(uid, name, descript, price);

    if (status == false) {
      return;
    }
    String pathImage = '-1';
    if (file.path != '-1') {
      pathImage = await uploadImage();
    }
      Map<String, dynamic> newMap = Map();
      newMap['uid'] = uid;
      newMap['name'] = name;
      newMap['descript'] = descript;
      newMap['price'] =  int.parse(price);
      newMap['count'] = itemcount;
      newMap['categories'] = listCategory;
      if (pathImage != '-1') {
        newMap['image'] = pathImage;
      } else {
        newMap['image'] = null;
      }

      try {
        DocumentReference doc =
            await firestore.collection('product').add(newMap);
        reseter();
        setState(() {
          showprogress = false;
        });
      } catch (e) {
        print('not save');
        setState(() {
          showprogress = false;
        });
      }

  }

  Future<String> uploadImage() async {
    try {
      String filename = file.path.split('/').last;
      TaskSnapshot snapshot =
          await storage.ref().child('item/images/$filename').putFile(file);
      String Url = await snapshot.ref.getDownloadURL();
      print(Url);
      return Url;
    } catch (e) {
      print('error');
      return '-1';
    }
  }

  void showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: Categories,
          onConfirm: (values) {
            setState(
              () {
                listCategory.clear();
                for (int e = 0; e < values.length; e++) {
                  String each = values[e].toString();
                  listCategory.add(each);
                }
              },
            );
          },
          maxChildSize: 0.8,
          initialValue: [],
        );
      },
    );
  }

  void selectImage() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          selectImageFromGallery: selectImageFromGallery,
          selectImageFromCamera: selectImageFromCamera,
        );
      },
    );
  }

  void selectImageFromGallery() async {
    print('gallery');
    bool status = await selectImagePiker(ImageSource.gallery);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  void selectImageFromCamera() async {
    print('camera');
    bool status = await selectImagePiker(ImageSource.camera);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  Future<bool> selectImagePiker(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile imagePic =
          await imagePicker.pickImage(source: source) ?? XFile('-1');
      if (imagePic.path == '-1') return false;
      setState(() {});
      file = File(imagePic.path);
      return true;
    } catch (e) {
      return false;
    }
  }

  onAdd() {
    setState(() {
      itemcount++;
    });
  }

  onRemove() {
    if (itemcount <= 0) {
      return;
    }
    setState(() {
      itemcount--;
    });
  }

  reseter() {
    setState(() {
      nameController.clear();
      descriptController.clear();
      priceController.clear();
      itemcount = 0;
      listCategory.clear();
      file = File('-1');
    });
  }
}
