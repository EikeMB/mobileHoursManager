

class WorkDay{
  String org;
  DateTime startTime;
  DateTime endTime;
  Duration breakTime;
  Duration get totalTime => (endTime.difference(startTime)) - breakTime;

  WorkDay(this.org, this.startTime, this.endTime, this.breakTime);



  Map<String, dynamic> getMapFromWorkDay() {



    return {
      'organization': org,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'breakTime': breakTime.toString(),
    };
  }

  static WorkDay dayFromMap(Map<String, dynamic> map){
    
    List<String> splitDuration = map['breakTime'].split(':');
    int hours = int.parse(splitDuration[0]);
    int minutes = int.parse(splitDuration[1]);
    int seconds = int.parse(splitDuration[2].split('.')[0]); // remove milliseconds part
    Duration parsedDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
    return WorkDay(map['organization'], DateTime.parse(map['startTime']), DateTime.parse(map['endTime']), parsedDuration);
  }
}