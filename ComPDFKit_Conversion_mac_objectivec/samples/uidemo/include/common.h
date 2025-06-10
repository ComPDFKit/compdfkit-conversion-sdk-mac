#import <Foundation/Foundation.h>
#import "base_type.h"

/**
 * Progress callback Block.
 * @param current_page The current page being processed.
 * @param total_page The total number of pages.

 * The `LibraryManager` class serves as a central hub for managing the lifecycle of an SDK library. It provides
 * functionalities such as initializing the library with specified resources, verifying licenses, installing fonts,
 * setting up logging and progress callbacks, retrieving version information, and counting pages in documents.
 */
typedef void (^COMProgressBlock)(int current_page, int total_page);

/**
 * @class LibraryManager
 * @brief Manages all operations related to the SDK library.
 */
@interface LibraryManager : NSObject

/**
 * Initialize the SDK.
 * @param resourcePath The resource file path for the SDK.
 */
+ (void)initialize:(NSString *)resourcePath;

/**
 * Verify the SDK license.
 * @param license License string.
 * @param deviceId Unique device identifier.
 * @param appId Application identifier.
 * @return Error code, 0 for success.
 */
+ (ErrorCode)licenseVerify:(NSString *)license;

/**
 * Set the progress callback.
 * @param handler Progress callback block.
 * @param isMT Whether to use multithreading.
 */
+ (void)setProgress:(COMProgressBlock)handler isMT:(BOOL)isMT;

/**
 * Set the Document AI model.
 * @param modelPath Model file path.
 * @param ocrLanguage OCR recognition language.
 * @return Error code, 0 for success.
 */
+ (int)setDocumentAIModel:(NSString *)modelPath 
             ocrLanguage:(OCRLanguage)language;

/**
 * Set the OCR recognition language.
 * @param language OCR recognition language.
 */
+ (void)setOCRLanguage:(OCRLanguage)language;

/**
 * Get the number of pages in the document.
 * @param filePath File path.
 * @param password Password required to open the document (if any).
 * @return Total number of pages in the document.
 */
+ (int)getPageCount:(NSString *)filePath 
                password:(NSString *)password;

/**
 * Get the SDK version number.
 * @return Version string.
 */
+ (NSString *)getVersion;

/**
 * Release SDK resources.
 */
+ (void)release;

@end