import 'dart:developer';

class LoggerDebug {
  LoggerDebug({this.headColor = "", this.constTitle});
  String headColor;
  String? constTitle;

  black(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.black}$message${LogColors.reset}");
  }

  white(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.white}$message${LogColors.reset}");
  }

  red(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.red}$message${LogColors.reset}");
  }

  green(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.green}$message${LogColors.reset}");
  }

  yellow(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.yellow}$message${LogColors.reset}");
  }

  blue(String message, String? title) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.blue}$message${LogColors.reset}");
  }

  cyan(String message, [String? title]) {
    return log("$headColor${title ?? constTitle ?? ""}${LogColors.reset} ${LogColors.cyan}$message${LogColors.reset}");
  }
}

class LogColors {
  static String reset = "\x1B[0m";
  static String black = "\x1B[30m";
  static String white = "\x1B[37m";
  static String red = "\x1B[31m";
  static String green = "\x1B[32m";
  static String yellow = "\x1B[33m";
  static String blue = "\x1B[34m";
  static String cyan = "\x1B[36m";
}
