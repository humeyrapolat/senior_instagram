import 'package:flutter/material.dart';
import 'package:senior_instagram/util/consts.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  TextEditingController searchController;

  SearchWidget({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: searchController,
          style: const TextStyle(
            color: primaryColor,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: secondaryColor,
              fontSize: 15,
            ),
          ),
        ));
  }
}
