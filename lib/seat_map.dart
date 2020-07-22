import 'package:GoToPassenger/widgets/extensions.dart';
import 'package:flutter/material.dart';

/*
A : 1 Seat Available
B : 1 seat Booked
R : 1 seat Reserved
_ : 1 Seat Empty
 */

enum SeatStatus { AVAILABLE, BOOKED, RESERVED, EMPTY }

const String SEAT_STRING = '''
|AB_AA|
|BA_AR|
|AB_AA|
|BB_AA|
|AA_AA|
|BAAAA|
''';
const List seatMap=[
  [1,0,0,1],
  [1,0,1,1],
  [0,0,1,1],
  [1,0,1,1],
  [1,0,1,1],
  [1,1,1,1]
];



//    1 2 3 4
//  A[1,0,0,1],
//  B[1,0,1,1],
//  C[0,0,1,1],
//  D[1,0,1,1],
//  E[1,0,1,1],
//  F[1,1,1,1]


/*
1 : 1 Seat Available
2 : 1 seat Booked
3 : 1 seat Reserved
0 : 1 Seat Empty

11, 12, 15
2,3 || 2,4 || 3,3

11 / 4 = 2: 2*4 = 8 : 11 - 8 = 3

11 / (map.len - emptySpaceCount) = 11 / (6-1) = 2
11 % (list.len - emptySpaceCount)  = 11 % (5 -1 ) = 3


12 / (map.len - emptySpaceCount) = 12 / (6-1) = 2
12 % (list.len - emptySpaceCount)  = 12 % (5-1 ) = 0 : if 0 then add (lis.len - emptySpaceCount) :  0 + (5-1) = 4

15 / (map.len - emptySpaceCount) = 15 / (6-1) = 3
15 % (list.len - emptySpaceCount)  = 15 % (5-1 ) = 3

22 / (map.len - emptySpaceCount) = 22 / (6-1) = 4
22 % (list.len - emptySpaceCount)  = 22 % (5-1 ) = 2



const inputArray = [AA_BAB,
                    AA_AAB,
                    AA_BBB,
                    AAABAB]

m = {'A': 1, 'B':2, '_': 0}

seatlayoutarr = [[]]    /2D ARRAY initialised with all values 1

for i in range(inputarr.length){
  for j in range(inputarr[i].length){
    seatlayoutarr[i][j] = m[i][j]
  }
}



Map<int, List<int>>

   0 1 2 3 4
____________
0| 1 1 0 1 1     1   2 _  3  4
1| 2 1 0 1 3     5   6 _  7  8
2| 2 2 0 1 1     9  10 _ 11 12
3| 1 1 0 1 1    13  14 _ 15 16
4| 1 1 0 1 1    17  18 _ 19 20
5| 2 1 1 1 1    21 22 23 24 25


   0 1 3 4
____________
0| 1 1 1 1     1   2 _  3  4
1| 2 1 1 3     5   6 _  7  8
2| 2 2 1 1     9  10 _ 11 12
3| 1 1 1 1    13  14 _ 15 16
4| 1 1 1 1    17  18 _ 19 20
5| 2 1 1 1    21 22 23 24 25

*/

class SeatMap extends StatefulWidget {
  final String encoded;
  final IconData icon;
  final Color availableColor;
  final Color bookedColor;
  final TextStyle textStyle;
  final Color reservedColor;
  final Color selectedColor;
  final int maxSelection;
  final double spaceSize;
  final VoidCallback onMaxSelection;
  final Function(List<String>) callback;
  final EdgeInsets itemPadding;
  final double seatSize;

  const SeatMap({
    Key key,
    @required this.callback,
    @required this.icon,
    this.encoded = SEAT_STRING,
    this.spaceSize = 24,
    this.seatSize = 24,
    this.maxSelection = 2,
    this.onMaxSelection,
    this.availableColor = Colors.grey,
    this.bookedColor = Colors.black12,
    this.selectedColor = Colors.green,
    this.reservedColor = Colors.lime,
    this.itemPadding = const EdgeInsets.all(8.0),
    this.textStyle = const TextStyle(fontSize: 12.0, color: Colors.black87),
  })  : assert(callback != null,
  "Callback is required to listen selection of seats"),
        assert(icon != null, "Seat icon is required"),
        super(key: key);

