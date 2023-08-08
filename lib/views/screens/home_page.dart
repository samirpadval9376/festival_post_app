import 'package:festival_post_app/utils/festival_utils.dart';
import 'package:festival_post_app/utils/my_page_route_utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Festival Post",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: allFestival.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    MyPageRoute.festival,
                    arguments: index,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        allFestival[index]['image'],
                      ),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          10,
                        ),
                        bottom: Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${allFestival[index]['name']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
