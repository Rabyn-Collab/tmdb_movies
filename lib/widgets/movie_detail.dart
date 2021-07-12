import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme/data_provider/db_provider.dart';
import 'package:flutter_theme/data_provider/movies.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class MovieDetail extends StatelessWidget {
final Movies movies;
MovieDetail({this.movies});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Consumer(
          builder: (_, watch, child) {
            final data = watch(videoProvider(movies.id));
            return data.when(data: (id){
              return  Stack(
                children: [
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/perfume.jpg'),
                        )
                    ),
                    child: BackdropFilter(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0)
                    ),
                  ),
                  Consumer(
                      builder: (context, watch, child) {
                        final isLoad = watch(toggleProvider);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: ListView(
                            children: [
                              isLoad == true ? Container(
                                height: 270,
                                width: double.infinity,
                                child: InkWell(
                                  onTap: (){
                                    context.read(toggleProvider.notifier).toggle();
                                  },
                                  child: Image.asset(
                                    'images/video-play.jpg', fit: BoxFit.cover,),
                                ),
                              ) : Container(
                                height: 300,
                                child: YoutubePlayer(
                                  showVideoProgressIndicator: false,
                                  controller: YoutubePlayerController(
                                    initialVideoId: id,
                                    flags: YoutubePlayerFlags(
                                      autoPlay: true,
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                            placeholder: (context, url) => Image.asset('images/perfume.jpg'),
                                            imageUrl:'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${movies.posterPath}', width: 150,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.50,
                                                child: Text(
                                                  '${movies
                                                      .title} (${
                                                      movies.releaseDate.substring(
                                                          0, 4)})',
                                                  style: TextStyle(fontSize: 17),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,),
                                              ),
                                              SizedBox(height: 10,),
                                              Text('${movies.popularity}',
                                                style: TextStyle(fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.share)),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.favorite)),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.comment)),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(movies.overview, style: TextStyle(fontSize: 15), ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  ),
                ],
              );
            }, loading: ()=> Text(''), error: (err, stack)=> Container());
          }
        ));
  }
}
