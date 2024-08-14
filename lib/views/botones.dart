import 'package:flutter/material.dart';
import 'package:gato/config/config.dart';
import 'package:gato/widgets/celda.dart';

class Botones extends StatefulWidget {
  final VoidCallback actualizarPuntosEx;
  final VoidCallback actualizarPuntosOs;
  final VoidCallback actualizarPuntosEmpate;

  const Botones({
    super.key,
    required this.actualizarPuntosEx,
    required this.actualizarPuntosOs,
    required this.actualizarPuntosEmpate,
  });

  @override
  State<Botones> createState() => BotonesState();
}

class BotonesState extends State<Botones> {
  double ancho = 0, alto = 0;
  estados inicial = estados.vacio;
  int clicks = 0;
  List<estados> board = List.filled(9, estados.vacio);
  Map<estados, bool> winner = {
    estados.ex: false,
    estados.os: false,
    estados.vacio: false,
  };

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return SizedBox(
      width: ancho,
      height: ancho,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Celda(inicial: board[0], espacio: ancho / 3, clicked: () => clicked(0)),
                Celda(inicial: board[1], espacio: ancho / 3, clicked: () => clicked(1)),
                Celda(inicial: board[2], espacio: ancho / 3, clicked: () => clicked(2)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Celda(inicial: board[3], espacio: ancho / 3, clicked: () => clicked(3)),
                Celda(inicial: board[4], espacio: ancho / 3, clicked: () => clicked(4)),
                Celda(inicial: board[5], espacio: ancho / 3, clicked: () => clicked(5)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Celda(inicial: board[6], espacio: ancho / 3, clicked: () => clicked(6)),
                Celda(inicial: board[7], espacio: ancho / 3, clicked: () => clicked(7)),
                Celda(inicial: board[8], espacio: ancho / 3, clicked: () => clicked(8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clicked(int index) {
    if (board[index] == estados.vacio) {
      board[index] = inicial;
      inicial = inicial == estados.ex ? estados.os : estados.ex;
      setState(() {});
      clicks++;
      if (clicks >= 5) {
        estados winner = buscarGanador();
        if (winner != estados.vacio) {
          _showMyDialog(winner);
        } else if (clicks == 10) {
          _showMyDialog(estados.vacio);
        }
      }
    }
  }

  Future<void> _showMyDialog(estados winner) async {
    String winnerText;
    if (winner == estados.ex) {
      winnerText = 'Player X wins!';
      widget.actualizarPuntosEx();
    } else if (winner == estados.os) {
      winnerText = 'Player O wins!';
      widget.actualizarPuntosOs();
    } else {
      winnerText = 'Empate!';
      widget.actualizarPuntosEmpate();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(winnerText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                exitGame();
              },
            ),
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      board = List.filled(9, estados.vacio);
      clicks = 0;
      inicial = estados.vacio;
      winner = {
        estados.ex: false,
        estados.os: false,
        estados.vacio: false,
      };
    });
  }

  estados buscarGanador() {
    // verificar renglones
    for (int i = 0; i < board.length; i += 3) {
      sonIguales(i, i + 1, i + 2);
    }
    // verificar columnas
    for (int i = 0; i < 3; i++) {
      sonIguales(i, i + 3, i + 6);
    }
    // verificar diagonales
    sonIguales(0, 4, 8);
    sonIguales(2, 4, 6);
    if (winner[estados.ex] == true) {
      return estados.ex;
    }
    if (winner[estados.os] == true) {
      return estados.os;
    }
    return estados.vacio;
  }

  void sonIguales(int a, int b, int c) {
    if (board[a] != estados.vacio) {
      if (board[a] == board[b] && board[b] == board[c]) {
        winner[board[a]] = true;
      }
    }
  }
}
