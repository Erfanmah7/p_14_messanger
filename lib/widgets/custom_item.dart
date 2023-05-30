import 'package:flutter/material.dart';

class CustomItem extends StatelessWidget {
  final String defaultAssetImagePath = 'assets/images/default.png';
  String imageUrl = '';
  String name = '';
  int price = 0;

  CustomItem({
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: '$price',
      location: BannerLocation.bottomEnd,
      child: Container(
        height: 200,width: 150,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Colors.blueGrey,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            FadeInImage(
              placeholder: AssetImage(defaultAssetImagePath),
              image: NetworkImage(imageUrl),height: 120,width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10,),
            Text(name),
          ],
        ),
      ),
    );
  }
}