  @override
  _SeatMapState createState() => _SeatMapState();
}

class _SeatMapState extends State<SeatMap> {
  List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    if (widget.callback != null) {
      widget.callback(selectedSeats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: getWidget(),
      ),
    );
  }

  List<Widget> getWidget(){
//    List<String> list =
//        widget.encoded.split("\n").map((e) => e.replaceAll("|", "")).toList();
    List<Widget> rows = [];
    for (int i = 0; i < seatMap.length; i++) {
      final List<Widget> rowChild = [];
      for (int j = 0; j < seatMap[i].length; j++) {
        if (seatMap[i][j] == 1) {
          rowChild.add(getSeat(i,j, SeatStatus.AVAILABLE,
              enable: selectedSeats.contains("$i$j")));
        } else if (seatMap[i][j] == 2) {
          rowChild.add(getSeat(i,j, SeatStatus.BOOKED));
        } else if (seatMap[i][j] == 3) {
          rowChild.add(getSeat(i,j, SeatStatus.RESERVED));
        } else {
          rowChild.add(getSeat(i,j, SeatStatus.EMPTY));
        }
      }
      final Row row = new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChild,
      );
      rows.add(row);
    }
    return rows;
  }

  Widget seat(int i,int j, Color color, {bool enable = false}) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: widget.itemPadding,
          child: Icon(
            widget.icon,
            size: widget.seatSize,
            color: color,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            getSeatNumber(i, j),
            softWrap: true,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
        )
      ],
    ).addMaterialRipple(
      color: Colors.transparent,
      onTap: enable
          ? () {
        _addItem(i,j);
      }
          : null,
    );
  }

  Widget getSeat(int i,int j, SeatStatus status, {bool enable = false}) {
    switch (status) {
      case SeatStatus.AVAILABLE:
        return seat(i,j, enable ? widget.selectedColor : widget.availableColor,
            enable: true);
      case SeatStatus.BOOKED:
        return seat(i,j, widget.bookedColor);
      case SeatStatus.RESERVED:
        return seat(i,j, widget.reservedColor);
      case SeatStatus.EMPTY:
        return SizedBox(
            width: widget.seatSize +
                widget.itemPadding.right +
                widget.itemPadding.left);
    }
    return SizedBox.shrink();
  }



  String getSeatNumber(int i,int j) {
    Map<String, int> seatDenotation = {
      "A": 1,
      "B": 2,
      "C": 3,
      "D": 4,
      "E": 5,
      "F": 6,
    };
    String seatRow = seatDenotation.keys.firstWhere((k) =>
    seatDenotation[k] == i + 1, orElse: () => null);
    String col = "${j + 1}";
    String seatNumber = seatRow + col;
    return seatNumber;
  }




  void _addItem(int i,int j) {




    String seatnumber=getSeatNumber(i, j);


    if (selectedSeats.contains(seatnumber)) {
      selectedSeats.remove(seatnumber);
    } else {
      if (selectedSeats.length == widget.maxSelection) {
        if (widget.onMaxSelection != null) {
          widget.onMaxSelection();
        }
      } else {
        selectedSeats.add(seatnumber);
      }
    }

    if (mounted) {
      setState(() {
        if (widget.callback != null) {
          widget.callback(selectedSeats);
        }
      });
    }
  }
}

class LegendWidget extends StatelessWidget {
  final Axis direction;
  final List<LegendData> legends;
  final IconData icon;
  final double iconSize;
  final TextStyle textStyle;

  const LegendWidget(
      {Key key,
        @required this.icon,
        @required this.legends,
        this.direction = Axis.vertical,
        this.iconSize = 24,
        this.textStyle = const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)})
      : assert(icon != null, "IconData is required"),
        assert(legends != null, "Legends require to plot"),
        super(key: key);

  Widget getLegend(Color color, String text) {
    return Wrap(
      direction: direction == Axis.horizontal ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: iconSize,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          text,
          style: textStyle,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        direction: direction,
        children: legends
            .map((legend) => getLegend(legend.color, legend.description))
            .toList(),
      ),
    );
  }
}

class LegendData {
  final String key;
  final String description;
  final Color color;

  LegendData(
      {@required this.key, @required this.description, @required this.color});
}
