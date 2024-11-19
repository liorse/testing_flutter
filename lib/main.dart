import 'package:flutter/material.dart';

void main() {
  runApp(const ScoreTrackerApp());
}

class ScoreTrackerApp extends StatelessWidget {
  const ScoreTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScoreTracker(),
    );
  }
}

class ScoreTracker extends StatefulWidget {
  const ScoreTracker({super.key});

  @override
  ScoreTrackerState createState() => ScoreTrackerState();
}

class ScoreTrackerState extends State<ScoreTracker> {
  // Initialize player scores and buttons
  Map<String, int> scores = {'Lior': 0, 'Gadi': 0, 'Erez': 0, 'Oz': 0};
  Map<String, String> places = {'Lior': '', 'Gadi': '', 'Erez': '', 'Oz': ''};
  List<String> players = ['Lior', 'Gadi', 'Erez', 'Oz'];
  List<String> winnersOrder = [];
  final List<int> points = [4, 3, 2, 1];

  void resetTournament() {
    setState(() {
      winnersOrder.clear();
      places = {'Lior': '', 'Gadi': '', 'Erez': '', 'Oz': ''};
    });
  }

  void resetScores() {
    setState(() {
      scores = {'Lior': 0, 'Gadi': 0, 'Erez': 0, 'Oz': 0};
      winnersOrder.clear();
      places = {'Lior': '', 'Gadi': '', 'Erez': '', 'Oz': ''};
    });
  }

  String getPlaceSuffix(int place) {
    if (place == 1) return 'st';
    if (place == 2) return 'nd';
    if (place == 3) return 'rd';
    return 'th';
  }

  void awardPoints(String player) {
    setState(() {
      if (winnersOrder.contains(player)) {
        int pointsIndex = winnersOrder.indexOf(player);
        scores[player] = (scores[player] ?? 0) - points[pointsIndex];
        winnersOrder.remove(player);
        places[player] = '';
        // Update places for remaining players
        for (int i = pointsIndex; i < winnersOrder.length; i++) {
          String p = winnersOrder[i];
          scores[p] = (scores[p] ?? 0) - points[i + 1] + points[i];
          places[p] = '${i + 1}${getPlaceSuffix(i + 1)} place';
        }
      } else if (winnersOrder.length < 4) {
        int pointsIndex = winnersOrder.length;
        scores[player] = (scores[player] ?? 0) + points[pointsIndex];
        winnersOrder.add(player);
        places[player] = '${pointsIndex + 1}${getPlaceSuffix(pointsIndex + 1)} place';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Player Scores',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetTournament,
            child: const Text('Start New Tournament'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: players.map((player) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => awardPoints(player),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: winnersOrder.contains(player)
                          ? Colors.grey
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black,
                    ),
                    child: Text(
                      '$player\nScore: ${scores[player]}\n${places[player]}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetScores,
            child: const Text('Reset Scores'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}