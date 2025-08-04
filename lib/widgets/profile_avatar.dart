import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final IconData defaultIcon;
  final Color? iconColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 30,
    this.backgroundColor,
    this.defaultIcon = Icons.person,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final effectiveBackgroundColor =
        backgroundColor ?? primaryColor.withValues(alpha: 0.1);
    final effectiveIconColor = iconColor ?? primaryColor.withValues(alpha: 0.5);

    return CircleAvatar(
      radius: radius,
      backgroundColor: effectiveBackgroundColor,
      child:
          imageUrl != null && imageUrl!.isNotEmpty
              ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: radius * 2,
                      height: radius * 2,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading profile image: $error');
                    return Icon(
                      defaultIcon,
                      size: radius,
                      color: effectiveIconColor,
                    );
                  },
                ),
              )
              : Icon(defaultIcon, size: radius, color: effectiveIconColor),
    );
  }
}
