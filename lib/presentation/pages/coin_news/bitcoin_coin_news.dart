import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptoboard/business_logic/blocs/news/news_bloc.dart';
import 'package:cryptoboard/constants/constants.dart';
import 'package:cryptoboard/presentation/screens/loading/news_load_in_progress_shimmer.dart';
import 'package:cryptoboard/presentation/screens/loading/shimmer_avi.dart';
import 'package:cryptoboard/presentation/shared/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BitcoinCoinNews extends StatelessWidget {
  final NewsBloc newsBloc;

  const BitcoinCoinNews({Key key, this.newsBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ChromeSafariBrowser browser = new MyChromeSafariBrowser(new WebViewContent());

    return BlocBuilder<NewsBloc, NewsState>(
      cubit: newsBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              splashRadius: 20.w,
              padding: EdgeInsets.all(0),
              hoverColor: Color(0xff2777FF).withAlpha(80),
              splashColor: Color(0xff2777FF).withAlpha(80),
              highlightColor: Color(0xff2777FF).withAlpha(80),
              icon: Icon(Icons.arrow_back),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bitcoin', style: appBarText.copyWith(fontSize: 17.sp)),
                Text("Based on market rankings", style: subTitle),
              ],
            ),
          ),
          body: state is NewsLoadSuccess
              ? Padding(
                  padding: EdgeInsets.only(left: 16.0.w, bottom: 32.0.h, right: 16.0.w),
                  child: Container(
                    height: 1.sh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        final news = state.bitcoinNews.data[index];
                        final timestamp = news.publishedOn;
                        final newsUrl = news.url;
                        final publishedAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                        final publishedAgo = DateTime.now().difference(publishedAt);
                        final timeAgo = publishedAgo.inMinutes > 60 ? publishedAgo.inHours : publishedAgo.inMinutes;
                        return GestureDetector(
                          onTap: () {
                            browser.open(url: newsUrl);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 24.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //image
                                Container(
                                  height: 100.0.h,
                                  width: 100.0.w,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: CachedNetworkImage(
                                    height: 100.h,
                                    width: double.maxFinite,
                                    filterQuality: FilterQuality.high,
                                    imageUrl: news.imageurl,
                                    fit: BoxFit.cover,
                                    placeholder: (BuildContext, String) => ShimmerBitcoinNewsImage(),
                                    alignment: Alignment.center,
                                  ),
                                ),

                                //title
                                Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 266.w,
                                        child: Text(
                                          news.title,
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: newsTitle,
                                        ),
                                      ),
                                      SizedBox(height: 16.0.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          //publisher
                                          CircleAvatar(
                                            radius: 13.w,
                                            backgroundColor: Colors.black,
                                            child: Container(
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (BuildContext, String) => ShimmerAvi(),
                                                imageUrl: news.sourceInfo.img,
                                                filterQuality: FilterQuality.high,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 5.0.w),

                                          //time
                                          Text(
                                            publishedAgo.inMinutes > 60
                                                ? news.sourceInfo.name + " • " + timeAgo.toString() + 'h' + " ago"
                                                : news.sourceInfo.name + " • " + timeAgo.toString() + 'm' + " ago",
                                            style: subTitle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : state is NewsInitial
                  ? NewsLoadInProgressShimmer()
                  : null,
        );
      },
    );
  }

  Widget ShimmerBitcoinNewsImage() {
    return Shimmer(
      enabled: true,
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        colors: [
          Color(0xff131518),
          Color(0xff2A2F37),
        ],
      ),
      child: Container(
        height: 56.h,
        width: double.maxFinite,
        color: Colors.red,
      ),
    );
  }
}
