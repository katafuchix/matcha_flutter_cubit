import '../../core/configure.dart';
import '../../model/user/profile_image.dart';
import '../../model/user/profile_response.dart';

class ImageLoader {
  static String? apiUrlToFullPath(String? apiUrl) {
    if (apiUrl == null || apiUrl.isEmpty) return null;
    return '${Config.environment.apiBaseUrl}$apiUrl';
  }

  static String? profileResponseToFullPath(ProfileResponse? profile) {
    if (profile == null) return null;
    if (profile.profileImages.isNotEmpty == true) {
      return '${Config.environment.apiBaseUrl}${profile.profileImages.first.image}';
    }
    return null;
  }

  static String? profileImageToFullPath(List<ProfileImage>? profileImages) {
    if (profileImages == null) return null;
    if (profileImages.isNotEmpty == true) {
      return '${Config.environment.apiBaseUrl}${profileImages.first.image}';
    }
    return null;
  }
}
