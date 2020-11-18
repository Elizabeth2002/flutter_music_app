import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarrousalImageView extends StatefulWidget {
  @override
  _CarousalImageViewState createState() => _CarousalImageViewState();
}

class _CarousalImageViewState extends State<CarrousalImageView> {

  int _currentIndex=0;
  List<Widget> cardList = [];
  List<String> imageList = ['assets/panda.jpg', 'assets/music.jpg', 'assets/teddy.jpg'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return  Column(
     children: [
       _dotsIndicator(),
       _buildCarouselSlider(context),
     ],
   );
  }

  CarouselSlider _buildCarouselSlider(BuildContext context) {
    return CarouselSlider.builder(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        itemCount: imageList.length,
        itemBuilder: (ctx, int index) {
          return Transform.scale(
            scale: _currentIndex == index ? 1 : 0.8 ,
            child: Container(
              height: MediaQuery.of(context).size.height*0.30,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(5.0),
                child: Image.asset(imageList[index], fit: BoxFit.cover),
              ),
            ),
          );
        }
      );
  }

  Widget _dotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(imageList, (index, url) {
        return Container(
          width: 10.0,
          height: 50.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
          ),
        );
      }),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
}
