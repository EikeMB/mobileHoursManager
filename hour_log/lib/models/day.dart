class WorkDay{
  DateTime startTime;
  DateTime endTime;
  Duration breakTime;
  Duration get totalTime => (endTime.difference(startTime)) - breakTime;

  WorkDay(this.startTime, this.endTime, this.breakTime);



  Map<String, dynamic> getMapFromWorkDay() {



    return {
      'startTime': startTime.toUtc().toString(),
      'endTime': endTime.toUtc().toString(),
      'breakTime': breakTime.toString(),
      'totalTime': totalTime.toString()
    };
  }
}