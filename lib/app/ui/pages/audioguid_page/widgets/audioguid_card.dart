import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/ui/theme/app_svg.dart';
import 'package:ruhrkultur/app/ui/theme/colors.dart';

class AudioguidCard extends StatelessWidget {
  final AudioGuideController audioGuideController;
  final AudioGuide audioGuide;

  AudioguidCard(
      {Key? key, required this.audioGuideController, required this.audioGuide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    // Set the card width and height based on screen size
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.2;

    return Center(
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: shadowColor, offset: const Offset(8, 6), blurRadius: 12),
            const BoxShadow(
                color: Colors.white, offset: Offset(-8, -6), blurRadius: 12),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: audioGuide.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        audioGuide.audioName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.width *
                                0.05), // Adjust font size based on screen width
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            audioGuide.audioBeschreibung,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width * 0.03,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '2033533 Listeners',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width * 0.02),
                            // Adjust font size based on screen width
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                        child: Container(
                          height: cardHeight * 0.3,
                          width: cardWidth * 0.3,
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: const Text(
                                      'Jetzt hören',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    onTap: () {},
                                  ),
                                  CircleAvatar(
                                    radius: 11,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AppSvg.play,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: const Text(
                                      'Merken',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    onTap: () {},
                                  ),
                                  CircleAvatar(
                                    radius: 11,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AppSvg.merken,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
