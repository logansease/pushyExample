//
//  PushNotificationService.m
//  MovieQuotes
//
//  Created by lsease on 10/15/12.
//
//

#import "PushyNotificationService.h"
#import "NSStringData+AES.h"
#import "ASIFormDataRequest.h"

@implementation PushyNotificationService

static PushyNotificationService * sharedService;

+(id)sharedService
{
    if(sharedService == nil)
    {
        sharedService = [[PushyNotificationService alloc]init];
    }
    return sharedService;
}

-(void)saveNewDevice:(NSData*)deviceId
{
    [NSThread detachNewThreadSelector:@selector(saveNewDeviceThread:) toTarget:self withObject:deviceId];
}

-(void)saveNewDeviceThread:(NSData*)deviceId
{
        
    //get the string to encode
    NSString * dataStr = [NSString stringWithFormat:@"{\"device_id\":\"%@\",\"app_id\":\"%@\"}",deviceId,  kPushyAppId];
    
    //encrypt
    NSData *data = [NSData dataWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSData * key = [NSData dataWithBytes: [[kPushyAppSecret sha256] bytes] length: kCCKeySizeAES128];
    NSData * encrypted = [data aesEncryptedDataWithKey:key];
    NSString * encodedString = [ASIHTTPRequest base64forData:encrypted];
    
    //post the values
    NSString * baseUrl = [NSString stringWithFormat:@"%@%@",kPushyBaseUrl,kSaveDevicePath];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString: baseUrl]];
    [request setPostValue:kPushyAppId forKey:@"app_id"];
    [request setPostValue:encodedString forKey:@"data"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
    }
}


@end
