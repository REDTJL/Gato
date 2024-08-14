import 'package:flutter/material.dart';
import 'package:gato/config/config.dart';
import 'package:gato/views/botones.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int puntosEx = 0;
  int puntosOs = 0;
  int puntosEmpate = 0;

  final GlobalKey<BotonesState> _botonesKey = GlobalKey<BotonesState>();

  void actualizarPuntosEx() {
    setState(() {
      puntosEx++;
    });
  }

  void actualizarPuntosOs() {
    setState(() {
      puntosOs++;
    });
  }

  void actualizarPuntosEmpate() {
    setState(() {
      puntosEmpate++;
    });
  }

  void _exitGame() {
    exitGame();
  }

  void _restartGame() {
    _botonesKey.currentState?.restartGame();
  }

  Future<void> _showConfirmationDialog(String action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(0, 100, 150, 1.0),
          title: const Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro que quiere $action?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                if (action == 'salir') {
                  _exitGame();
                } else if (action == 'reiniciar tablero') {
                  _restartGame();
                } else if (action == 'reiniciar') {
                  _restartGame();
                  setState(() {
                    puntosEmpate = 0;
                    puntosOs = 0;
                    puntosEx = 0;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: const Color.fromRGBO(0, 100, 150, .9),
            width: ancho,
            height: alto * 0.15,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Puntos Ex: $puntosEx | Puntos Os: $puntosOs | Empates: $puntosEmpate',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'Salir') {
                      _showConfirmationDialog('salir');
                    } else if (result == 'Reiniciar') {
                      _showConfirmationDialog('reiniciar');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Salir', 'Reiniciar'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 0, .3),
            width: ancho,
            height: alto * 0.75,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    "resources/board.png",
                    width: ancho,
                    height: alto * 0.75,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Botones(
                      key: _botonesKey,
                      actualizarPuntosEx: actualizarPuntosEx,
                      actualizarPuntosOs: actualizarPuntosOs,
                      actualizarPuntosEmpate: actualizarPuntosEmpate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color.fromRGBO(0, 100, 150, 1.0),
        height: 60.54,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'Salir',
                color: Colors.black,
                icon: const Icon(Icons.logout),
                onPressed: () => _showConfirmationDialog('salir'),
              ),
              IconButton(
                tooltip: 'Reiniciar tablero',
                icon: const Icon(Icons.refresh),
                color: Colors.black,
                onPressed: () => _showConfirmationDialog('reiniciar tablero'),
              ),
              IconButton(
                tooltip: 'Reiniciar juego',
                icon: const Icon(Icons.delete_outline),
                color: Colors.black,
                onPressed: () => _showConfirmationDialog('reiniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
