enum NotificationEnum {
  like('like'),
  comment('comment');

  const NotificationEnum(this.type);
  final String type;
}

// Using an extension
// Enhanced enums

extension ConvertMessage on String {
  NotificationEnum toEnum() {
    switch (this) {
      case 'like':
        return NotificationEnum.like;
      case 'comment':
        return NotificationEnum.comment;
      default:
        return NotificationEnum.like;
    }
  }
}
