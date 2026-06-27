import 'dart:typed_data';

import '../model/notification/notifications.dart';
import '../model/search_condition/search_condition.dart';
import '../model/user/profile_response.dart';

class ProfileScreenArgs {
  final ProfileResponse profile;
  final bool isMe;
  const ProfileScreenArgs(this.profile, {this.isMe = false});
}

class MessageRoomScreenArgs {
  final String roomId;
  final ProfileResponse myProfile;
  final ProfileResponse targetProfile;
  const MessageRoomScreenArgs({
    required this.roomId,
    required this.myProfile,
    required this.targetProfile,
  });
}

class SearchConditionScreenArgs {
  final bool showSexField;
  final SearchCondition currentCondition;
  const SearchConditionScreenArgs(this.showSexField, this.currentCondition);
}

// MultiChoiceOneItem をここに定義（multi_choice_screen.dart から移動）
class MultiChoiceOneItem {
  int id;
  String label;
  bool selected;
  MultiChoiceOneItem(this.id, this.label, this.selected);

  @override
  String toString() => '{id: $id, label: $label, selected: $selected}';
}

class MultiChoiceScreenArgs {
  final String title;
  final List<MultiChoiceOneItem> items;
  MultiChoiceScreenArgs(this.title, List<MultiChoiceOneItem> items)
      : items = List.generate(
            items.length,
            (i) => MultiChoiceOneItem(
                items[i].id, items[i].label, items[i].selected));
}

class MultiChoiceScreenResult {
  final List<MultiChoiceOneItem> selectedItems;
  MultiChoiceScreenResult(this.selectedItems);
}

class NotificationContentsScreenArgs {
  final int notificationId;
  final NotificationType notificationType;
  final String title;
  const NotificationContentsScreenArgs(
      this.notificationId, this.notificationType, this.title);
}

class SimpleTextScreenArgs {
  final String title;
  final String text;
  const SimpleTextScreenArgs(this.title, this.text);
}

class SimpleImageScreenArgs {
  final String title;
  final String? url;
  final Uint8List? image;
  const SimpleImageScreenArgs(this.title, {this.url, this.image});
}
