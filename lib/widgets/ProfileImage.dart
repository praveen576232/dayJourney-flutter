import 'package:daybook/services/database/database.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/SelectImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  User user;
    Function(User) updateUser;
  ProfileImage({@required this.user,@required this.updateUser});

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Stack(
        children: [
          Opacity(
              opacity: loading ? 0.5 : 1,
              child: widget.user.photoURL != null
                  ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(widget.user.photoURL),
                              fit: BoxFit.cover)),
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: utils.profilebgColor,
                      ),
                      child: Center(
                          child: Text(widget.user.email[0],
                              style: TextStyle(
                                  color: utils.profileTextColor,
                                  fontSize: utils.profileTextSize))),
                    )),
          loading ? Center(child: CircularProgressIndicator()) : Offstage(),
          Positioned(
              right: 0,
              top: 0,
              child: Opacity(
                opacity: loading ? 0.5 : 1,
                child: IconButton(
                    icon: Icon(Icons.add_to_photos, color: Colors.grey),
                    onPressed: !loading
                        ? () async {
                            setState(() {
                              loading = true;
                            });
                            var image = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectImage(
                                          selectOnlyOneImage: true,
                                        )));
                            if(image!=null ){
                              String imageUrl =
                                await uploadProfileImages(image, widget.user);

                            await widget.user.updateProfile(photoURL: imageUrl);

                            setState(() {
                              widget.user = FirebaseAuth.instance.currentUser;
                              loading = false;
                            });
                            widget.updateUser(widget.user);
                            }
                          }
                        : null),
              )),
        ],
      ),
    );
  }
}
