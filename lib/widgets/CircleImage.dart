import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daybook/utils/utils.dart';

class CircleImageView extends StatelessWidget {
  User user;
  CircleImageView({@required this.user});
  @override
  Widget build(BuildContext context) {
    return user.photoURL != null
        ?Stack(
          alignment: Alignment.center,
          children: [
             Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black)),),
Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  image: DecorationImage(
                      image: NetworkImage(user.photoURL), fit: BoxFit.cover)),
            ),
          ],
        )
        
        : Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: utils.profilebgColor,
            ),
            child: Center(
                child: Text(user.email[0],
                    style: TextStyle(
                        color: utils.profileTextColor, fontSize: 25))),
          );
  }
}
