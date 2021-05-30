import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:log_book/constants.dart';
import 'package:sembast/src/api/v2/sembast.dart';

var _random = Random.secure();

/// Random bytes generator
Uint8List _randBytes(int length) {
  return Uint8List.fromList(
      List<int>.generate(length, (i) => _random.nextInt(256)));
}

Uint8List _generateEncryptPassword(String password) {
  var blob = Uint8List.fromList(md5.convert(utf8.encode(password)).bytes);
  assert(blob.length == 16);
  return blob;
}

class _EncryptEncoder extends Converter<dynamic, String> {
  final Salsa20 salsa20;

  _EncryptEncoder(this.salsa20);

  @override
  String convert(dynamic input) {
    final iv = _randBytes(8);
    final ivEncoded = base64.encode(iv);
    assert(ivEncoded.length == 12);

    final encoded =
        Encrypter(salsa20).encrypt(json.encode(input), iv: IV(iv)).base64;

    return '$ivEncoded$encoded';
  }
}

class _EncryptDecoder extends Converter<String, dynamic> {
  final Salsa20 salsa20;

  _EncryptDecoder(this.salsa20);

  @override
  dynamic convert(String input) {
    assert(input.length >= 12);
    final iv = base64.decode(input.substring(0, 12));

    input = input.substring(12);

    var decoded = json.decode(Encrypter(salsa20).decrypt64(input, iv: IV(iv)));
    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }
    return decoded;
  }
}

/// Salsa20 based Codec
class _EncryptCodec extends Codec<dynamic, String> {
  _EncryptEncoder _encoder;
  _EncryptDecoder _decoder;

  _EncryptCodec(Uint8List passwordBytes) {
    var salsa20 = Salsa20(Key(passwordBytes));
    _encoder = _EncryptEncoder(salsa20);
    _decoder = _EncryptDecoder(salsa20);
  }

  @override
  Converter<String, dynamic> get decoder => _decoder;

  @override
  Converter<dynamic, String> get encoder => _encoder;
}

/// CALL CODEC AND PASSWORD HERE
SembastCodec getEncryptSembastCodec() {
  return SembastCodec(
    signature: EncryptionDatabaseCodec().dbCodec,
    codec: _EncryptCodec(
      _generateEncryptPassword(
        EncryptionDatabaseCodec().dbPwd,
      ),
    ),
  );
}
