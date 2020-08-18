import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final String name = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[900],
              Colors.blue[300],
              Colors.blue[100],
            ],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://robohash.org/$name'),
                            radius: 40.0,
                          ),
                        ),
                        Divider(
                          height: 90.0,
                          color: Colors.grey[600],
                        ),
                        Text(
                          "Welcome $name!",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 130,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: FlatButton(
                            onPressed: () =>
                                Navigator.popAndPushNamed(context, '/login'),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), //
      ),
    );
  }
}
