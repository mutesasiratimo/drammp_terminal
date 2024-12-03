import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis_auth/googleapis_auth.dart';

class AccessFirebaseToken {
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "spesho-entebbe-drammp",
          "private_key_id": "75684b9c9a97aae49e9bdda587718d8e32bb28ed",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDKY0Jjx5Bt7CEi\nwQoklzFtskoGgSJhIE+FF1vAs0DD0QCJsc/l6GfDB4shwHAA33viu8qoEK/Lnp/t\nsr/+bjS1BwKCRBgf1/3iZBBSSkrzAuzvYxMgGkOYRrF++rFApSM4fvN0nnsXRsna\nJFHOMmgL5ehLRsGBE81nSIQ95iwQEk8pWhen56WIjR4AEnTHbrbzISbD6gWjz7Mw\nzBfz5vEtZU7nsnL4sUDf8aS58bOvvUR8mZgkxGztfyJqvgeq+bP1yI8QW6FODb5b\nasjLx+TLG4umEsLj8XqLdyTgxymQSl5Wv414Q3CXj4Zo9nEnWici7CXxhKjZiAbX\nhVskwzS9AgMBAAECggEAC1A8JFbCCJsECSzQU9ZN0Yt/Xti2IsbLGy4Al4eNrcSP\nqqLRc9Enh7vyt5rJyAq2IqkLvZRdN10xJHjzCZaAhMQVDFIhJRqOWyrrzKXRhb8a\nnpEjvw4ozCjbgDUkVnBExUI3esPnLphq7TJNjmC79zpNX3PfmkcQmt7vYYRt3yIF\nW+KBhVp+9lk0T8uJ0wsZETphdHLH1MHG66eVcUVurNszJScwYzmnKuDMrlG8QwU5\n9FnpsMvJf8ICZSfANJus6Z+6AihE6ZcpUpkFiXWIAizMF6B2qEyEZZrLy8MxfwOL\nG0ShbPcQZSgOb9s7XtmAfW+E8Sb0v1jlc7iWpi9MwwKBgQD1xUjTRWZrXGCbOPXR\nK91rgHwdAyrDq3uVbu9mLRjLzLhct8f5um03IxWCYerGcqpWaV4JuZ9P/taCvYvJ\n56TrXCzIn8hqF3aTTOZkjnqm1oy0kJj8TaKkl4TsOPm4R2yUcqFO9uX1Mi5rDIUN\nJGlo0K1yjSSd4qW52nqp6MEMYwKBgQDSz7mKjXqaBZba0yQ2arFla3xbI28fV7SJ\nRSneVZNqtkAlI48axgCCCA0vTEsWagG06LiH+aD8riASBXFQ/U3CZRXGGTUejlFd\nmIDRfvKlkhzZgABpa7Rs6r5g3dHBxS1xFrGRyzo88bLkpv3UpmUsGtSiOZTpt0jT\nmeqOqQ60XwKBgBb89wzb5vKP13FtaIDCK5nMkM9d5nga6BpYIAhcm38kjPIPNqND\nLsgDfhWN9xnMy+X9QRCDzkT7PzFHbXXbNu/U1VOGroZN34dzn/Ez6oEEfHC/PbAL\nyvS+P26g/aqg86UG+9OZAHVo1jKpHyDVkQ5+xlp6nTwvYPT7XJHb9YKlAoGASyhd\nyOTZ0fGuL8PZBEGTj0n74u5GHtGA/vOWkrrFvOTPB66exXfUFIfUU4mKt6oBg8L4\njxnTaGKX8nTYSnyUbXrmgWLZSlSI86p8OrRcw+TMvkphWzRX9gDW8OgEcWXf5pKl\nqgnfcHznP5e9pUPRjCDgsBmBWrXKlA4qzsO9B1cCgYB3jyLHSnU9XXZWPmr+5quh\nP3sOFuNInhzCGpWRWwLfgBDIBKIq0Zu9vYdA3VItKRPU5kIL2RWglralHYCz8/bs\n5R/GzMfGG9IKW3iMoCnkdsgwqzuDPWBh4wxjiqdl2U1vXJ+PkqYH61iX/ww8Eart\naYC9Ci3IH7IE3O/8vH8YNg==\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-j1nvj@spesho-entebbe-drammp.iam.gserviceaccount.com",
          "client_id": "109093096299417058966",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-j1nvj%40spesho-entebbe-drammp.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [firebaseMessagingScope]);
    final accessToken = client.credentials.accessToken.data;

    debugPrint(
        "+++++++++++++++++++++++++++ FIREBASE TOKEN ${accessToken.toString()}");
    return accessToken;
  }
}
