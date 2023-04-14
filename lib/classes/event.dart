// This class represents an individual Event (personal, activity, and NCHS).
// It has the subject of the event, tag to identifiy an icon to with it, start and end time
// of the event, and a description (or notes) of the event.
class Event {
  late String subject;
  late String tag;
  late DateTime startTime;
  late DateTime endTime;
  late String notes;

  Event(String subject, String tag, DateTime startTime, DateTime endTime,
      String notes) {
    this.subject = subject;
    this.tag = tag;
    this.startTime = startTime;
    this.endTime = endTime;
    this.notes = notes;
  }
}
