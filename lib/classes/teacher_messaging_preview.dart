class TeacherMessagingPreview {
  late String name;
  late int unread;
  late String lastMessage;
  late String lastMessageDate;
  late DateTime lastMessageDateTime;

  TeacherMessagingPreview(String name, int unread, String lastMessage,
      String lastMessageDate, DateTime lastMessageDateTime) {
    this.name = name;
    this.unread = unread;
    this.lastMessage = lastMessage;
    this.lastMessageDate = lastMessageDate;
    this.lastMessageDateTime = lastMessageDateTime;
  }
}
