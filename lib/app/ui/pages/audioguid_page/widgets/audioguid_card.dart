import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:ruhrkultur/app/ui/theme/app_svg.dart';
import 'package:ruhrkultur/app/ui/theme/colors.dart';

class AudioguidCard extends GetView<AudioController> {
  final AudioGuide audioGuide;

  AudioguidCard({required this.audioGuide});

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
        child: Stack(fit: StackFit.expand, children: [
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
            child: ResponsiveRowColumn(
              layout: ResponsiveBreakpoints.of(context).isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                  child: SizedBox(
                    height: 5,
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Text(
                    audioGuide.audioName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width *
                            0.05), // Adjust font size based on screen width
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: SizedBox(
                    height: 5,
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: ResponsiveRowColumn(
                    layout: ResponsiveBreakpoints.of(context).isMobile
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    children: [
                      ResponsiveRowColumnItem(
                        child: Text(
                          audioGuide.audioBeschreibung,
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.width * 0.03,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: Text(
                          
                          '2033533 Listeners',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width * 0.02),
                          // Adjust font size based on screen width
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveRowColumnItem(child: Spacer()),
                ResponsiveRowColumnItem(
                  child: GestureDetector(
                    onTap: () async {
                      print(audioGuide.audioBeschreibung);
                      controller.setSelectedGuide(audioGuide);
                      await Get.toNamed(AppRoutes.AUDIOGUIDDEATILPAGE);
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                          child: Container(
                            height: cardHeight * 0.3,
                            width: cardWidth * 0.3,
                            margin: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black26),
                            child: ResponsiveRowColumn(
                              layout: ResponsiveBreakpoints.of(context).isMobile
                                  ? ResponsiveRowColumnType.COLUMN
                                  : ResponsiveRowColumnType.ROW,
                              children: [
                                ResponsiveRowColumnItem(
                                  child: ResponsiveRowColumn(
                                    layout: ResponsiveBreakpoints.of(context)
                                            .isMobile
                                        ? ResponsiveRowColumnType.COLUMN
                                        : ResponsiveRowColumnType.ROW,
                                    children: [
                                      ResponsiveRowColumnItem(
                                          child: SizedBox(
                                        height: 5,
                                      )),
                                      ResponsiveRowColumnItem(
                                        child: Text("Jetzt Hören",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      ResponsiveRowColumnItem(
                                          child: SizedBox(
                                        height: 5,
                                      )),
                                      ResponsiveRowColumnItem(
                                          child: CircleAvatar(
                                        radius: 11,
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppSvg.play,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
