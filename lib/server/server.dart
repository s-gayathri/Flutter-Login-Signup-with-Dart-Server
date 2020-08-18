import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    3000,
  );
  print('Listening on localhost:${server.port}');

  Db db = Db('mongodb://localhost:27017/prod');
  await db.open();
  DbCollection users = db.collection('users');
  DbCollection userSessions = db.collection('userSessions');

  await for (HttpRequest request in server) {
    print("Request initiated!");
    var path = request.uri.path;
    var method = request.method;
    var res = request.response;

    res.headers.set('Cache-Control', 'no-cache');

    // HOME PAGE
    if (method == 'GET' && path == '/')
      res..write('Server home page is running');

    // REGISTRATION
    if (method == 'GET' && path == '/register')
      res..write('Register Route Initiated');

    if (method == 'POST' && path == '/register') {
      var content = await utf8.decoder.bind(request).join();
      var data = jsonDecode(content) as Map;

      var name = data['name'];
      var password = data['password'];
      var email = data['email'];

      print('$name $email $password');

      var rand = Random();
      var saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
      var salt = base64.encode(saltBytes);

      var hash = hashPassword(password, salt);

      await users.save({
        'name': name,
        'email': email,
        'hash': hash,
        'salt': salt,
      });

      var session = {'email': email, 'sessionToken': Uuid().v4()};
      await userSessions.save(session);

      res.cookies.add(Cookie(
          'userToken', base64.encode(utf8.encode(json.encode(session)))));

      res.write('Created User: $name');
    }

    // AUTHENTICATION
    if (method == 'GET' && path == '/login') {
      var userTokenCookie = request.cookies
          .firstWhere((c) => c.name == 'userToken', orElse: () => null);

      if (userTokenCookie == null) {
        res.write("Not logged in.");
      } else {
        var decodedUserToken =
            json.decode(utf8.decode(base64.decode(userTokenCookie.value)));

        var count = await userSessions.count(where
            .eq('sessionToken', decodedUserToken['sessionToken'])
            .eq('email', decodedUserToken['email']));

        if (count > 0) {
          print(count);
          res.write("Already logged in. Cookie Count = $count");
        } else {
          res.headers.set('Set-Cookie', 'userToken=;Max-Age=0');
          res.write("Not logged in.");
        }
      }
    }

    if (method == 'POST' && path == '/login') {
      var content = await utf8.decoder.bind(request).join();
      var data = jsonDecode(content) as Map;

      var password = data['password'];
      var email = data['email'];
      var name = '';

      print('$email $password');

      try {
        var persistedUser = await users.findOne(where.eq('email', email));

        if (persistedUser == null)
          throw ArgumentError('Incorrect credentials entered');

        var salt = persistedUser['salt'];
        var hash = hashPassword(password, salt);

        if (hash == persistedUser['hash']) {
          var session = {'email': email, 'sessionToken': Uuid().v4()};
          await userSessions.save(session);

          res.cookies.add(Cookie(
              'userToken', base64.encode(utf8.encode(json.encode(session)))));

          await users.find(where.eq('email', email)).forEach((element) {
            name = element['name'];
          });
          res.write('User: $name logged in. Go to profile!');
        } else {
          throw ArgumentError('Incorrect credentials entered');
        }
      } catch (e) {
        res
          ..statusCode = HttpStatus.unauthorized
          ..write('Incorrect credentials entered');
      }
    }

    // END SESSION
    if (method == 'GET' && path == '/logout') {
      var userTokenCookie = request.cookies
          .firstWhere((c) => c.name == 'userToken', orElse: () => null);

      if (userTokenCookie == null) {
        // await res.redirect(Uri.parse('/login'));
        res.write("Not logged in.");
      } else {
        var decodedUserToken =
            json.decode(utf8.decode(base64.decode(userTokenCookie.value)));

        await userSessions.remove(where
            .eq('sessionToken', decodedUserToken['sessionToken'])
            .eq('email', decodedUserToken['email']));

        res.headers.set('Set-Cookie', 'userToken=;Max-Age=0');

        res.write('Logged out successfully');
      }
    }

    await res.close();
  }
}

String hashPassword(String password, String salt) {
  var key = utf8.encode(password);
  var bytes = utf8.encode(salt);

  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);
  return digest.toString();
}
