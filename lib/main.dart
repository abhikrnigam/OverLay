import 'dart:io';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter/material.dart';
import 'package:pip_view/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:providerexample/counter.dart';
import 'OverLayScreen.dart';
import 'MainScreen.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<Counter>(
       create: (context)=>Counter(),
          child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;


  @override
  Widget build(BuildContext context) {
    final counter=Provider.of<Counter>(context,listen: false);
    return Scaffold(
      appBar: AppBar(

        title: Text(title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Counter>(  
              builder:(context,counter,_)=> Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            RawMaterialButton(
              child: Text("Press here for the floating screen"),
              onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>MyScreen()));
              },
            ),
            RawMaterialButton(
              child: Text("Press here for the floating screen"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OverLayScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
          {
            counter.increment();
          },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {

  CountdownController controller=CountdownController();
  bool hodeTimer=true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PIPView(
        floatingHeight: 100,
        floatingWidth: 100,
        initialCorner: PIPViewCorner.topRight,
        builder: (context, isFloating) {
          return Scaffold(
              body: hodeTimer?Column(
                  children: [
                  Text('Hello',style: TextStyle(
                    fontSize: 100,

                  ),),
              MaterialButton(
              child: Text('Reserve Seat'),
          onPressed: () {
                setState(() {
                  hodeTimer=false;
                });
            PIPView.of(context).presentBelow(MyBackgroundScreen());
          },
          ),
          ],
          ):Container(
                child: Center(
                  child: Countdown(
                      onFinished: (){
                        setState(() {
                          controller.restart();
                        });
                      },
                      controller: controller,
                      seconds: 10,
                      build:(_,double time) =>Center(
                        child: Column(

                          children: [
                            Spacer(),
                            Text("We have reserved your Seat for \n",style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),),
                            Text('${time.toInt()} sec',style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),),
                            Spacer(),
                  ],
                        ),
                      ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}

class MyBackgroundScreen extends StatefulWidget {
  @override
  _MyBackgroundScreenState createState() => _MyBackgroundScreenState();
}

class _MyBackgroundScreenState extends State<MyBackgroundScreen> {
  CountdownController controller=CountdownController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        body: Countdown(
//          onFinished: (){
//            setState(() {
//              controller.restart();
//            });
//          },
//          controller: controller,
//            seconds: 10,
//            build:(_,double time) =>Text('${time.toString()}',style: TextStyle(
//              fontSize: 100,
//              fontWeight: FontWeight.bold,
//            ),)
//        ),
    );
  }
}