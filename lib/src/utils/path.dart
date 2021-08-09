import 'dart:io';

String locatePath()
{
  String home = "";
  String path = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS || Platform.isLinux) {
    home = envVars['HOME'] ?? '';
    path = home + '/.pub-cache/git';
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'] ?? '';
    path = home + '\\AppData\\Roaming\\Pub\\Cache\\git';
  }
  var files = Directory(path).listSync();

  for (var file in files) {
    path = file.path;
    var dir = "";
    if (Platform.isMacOS || Platform.isLinux)
      dir = path.split('/').last.split('-')[0];
    else if (Platform.isWindows)
      dir = path.split('\\').last.split('-')[0];
    if (dir == 'dartffiedlibdecaf')
      break;
    else
      path = '';
  }

  if (path.isEmpty) {
    var currentDirectory = Directory.current.path;
    var folders = currentDirectory.split('/');
    var index = folders.length - 1;

    var indexOfPackage = folders.lastIndexOf('dartffiedlibdecaf');
    if (indexOfPackage != -1) {
      folders = folders.sublist(0, indexOfPackage + 1);
      path = folders.join('/');
    }  
  }

  if (Platform.isMacOS || Platform.isLinux)
    return path + '/lib/src/libdecaf/src/libdecaf.so';
  else if (Platform.isWindows)
    return path + '\\lib\\src\\libdecaf\\src\\libdecaf.so';
  else 
    return '';
}