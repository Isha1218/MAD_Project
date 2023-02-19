import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  double _value = 5;
  String? selectedValue = null;
  TextEditingController textController = TextEditingController();
  String displayText = "";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Bug"), value: "Bug"),
      DropdownMenuItem(child: Text("Suggestion"), value: "Suggestion"),
      DropdownMenuItem(child: Text("Content"), value: "Content"),
      DropdownMenuItem(child: Text("Compliment"), value: "Compliment"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Text('Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text('Your opinion is important to us.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )),
              SizedBox(height: 40.0),
              Text(
                'Rate your overall satisfaction with this mobile app.',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                  trackShape: RoundedRectSliderTrackShape(),
                  activeTrackColor: Color(0xff4C2C72),
                  inactiveTrackColor: Colors.purple.shade100,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 14.0,
                    pressedElevation: 8.0,
                  ),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                ),
                child: Slider(
                  min: 0.0,
                  max: 10.0,
                  value: _value,
                  divisions: 10,
                  label: '${_value.round()}',
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 40.0),
              Text(
                'Pick a subject and provide your feedback.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffFFD863), width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffFFD863), width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Select subject',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'Not selected',
                    ),
                    validator: (value) =>
                        value == null ? "Select a subject" : null,
                    dropdownColor: Colors.white,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
              ),
              SizedBox(height: 40.0),
              Text(
                'Would you like to add a comment?',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
              TextField(
                controller: textController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Add your comment here...',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xffD56AA0)),
                  ),
                ),
              ),
              Text(
                displayText,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 40.0),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('feedback').add({
                        'comment': textController.text,
                        'subject': selectedValue,
                        'rating': _value
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff32959E),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
