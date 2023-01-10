import 'package:flutter/material.dart';

import '../const/regions.dart';

typedef OnRegionTap = void Function(
    String region); // drawer에서 어떤게 tap되었는지 알기위해 선언한 typedef

class MainDrawer extends StatelessWidget {
  final OnRegionTap onRegionTap;
  final String selectedRegion;
  final Color darkColor;
  final Color lightColor;

  const MainDrawer({
    required this.onRegionTap,
    required this.selectedRegion,
    required this.darkColor,
    required this.lightColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              '지역 선택',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          ...regions
              .map(
                // ... -> list에 있는 내용 하나하나를 뿌림
                (e) => ListTile(
                  tileColor: Colors.white,
                  selectedTileColor: lightColor,
                  // 선택이 된 상태에서의 타일 색상
                  selectedColor: Colors.black,
                  // 선택이 된 상태에서의 글자 색상
                  selected: e == selectedRegion,
                  onTap: () {
                    onRegionTap(e);
                  },
                  title: Text(
                    e,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
