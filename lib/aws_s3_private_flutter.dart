import 'export.dart';

const _awsSHA256 = 'AWS4-HMAC-SHA256';
const _aws4Request = 'aws4_request';
const _aws4 = 'AWS4';

class AwsS3PrivateFlutter {
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
  /// @param [bucketId] The bucketId is not required for web request.
  AwsS3PrivateFlutter(
      {required String secretKey,
      required String accessKey,
      String? bucketId,
      required String? host,
      required String region,
      String? sessionToken})
      : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host ?? "s3.$region.amazonaws.com",
        _bucketId = bucketId,
        _region = region,
        _sessionToken = sessionToken;

  _SignedRequestParams _buildSignedGetParams(
      {required String key, Map<String, String>? queryParams}) {
    final unEncodedPath =
        (_bucketId != null || _bucketId!.isNotEmpty) ? "$_bucketId/$key" : key;
    final uri = Uri.https(_host, unEncodedPath, queryParams);
    final payload = _SigV4._hashCanonicalRequest('');
    final datetime = _SigV4._generateDatetime();
    final credentialScope =
        _SigV4._buildCredentialScope(datetime, _region, _service);
    final canonicalQuery = _SigV4._buildCanonicalQueryString(queryParams);
    final canonicalRequest = '''GET
${'/$unEncodedPath'.split('/').map(Uri.encodeComponent).join('/')}
$canonicalQuery
host:$_host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${_sessionToken ?? ""}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';

    final stringToSign = _SigV4._buildStringToSign(datetime, credentialScope,
        _SigV4._hashCanonicalRequest(canonicalRequest));
    final signingKey =
        _SigV4._calculateSigningKey(_secretKey, datetime, _region, _service);
    final signature = _SigV4._calculateSignature(signingKey, stringToSign);

    final authorization = [
      'AWS4-HMAC-SHA256 Credential=$_accessKey/$credentialScope',
      'SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token',
      'Signature=$signature',
    ].join(',');

    return _SignedRequestParams(uri, {
      'Authorization': authorization,
      'x-amz-content-sha256': payload,
      'x-amz-date': datetime,
      'Access-Control-Allow-Origin': "*"
    });
  }

  Future? getObjectWithSignedRequest({
    required String key,
    Map<String, String>? queryParams,
  }) async {
    final _SignedRequestParams params = _buildSignedGetParams(key: key);
    return _apiCall(url: params.uri, headers: params.headers);
  }

  Future? _apiCall({url, headers}) async {
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      return response;
    }
  }
}

class _SignedRequestParams {
  final Uri uri;
  final Map<String, String> headers;

  const _SignedRequestParams(this.uri, this.headers);
}

class _SigV4 {
  static String _generateDatetime() {
    return DateTime.now()
        .toUtc()
        .toString()
        .replaceAll(RegExp(r'\.\d*Z$'), 'Z')
        .replaceAll(RegExp(r'[:-]|\.\d{3}'), '')
        .split(' ')
        .join('T');
  }

  static List<int> _hash(List<int> value) {
    return sha256.convert(value).bytes;
  }

  static String _hexEncode(List<int> value) {
    return hex.encode(value);
  }

  static List<int> _sign(List<int> key, String message) {
    final hmac = Hmac(sha256, key);
    final dig = hmac.convert(utf8.encode(message));
    return dig.bytes;
  }

  static String _hashCanonicalRequest(String request) {
    return _hexEncode(_hash(utf8.encode(request)));
  }

  static String _buildCanonicalQueryString(Map<String, String>? queryParams) {
    if (queryParams == null) {
      return '';
    }

    final sortedQueryParams = [];
    queryParams.forEach((key, value) {
      sortedQueryParams.add(key);
    });
    sortedQueryParams.sort();

    final canonicalQueryStrings = [];
    for (var key in sortedQueryParams) {
      canonicalQueryStrings.add(
          '$key=${Uri.encodeQueryComponent(queryParams[key]!).replaceAll('+', "%20")}');
    }

    return canonicalQueryStrings.join('&');
  }

  static String _buildStringToSign(String datetime, String? credentialScope,
      String? hashedCanonicalRequest) {
    return '$_awsSHA256\n$datetime\n$credentialScope\n$hashedCanonicalRequest';
  }

  static String _buildCredentialScope(
      String datetime, String region, String service) {
    return '${datetime.substring(0, 8)}/$region/$service/$_aws4Request';
  }

  static List<int> _calculateSigningKey(
      String secretKey, String datetime, String region, String service) {
    return _sign(
        _sign(
            _sign(
                _sign(
                    utf8.encode('$_aws4$secretKey'), datetime.substring(0, 8)),
                region),
            service),
        _aws4Request);
  }

  static String _calculateSignature(List<int> signingKey, String stringToSign) {
    return _hexEncode(_sign(signingKey, stringToSign));
  }
}
