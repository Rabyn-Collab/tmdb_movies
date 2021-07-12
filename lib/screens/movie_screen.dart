import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme/data_provider/db_provider.dart';
import 'package:flutter_theme/data_provider/initial_state.dart';
import 'package:flutter_theme/widgets/movie_detail.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MovieScreen extends StatelessWidget {
  final textFocus = FocusNode();

 final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async{
    await Future.delayed(Duration(milliseconds: 1000));
    context.read(dbProvider.notifier);
    _refreshController.refreshCompleted();
  }
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: KeyboardDismisser(
          gestures: [
            GestureType.onTap,
            GestureType.onPanUpdateDownDirection,
          ],
          child: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/perfume.jpg')),
                  ),
                  child: BackdropFilter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              width: width * 0.60,
                              height: 45,
                              child: TextField(
                                focusNode: FocusNode(canRequestFocus: false),
                                controller: searchController,
                                onSubmitted: (val){
                                  context.read(dbProvider.notifier).searchMovies(searchController.text);
                                },
                                cursorColor: Colors.grey[400],
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  labelText: 'Search Movies',
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white24, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle:
                                      TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          Consumer(
                              builder: (context, watch, child) {
                                return  PopupMenuButton(
                                    icon: Icon(Icons.menu),
                                    onSelected: (val){
                        context.read(dbProvider.notifier).updatedCategory(val);
                                    },
                                    itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: Category.popular,
                                      child: Text('Popular')
                                  ),
                                      PopupMenuItem(
                                          value: Category.upcoming,
                                          child: Text('UpComing')
                                      ), PopupMenuItem(
                                          value: Category.topRated,
                                          child: Text('Top_Rated')
                                      ),
                                ]);
                              }
                          )
                        ],
                      ),
                      Consumer(
                        builder: (context, watch, child) {
                          final data = watch(dbProvider);
                          return data.movies.length == 0 ? Center(child: Column(
                            children: [
                              SizedBox(height: 250,),
                              CircularProgressIndicator(),
                            ],
                          ),) : Expanded(
                            child: NotificationListener(
                              onNotification: (onNotification){
                                if(onNotification is ScrollEndNotification){
                                  final before = onNotification.metrics.extentBefore;
                                  final max = onNotification.metrics.maxScrollExtent;
                                  if(before == max){
                                    context.read(dbProvider.notifier).getMovies();
                                    return true;
                                  }
                                  return false;
                                }
                                return false;
                              },
                              child: SmartRefresher(
                                onRefresh: () => _onRefresh(context),
                                controller: _refreshController,
                                enablePullDown: true,
                                enablePullUp: true,
                                child: CustomScrollView(
                                  shrinkWrap: true,
                                  slivers: [
                                    SliverGrid(
                                        delegate: SliverChildBuilderDelegate((context,
                                            index) {
                                          return TextButton(
                                            onPressed: (){
                              Get.to(() => MovieDetail(movies: data.movies[index]), transition: Transition.zoom, duration: Duration(milliseconds: 300));
                                            },
                                            child: Container(
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) => Image.asset('images/perfume.jpg'),
                                                  imageUrl:'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${data.movies[index].posterPath}'
                                              ),
                                            ),
                                          );
                                        }, childCount: data.movies.length),
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 150,
                                          childAspectRatio: 2/3,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      )
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
