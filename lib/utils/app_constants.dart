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
    MoodEmoji(moodEmoji: '😊', moodTitle: 'Happy'),
    MoodEmoji(moodEmoji: '☹️', moodTitle: 'Sad'),
    MoodEmoji(moodEmoji: '😂', moodTitle: 'Funny'),
    MoodEmoji(moodEmoji: '😔', moodTitle: 'Shameful'),
    MoodEmoji(moodEmoji: '🤦', moodTitle: 'Tired'),
    MoodEmoji(moodEmoji: '😩', moodTitle: 'Panicked'),
  ];
  static const assets = 'assets';
  static const data = '$assets/data';
  static const String dbSchemaFile = '$data/schema.db';

  static String betProId = '';
  static String betProPass = '';
}
