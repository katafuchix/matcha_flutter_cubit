import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/basic/sex.dart';
import '../../../model/bbs/bbs.dart';
import '../../../model/matching/matched_response.dart';
import '../../../model/notification/notifications.dart';
import '../../../model/repository/repository_result.dart';
import '../../../model/search_condition/search_condition.dart';
import '../../../model/user/profile_response.dart';
import '../../../model/visitor/visitor.dart';
import '../../../repository/bbs_repository.dart';
import '../../../repository/matching_repository.dart';
import '../../../repository/notification_repository.dart';
import '../../../repository/search_repository.dart';
import '../../../repository/user_repository.dart';
import '../../helper/repository_handler.dart';

class MyProfileNotifier extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final BbsRepository _bbsRepository = BbsRepository();

  ProfileResponse? myProfile;

  static MyProfileNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<MyProfileNotifier>(context, listen: false);
  }

  Future update(BuildContext context) async {
    {
      final result = await _userRepository.getLatestMe();
      myProfile = RepositoryHandler.getSuccessOrNull(result);
    }
    {
      final result = await _bbsRepository.getMyBbsPostList(
          /*BbsPost.defaultCategoryId*/ null,
          1);
      List<BbsPostResponse>? postList =
          RepositoryHandler.getSuccessOrNull(result);
      if (postList?.isNotEmpty == true) {
        myProfile?.recentPost = [postList!.first.bbsPost];
      }
    }
    // 通知
    notifyListeners();
  }
}

class SearchingNotifier extends ChangeNotifier {
  final SearchRepository _searchRepository = SearchRepository();

  int? _page = 1;
  bool isLoading = false;
  bool doneInitialLoad = false;
  final List<ProfileResponse> profileResponseList = [];
  SearchCondition searchCondition = SearchCondition();

  static SearchingNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<SearchingNotifier>(context, listen: false);
  }

  updateSearchCondition(SearchCondition searchCondition) {
    this.searchCondition = searchCondition;
  }

  updateList(BuildContext context) async {
    _page = 1;
    doneInitialLoad = false;
    profileResponseList.clear();
    getListMore(context);
  }

  removeItem(int userId) {
    profileResponseList
        .removeWhere((element) => element.profile.userId == userId);
    // 通知
    notifyListeners();
  }

  getListMore(BuildContext context) async {
    if (isLoading) return;
    if (_page == null) return;

    isLoading = true;

    // 自分の性別から検索条件を決定する
    searchCondition.sex = UserRepository.mySex == Sex.Male
        ? SexAsCondition.Female
        : SexAsCondition.Male;
    // ページセット
    searchCondition.page = _page;

    final result = await _searchRepository.getMembers(searchCondition);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<ProfileResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        profileResponseList.addAll(value);
      }

      // ページ情報更新
      if (misc?.loadedPageIndex == null) {
        _page = null;
      } else {
        _page = misc!.loadedPageIndex! + 1;
      }

      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    isLoading = false;
    doneInitialLoad = true;
  }
}

class BbsNotifier extends ChangeNotifier {
  final SearchRepository _searchRepository = SearchRepository();
  final BbsRepository _bbsRepository = BbsRepository();

  int? _page = 1;
  bool isLoading = false;
  bool doneInitialLoad = false;
  final List<ProfileResponse> profileResponseList = [];
  SearchCondition searchCondition = SearchCondition();

  static BbsNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<BbsNotifier>(context, listen: false);
  }

  updateSearchCondition(SearchCondition searchCondition) {
    this.searchCondition = searchCondition;
  }

  updateList(BuildContext context) async {
    _page = 1;
    doneInitialLoad = false;
    profileResponseList.clear();
    getListMore(context);
  }

  removeItem(int userId) {
    profileResponseList
        .removeWhere((element) => element.profile.userId == userId);
    // 通知
    notifyListeners();
  }

  getListMore(BuildContext context) async {
    if (isLoading) return;
    if (_page == null) return;

    isLoading = true;

    // ページセット
    searchCondition.page = _page;

    final result = await _searchRepository.getMembers(searchCondition);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<ProfileResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        profileResponseList.addAll(value);
      }

      // ページ情報更新
      if (misc?.loadedPageIndex == null) {
        _page = null;
      } else {
        _page = misc!.loadedPageIndex! + 1;
      }

      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    isLoading = false;
    doneInitialLoad = true;
  }
}

class MatchingProfileNotifier extends ChangeNotifier {
  final MatchingRepository _matchingRepository = MatchingRepository();

