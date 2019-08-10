import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import './pen.dart';

class NoteModel extends ChangeNotifier {
  List<Page> _pages = [Page()];
  int pageIndex = 0;
  bool isPlaying = false;
  double fps = 12;

  void play() {
    isPlaying = !isPlaying;
    notifyListeners();
    if (isPlaying) {
      Timer.periodic(
        Duration(milliseconds: 1000 ~/ fps),
        (Timer timer) {
          if (!isPlaying) {
            timer.cancel();
          }
          pushPageAndLoop();
          notifyListeners();
        },
      );
    }
  }

  void pushPageAndLoop() {
    pageIndex++;
    if (pageIndex >= _pages.length) {
      pageIndex = 0;
    }
    notifyListeners();
  }

  void pushPageAndCreate() {
    pageIndex++;
    if (pageIndex >= _pages.length) {
      _pages.add(Page());
    }
    notifyListeners();
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
    notifyListeners();
  }

  Page getRelativePage(int i) => _pages[pageIndex + i];

  Page get currentPage => getRelativePage(0);

  int get pageLength => _pages.length;

  void addLine(PenModel pen, Offset point) {
    currentPage.addLine(pen, point);
    notifyListeners();
  }

  void updateLine(Offset point) {
    currentPage.updateLine(point);
    notifyListeners();
  }
}

class Page {
  List<Line> lines = [];

  void addLine(PenModel pen, Offset point) {
    lines.add(Line(pen.paint)..points.add(point));
  }

  void updateLine(Offset point) {
    lines.last.points.add(point);
  }
}

class Line {
  List<Offset> points = [];
  Paint paint;
  List<Color> _onionColors = [
    Colors.grey,
    Colors.grey.shade400,
    Colors.grey.shade300,
  ];

  Line(this.paint);

  getOnionPaint(int onionIndex) {
    int index = -(onionIndex + 1);
    return Paint()
      ..strokeWidth = paint.strokeWidth
      ..strokeCap = paint.strokeCap
      ..color = _onionColors[index];
  }
}
