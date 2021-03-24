import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'FullScreenImagePage.dart';

const String testDevice = '';
//for id test device
class WallScreen extends StatefulWidget {
  //final FirebaseAnalytics analytics;
  //final FirebaseAnalyticsObserver observer;

 // WallScreen({this.analytics, this.observer});

  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    //keyword in app to known admop on app
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    birthday: new DateTime.now(),
       childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
  Firestore.instance.collection("wallpaper");

 BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: "ca-app-pub-8863955369821389/9612981899",
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-8863955369821389/5430194309",
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }
/*
  Future<Null> _currentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName: 'Wall Screen', screenClassOverride: 'WallScreen');
  }

  Future<Null> _sendAnalytics() async {
    await widget.analytics
        .logEvent(name: 'full_screen_tapped', parameters: <String, dynamic>{});
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   FirebaseAdMob.instance.initialize(appId: "ca-app-pub-8863955369821389~9804553583");
    _bannerAd = createBannerAd()..load()..show();


    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });

    // _currentScreen();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd.dispose();
    //if list empty
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Wallfy"),
        ),
        body: wallpapersList != null
            ? new StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpapersList.length,
          itemBuilder: (context, i) {
            String imgPath = wallpapersList[i].data['url'];
            return new Material(
              elevation: 8.0,
              borderRadius:
              new BorderRadius.all(new Radius.circular(8.0)),
              child: new InkWell(
                onTap: () {
                 // _sendAnalytics();
                  // on tap on image download banner
                  createInterstitialAd()..load()..show();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new FullScreenImagePage(imgPath)));
                },
                child: new Hero(
                  tag: imgPath,
                  child: new FadeInImage(
                    image: new NetworkImage(imgPath),
                    fit: BoxFit.cover,
                    placeholder: new AssetImage("assets/not.png"),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (i) =>
          new StaggeredTile.count(2, i.isEven ? 2 : 3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        )
            :
        new Center(
          child: new CircularProgressIndicator(),
        ));
  }
}