  int? _page = 1;
  bool _isLoading = false;
  final List<MatchedResponse> matchedResponseList = [];

  static MatchingProfileNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<MatchingProfileNotifier>(context, listen: false);
  }

  updateList(BuildContext context) async {
    _page = 1;
    matchedResponseList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (_isLoading) return;
    if (_page == null) return;

    _isLoading = true;

    final result = await _matchingRepository.getMatches(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<MatchedResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        matchedResponseList.addAll(value);
      }

      // ページ情報更新
      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    _isLoading = false;
  }
}

class FavoriteNotifier extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  int? _page = 1;
  bool isLoading = false;
  bool doneInitialLoad = false;
  final List<ProfileResponse> favoriteResponseList = [];

  static FavoriteNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<FavoriteNotifier>(context, listen: false);
  }

  addItem(ProfileResponse profileResponse) {
    favoriteResponseList.add(profileResponse);
    // 通知
    notifyListeners();
  }

  removeItem(int userId) {
    favoriteResponseList
        .removeWhere((element) => element.profile.userId == userId);
    // 通知
    notifyListeners();
  }

  updateList(BuildContext context) async {
    _page = 1;
    doneInitialLoad = false;
    favoriteResponseList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (isLoading) return;
    if (_page == null) return;

    isLoading = true;

    final result = await _userRepository.getFavorites(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<ProfileResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        favoriteResponseList.addAll(value);
      }

      // ページ情報更新
      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    isLoading = false;
    doneInitialLoad = true;
  }
}

class IncommingFavoriteNotifier extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  int? _page = 1;
  bool _isLoading = false;
  final List<ProfileResponse> favoriteResponseList = [];

  static IncommingFavoriteNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<IncommingFavoriteNotifier>(context, listen: false);
  }

  updateList(BuildContext context) async {
    _page = 1;
    favoriteResponseList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (_isLoading) return;
    if (_page == null) return;

    _isLoading = true;

    final result = await _userRepository.getIncommingFavorites(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<ProfileResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        favoriteResponseList.addAll(value);
      }

      // ページ情報更新
      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    _isLoading = false;
  }
}

class BlockNotifier extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  int? _page = 1;
  bool isLoading = false;
  bool doneInitialLoad = false;
  final List<ProfileResponse> blockResponseList = [];

  static BlockNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<BlockNotifier>(context, listen: false);
  }

  addItem(ProfileResponse profileResponse) {
    blockResponseList.add(profileResponse);
    // 通知
    notifyListeners();
  }

  removeItem(int userId) {
    blockResponseList
        .removeWhere((element) => element.profile.userId == userId);
    // 通知
    notifyListeners();
  }

  updateList(BuildContext context) async {
    _page = 1;
    doneInitialLoad = false;
    blockResponseList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (isLoading) return;
    if (_page == null) return;

    isLoading = true;

    final result = await _userRepository.getBlocks(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<ProfileResponse>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        blockResponseList.addAll(value);
      }

      // ページ情報更新
      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    isLoading = false;
    doneInitialLoad = true;
  }
}

class NotificationNotifier extends ChangeNotifier {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  int? _page = 1;
  bool _isLoading = false;
  int? badgeCount;
  List<Notifications> notificationList = [];

  static NotificationNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<NotificationNotifier>(context, listen: false);
  }

  updateList(BuildContext context) async {
    _page = 1;
    notificationList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (_isLoading) return;
    if (_page == null) return;

    _isLoading = true;

    final result = await _notificationRepository.getNotifications(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<Notifications>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        notificationList.addAll(value);
      }

      // ページ情報更新
      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      badgeCount = misc?.badgeCount;

      // 通知
      notifyListeners();
    });
    _isLoading = false;
  }
}

class VisitorNotifier extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  int? _page = 1;
  bool _isLoading = false;
  List<Visitor> visitorResponseList = [];

  static VisitorNotifier getNoListenerNotifier(BuildContext context) {
    return Provider.of<VisitorNotifier>(context, listen: false);
  }

  updateList(BuildContext context) async {
    _page = 1;
    visitorResponseList.clear();
    getListMore(context);
  }

  getListMore(BuildContext context) async {
    if (_isLoading) return;
    if (_page == null) return;

    _isLoading = true;

    final result = await _userRepository.getVisitors(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<Visitor>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        visitorResponseList.addAll(value);
      }

      _page = (misc?.loadedPageIndex ?? 0) + 1;
      if (misc?.totalCount == 0 || value?.isEmpty == true) _page = null;

      // 通知
      notifyListeners();
    });
    _isLoading = false;
  }
}
