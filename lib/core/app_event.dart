part of 'event_tracking.dart';

class AppEvent {
  static sendPushEvent(String screenName) {
    EventTracking._sendEvent('screen_push', {'screen_name': screenName});
  }

  static sendHomeTabEvent(String screenName) {
    EventTracking._sendEvent('home_tab_selected', {'screen_name': screenName});
  }

  static Future sendRegisterEvent(Sex sex) async {
    if (sex == Sex.Male) {
      await EventTracking._sendEvent('complete_registration_male', null);
    }
    if (sex == Sex.Female) {
      await EventTracking._sendEvent('complete_registration_female', null);
    }

    await EventTracking.getAppsflyerSdk()
        ?.logEvent('af_complete_registration', {});
  }

  // メッセージ送信
  static Future sendMessageSendEvent() async {
    await EventTracking._sendEvent('message_send', null);
  }

  // 初回限定チケット購入
  static Future sendPurchaseFirstEvent() async {
    await EventTracking._sendEvent('purchase_first', null);
  }

  // 通常チケット購入
  static Future sendPurchaseRegularEvent() async {
    await EventTracking._sendEvent('purchase_regular', null);
  }

  // 絞り込み検索（絞り込み設定後完了ボタンを押したタイミングでイベント発生）
  static Future sendRefinedResearchEvent() async {
    await EventTracking._sendEvent('refined_research', null);
  }

  // 履歴ページ閲覧
  static Future sendViewHistoryEvent() async {
    await EventTracking._sendEvent('view_history', null);
  }

  // プロフィール画像拡大
  static Future sendTapToProfileImageEvent() async {
    await EventTracking._sendEvent('tap_to_profileImage', null);
  }
}
