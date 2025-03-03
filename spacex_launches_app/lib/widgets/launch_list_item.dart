import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/launch.dart';

class LaunchListItem extends StatelessWidget {
  final Launch launch;
  final VoidCallback onTap;

  const LaunchListItem({
    Key? key,
    required this.launch,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission patch
              SizedBox(
                width: 80,
                height: 80,
                child: launch.patchSmall != null
                    ? CachedNetworkImage(
                        imageUrl: launch.patchSmall!,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.rocket,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : const Icon(
                        Icons.rocket,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 16),
              // Launch details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${launch.formattedDate}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusChip(),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText = launch.statusText;
    
    if (launch.upcoming) {
      chipColor = Colors.blue;
    } else if (launch.success == true) {
      chipColor = Colors.green;
    } else {
      chipColor = Colors.red;
    }
    
    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
} 