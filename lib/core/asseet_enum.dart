enum AssetEnum { MALE, FEMALE, TICKET }

extension AssetEnumExt on AssetEnum {
  String get path {
    switch (this) {
      case AssetEnum.MALE:
        return 'assets/images/male.png';
      case AssetEnum.FEMALE:
        return 'assets/images/female.png';
      case AssetEnum.TICKET:
        return 'assets/images/ticket.png';

      default:
        throw StateError('unexpected');
    }
  }
}
