import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/utils.dart';

import '../models/pen.dart';
import '../models/note.dart';
import '../models/config.dart';

class SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfigModel _config = Provider.of<ConfigModel>(context);
    PenModel _pen = Provider.of<PenModel>(context);
    NoteModel _note = Provider.of<NoteModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('ペンの太さ'),
          Slider(
            label: _pen.width.toString(),
            min: 1,
            max: 10,
            divisions: 9,
            value: _pen.width,
            onChanged: (double value) => _pen.width = value,
          ),
          Text('透過枚数'),
          Slider(
            label: _config.onionRange.toString(),
            min: 0,
            max: 3,
            divisions: 3,
            value: _config.onionRange.toDouble(),
            onChanged: (double value) => _config.onionRange = value.toInt(),
          ),
          Text('fps'),
          Slider(
            label: _note.fps.toString(),
            min: 0,
            max: 30,
            divisions: 30,
            value: _note.fps.toDouble(),
            onChanged: (double value) => _note.fps = value.toInt(),
          ),
        ],
      ),
    );
  }
}

class PenForm extends StatelessWidget {
  static textColor(Color color) {
    return useWhiteForeground(color) ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final PenModel _pen = Provider.of<PenModel>(context);
    final NoteModel _note = Provider.of<NoteModel>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: _pen.isActive ? Colors.grey.shade400 : null,
                  child: FlatButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('1'),
                    textColor: textColor(_pen.color),
                    color: _pen.color,
                    onPressed: () => _pen.isActive = true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: !_pen.isActive ? Colors.grey.shade400 : null,
                  child: FlatButton.icon(
                    label: Text('2'),
                    icon: Icon(Icons.mode_edit),
                    textColor: textColor(_note.backgroundColor),
                    color: _note.backgroundColor,
                    onPressed: () => _pen.isActive = false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _pen.isActive,
              child: BlockPicker(
                availableColors: penColorList,
                pickerColor: _pen.color,
                onColorChanged: (Color value) => _pen.color = value,
              ),
            ),
            Visibility(
              visible: !_pen.isActive,
              child: BlockPicker(
                availableColors: backgroundColorList,
                pickerColor: _note.backgroundColor,
                onColorChanged: (Color value) {
                  _note.backgroundColor = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
