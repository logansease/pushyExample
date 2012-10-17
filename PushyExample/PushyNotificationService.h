//
//  PushNotificationService.h
//  MovieQuotes
//
//  Created by lsease on 10/15/12.
//
//

#import <Foundation/Foundation.h>
#define kPushyAppId      @"your id here"
#define kPushyAppSecret  @"your secret key here"

#define kCCKeySizeAES128	 16
#define kPushyBaseUrl     @"http://pushyapi.com/"
#define kSaveDevicePath          @"api/register_push"

@interface PushyNotificationService : NSObject

+(id)sharedService;
-(void)saveNewDevice:(NSData*)deviceId;

@end
