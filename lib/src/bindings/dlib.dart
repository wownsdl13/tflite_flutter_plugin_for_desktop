import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as Path;

const Set<String> _supported = {'linux', 'mac', 'win'};

String get binaryName {
  String os, ext;
  if (Platform.isLinux) {
    os = 'linux';
    ext = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    ext = 'dylib';
  } else if (Platform.isWindows) {
    os = 'win';
    ext = 'dll';
  } else {
    throw Exception('Unsupported platform!');
  }

  if (!_supported.contains(os)) {
    throw UnsupportedError('Unsupported platform: $os!');
  }

  return 'libtensorflowlite_c-$os.$ext';
}

/// TensorFlowLite C library.
// ignore: missing_return
DynamicLibrary tflitelib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libtensorflowlite_c.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open(
        Directory(Platform.resolvedExecutable).parent.parent.path +
            '/resources/libtensorflowlite_c-mac.dylib');
  } else if (Platform.isLinux) {
    return DynamicLibrary.open(
        Directory(Platform.resolvedExecutable).parent.path +
            '/blobs/libtensorflowlite_c-linux.so');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open(
        Directory(Platform.resolvedExecutable).parent.path +
            '/blobs/libtensorflowlite_c-win.dll');
  } else {
    throw UnsupportedError('Unsupported platform!');
  }
}();
