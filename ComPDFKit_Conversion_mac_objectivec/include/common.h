#import <Foundation/Foundation.h>
#import "base_type.h"



typedef void (^COMProgressBlock)(int current_page, int total_page);

@interface LibraryManager : NSObject

+ (void)initialize:(NSString *)resourcePath;
+ (ErrorCode)licenseVerify:(NSString *)license;
+ (void)setProgress:(COMProgressBlock)handler isMT:(BOOL)isMT;
+ (int)setDocumentAIModel:(NSString *)modelPath
            ocrLanguages:(NSArray<NSNumber *> *)languages;
+ (void)setOCRLanguage:(NSArray<NSNumber *> *)languages;
+ (int)getPageCount:(NSString *)filePath 
                password:(NSString *)password;
+ (NSString *)getVersion;
+ (void)release;
+ (void)releaseDocumentAIModel;

@end