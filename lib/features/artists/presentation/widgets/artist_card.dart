import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../config/app_config.dart';
import '../../domain/models/artist.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final bool showPrice;

  const ArtistCard({
    super.key,
    required this.artist,
    this.onTap,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppConfig.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    child: artist.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: artist.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.music_note,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.music_note,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                          )
                        : Image.asset(
                            artist.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.music_note,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                  // Verified Badge
                  if (artist.isVerified)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  // Availability Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: artist.isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        artist.isAvailable ? 'Available' : 'Booked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Artist Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artist Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          artist.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConfig.textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            artist.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConfig.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Category and Location
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(artist.category),
                        color: AppConfig.primaryColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${artist.category} • ${artist.location}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConfig.textSecondaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Genres
                  if (artist.genres.isNotEmpty)
                    Text(
                      artist.genres.take(2).join(', '),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppConfig.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Price Range
                  if (showPrice)
                    Row(
                      children: [
                        Text(
                          '₦${_formatPrice(_getMinPrice())} - ₦${_formatPrice(_getMaxPrice())}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'dj':
        return Icons.headphones;
      case 'mc':
        return Icons.mic;
      case 'musician':
        return Icons.music_note;
      case 'cultural group':
        return Icons.celebration;
      case 'photographer':
        return Icons.camera_alt;
      case 'videographer':
        return Icons.videocam;
      default:
        return Icons.music_note;
    }
  }

  double _getMinPrice() {
    return artist.pricing['min'] ?? artist.price;
  }

  double _getMaxPrice() {
    return artist.pricing['max'] ?? artist.price;
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toStringAsFixed(0);
    }
  }
} 