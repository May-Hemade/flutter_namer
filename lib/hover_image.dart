import 'package:flutter/material.dart';

class HoverDeleteImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const HoverDeleteImage(
      {Key? key, required this.imageUrl, required this.onDelete})
      : super(key: key);

  @override
  _HoverDeleteImageState createState() => _HoverDeleteImageState();
}

class _HoverDeleteImageState extends State<HoverDeleteImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          if (_isHovered)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
