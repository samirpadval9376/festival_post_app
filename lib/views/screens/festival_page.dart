import 'dart:io';
import 'dart:ui';

import 'package:festival_post_app/controllers/festival_controller.dart';
import 'package:festival_post_app/utils/festival_utils.dart';
import 'package:flutter/cupertino.dart';
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
                    title: Consumer<FestivalController>(
                        builder: (context, provider, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Change Text Colour :- ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
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
                              height: 10,
                            ),
                            const Text(
                              "Text Align :- ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CupertinoSlidingSegmentedControl(
                              children: const {
                                TextAlign.start: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.format_align_left,
                                  ),
                                ),
                                TextAlign.center: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.format_align_center,
                                  ),
                                ),
                                TextAlign.end: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.format_align_right,
                                  ),
                                ),
                              },
                              groupValue: provider.textAlign,
                              onValueChanged: (val) {
                                provider.change(val: val);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Text font weight :- ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Slider(
                              min: 0,
                              max: 8,
                              divisions: 9,
                              value: provider.weight.toDouble(),
                              onChanged: (val) {
                                provider.changeWeight(
                                  val: val.toInt(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          provider.back(index: index);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Quote",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.forward(index: index);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: s.height * 0.02,
                  ),
                  RepaintBoundary(
                    key: imageKey,
                    child: Container(
                      height: s.height * 0.4,
                      width: s.width,
                      padding: const EdgeInsets.all(10),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            "${allFestival[ind]['quote'][index]}",
                            textAlign: provider.textAlign,
                            style: TextStyle(
                              color: provider.textColor,
                              fontWeight: FontWeight.values[provider.weight],
                              fontSize: 22,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${allFestival[ind]['text']}",
                                style: TextStyle(
                                  color: provider.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
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
    SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    allFestival[0]['image'],
                  ),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Festivals",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              child: Container(
                height: s.height * 0.8,
                child: PageView.builder(
                  itemCount: allFestival.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            allFestival[index]['image'],
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black45,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    allFestival.length,
                                    (index) => Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
