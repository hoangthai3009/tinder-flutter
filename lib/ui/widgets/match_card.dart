import 'package:flutter/material.dart';
import 'package:tinder/data/models/user/user.dart';
import 'package:tinder/utils/date_utils.dart';

class MatchCard extends StatefulWidget {
  final User user;

  const MatchCard({super.key, required this.user});

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  int _currentPictureIndex = 0;

  void _showNextPicture() {
    setState(() {
      _currentPictureIndex = (_currentPictureIndex + 1) % widget.user.profile.picture.length;
    });
  }

  void _showPreviousPicture() {
    setState(() {
      _currentPictureIndex = (_currentPictureIndex - 1 + widget.user.profile.picture.length) % widget.user.profile.picture.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        child: GestureDetector(
          onTapUp: (details) {
            if (widget.user.profile.picture.isNotEmpty) {
              final screenWidth = MediaQuery.of(context).size.width;
              if (details.localPosition.dx > screenWidth / 2) {
                _showNextPicture();
              } else {
                _showPreviousPicture();
              }
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width - 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: ClipRRect(
                    key: ValueKey<int>(_currentPictureIndex),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.user.profile.picture.isNotEmpty ? widget.user.profile.picture[_currentPictureIndex] : 'https://via.placeholder.com/720x1280',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.user.name}, ${calculateAge(widget.user.profile.dateOfBirth)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.user.topPicks.enabled)
                        const Text(
                          'TOP PICK',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 16.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
