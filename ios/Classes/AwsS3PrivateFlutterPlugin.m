#import "AwsS3PrivateFlutterPlugin.h"
#if __has_include(<aws_s3_private_flutter/aws_s3_private_flutter-Swift.h>)
#import <aws_s3_private_flutter/aws_s3_private_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aws_s3_private_flutter-Swift.h"
#endif

@implementation AwsS3PrivateFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwsS3PrivateFlutterPlugin registerWithRegistrar:registrar];
}
@end
