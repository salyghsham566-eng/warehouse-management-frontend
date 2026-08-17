import 'package:flutter/material.dart';
import 'package:project_2/Core/network/api_endpoints.dart';

class AppImage extends StatelessWidget {
  final String? image;
  final IconData fallbackIcon;

  final BoxFit fit;

  final double? width;
  final double? height;

  final double fallbackSize;
  final Color fallbackColor;

  const AppImage({
    super.key,
    required this.image,
    required this.fallbackIcon,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.fallbackSize = 32,
    this.fallbackColor = const Color(0xff6B8A92),
  });

  @override
  Widget build(BuildContext context) {
    final String value =
        image?.trim() ?? '';

    if (value.isEmpty) {
      return _fallback();
    }

    final String? networkUrl =
        _resolveNetworkUrl(value);

    if (networkUrl != null) {
      return Image.network(
        networkUrl,
        width: width,
        height: height,
        fit: fit,

        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _fallback();
        },
      );
    }

    return Image.asset(
      value,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    return Center(
      child: Icon(
        fallbackIcon,
        size: fallbackSize,
        color: fallbackColor,
      ),
    );
  }

  String? _resolveNetworkUrl(
    String value,
  ) {
    final Uri? uri =
        Uri.tryParse(value);

    if (uri != null &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https')) {
      return value;
    }

    // Mock assets
    if (value.startsWith('assets/')) {
      return null;
    }

    // لو الباك رجع:
    // /storage/products/image.png
    // storage/products/image.png
    // uploads/image.png
    // media/image.png
    final bool looksLikeRemotePath =
        value.startsWith('/') ||
        value.startsWith('storage/') ||
        value.startsWith('uploads/') ||
        value.startsWith('media/');

    if (!looksLikeRemotePath) {
      return null;
    }

    try {
      final Uri base =
          Uri.parse(
        ApiEndpoints.baseUrl,
      );

      final String origin =
          '${base.scheme}://${base.authority}';

      if (value.startsWith('/')) {
        return '$origin$value';
      }

      return '$origin/$value';
    } catch (_) {
      return null;
    }
  }
}