import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

Container feed_template(
    double width, String name, String category, String location) {
  List images = <String>[
    'https://firebasestorage.googleapis.com/v0/b/donatenow-20ecb.appspot.com/o/items%2FP2AITKkF01clRqPSdSr%2Fimage1?alt=media&token=b2ac9cb9-5d0b-4296-aeb3-5a60727743d6',
    'https://firebasestorage.googleapis.com/v0/b/donatenow-20ecb.appspot.com/o/items%2FP2AITKkF01clRqPSdSr%2Fimage2?alt=media&token=a864b66b-1e9b-4373-a394-3f77529da08f',
    'https://firebasestorage.googleapis.com/v0/b/donatenow-20ecb.appspot.com/o/items%2FB0TvFMGGIRiTWlUJeU%2Fimage1?alt=media&token=845a6199-fef1-4ab5-ad7c-7fe14aaf41a4'
  ];
  return Container(
      width: width,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey[500], spreadRadius: 3, blurRadius: 5)
          ],
        ),
        width: width,
        height: 400,
        // color: Colors.cyan,
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.grey[300],
              child: Carousel(
                images:
                    images.map((e) => Image(image: NetworkImage(e))).toList(),
                autoplay: false,
              ),
            ),
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      )),
                  // SizedBox(height: 7),
                  Row(
                    children: [
                      Text('Category - ',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          )),
                      Text(category),
                    ],
                  ),
                  // SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.red[300],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        location,
                        style: TextStyle(color: Colors.red[300]),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
