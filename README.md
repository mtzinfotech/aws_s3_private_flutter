# AWS S3 Flutter

This plugin developed to make it easy to get object from AWS S3 without writing Android, IOS, and
Web code separately using method channel.

## 🌟 Installing

```yaml
dependencies:
  ...
  aws_s3_private_flutter: <latest_version>
```

## ⚡️ Import

```dart
import 'package:aws_s3_private_flutter/aws_s3_private_flutter.dart';
```

## Screen Shot

<img src="https://github.com/mtzinfotech/aws_s3_private_flutter/blob/main/images/screen_shot_1.JPEG" alt="alt text" width="300" height="620">
<img src="https://github.com/mtzinfotech/aws_s3_private_flutter/blob/main/images/screen_shot_2.JPEG" alt="alt text" width="300" height="620">

| Platform  | Android |  IOS  |  Web  |
|-----------|---------|-------|-------|
| Supported |    ✅️️   |   ✅️  |  ✅️   |

## Available Parameters

```dart
final String _secretKey;
final String _accessKey;
final String _host;
final String _region;
final String? _bucketId;
final String? _sessionToken;
static const _service = "s3";

/// Creates a new AwsS3Client instance.
/// @param [secretKey] The secret key. Required. see https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
/// @param [accessKey] The access key. Required. see https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
/// @param [bucketId] The bucket. Required. See https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html#access-bucket-intro
/// @param [host] The host, in path-style. Defaults to "s3.$region.amazonaws.com". See https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html#access-bucket-intro
/// @param [region] The region of the bucket. Required.
/// @param [sessionToken] The session token. Optional.
/// @param [bucketId] is not required if buckedId is already available in your [host].
AwsS3PrivateFlutter({required String secretKey,
  required String accessKey,
  required String? bucketId,
  required String host,
  required String region,
  String? sessionToken});
```

| Parameter      | Datatype | Initial Value | Required |
|----------------|----------|---------------|----------|
| _secretKey     | String   | null          | Yes      |
| _accessKey     | String   | null          | Yes      |
| _host          | String   | null          | Yes      |
| _region        | String   | null          | Yes      |
| _bucketId      | String   | null          | No       |
| _sessionToken  | String   | null          | No       |

# Example

```dart

var url = 'bucket-folder/object-name.extension';

final AwsS3PrivateFlutter awsS3PrivateFlutter = AwsS3PrivateFlutter(
    accessKey: 'your-access-key',
    secretKey: 'your-secret-key',
    region: 'your-region-here',
    /// example host: '[bucket-id].s3.[region].amazonaws.com' 
    host: 'your-host-here',
    /// [bucketId] is not required if bucketId is already available in your [host].
    bucketId: 'your-bucket-id');

getObject() async {
  Response res = await awsS3PrivateFlutter.getObjectWithSignedRequest(key: url);
}
```

# Contributions

If you encounter any problem or the library is missing a feature feel free to open an issue. Feel
free to fork, improve the package and make pull request.

# MTZ INFOTECH

<a href="https://in.linkedin.com/company/mtzinfotech"><img src="https://github.com/aritraroy/social-icons/blob/master/linkedin-icon.png?raw=true" width="60"></a>
