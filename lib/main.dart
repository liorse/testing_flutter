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
    // Sort players by score in descending order
    List<String> sortedPlayers = players.toList()
      ..sort((a, b) => scores[b]!.compareTo(scores[a]!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10), // Adjust the height as needed
          const Text(
            'Player Scores',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: resetTournament,
            child: const Text('Start New Tournament'),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10.0),
              children: players.map((player) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => awardPoints(player),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 25),
                      backgroundColor: winnersOrder.contains(player)
                          ? Colors.grey
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3,
                      shadowColor: Colors.black,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$player\nScore: ${scores[player]}\n${places[player]}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Flexible(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 10.0, // Reduced column spacing
                    horizontalMargin: 5.0, // Reduced horizontal margin
                    dataRowHeight: 30.0, // Reduced row height
                    columns: const [
                      DataColumn(label: Text('Player')),
                      DataColumn(label: Text('Score')),
                    ],
                    rows: sortedPlayers.map((player) {
                      return DataRow(
                        cells: [
                          DataCell(Text(player)),
                          DataCell(Text(scores[player].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: resetScores,
                  child: const Text('Reset Scores'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
