import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: generateRoomId());
  final nameText = TextEditingController(text: "your name");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = false;
  var isAudioMuted = false;
  var isVideoMuted = false;
  static String generateRoomId() {
    var randomString = Random();
    return randomString.hashCode.toString();
  }

  @override
  void initState() {
    super.initState();
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
              height: 16.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: nameText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Display Name",
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            CheckboxListTile(
              title: Text("Audio Only"),
              value: isAudioOnly,
              onChanged: _onAudioOnlyChanged,
            ),
            SizedBox(
              height: 16.0,
            ),
            CheckboxListTile(
              title: Text("Audio Muted"),
              value: isAudioMuted,
              onChanged: _onAudioMutedChanged,
            ),
            SizedBox(
              height: 16.0,
            ),
            CheckboxListTile(
              title: Text("Video Muted"),
              value: isVideoMuted,
              onChanged: _onVideoMutedChanged,
            ),
            Divider(
              height: 48.0,
              thickness: 2.0,
            ),
            SizedBox(
              height: 64.0,
              width: double.maxFinite,
              child: RaisedButton(
                onPressed: () {
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
        ..videoMuted = isVideoMuted;

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
}
