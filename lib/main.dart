import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  String _currentPlayer = 'X';
  String _winner = '';

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _currentPlayer = 'X';
      _winner = '';
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner(row, col)) {
          _winner = _currentPlayer;
        } else if (_isBoardFull()) {
          _winner = 'Draw';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    // Check the current row, column, and diagonals
    return (_board[row].every((cell) => cell == _currentPlayer) ||
        _board.every((r) => r[col] == _currentPlayer) ||
        (row == col && _board.every((r) => r[_board.indexOf(r)] == _currentPlayer)) ||
        (row + col == 2 && _board.every((r) => r[2 - _board.indexOf(r)] == _currentPlayer)));
  }

  bool _isBoardFull() {
    return _board.every((row) => row.every((cell) => cell != ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tic Tac Toe')),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildBoard(),
          SizedBox(height: 20),
          _buildStatus(),
          SizedBox(height: 20),
          _buildResetButton(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildStatus() {
    if (_winner.isNotEmpty) {
      if (_winner == 'Draw') {
        return Text(
          'It\'s a Draw!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      } else {
        return Text(
          'Player $_winner Wins!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      }
    } else {
      return Text(
        'Player $_currentPlayer\'s turn',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      child: Text('Reset Game'),
    );
  }
}
