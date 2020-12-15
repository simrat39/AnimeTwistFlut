import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/providers/settings/ZoomFactorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class ZoomFactorSetting extends StatefulWidget {
  const ZoomFactorSetting({Key key}) : super(key: key);

  @override
  _ZoomFactorSettingState createState() => _ZoomFactorSettingState();
}

class _ZoomFactorSettingState extends State<ZoomFactorSetting> {
  @override
  Widget build(BuildContext context) {
    var provider = context.read(zoomFactorProvider);
    return ListTile(
      title: Text("Zoom factor in fill mode"),
      leading: Icon(Icons.zoom_in),
      subtitle: MediaQuery.removePadding(
        context: context,
        child: SliderTheme(
          data: SliderThemeData(trackShape: CustomTrackShape()),
          child: Slider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).accentColor.withOpacity(0.2),
            onChanged: (double value) {
              setState(() {
                provider.updateValue(value);
              });
            },
            value: provider.data,
            min: ZoomFactorProvider.MIN,
            max: ZoomFactorProvider.MAX,
            label: provider.data.toString(),
            divisions: 20,
          ),
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
