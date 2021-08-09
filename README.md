# dartffiedlibdecaf

This is a FFI interface to the libdecaf, a library for elliptic curve research and practical application.

## Building

There's two ways to build this project

### As local project
In order to build you have to clone (or initialize later) git submodules, 
this repository relies on multiple submodules. Recommended way to clone is:

```
git clone --recurse-submodules https://github.com/pbad-pades/dartffiedlibdecaf.git
```

### As dart package
To use this project as dart package, will be necessary to add this repository as dependecy of `pubspec.yaml` using the cli branch.
Recommended use SSH key, like:

```
dependencies:
  dartffiedlibdecaf:
    git:
      url: git@github.com:pbad-pades/dartffiedlibdecaf.git
```
After, run 
```
$ dart pub get
```    

At code, import the package with `import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';`

After that it is possible to make the function calls normally. 

## examples/

You will find a set of examples.

### example/main.dart

This example sign and verify a message using a pregenerated private key.
OBS: Do not use the private key for any other purpose.

Usage:   
At example directory
```
dart main.dart
```
