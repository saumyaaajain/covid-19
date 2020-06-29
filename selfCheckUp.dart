import 'package:flutter/material.dart';

class SelfCheckUp extends StatefulWidget {
  @override
  State<SelfCheckUp> createState() => SelfCheckUpState();
}

class SelfCheckUpState extends State<SelfCheckUp> with TickerProviderStateMixin{
  bool hasFever = false;
  bool hasCough = false;
  bool hasSourThroat = false;
  bool hasRunnyNose = false;
  bool working = false;
  bool hasBreathingProblems = false;
  bool hasPneumonia = false;
  bool hasSeverPneumonia = false;
  bool hasLowHR = false;
  bool status = false;
  String result = '';
  String theme = 'low';
  AnimationController controller;
  Animation<double> animation;

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  void getResults(){
    if(hasFever){
      result = "Your infection risk is low, we recommend that you stay at home to avoid any chance of exposure";
      theme = 'low';
    }
    else if(hasFever && (hasCough || hasSourThroat || hasRunnyNose || working || hasBreathingProblems)){
      result = "Your infection risk is mild. We recommend you visit the nearest COVID Testing Center. A doctor will assess for further evaluation and admission.";
      theme = 'mild';
    }
    else if(hasPneumonia && !hasSeverPneumonia){
      result = "Your infection risk is low. We recommend that you stay at home to avoid any chance of exposure and consult a doctor on the phone.";
      theme = 'low';
    }
    else if(hasCough && hasLowHR){
      result = "Your infection risk is moderate. We recommend you visit the nearest COVID Health Center for further evaluation.";
      theme = 'moderate';
    }
    else if(hasSeverPneumonia || hasLowHR || status){
      result = "Your infection risk is high. We recommend you go to the nearest Covid Dedicated Hospital for further management and admission.You can avail ambulance service by dialing 102";
      theme = 'high';
    }
    else{
      result = "Your infection risk is low. We recommend that you stay at home to avoid any chance of exposure.";
      theme = 'low';
    }
    _showMyDialog(result, theme);
  }

  Future<void> _showMyDialog(String result, String theme) async {
    Color color = Colors.green;
    double val = .25;
    if(theme == 'mild'){
      color = Colors.orange;
      val = 0.5;
    } else if(theme == 'moderate'){
      color = Colors.yellow;
      val = 0.75;
    } else if(theme == 'high'){
      color = Colors.red;
      val = 1;
    }

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: val).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              theme.toUpperCase(),
            style: TextStyle(
              color: color
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(result),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    width: 200,
                    child: LinearProgressIndicator( value:  animation.value, valueColor:new AlwaysStoppedAnimation<Color>(Colors.green), backgroundColor: color,),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                controller.stop();
              },
            ),
          ],
        );
      },
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return new Center(
//        child: new Container(
//          child:  LinearProgressIndicator( value:  animation.value,),
//
//        )
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Self-CheckUp"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  child: Image.asset('assets/fever.png'),
                ),
                title: Text("Do you have fever?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasFever,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasFever = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/cough.png'),
              ),
                title: Text("Do you have cough?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasCough,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasCough = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/fever.png'),
              ),
                title: Text("Do you have sour throat?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasSourThroat,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasSourThroat = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  child: Image.asset('assets/runny-nose.png'),
                ),
                title: Text("Do you have running nose?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasRunnyNose,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasRunnyNose = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/work.png'),
              ),
                title: Text("Are you a health worker or a frontline worker like a police official, sanitation worker, journalist or government employee?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: working,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        working = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/breathingproblem.png'),
              ),
                title: Text("Do you have shortness of breath?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasBreathingProblems,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasBreathingProblems = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/coughing.png'),
              ),
                title: Text("Are you experiencing mild pneumonia / any problem in breathing?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasPneumonia,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasPneumonia = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/coughing.png'),
              ),
                title: Text("Are you experiencing sever pneumonia?"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasSeverPneumonia,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasSeverPneumonia = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/heart.png'),
              ),
                title: Text("Are you experiencing Septic Shock"),
                subtitle: Text("Low BP and Heart Rate more than 100 per min"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: hasLowHR,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        hasLowHR = value;
                      });
                    }
                ),
              ),
            ),
            Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Image.asset('assets/heart.png'),
              ),
                title: Text("Do you have any existing disease?"),
                subtitle: Text("Blood Pressure\nDiabetes\nAsthma\nChronic Chest Problem"),
                trailing: Switch(
                    activeColor: Colors.deepPurple,
                    value: status,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        status = value;
                      });
                    }
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.assessment,
                      size: 22,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        "Submit Form",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: getResults,
              ),
            )
          ],
        )
    );
  }
}