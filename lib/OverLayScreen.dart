import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
class OverLayScreen extends StatelessWidget {
  CountdownController countdownController=CountdownController();
  @override
  showOverlay(BuildContext context) async{
    OverlayState overlayState=Overlay.of(context);  
    OverlayEntry overlayEntry=OverlayEntry(
      builder: (context)=>SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink,
              ),

              child: Center(
                child: Countdown(
                  onFinished: (){
                    countdownController.restart();
                  },
                  controller: countdownController,
                  seconds: 10,
                  build:(context,double time)=> Text("${time.toInt()} sec",style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                ),
              ),
            ),
          ),
      )

    );
    overlayState.insert(overlayEntry);
   await Future.delayed(Duration(seconds: 10));
    overlayEntry.remove();

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Spacer(),
          RawMaterialButton(
            child: Text("Press here for the floating screen"),
            onPressed: (){
              showOverlay(context);
            },
          ),
          RawMaterialButton(
            child: Text("Navigate Back"),
            onPressed: (){
             Navigator.pop(context);
             },
          ),
        ],
      ),
    );
  }
}
