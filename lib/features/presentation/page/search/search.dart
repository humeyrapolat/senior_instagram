import 'package:flutter/material.dart';
import 'package:senior_instagram/features/presentation/page/search/widget/search_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgGroundColor,
        body: SingleChildScrollView(
          child: Column(
            //item count 32 olduğu için sayfaya sığmadı scroll yapılması lazım
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SearchWidget(searchController: searchController),
              ),
              sizeVertical(10),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 32,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: secondaryColor,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
