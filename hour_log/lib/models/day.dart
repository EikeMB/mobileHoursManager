class WorkDay{
  DateTime startTime;
  DateTime endTime;
  Duration breakTime;
  Duration get totalTime => (endTime.difference(startTime)) - breakTime;

  WorkDay(this.startTime, this.endTime, this.breakTime);
}