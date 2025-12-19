enum PracticeMode { timeAttack, lineEndLock }

extension PracticeModeX on PracticeMode {
  String get key => switch (this) {
        PracticeMode.timeAttack => 'timeAttack',
        PracticeMode.lineEndLock => 'lineEndLock',
      };

  static PracticeMode fromKey(String? key) {
    switch (key) {
      case 'lineEndLock':
        return PracticeMode.lineEndLock;
      case 'timeAttack':
      default:
        return PracticeMode.timeAttack;
    }
  }
}
