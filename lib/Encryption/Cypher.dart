import 'package:steel_crypt/steel_crypt.dart';


var key = 'EjRWeJCrze8SNFZ4kKvN7w==';
var iv = '/ty6CYdlQyH+3LoJh2VDIQ==';


String encryptData(String plainText) {
  var cypher = AesCrypt(key: key, padding: PaddingAES.pkcs7);
  return cypher.cbc.encrypt(inp: plainText, iv: iv);
}

String decryptData(String cipher) {
  var cypher = AesCrypt(key: key, padding: PaddingAES.pkcs7);
  return cypher.cbc.decrypt(enc: cipher, iv: iv);
}
