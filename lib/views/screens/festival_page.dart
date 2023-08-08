import 'dart:io';
import 'dart:ui';

import 'package:festival_post_app/controllers/festival_controller.dart';
import 'package:festival_post_app/utils/festival_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class FestivalPage extends StatelessWidget {
  const FestivalPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey imageKey = GlobalKey();
    int ind = ModalRoute.of(context)!.settings.arguments as int;
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          allFestival[ind]['name'],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Select Method !!"),
                    actions: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          RenderRepaintBoundary? boundary =
                              imageKey.currentContext!.findRenderObject()
                                  as RenderRepaintBoundary;
                          var image = await boundary.toImage(
                            pixelRatio: 8,
                          );
                          var byteData = await image.toByteData(
                              format: ImageByteFormat.png);
                          var imageByte = byteData!.buffer.asUint8List();

                          if (imageByte != null) {
                            Directory dir =
                                await getApplicationDocumentsDirectory();
                            File imagePath =
                                await File("${dir.path}/quote.png").create();
                            await imagePath.writeAsBytes(imageByte);

                            ShareExtend.share(imagePath.path, 'file');
                          }
                        },
                        icon: const Icon(
                          Icons.share,
                        ),
                        label: const Text("Share"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          RenderRepaintBoundary? boundary =
                              imageKey.currentContext!.findRenderObject()
                                  as RenderRepaintBoundary;
                          var image = await boundary.toImage(
                            pixelRatio: 12,
                          );
                          var byteData = await image.toByteData(
                              format: ImageByteFormat.png);
                          var imageByte = byteData!.buffer.asUint8List();

                          if (imageByte != null) {
                            Directory dir =
                                await getApplicationDocumentsDirectory();
                            File imagePath =
                                await File("${dir.path}/quote.png").create();
                            await imagePath.writeAsBytes(imageByte);

                            ImageGallerySaver.saveImage(imageByte);
                          }
                        },
                        icon: const Icon(
                          Icons.save_alt,
                        ),
                        label: const Text("Save"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.share,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Consumer<FestivalController>(
            builder: (context, provider, child) {
              int index = provider.index;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: imageKey,
                    child: Container(
                      height: s.height * 0.4,
                      width: s.width,
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            allFestival[ind]['images'][provider.bgIndex],
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(3, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  provider.back(index: index);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Quote",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.forward(index: index);
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${allFestival[ind]['quote'][index]}",
                            style: TextStyle(
                              color: provider.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(
                            flex: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Change Text Colour :- ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        provider.colors.length,
                        (index) => GestureDetector(
                          onTap: () {
                            provider.changeColor(index: index);
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: provider.colors[index],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Change Background :- ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        allFestival[ind]['images'].length,
                        (index) => GestureDetector(
                          onTap: () {
                            provider.changeBackground(index: index);
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  allFestival[ind]['images'][index],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
