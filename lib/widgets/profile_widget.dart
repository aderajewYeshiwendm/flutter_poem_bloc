import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = 'Y O N A T A N';
  String picturePath = 'assets/images/backg.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/images/backg.jpg'),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
