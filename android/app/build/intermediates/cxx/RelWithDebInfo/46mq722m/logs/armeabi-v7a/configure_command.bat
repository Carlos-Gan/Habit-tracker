@echo off
"C:\\Users\\Carlo\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HP:\\FlutterSDK\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\groovy" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=34" ^
  "-DANDROID_PLATFORM=android-34" ^
  "-DANDROID_ABI=armeabi-v7a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a" ^
  "-DANDROID_NDK=C:\\Users\\Carlo\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\Carlo\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\Carlo\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\Carlo\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=P:\\Coding\\Flutter\\Habit Tracker\\habit_tracker\\android\\app\\build\\intermediates\\cxx\\RelWithDebInfo\\46mq722m\\obj\\armeabi-v7a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=P:\\Coding\\Flutter\\Habit Tracker\\habit_tracker\\android\\app\\build\\intermediates\\cxx\\RelWithDebInfo\\46mq722m\\obj\\armeabi-v7a" ^
  "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ^
  "-BP:\\Coding\\Flutter\\Habit Tracker\\habit_tracker\\android\\app\\.cxx\\RelWithDebInfo\\46mq722m\\armeabi-v7a" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli
