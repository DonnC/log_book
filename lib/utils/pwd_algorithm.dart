import 'dart:convert';

import 'dart:math';

/// token generator class
///
/// generate token for word HATCHPRO or any
/// the less the word count the lesser the token length
///
/*
  DonnC Lab

  12 May 2021

  an algorithm to make a random number that validates to HATCHPRO as a password
  each letter in the alphabet corresponds to a position in the alphabet
  each entered number corresponds to that letter when substracted by a certain number at a particular index

  A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z 
  0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25

  10 - 3 = 7 [H]
  8 - 1  = 7 [H]

  logic:
    1. Generate a random number -> X
    2. Add 7 to X -> where H is (correspondingly where all required letters are, [0 -> A, 19 -> T..])
    3. From there, you have a pair -> Y
    4. pair generated as (X, Y) -> required number XY

  after getting first pair, write first digit on first index, next digit tells the index of the second paired digit

  e.g

  10, 3 -> 7 [H]

  will be represented as 
  10 | 3 | .. | .. | .. | 7 | .. | ..

  10 -> first pair digit, 
  3 -> next is at index 3 from the first pair (determined & placed randomly)
  [3] index 3 -> 7 - other index pair, second digit of first pair..
  .. and so on

  -- UPDATE --
  Use equivalent ascii numbers of each letter, generate a 2 digit pair that equals the ascii number
  A - 65
  (XX, YY) -> XX - YY = 65 (A)

  Add all secret word asciis as total number e.g 601
  generate a random number as divider (to minimize total ascii number)
  determine if total is odd | even and divide by corresponding type (to avoid reminders)
  save the random divider and the answer
  append on first position (the string of generated pairs) the index of where the divider is
  second from first index is the number of digits of the divider
  e.g if total is 200 (even) -> divider is 10 (generated) -> answer is 20
  
  >> insert 10 at random index e.g 7 (must be < 10)
  e.g string sequence is 78376837[10]3...
  7 shows index of divider [10]
  > last digit of the string sequence is always the answer [20]
  so, 10 * 20 == 200
  and double check if secret word total units are == 200 calculated
  if so, then proceed to decode the string sequence, YY - XX = answer
  look up for [answer] in indexedAlphabet or js decode to get proper word from ascii to see
  if it matches secret word
*/

class TokenGenerator {
  /// screen word, the generator encrypts and decrypts
  final String secretWord;

  /// store found paired combination
  ///
  /// using subtraction tactic, (x,y) -> x - y = index of letter in _secretWord
  List<Set> _foundPairs = [];

  /// hold concetanated pairs here
  String _concPairs = '';

  /// hold conc pairs with appended index
  String _appendIndex = '';

  /// hold conc pairs with divider and answer appended
  String _appendDivider = '';

  // pair wth answer
  String _concPairAns = '';

  //hold answer wth index, pair answer index
  String _concPAI = '';

  /// generated token
  String encryptedGeneratedToken;

  // store total code units to append to generated token
  int _totalCodeUnits = 0;

  /// generate token based on secret word
  ///
  /// max word length is 8 chars
  TokenGenerator(this.secretWord) {
    /// check word length
    if (secretWord.length > 8) {
      throw Exception('[TokenGenerator] secretWord must be less than 8 chars');
    }

    // check for valid letter / word
    if (!secretWord.contains(RegExp(r'[A-Za-z]'))) {
      throw Exception('[TokenGenerator] secretWord must contain valid letters');
    }

    // else, process token gen
    // reset variables
    _reset();

    // process here
    _processWordPairTotal();
  }

  /// do encryption process of passed secretWord
  ///
  /// returns a generated token string
  String encrypt() {
    _genEncryptedToken();

    return encryptedGeneratedToken;
  }

  /// do decryption process of passed encrypted token
  ///
  /// returns a boolean if its successful | not
  dynamic decrypt(String token) {
    try {
      String result = _decryptPassedToken(token);

      if (result.trim() == secretWord.trim()) {
        return true;
      }
    }

    // might be assertion error
    catch (e) {
      return 'Failed to decrypt. Wrong token!';
    }

    return false;
  }

