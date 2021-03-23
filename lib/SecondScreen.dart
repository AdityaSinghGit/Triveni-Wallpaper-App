import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      backgroundColor: Colors.grey[500],
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 50.0,
                  backgroundImage: AssetImage('assets/img2.png'),
                ),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.grey[600],
                    width: 2.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'A D I T Y A   S I N G H',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600),
              )),
          SizedBox(
            height: 30,
          ),
          Container(
            height: height / 2,
            width: width,
            margin: EdgeInsets.all(15.0),
            child: Card(
              elevation: 1.0,
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Ｐ Ｏ ＲＴＦＯＬ I Ｏ',
                      style: TextStyle(
                          // backgroundColor: Colors.transparent,
                          fontSize: 18.0,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Flutter Developer ',
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.games,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Mobile Apps / Game Testing ',
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.create,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Graphic Designing',
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/gitlogo.png'),
                          width: 20,
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'github.com/AdityaSinghGit',
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 16.0),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/instalogo.png'),
                          width: 20,
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'aeliusadi',
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 16.0),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
