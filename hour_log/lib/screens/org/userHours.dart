import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/services/auth.dart';
import 'package:table_calendar/table_calendar.dart';

class UserHours extends StatefulWidget {
  final Organization org;
  final UserData user;
  const UserHours(this.org, this.user, {super.key});

  @override
  State<UserHours> createState() => _UserHoursState();
}

class _UserHoursState extends State<UserHours> {

  DateTime? selectedFirstDate;
  DateTime? selectedSecondDate;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late DateTime _firstDay;
  late DateTime _lastDay;
  WorkDay? workDay;


  @override
  void initState() {
    super.initState();
    _firstDay = DateTime.now();
    _lastDay = DateTime.now().add(Duration(days: 30));
  }


  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now(),
        end: _endDate ?? DateTime.now().add(Duration(days: 7)),
      ),
    );
    if (picked != null && picked.start != picked.end) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _firstDay = picked.start;
        _lastDay = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    UserData user = widget.user;
    Organization org = widget.org;

    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black)
            ),
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
            label: const Text(
              'logout',
              style: TextStyle(
                color: Colors.black
              )
            ),
          )
        ],
        title: Text(user.username),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 50.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickDateRange(context),
                    child: const Text('Select Date Range'),
                    
                  ),
                ],
              ),
              const SizedBox(height: 20.0,),
              if (_startDate != null && _endDate != null)
                TableCalendar(
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  rangeStartDay: _startDate,
                  rangeEndDay: _endDate,
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        workDay = user.getWorkdayFromDay(org.code, _selectedDay);
                      });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  onFormatChanged: (format) {},
                ),
                workDay != null ?
                
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('Start: ${formatTime(workDay!.startTime)}', 
                        style: const TextStyle(fontSize: 20.0),),
                        const SizedBox(height: 10.0),
                        Text('End: ${formatTime(workDay!.endTime)}', 
                        style: const TextStyle(fontSize: 20.0),),
                        const SizedBox(height: 10.0),
                        Text('Break: ${workDay!.breakTime.inHours} hour(s) ${workDay!.breakTime.inMinutes % 60} Minute(s)', 
                        style: const TextStyle(fontSize: 20.0),),
                        const SizedBox(height: 10.0),
                        Text('Total: ${workDay!.totalTime.inHours} Hour(s) and ${workDay!.totalTime.inMinutes % 60} Minute(s)', 
                        style: const TextStyle(fontSize: 20.0),),
                        ],
                        ),
                      )
                    ),
                  )
                :
                 const Text('Did not work this day')

            ],
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}