  String _decryptPassedToken(String token) {
    // concPAI -> concetenated pair with answer and index [token]
    String concPAI = token;

    var chunkedToken = concPAI.split('');

    int index = int.parse(chunkedToken.first);

    int dividerLength = int.parse(chunkedToken[1]);

    // a quick check
    var divider = concPAI.substring(index, index + dividerLength);

    var lenOfAns = concPAI.split('').last;

    // get ans
    var ans = concPAI.substring(
        (concPAI.length - int.parse(lenOfAns)) - 1, concPAI.length - 1);

    // mulitply to check it equals to word
    var _confirmedAnswer = int.parse(ans) * int.parse(divider);

    //print('== confirmed answer: $_confirmedAnswer | calc: $_totalCodeUnits');
    assert(_totalCodeUnits == _confirmedAnswer);

    if (_totalCodeUnits != _confirmedAnswer) {
      throw Exception();
    }

    //  remove answer
    var rAns = concPAI.replaceRange(
        (concPAI.length - int.parse(lenOfAns)) - 1, concPAI.length - 1, '');

    // remove answer index
    var raI = rAns.replaceFirst(RegExp(r'\d$', multiLine: true), '');

    // remove inserted divider
    var riD = raI.replaceRange(index, index + dividerLength, '');

    // remove all added numbers
    // remove inserted generated index
    var genIndexR = riD.replaceFirst(RegExp(r'\d'), '');

    // remove index of divider
    var iodR = genIndexR.replaceFirst(RegExp(r'\d'), '');

    var chunks = iodR.split('');

    // numbers are always pairs, therefore len is even
    int indexFetchF = 0;
    int indexFetchL = 2;

    // numbers are list of strings, pair them in order to add them
    // easier this way, might find a better way later
    List gluedPair = [];

    while (indexFetchL <= chunks.length) {
      // get a pair at current index
      gluedPair.add(chunks.getRange(indexFetchF, indexFetchL));
      indexFetchF += 2;
      indexFetchL += 2;
    }

    // add all glued pairs as a single integer
    List<int> asciiNum = [];

    gluedPair.forEach((explodedNumber) {
      Iterable<String> eNum = explodedNumber;
      String gluedNum = eNum.first + eNum.last;
      asciiNum.add(int.parse(gluedNum));
    });

    // numbers are always pairs, therfore len is even
    // glue items togethr to form original pair
    int indexFetchX = 0;
    int indexFetchY = 2;

    List<Iterable<int>> combinationPair = [];

    while (indexFetchY <= asciiNum.length) {
      // get a pair at current index
      combinationPair.add(asciiNum.getRange(indexFetchX, indexFetchY));
      indexFetchX += 2;
      indexFetchY += 2;
    }

    // store, decrypted original ascii code units
    // to verify with secretWord
    List<int> asciiRunes = [];

    combinationPair.forEach((xyPair) {
      int asciiCodeUnit = xyPair.last - xyPair.first;
      asciiRunes.add(asciiCodeUnit);
    });

    // try decoding
    String decryptedWord = ascii.decode(asciiRunes);

    return decryptedWord;
  }

  /// generate a random index number to place divider
  ///
  /// must be < 10 (a single digit number)
  int _indexGen() {
    final randomizer = Random();

    // add 2 to avoid placing divider at index 2
    // where length of divider is always on
    int _genIndex = 2 + randomizer.nextInt(8);

    return _genIndex;
  }

  /// generate a divider to divide the total code units
  ///
  /// into small number
  ///
  /// divider will have no reminder so will derive total type first (odd | even)
  int _dividerGen() {
    int total = _totalCodeUnits;

    final randomizer = Random();

    bool isEven = total.isEven;

    //print('=== isEven: $isEven | isOdd; ${total.isOdd} ===');

    // maximum divider len of digits <= 3
    int divider = 0;

    bool foundDivider = false;

    if (isEven) {
      // find an even number as divider too, less than total

      while (!foundDivider) {
        divider = 1 + randomizer.nextInt(100);

        // check if divider is even
        try {
          assert(divider.isEven == true);
          assert(divider < total);

          // if multiplied back, it should equal total
          int answer = total ~/ divider;

          //print('=== divider: $divider | answer is: $answer | mul back: ${answer * divider}');

          int check = (answer * divider).toInt();

          if (check == total) {
            //print('=== FOUND check: $check | total: $total ===');
            foundDivider = true;
          }

          //
          else {
            //print('=== check: $check | total: $total ===');
          }
        }

        // try again
        catch (e) {
          divider = 0;
          //print('retrying: ${e.toString()}..');
        }
      }

      //print('=== even divider: $divider');

      // divider found
      return divider;
    }

    // check for odd divider
    else {
      // find an odd number as divider too, less than total

      while (!foundDivider) {
        divider = 1 + randomizer.nextInt(total);

        // check if divider is odd
        try {
          assert(divider.isOdd == true);
          assert(divider < total);

          // if multiplied back, it should equal total
          int answer = total ~/ divider;

          //print('=== divider: $divider | answer is: $answer | mul back: ${answer * divider}');

          int check = (answer * divider).toInt();

          if (check == total) {
            //print('=== FOUND check: $check | total: $total ===');
            foundDivider = true;
          }

          //
          else {
            //print('=== check: $check | total: $total ===');
          }
        }

        // try again
        catch (e) {
          divider = 0;
          //print('retrying: ${e.toString()}..');
        }
      }

      //print('=== odd divider: $divider');

      // divider found
      return divider;
    }
  }

