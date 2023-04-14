import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This widget allows the user to provide feedback to the developers.
class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  // The default value of the slider is 5.
  double _value = 5;

  // There is no default value for the dropdown menu, but this can change.
  String? selectedValue = null;

  // This will represent the text that the user will input as a comment about thw app.
  TextEditingController textController = TextEditingController();

  // These focus colors will change depending on whether the user has clicked on the field or not.
  Color subjectFocusColor = Colors.transparent;
  Color commentFocusColor = Colors.transparent;

  // These are a list of dropdown menu items that the user may find with the app.
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

  // This widget will allow the user to use the dropwdown menu to select
  // the subject of their feedback.
  Widget buildSubjectField() {
    return DropdownButtonFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: 'Choose subject of feedback',
            border: InputBorder.none,
            filled: true,
            fillColor: subjectFocusColor,
            prefixIcon: Icon(
              Icons.feedback,
              color: Color(0xff78CAD2),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff78CAD2)),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff78CAD2)),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ))),
        validator: (value) => value == null ? "Select a reason" : null,
        dropdownColor: Colors.white,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
            subjectFocusColor = Color(0xff78CAD2).withOpacity(0.3);
          });
        },
        items: dropdownItems);
  }

  // This widget represents a slider, so that the user can rate their satisfaction with the app.
  Widget buildSatisfactionSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 10.0,
        trackShape: RoundedRectSliderTrackShape(),
        activeTrackColor: Color(0xff78CAD2),
        inactiveTrackColor: Color(0xff78CAD2).withOpacity(0.4),
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
    );
  }

  // This widget represents a text field, which will be a comment about the app.
  Widget buildCommentField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: textController,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: 'e.g. I love this app',
          border: InputBorder.none,
          filled: true,
          fillColor: commentFocusColor,
          prefixIcon: Icon(
            Icons.edit_note,
            size: 30,
            color: Color(0xff78CAD2),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ))),
      onChanged: (value) => setState(() {
        if (!value.isEmpty) {
          commentFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        } else {
          commentFocusColor = Colors.transparent;
        }
      }),
    );
  }

  // All of the above widgets will be displayed here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 60, 32, 2),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Give Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate your satisfaction of using Vertex',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildSatisfactionSlider(),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Pick subject and provide feedback',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildSubjectField(),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Add a comment (optional)',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildCommentField(),
                          SizedBox(
                            height: 40,
                          ),

                          // The feedback will be added to the feedback Firebase collection
                          // and will be seriously considered by the developers.
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('feedback')
                                    .add({
                                  'comment': textController.text,
                                  'subject': selectedValue,
                                  'rating': _value
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff78CAD2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 15, 50, 15),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
