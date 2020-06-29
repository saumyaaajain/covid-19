import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:encrypt/encrypt.dart' as e;

import 'package:healthcard/mapView.dart';
import 'package:healthcard/selfCheckUp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => btScan());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void btScan(){
    flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      print(results);
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        encrypt(r.device.name);
//        await r.device.connect();
//        List<BluetoothService> services = await r.device.discoverServices();
//        services.forEach((service) async {
//          // do something with service
//          var characteristics = service.characteristics;
//          for(BluetoothCharacteristic c in characteristics) {
//            List<int> value = await c.read();
//            print(value);
//          }
//        });
      }
    });

    flutterBlue.stopScan();
  }

  void encrypt(String msg){
//    final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final key = e.Key.fromUtf8('my 32 length key................');
    final iv = e.IV.fromLength(16);

    final encrypter = e.Encrypter(e.AES(key));

    final encrypted = encrypter.encrypt(msg, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base64);

    updateFirebase(encrypted.base64);
  }

  void updateFirebase(String person){
    DateTime today = DateTime.now();
    Firestore.instance.collection('people').document()
        .setData({ 'met': person, 'time': today});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: ListView(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32) ),
//              borderRadius: BorderRadius.circular(32),
              color: Colors.deepPurple,
//              border: Border.all(
//                color: Colors.blue,
//                width: 10,
//              ),
            ),
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Text(
                    "COVID-19",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Text(
                    "Are you feeling sick?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 12, top: 7, bottom: 18),
                  child: Text(
                    "If you feel sick with any of the Covid-19 symptoms. Please call or SMS us immediately for help",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                              Icons.call,
                            size: 22,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              "Call",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => {

                      },
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                              Icons.message,
                            size: 22,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              "SMS",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => {

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32),
            child: Text(
                "Precautions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/wearMask.png",
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Text("Wear a \nmask",style: TextStyle(fontSize: 12), textAlign: TextAlign.center, )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/washHands.png",
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Text("Wash your \nhands", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/socialDist.png",
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Text("Maintain social \ndistancing",style: TextStyle(fontSize: 12), textAlign: TextAlign.center,)
                  ],
                ),
              ],
            )
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelfCheckUp()),
              )
            },
            child: Padding(
              padding: EdgeInsets.only( left: 16, right: 16),
              child: Container(
                width: width - 32,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.deepPurpleAccent, Colors.deepPurple]
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 175,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://previews.123rf.com/images/grgroup/grgroup1609/grgroup160900017/62170454-doctor-woman-and-cartoon-icon-profession-worker-and-occupation-theme-isolated-design-vector-illustra.jpg",
                              ),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Do your own test",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Follow the instructions \nto do your own test",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.green,
        isExtended: true,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapSample()),
          )
          },
        tooltip: 'Map',
        child: Icon(Icons.map),
      ),
    );
  }
}
