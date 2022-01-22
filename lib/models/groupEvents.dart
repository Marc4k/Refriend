class GroupEvent {
  final String name;
  final String description;
  final String location;
  final String time;
  final String chatId;
  final List thumpsUp;
  final List thumpsDown;
  GroupEvent(
      {this.name,
      this.description,
      this.time,
      this.location,
      this.chatId,
      this.thumpsUp,
      this.thumpsDown});
}
