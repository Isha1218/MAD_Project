
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

// This widget will display a form for parents to report absences for their students.
class StudentAbsences extends StatefulWidget {
  const StudentAbsences({Key? key, required this.child, required this.user})
      : super(key: key);

  final GoogleSignInAccount user;
  final String child;

  @override
  State<StudentAbsences> createState() => _StudentAbsencesState();
}

class _StudentAbsencesState extends State<StudentAbsences> {
  // Before this page has been initialized the date variables will be set to today
  // and the date picker range will show a duration of three days by default.
  @override
  void initState() {
    final DateTime today = DateTime.now();
    _startDate = DateFormat('MMM dd, yyyy').format(today).toString();
    _endDate = DateFormat('MMM dd, yyyy').format(today).toString();
    _startTime = DateFormat('hh:mm a').format(today).toString();
    _endTime = DateFormat('hh:mm a').format(today).toString();
    _oneDate = DateFormat('MMM dd, yyy').format(today).toString();

    // The Simple Time Range Picker package is used.
    _controller.selectedRange =
        PickerDateRange(today, today.subtract(Duration(days: 3)));
    super.initState();
  }

  // This value represents the default item on the dropdown menu, but will change.
  String dropdownVal = 'Sick';

  // This will take the form of a text field and allow the user to edit the details of
  // the event.
  TextEditingController details = TextEditingController();

  // These colors represent the focus colors and will change as the user selects one of the fields.
  Color detailFocusColor = Colors.transparent;
  Color reasonFocusColor = Colors.transparent;
  Color timeFocusColor = Colors.transparent;
  Color dateFocusColor = Colors.transparent;

  final formField = GlobalKey<FormState>();

  // This will be the default type (either multiple days or part of day) that represents
  // the durection for how long the student was absent for.
  String _timeType = 'Multiple Days';

  late String _startDate, _endDate, _startTime, _endTime, _oneDate;

  // This will allow the user to select dates and times to detail the date(s) of absence.
  final DateRangePickerController _controller = DateRangePickerController();

  // These are predefined dropdown menu, which represent common reasons why individuals may be absent.
  var items = [
    DropdownMenuItem(
      child: Text('Sick'),
      value: 'Sick',
    ),
    DropdownMenuItem(
      child: Text('COVID-Positive'),
      value: 'COVID-Positive',
    ),
    DropdownMenuItem(
      child: Text('Conflicting Appointment'),
      value: 'Conflicting Appointment',
    ),
    DropdownMenuItem(
      child: Text('Travel'),
      value: 'Travel',
    ),
    DropdownMenuItem(
      child: Text('Other'),
      value: 'Other',
    )
  ];

  // This function will add the absence to Firebase when the user clicks submit on the form.
  // It can then be used by adminstration to record these absences.
  // The absences collection is accessed and a new document is created set to the fields that the parent
  // filled out on the form.
  Future<void> addAbsence(bool partOfDay) async {
    if (partOfDay) {
      await FirebaseFirestore.instance
          .collection('absences')
          .doc(widget.user.displayName!
              .replaceAll(' ', '_')
              .toLowerCase()
              .toString())
          .collection(widget.child)
          .doc()
          .set({
        'reason': dropdownVal,
        'details': details.text,
        'startTime': _startTime,
        'endTime': _endTime,
        'date': _oneDate,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('absences')
          .doc(widget.user.displayName!
              .replaceAll(' ', '_')
              .toLowerCase()
              .toString())
          .collection(widget.child)
          .doc()
          .set({
        'reason': dropdownVal,
        'details': details.text,
        'startDate': _startDate,
        'endDate': _endDate,
      });
    }
  }

  // When the user changes the values on the date picker, these changes will be updated.
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('MMM dd, yyyy').format(args.value.startDate).toString();
      _endDate = DateFormat('MMM dd, yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
      print('startDate ' + _startDate);
    });
  }

