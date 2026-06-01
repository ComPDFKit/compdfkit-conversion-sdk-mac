#import <Foundation/Foundation.h>
#import "base_type.h"



typedef void (^COMProgressBlock)(int current_page, int total_page);

/// Cancellation callback for long-running operations.
/// Return YES to request cancel; NO to continue.
typedef BOOL (^COMCancelBlock)(void);

@interface LibraryManager : NSObject

+ (void)initialize:(NSString *)resourcePath;
+ (ErrorCode)licenseVerify:(NSString *)license;
+ (void)setLogger:(BOOL)enableInfo enableWarning:(BOOL)enableWarning;
+ (ErrorCode)setDocumentAIModel:(NSString *)modelPath;
+ (ErrorCode)setDocumentAIModel:(NSString *)modelPath gpuId:(int)gpuId;
+ (void)setDocumentAIModelCount:(int)layoutModelCount tableModelCount:(int)tableModelCount;
+ (int)getPageCount:(NSString *)filePath 
                password:(NSString *)password;
+ (NSString *)getVersion;
+ (void)release;
+ (void)releaseDocumentAIModel;

@end