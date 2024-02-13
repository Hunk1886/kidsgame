import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, bool> score = {};
  final Map<String, Color> choices = {
    '🐶': Colors.black,
    '🍎': Colors.red,
    '🥒': Colors.green,
    '🔵': Colors.blue,
    '🍍': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;
  final play = AudioPlayer();
  int playerScore = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' Game'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
              children: [
                Icon(Icons.reviews, color: Colors.yellow),
                SizedBox(width: 5),
                Text(
                  '$playerScore',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            )
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((element) {
                return Expanded(
                  child: Draggable<String>(
                    data: element,
                    child: Movable(element),
                    feedback: Movable(element),
                    childWhenDragging: Movable('🐰'),
                  ),
                );
              }).toList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices.keys.map((element) {
                return buildTarget(element);
              }).toList()
                ..shuffle(Random(index)),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            playerScore = 0; // Reset the score
            index++;
          });
        },
      ),
    );
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(
      builder: (context, incoming, rejects) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Congratulations'),
                
              ],
            ),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          play.play(AssetSource('M.mp3'));
          playerScore++; // Increment the score on successful match
        });
      },
      onLeave: (data) {},
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;
  Movable(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 150,
        padding: EdgeInsets.all(15),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}