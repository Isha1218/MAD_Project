import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:mad/classes/event.dart';

class CarouselPage extends StatelessWidget {
  final Icon icon;
  final String name;
  final String description;
  final DateTime start;
  final DateTime end;

  const CarouselPage({
    Key? key,
    required this.icon,
    required this.name,
    required this.description,
    required this.start,
    required this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Container(
        child: Row(
          children: [
            Align(alignment: Alignment.topRight, child: this.icon),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 175,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      this.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(this.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(DateFormat('MMMM dd').format(this.start),
                      style: TextStyle(
                        color: Color(0xff4C2C72),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Color(0xff4C2C72),
                        size: 17.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        DateFormat('hh:mm a').format(this.start) +
                            ' - ' +
                            DateFormat('hh:mm a').format(this.end),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4C2C72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CarouselPageDisplay extends StatelessWidget {
  final List<Event> events;
  final int index;

  const CarouselPageDisplay({
    Key? key,
    required this.events,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselPage(
        icon: IconTags(this.events[index].tag, true).findIcon(),
        name: this.events[index].subject,
        description: this.events[index].notes,
        start: this.events[index].startTime,
        end: this.events[index].endTime);
  }
}
