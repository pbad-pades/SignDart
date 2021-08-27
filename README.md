# signdart

This is a pure Dart library for elliptic curve research and practical application.

## Building

There are two ways to build this project

### As local project
The recommended way to clone is:

```
git clone git@github.com:pbad-pades/SignDart.git
```

### As dart package
To use this project as dart package, it is necessary to add this repository as dependecy of `pubspec.yaml` using the cli branch.
It is recommended to use SSH keys, like:

```
dependencies:
  dartffiedlibdecaf:
    git:
      url: https://github.com/pbad-pades/SignDart.git
```
After, run 
```
$ dart pub get
```    

At code, import the package with `import 'package:signdart/signdart.dart';`

After that it is possible to use the library normally. 

## examples/

You will find a set of examples.

### example/ed521_example.dart

This example create a public and private key, sign and verify a message using the Ed521 algorithm.
OBS: Do not use the private key give for any other purpose.

Usage:   
At example directory
```
dart ed521_example.dart
```
