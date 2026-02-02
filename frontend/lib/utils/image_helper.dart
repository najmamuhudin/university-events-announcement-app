import 'package:flutter/material.dart';
import 'constants.dart';

class ImageHelper {
  static String getEventImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Fallback if no image provided
      return 'https://images.unsplash.com/photo-1523050853063-913a6e046732?auto=format&fit=crop&w=1350&q=80';
    }

    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    // Ensure leading slash
    String path = imageUrl;
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    return '${AppConstants.baseImageUrl}$path';
  }

  static Widget buildNetworkImage(
    String? imageUrl, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    final String url = getEventImageUrl(imageUrl);

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                color: Colors.grey[500],
                size: 30,
              ),
              if (height != null && height > 80) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Failed: $url',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 8),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: Colors.grey[100],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }
}