  void oneSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _oneDate = DateFormat('MMM dd, yyyy').format(args.value).toString();
    });
  }

  // This widget will be a dropdown menu that represents the student's reason for being
  // absent.
  Widget buildReasonForm() {
    return DropdownButtonFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: 'Choose reason for absence',
            border: InputBorder.none,
            filled: true,
            fillColor: reasonFocusColor,
            prefixIcon: Icon(
              Icons.report,
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
            dropdownVal = newValue!;
            reasonFocusColor = Color(0xff78CAD2).withOpacity(0.3);
          });
        },
        items: items);
  }

  // This widget will be a text field that will represent the details of the student's absecne.
  Widget buildDetailsForm() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: details,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: 'e.g. My child is at SBLC',
          border: InputBorder.none,
          filled: true,
          fillColor: detailFocusColor,
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
          detailFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        } else {
          detailFocusColor = Colors.transparent;
        }
      }),
    );
  }

  // This widget will ask the user about the durection of the student's absence and display
  // a particular date picker accordingly.
  Widget timeSlot() {
    return Container(
      width: 100,
      height: 100,
      child: Row(
        children: [
          RadioListTile(
              value: 'Multiple Days',
              groupValue: _timeType,
              onChanged: (value) {
                setState(() {
                  _timeType = value.toString();
                });
              }),
          RadioListTile(
              value: 'One Day',
              groupValue: _timeType,
              onChanged: (value) {
                setState(() {
                  _timeType = value.toString();
                });
              })
        ],
      ),
    );
  }

  // This function will show the range date picker to the user when they click on it,
  // which allows the user to select multiple days.
  void showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                child: Column(
                  children: [
                    SfDateRangePicker(
                      controller: _controller,
                      selectionMode: DateRangePickerSelectionMode.range,
                      onSelectionChanged: selectionChanged,
                      allowViewNavigation: false,
                      startRangeSelectionColor: Color(0xff78CAD2),
                      endRangeSelectionColor: Color(0xff78CAD2),
                      selectionColor: Color(0xff78CAD2),
                      rangeSelectionColor: Color(0xff78CAD2).withOpacity(0.3),
                      todayHighlightColor: Colors.transparent,
                    ),
                    CupertinoButton(
                        child: Text('Close'),
                        onPressed: () => Navigator.of(ctx).pop())
                  ],
                ),
              ),
            ));
  }

  // This function displays a date picker to the user. The days cannot be selected as a range.
  void showOneDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                child: Column(
                  children: [
                    SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      onSelectionChanged: oneSelectionChanged,
                      allowViewNavigation: false,
                      startRangeSelectionColor: Color(0xff78CAD2),
                      endRangeSelectionColor: Color(0xff78CAD2),
                      selectionColor: Color(0xff78CAD2),
                      rangeSelectionColor: Color(0xff78CAD2).withOpacity(0.3),
                      todayHighlightColor: Colors.transparent,
                    ),
                    CupertinoButton(
                        child: Text('Close'),
                        onPressed: () => Navigator.of(ctx).pop())
                  ],
                ),
              ),
            ));
  }

  // This will represent a layout of the combined fields into a fully functioning form.
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
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Absence',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'For ' +
                              widget.child.substring(0, 1).toUpperCase() +
                              widget.child.substring(1, widget.child.length),
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
                              'Reason for Absence',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            buildReasonForm(),
                            SizedBox(height: 30),
                            Text(
                              'Details of Absence',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            buildDetailsForm(),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Duration of Absence',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            RadioListTile(
                                activeColor: Color(0xff78CAD2),
                                value: 'One or more day(s)',
                                title: Text('One or more day(s)'),
                                groupValue: _timeType,
                                onChanged: (value) {
                                  setState(() {
                                    _timeType = value.toString();
                                  });
                                }),
                            RadioListTile(
                                activeColor: Color(0xff78CAD2),
                                value: 'Part of school',
                                title: Text('Part of school'),
                                groupValue: _timeType,
                                onChanged: (value) {
                                  setState(() {
                                    _timeType = value.toString();
                                  });
                                }),
                            SizedBox(
                              height: 30,
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              if (_timeType == 'One or more day(s)') {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date(s) of absence',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        dateFocusColor =
                                            Color(0xff78CAD2).withOpacity(0.3);
                                        showDatePicker(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: dateFocusColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xff78CAD2))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Color(0xff78CAD2),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _startDate.compareTo(
                                                            _endDate) ==
                                                        0
                                                    ? _startDate
                                                    : _startDate +
                                                        ' - ' +
                                                        _endDate,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          addAbsence(false);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff78CAD2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                );
                              } else if (_timeType == 'Part of school') {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time of absence',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        dateFocusColor =
                                            Color(0xff78CAD2).withOpacity(0.3);
                                        showOneDatePicker(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: dateFocusColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xff78CAD2))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Color(0xff78CAD2),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _oneDate,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        TimeRangePicker.show(
                                          context: context,
                                          onSubmitted: (TimeRangeValue value) {
                                            setState(() {
                                              timeFocusColor = Color(0xff78CAD2)
                                                  .withOpacity(0.3);
                                              _startTime = value.startTime!
                                                  .format(context);
                                              _endTime = value.endTime!
                                                  .format(context);
                                            });
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: timeFocusColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xff78CAD2))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Color(0xff78CAD2),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _startTime + ' - ' + _endTime,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    TextButton(

                                        // Absence will be added to Firebase.
                                        onPressed: () {
                                          addAbsence(true);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff78CAD2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                );
                              } else {
                                return Text('');
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
