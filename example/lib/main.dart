import 'package:aws_s3_private_flutter/aws_s3_private_flutter.dart';
import 'package:aws_s3_private_flutter/export.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AwsS3PrivateFlutter awsS3Flutter = AwsS3PrivateFlutter(
      accessKey: 'your-access-key',
      region: 'your-region-id',
      secretKey: 'your-secret-key',
      host: 'your-access-key',

      /// note : [bucketId] is not required when you are request from web platform
      bucketId: 'your-bucket-id');
  final TextEditingController accessKey = TextEditingController();
  final TextEditingController region = TextEditingController();
  final TextEditingController secretKey = TextEditingController();
  final TextEditingController host = TextEditingController();
  final TextEditingController bucketId = TextEditingController();
  final TextEditingController url = TextEditingController();
  Response? response = Response('', 000);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AWS S3 Flutter Demo'),
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          TextField(
            controller: accessKey,
            decoration: InputDecoration(
                hintText: 'Access Key',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: secretKey,
            decoration: InputDecoration(
                hintText: 'secret Key',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: region,
            decoration: InputDecoration(
                hintText: 'Bucket Region',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: host,
            decoration: InputDecoration(
                hintText: 'Host',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: url,
            decoration: InputDecoration(
                hintText: 'Object URL',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: bucketId,
            decoration: InputDecoration(
                hintText: 'Bucket ID',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final AwsS3PrivateFlutter awsS3PrivateFlutter =
                  AwsS3PrivateFlutter(
                      region: region.text,
                      accessKey: accessKey.text,
                      secretKey: secretKey.text,
                      host: host.text,
                      bucketId: bucketId.text);
              setState(() async {
                response = await awsS3PrivateFlutter.getObjectWithSignedRequest(
                    key: url.text);
                if (response!.statusCode == 200) {
                  debugPrint('${response!.statusCode}');
                }
              });
            },
            child: Container(
                width: 100,
                height: 50,
                color: Colors.blue,
                child: const Center(
                    child: Text(
                  'Get Object',
                  style: TextStyle(color: Colors.white),
                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 300,
              width: double.maxFinite,
              color: Colors.grey.shade200,
              child: Text('Response StatusCode: ${response!.statusCode} \n'
                  'Response ContentLength: ${response!.contentLength}\n'
                  'Response Headers: ${response!.headers}\n'
                  'Response bodyBytes: ${response!.body}'),
            ),
          )
        ],
      ),
    );
  }
}