  // reset variables
  void _reset() {
    this._foundPairs = [];
    this._concPairs = '';
    this._concPairAns = '';
    this._concPAI = '';
    this._appendIndex = '';
    this._appendDivider = '';
    this._totalCodeUnits = 0;
  }

  /// process init
  void _processWordPairTotal() {
    // perform clean up
    _reset();

    secretWord.codeUnits.forEach((element) {
      var pair = _randomPairGen(element);
      //print('== answer: $element | pair: $pair ==');
      _foundPairs.add(pair);
      _totalCodeUnits += element;
    });
  }

  /// perform all process word manipulation here
  ///
  /// and encrypt token based on word given
  void _genEncryptedToken() {
    /// add pairs to string, consecutively
    _foundPairs.forEach((pair) {
      _concPairs += '${pair.first}${pair.last}';
    });

    int index = _indexGen();

    int divider = _dividerGen();

    // insert index of divider
    var splittedCP = _concPairs.split('');
    splittedCP.insert(0, index.toString());

    // insert length of divider at second index
    splittedCP.insert(1, divider.toString().length.toString());

    // conc back with index appended
    splittedCP.forEach((element) {
      _appendIndex += element;
    });

    // append answer on the end
    int answer = _totalCodeUnits ~/ divider;

    // insert divider at index generated
    var splittedIndP = _appendIndex.split('');
    splittedIndP.insert(index, divider.toString());

    // conc back with divider inserted at gen index appended
    splittedIndP.forEach((element) {
      _appendDivider += element;
    });

    // append length of answer to the end
    _appendDivider += answer.toString().length.toString();

    _concPairAns += _appendDivider;

    var splittedCPA = _concPairAns.split('');

    // append answer, second from last whr answer index is
    splittedCPA.insert(_concPairAns.length - 1, answer.toString());

    splittedCPA.forEach((element) {
      _concPAI += element;
    });

    encryptedGeneratedToken = _concPAI;
  }

  /// generate a random pair, that when subtracted
  ///
  /// will yield [answer]
  Set _randomPairGen(int answer) {
    final randomizer = Random();

    /// signal when pair is found
    bool pairFound = false;

    /// first of the pair -> X, X - Y
    int firstNum = 0;

    /// second num -> Y
    int secondNumGuess = 0;

    /// X - Y = answer
    /// X + answer = Y

    while (!pairFound) {
      // only 2 digits
      while (firstNum < 10 || firstNum > 99) {
        firstNum = randomizer.nextInt(99);
        //print(' ==> iteration found number: $firstNum');
      }

      //print('==== found =====');
      //print(firstNum);

      secondNumGuess = firstNum + answer;

      //print(' ==> second guessed number: $secondNumGuess');

      /// only consider 2 digits number
      if (secondNumGuess < 99) {
        //if (firstNum - secondNumGuess == answer) {
        try {
          // perform proof check
          assert(secondNumGuess - firstNum == answer);
          pairFound = true;
        }

        /// retry on assertion error
        catch (e) {
          firstNum = 0;
        }
      }

      // else, re-iterate
      else {
        firstNum = 0;
      }
    }

    // pair should be found by now
    var pair = [firstNum, secondNumGuess];

    // (X, Y)
    return pair.toSet();
  }
}

/// an indexed alphabet
///
/// A-Z -> 0-25
class IndexedAlphabet {
  final String letter;
  final int codeUnit;
  final int index;

  IndexedAlphabet({
    this.letter,
    this.index,
    this.codeUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'codeUnit': codeUnit,
      'letter': letter,
      'index': index,
    };
  }

  factory IndexedAlphabet.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return IndexedAlphabet(
      letter: map['letter'] ?? '',
      index: map['index'] ?? 0,
      codeUnit: map['codeUnit'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IndexedAlphabet(letter: $letter, index: $index, codeUnit: $codeUnit)';

  static List<IndexedAlphabet> get indexedAlphabet {
    final _alphabet = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ];

    return _alphabet
        .map(
          (letter) => IndexedAlphabet(
            letter: letter,
            codeUnit: letter.codeUnits.first,
            index: _alphabet.indexOf(letter),
          ),
        )
        .toList();
  }
}
