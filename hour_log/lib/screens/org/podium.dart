import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/org/avatar.dart';

class Podium extends StatelessWidget {
  final List<UserData> topThree;
  final Organization org;
  const Podium(this.topThree, this.org, {super.key});

  @override
  Widget build(BuildContext context) {
    List<double> heights = [40.0, 70.0, 30.0];

    List<int> order = [1,0,2];
    
    if(topThree.length < 3){
      order = order.sublist(0, topThree.length);
      heights = heights.sublist(0, topThree.length);
    }
    
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: topThree.isEmpty ? const [Text("No Users")] :

                  List<Widget>.generate(order.length, (index) {
                    UserData user = topThree[order[index]];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Avatar(user, org),
                        Container(
                          color: Colors.red[400],
                          width: 100.0,
                          height: heights[index],
                          child: 
                              Center(
                                child: Text('${order[index]+1}',
                                style:  const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),),
                              )
                        )
                      ],
                    );
                  })
              );   
  }
}