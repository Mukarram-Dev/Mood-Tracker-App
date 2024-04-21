import 'package:mood_track/model/mood_emoji.dart';

class AppConstants {
  static const String appName = 'BETTING App';

  static const String jazzCashAcctNum = '03011234567';
  static const String jazzCashAcctName = 'Noman Ijaz';

  static const String easypaisaAcctName = '0311234567';
  static const String easypaisaAcctNum = 'Noman Butt';

  static const String bankAcctName = '0611234567';
  static const String bankAcctNum = 'Ijaz Ali';

  static List<MoodEmoji> listEmoji = [
    MoodEmoji(moodEmoji: '😊', moodTitle: 'Happy', isSelected: false),
    MoodEmoji(moodEmoji: '☹️', moodTitle: 'Sad', isSelected: false),
    MoodEmoji(moodEmoji: '😂', moodTitle: 'Funny', isSelected: false),
    MoodEmoji(moodEmoji: '😔', moodTitle: 'Shameful', isSelected: false),
    MoodEmoji(moodEmoji: '🤦', moodTitle: 'Tired', isSelected: false),
    MoodEmoji(moodEmoji: '😩', moodTitle: 'Panicked', isSelected: false),
  ];

  static String betProId = '';
  static String betProPass = '';
}
