
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig{
  static FirebaseOptions get platformOptions{
    if(kIsWeb){
      return const FirebaseOptions(
          apiKey: 'apiKey',
          appId: 'appId',
          messagingSenderId: 'messagingSenderId',
          projectId: 'projectId'
      );
    }else if(Platform.isIOS || Platform.isMacOS){
      return const FirebaseOptions(
          apiKey: 'apiKey',
          appId: 'appId',
          messagingSenderId: 'messagingSenderId',
          projectId: 'projectId',
      );
    }else{
      ///android
      return const FirebaseOptions(
        apiKey: 'AAAAx2TixGU:APA91bGmSmv5jmRm76O9RClEONv-exlYBDayVxycHt1dvb46wIkZ6AgaT9uBw9unUMXl8tDZlGlayQKi_GEC1G5aYQ6QXCuA21DmnQNtSA7yNmlSTLkLDGQUXbWkpaUOKpd34wkQ-BVW',
        appId: '1:856391074917:android:591cfd088c25803377f28c',
        messagingSenderId: '856391074917',
        projectId: 'flutterfcm-34760',
      );
    }
  }
}