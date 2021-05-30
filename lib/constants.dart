// constants and enums
// DonnC

// a random num generator
import 'dart:math';

const String version = 'v1.0.0';

final Random _random = Random();

/// sidebar signal
enum SideBarSignal {
  None,
  AddTodo,
  AddLogBook,
  EditLogBook,
  ViewLogBook,
}

/// view mode on home screen
enum ViewMode {
  None,
  List,
  Grid,
}

/// general response action
enum ResponseAction {
  None,
  Success,
  Fail,
  Error,
}

/// general response event action
enum ResponseEventAction {
  None,
  Success,
  Fail,
  Error,
  DeleteTodo,
  DeleteLogEntry,
}

const String logHintText = """
- Introduced to the Log Book platform
- Learnt how to use Log Book app to add my workdone
- Initial introduction to Industrial Processes
- Participated in group work with other interns,
""";

class EncryptionDatabaseCodec {
  // system wide encryption and decryption key
  // FIXME: !!!!!!! DISABLE ENCRYPTION, VERY SLOW PERFOMANCE !!!!!!!!!!!!!!!!!
  /// ------------------------------------------------------------------------
  ///    !!!!!!!            DONT CHANGE THESE KEYS !!!!!!!!!
  /// ------------------------------------------------------------------------
  static const String _encryptCodecSignature = 'encrypt';
  static const String _databasePassword = "_?w0Q3nX*ns%";
  static const String _externalFileKey = "h%Jq&Q_Z+QbViW";

  // internal encryption
  static const bool _enableEncryption = true;

  String get dbPwd => _databasePassword;
  String get dbCodec => _encryptCodecSignature;
  String get backUpKey => _externalFileKey;
  bool get encryptionEnabled => _enableEncryption;
}

/// get a random number
int randomNumber() => _random.nextInt(99999).abs() - _random.nextInt(9739);

int randomNumberSmall() => _random.nextInt(100).abs() + _random.nextInt(99);

/// token secret word
const String secretWord = 'DC';
