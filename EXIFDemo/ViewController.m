//
//  ViewController.m
//  EXIFDemo
//
//  Created by huihuadeng on 15/12/1.
//  Copyright © 2015年 huihuadeng. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //查看exif信息
    NSURL *newFileUrl = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/Documents/DSC02040.JPG", NSHomeDirectory()]];
    NSString *myPath = [[NSBundle mainBundle] pathForResource:@"thumb_IMG_1357_1024" ofType:@"jpg"];
    NSURL *myURL = [NSURL fileURLWithPath:myPath];
    CGImageSourceRef mySourceRef = CGImageSourceCreateWithURL((CFURLRef)newFileUrl, NULL);
    CFDictionaryRef cfdic = CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
    NSDictionary  *myMetadata = (__bridge_transfer  NSDictionary*)cfdic;
    NSDictionary *exifDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    NSDictionary *tiffDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    NSDictionary *IPTCDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyIPTCDictionary];
    NSLog(@"exifDic properties: %@", myMetadata); //all data
    NSLog(@"IPTCDic properties: %@", IPTCDic); //all data
    float rawShutterSpeed = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] floatValue];
    int decShutterSpeed = (1 / rawShutterSpeed);
    NSLog(@"Camera %@",[tiffDic objectForKey:(NSString *)kCGImagePropertyTIFFModel]);
    NSLog(@"Focal Length %@mm",[exifDic objectForKey:(NSString *)kCGImagePropertyExifFocalLength]);
    NSLog(@"Shutter Speed %@", [NSString stringWithFormat:@"1/%d", decShutterSpeed]);
    NSLog(@"Aperture f/%@",[exifDic objectForKey:(NSString *)kCGImagePropertyExifFNumber]);
    NSNumber *ExifISOSpeed  = [[exifDic objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0];
    NSLog(@"ISO %i",[ExifISOSpeed integerValue]);
    NSLog(@"Taken %@",[exifDic objectForKey:(NSString*)kCGImagePropertyExifDateTimeDigitized]);
//    kCGImagePropertyIPTCOriginatingProgram
//    kCGImagePropertyIPTCDictionary
    //写入exif信息
    [self performSelectorInBackground:@selector(modifyMethod) withObject:nil];
}

//please have a try
- (void)modifyMethod
{
    NSString *myPath = [[NSBundle mainBundle] pathForResource:@"thumb_IMG_1357_1024" ofType:@"jpg"];
    NSURL *myURL = [NSURL fileURLWithPath:myPath];
    CGImageSourceRef mySourceRef = CGImageSourceCreateWithURL((CFURLRef)myURL, NULL);
    NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(mySourceRef, 0, NULL));
    NSMutableDictionary *dictInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    // modify dict before add
    NSMutableDictionary *exifDictInfo = [NSMutableDictionary dictionaryWithDictionary:[dictInfo valueForKey:(NSString *)kCGImagePropertyExifDictionary]];
    [exifDictInfo setValue:@"花花" forKey:(NSString*)kCGImagePropertyIPTCOriginatingProgram];
    [exifDictInfo setValue:@"1.0.2" forKey:(NSString*)kCGImagePropertyIPTCProgramVersion];
    [dictInfo setValue:exifDictInfo forKey:(NSString*)kCGImagePropertyIPTCDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(mySourceRef);
    NSURL *newFileUrl = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/Documents/DSC02040.JPG", NSHomeDirectory()]];
    CGImageDestinationRef _imageDestination = CGImageDestinationCreateWithURL((CFURLRef)newFileUrl, UTI, 1, NULL);
    CGImageDestinationAddImageFromSource(_imageDestination, mySourceRef, 0, (CFDictionaryRef)dictInfo);
    CGImageDestinationFinalize(_imageDestination);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
