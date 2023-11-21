import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const WorkingTable());
  }
}

class WorkingTable extends StatefulWidget {
  const WorkingTable({Key? key}) : super(key: key);

  @override
  State<WorkingTable> createState() => _WorkingTableState();
}

class _WorkingTableState extends State<WorkingTable> {
  final TransformationController controller = TransformationController();
  List<DraggableCard> elements = [];

  onTap (int card) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (details) {
          setState(() {
            elements.add(DraggableCard(initialPosition: details.localPosition));
          });
        },
        child: InteractiveViewer(
          transformationController: TransformationController(),
          minScale: 0.1,
          maxScale: 4.0,
          constrained: false,
          child: Stack(
            children: [
              CustomPaint(
                  size: MediaQuery.of(context).size * 10,
                  painter: GridPainter(controller)),
              ...elements,
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({Key? key, required this.initialPosition})
      : super(key: key);

  final Offset initialPosition;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (event) {
          double newX = _position.dx + event.delta.dx;
          double newY = _position.dy + event.delta.dy;
          setState(() {
            _position = Offset(newX, newY);
          });
        },
        child: const TableEntity(),
      ),
    );
  }
}

class TableEntity extends StatefulWidget {
  const TableEntity({super.key});

  @override
  State<TableEntity> createState() => _TableEntityState();
}

class _TableEntityState extends State<TableEntity> {
  final Size _size = const Size(300, 500);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size.width,
      height: _size.height,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 5.0)],
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final TransformationController controller;

  GridPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    final matrix = controller.value;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    canvas.transform(matrix.storage);

    const double step = 50.0;
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
