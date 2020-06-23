import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:random_string/random_string.dart';

class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: generateRoomId());
  final nameText = TextEditingController(text: "");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = false;
  var isAudioMuted = false;
  var isVideoMuted = false;

  //ads
  InterstitialAd _interstitialAd;
  static const String testDevice = 'F4FA7C1356925D1F';

  static String generateRoomId() {
    return randomAlphaNumeric(8);
  }

  @override
  void initState() {
    super.initState();

    _interstitialAd = createInterstitialAd();
    _interstitialAd.load();

    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: roomText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Room Id",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: nameText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Display Name",
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            CheckboxListTile(
              title: Text("Audio Only"),
              value: isAudioOnly,
              onChanged: _onAudioOnlyChanged,
            ),
            Divider(
              height: 30.0,
              thickness: 2.0,
            ),
            SizedBox(
              height: 64.0,
              width: double.maxFinite,
              child: RaisedButton(
                onPressed: () {
                  _interstitialAd.show();
                  _joinMeeting();
                },
                child: Text(
                  "Create Meeting",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue[800],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
          ],
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..userDisplayName = nameText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..chatEnabled = true;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['app', 'games'],
    contentUrl: 'http://google.com',
    childDirected: false,
    nonPersonalizedAds: false,
  );

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) _interstitialAd.load();
      },
    );
  }
}
