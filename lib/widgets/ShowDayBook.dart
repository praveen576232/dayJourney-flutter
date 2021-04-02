import 'package:daybook/screens/DisplayDayBook.dart';
import 'package:daybook/utils/converter.dart';
import 'package:flutter/material.dart';

class ShowDayBook extends StatelessWidget {
  Map<String, dynamic> dayBook;

  Size size;
  ShowDayBook({@required this.dayBook, @required this.size});
  Converter converter = Converter();
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(dayBook['dateTime'].toDate().toString());
    var images;

    if (dayBook['images'] != null && dayBook['images'].isNotEmpty) {
      images = dayBook['images'];
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          child: Container(
            width: size.width,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: dateTime.day.toString() + " ",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: converter
                                .convertNumberToMonthName(dateTime.month),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "  " +
                          dateTime.year.toString() +
                          " " +
                          converter
                              .convertNumberToWeekDayName(dateTime.weekday),
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      converter.convert24To12(dateTime.hour, dateTime.minute),
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width:
                          images != null ? size.width - 130 : size.width - 30,
                      child: Text(
                          dayBook['dayNote'] != null ? dayBook['dayNote'] : "",
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.black54)),
                    ),
                    images != null
                        ? Container(
                            height: size.height * 0.13,
                            width: 100,
                            child: Image.network(
                              images[0]['url'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Offstage()
                  ],
                )
              ],
            ),
          ),
          onTap: () {
           
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayDayBook(
                        images: images != null ? images : null,
                        tags: dayBook['tags']!=null ? dayBook['tags']:null,
                        dateTime: dateTime,
                        id: dayBook['id'],
                        text:dayBook['dayNote'] ,
                      
                           )));
          }),
    );
  }
}
