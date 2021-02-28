import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LaunchExternalPlayerButton extends StatelessWidget {
  const LaunchExternalPlayerButton({
    Key key,
    @required this.url,
    @required this.referer,
    @required this.pause,
  }) : super(key: key);

  final String url;
  final String referer;
  final VoidCallback pause;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      margin: EdgeInsets.only(bottom: 3),
      child: IconButton(
        icon: Icon(
          Icons.launch_outlined,
        ),
        iconSize: 18,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Select external player: '),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                content: Column(
                  children: [
                    ListTile(
                      title: Text('MxPlayer'),
                      leading: Icon(Icons.play_arrow),
                      onTap: () {
                        pause();
                        DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad')
                            .then(
                          (value) => {
                            if (value)
                              {
                                MethodChannel('tv_info').invokeMethod(
                                  'launchMxPlayer',
                                  {
                                    'url': url,
                                    'referer': referer,
                                  },
                                )
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('MxPlayer is not installed'),
                                  ),
                                )
                              }
                          },
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
