import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

class AdmobServices {
  AdmobServices._private();
  static int adsCounter = 0;
  static AdmobServices? _instance;
  static AdmobServices get instance => _instance ??= AdmobServices._private();

  // Real IDs
  String bannerID = 'ca-app-pub-4736180859140355/8830320517';
  String interstitialID = 'ca-app-pub-4736180859140355/4887206076';

  String appOpenID = 'ca-app-pub-4736180859140355/9010886556';

  // Test IDs
  String bannerTestID = 'ca-app-pub-3940256099942544/6300978111';
  String interstitialTestID = 'ca-app-pub-3940256099942544/1033173712';
  String rewardedTestID = '	ca-app-pub-3940256099942544/5224354917';
  String appOpenTestID = 'ca-app-pub-3940256099942544/3419835294';

  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// High Level Banner Loading Function
  ///
  /// ```dart
  /// AdmobServices.instance.loadBanner(yourBanner)..load();
  /// ```
  BannerAd loadBanner(AdSize size) {
    return BannerAd(
        size: size,
        adUnitId: bannerID,
        listener: BannerAdListener(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (ad, error) {
            toast("Failed to show advertise");
          },
        ),
        request: const AdRequest());
  }

  /// Ready to Use Container Widget In Embed Your Loaded Banner
  /// ```dart
  /// AdmobServices.instance.readyMadeBannerWidget(yourBanner) : Widget<Container>
  /// ```
  Widget readyMadeBannerWidget(BannerAd? bannerAd, AdSize size) {
    return SizedBox(
      height: size.height.toDouble(),
      width: size.width.toDouble(),
      child: bannerAd != null ? AdWidget(ad: bannerAd) : null,
    );
  }

  /// High Level Interstitial Loading Function
  ///
  /// [Warn : Do not need to set `fullScreenContentCallback` as it is already defined inside function]
  ///
  /// Usage :
  /// ```dart
  /// AdmobServices.instance.showInter(yourLoadedInterFromThisFunction);
  /// ```
  Future<void> loadInterstistial({required Function(InterstitialAd? inter) onSuccessfullLoaded}) async {
    await InterstitialAd.load(
        adUnitId: interstitialTestID,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (loadedInter) {
          // Auto Fill Full Screen Content Callback to input paramenter
          loadedInter.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdDismissedFullScreenContent: (ad) => loadInterstistial(onSuccessfullLoaded: onSuccessfullLoaded),
              onAdFailedToShowFullScreenContent: (ad, adError) => loadInterstistial(onSuccessfullLoaded: onSuccessfullLoaded));

          // Trigger Callback
          onSuccessfullLoaded(loadedInter);
          toast("Advertise is loaded ");
        }, onAdFailedToLoad: (LoadAdError error) {
          toast("Advertise Loading Error");
        }));
  }

  /// High Level Interstitial Showing Function
  ///
  /// ```dart
  /// AdmobServices.instance.showInterstitial(yourLoadedInterstitial)
  /// ```
  Future<void> showInterstistial(InterstitialAd? loadedInter, {VoidCallback? onFinished}) async {
    if (loadedInter != null) {
      await loadedInter.show();
      onFinished!();
    } else {
      loadInterstistial(onSuccessfullLoaded: (inter) => loadedInter = inter);
    }
  }

  /// High Level Rewarded Loading Function
  ///
  /// [Warn : Do not need to set `fullScreenContentCallback` as it is already defined inside function]
  ///
  /// Usage :
  /// ```dart
  /// AdmobServices.instance.showRewarded(yourLoadedRewardedFromThisFunction);
  /// ```
  Future<void> loadRewarded({required Function(RewardedAd? rewardedAd) onSuccessfullLoaded}) async {
    await RewardedAd.load(
        adUnitId: rewardedTestID,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (loadedRewarded) {
              // Auto Fill Full Screen Content Callback to input paramenter
              loadedRewarded.fullScreenContentCallback = FullScreenContentCallback(
                  onAdShowedFullScreenContent: (ad) {},
                  onAdDismissedFullScreenContent: (ad) => loadRewarded(onSuccessfullLoaded: onSuccessfullLoaded),
                  onAdFailedToShowFullScreenContent: (ad, AdError adError) => loadRewarded(onSuccessfullLoaded: onSuccessfullLoaded));

              // Trigger Callback
              onSuccessfullLoaded(loadedRewarded);
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  /// High Level Rewarded Showing Function
  ///
  /// ```dart
  /// AdmobServices.instance.showRewarded(yourLoadedRewarded)
  /// ```
  Future<void> showRewarded(RewardedAd? loadedReward, {required VoidCallback onFinished}) async {
    if (loadedReward == null) {
      toast("Advertise is prosponed");
      return;
    }

    loadedReward.show(onUserEarnedReward: (ad, RewardItem reward) => onFinished());
  }

  /// High Level App Open Loading Function
  ///
  /// [Warn : Do not need to set `fullScreenContentCallback` as it is already defined inside function]
  ///
  /// Usage :
  /// ```dart
  /// AdmobServices.instance.appOpenAddListener(yourLoadedAppOpenAd);
  /// ```
  Future<void> loadAppOpen({required Function(AppOpenAd? rewardedAd) onSuccessfullLoaded}) async {
    AppOpenAd.load(
        adUnitId: appOpenID,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdShowedFullScreenContent: (ad) {},
                  onAdFailedToShowFullScreenContent: (ad, error) => loadAppOpen(onSuccessfullLoaded: ((rewardedAd) {})),
                  onAdDismissedFullScreenContent: (ad) => loadAppOpen(onSuccessfullLoaded: ((rewardedAd) {})));
              onSuccessfullLoaded(ad);
            },
            onAdFailedToLoad: (error) => loadAppOpen(onSuccessfullLoaded: ((rewardedAd) {}))),
        orientation: AppOpenAd.orientationPortrait);
  }

  void appOpenAddListener(AppOpenAd? appOpenAd) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.listen((event) {
      if (event == AppState.foreground) {
        appOpenAd!.show();
      } else {
        print("output : AppOpen Background Started");
        loadAppOpen(onSuccessfullLoaded: (ad) => appOpenAd = ad);
      }
    });
  }
}

// Other Necessary Configurations
//  <meta-data
//             android:name="com.google.android.gms.ads.APPLICATION_ID"
//             android:value="ca-app-pub-4736180859140355~8678277271"/>
