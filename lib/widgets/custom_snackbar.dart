import 'package:flutter/material.dart';
import 'package:pos_app/main.dart';

enum SnackBarType { success, error, warning, info }

enum SnackBarPosition { top, bottom }

class CustomSnackBar {
  static final Map<SnackBarType, Color> _backgroundColors = {
    SnackBarType.success: Colors.green.shade800,
    SnackBarType.error: Colors.red.shade800,
    SnackBarType.warning: Colors.orange.shade800,
    SnackBarType.info: Colors.blue.shade800,
  };

  static final Map<SnackBarType, IconData> _icons = {
    SnackBarType.success: Icons.check_circle_outline,
    SnackBarType.error: Icons.error_outline,
    SnackBarType.warning: Icons.warning_amber_outlined,
    SnackBarType.info: Icons.info_outline,
  };

  static OverlayEntry? _currentOverlay;

  static void _removeCurrentOverlay() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  static void show({
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    double? width,
    bool floating = false,
    SnackBarPosition position = SnackBarPosition.bottom,
    VoidCallback? onVisible,
    BuildContext? context,
  }) {
    final overlayState = navigatorKey.currentState?.overlay;
    _removeCurrentOverlay();

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: position == SnackBarPosition.top ? (floating ? 100 : 0) : null,
        bottom: position == SnackBarPosition.bottom ? (floating ? 100 : 0) : null,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: floating ? 16.0 : 0,
                vertical: floating ? 8.0 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  _removeCurrentOverlay();
                  onTap?.call();
                },
                child: Container(
                  width: width,
                  margin: EdgeInsets.symmetric(
                    horizontal: floating ? 8.0 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColors[type],
                    borderRadius: BorderRadius.circular(floating ? 8 : 0),
                    boxShadow: floating
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _icons[type],
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(_currentOverlay!);
    onVisible?.call();

    Future.delayed(duration, _removeCurrentOverlay);
  }

  static void showSuccess({
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    double? width,
    bool floating = false,
    SnackBarPosition position = SnackBarPosition.bottom,
    VoidCallback? onVisible,
    BuildContext? context,
  }) {
    show(
      context: context ?? navigatorKey.currentState!.context,
      message: message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(seconds: 2),
      onTap: onTap,
      width: width,
      floating: floating,
      position: position,
      onVisible: onVisible,
    );
  }

  static void showError({
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    double? width,
    bool floating = false,
    VoidCallback? onVisible,
    BuildContext? context,
  }) {
    show(
      context: context ?? navigatorKey.currentState!.context,
      message: message,
      type: SnackBarType.error,
      duration: duration ?? const Duration(seconds: 4),
      onTap: onTap,
      width: width,
      floating: floating,
      onVisible: onVisible,
    );
  }

  static void showWarning({
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    double? width,
    bool floating = false,
    VoidCallback? onVisible,
    BuildContext? context,
  }) {
    show(
      context: context ?? navigatorKey.currentState!.context,
      message: message,
      type: SnackBarType.warning,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
      width: width,
      floating: floating,
      onVisible: onVisible,
    );
  }

  static void showInfo({
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    double? width,
    bool floating = false,
    VoidCallback? onVisible,
    BuildContext? context,
  }) {
    show(
      context: context ?? navigatorKey.currentState!.context,
      message: message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
      width: width,
      floating: floating,
      onVisible: onVisible,
    );
  }
}
