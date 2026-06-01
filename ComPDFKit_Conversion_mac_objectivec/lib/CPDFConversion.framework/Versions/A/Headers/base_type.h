#import <Foundation/Foundation.h>

/// \brief OCR language. When an API accepts NSArray<NSNumber *> *languages,
/// pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish), @(OCRLanguageJapanese)].
typedef NS_ENUM(NSInteger, OCRLanguage) {
    /// Unknown language
    OCRLanguageUnknown = 0,
    /// Simplified Chinese 
    OCRLanguageChinese = 1,
    /// Traditional Chinese 
    OCRLanguageChineseTraditional = 2,
    /// English
    OCRLanguageEnglish = 3,
    /// Korean
    OCRLanguageKorean = 4,
    /// Japanese
    OCRLanguageJapanese = 5,
    /// Latin 
    OCRLanguageLatin = 6,
    /// Devanagari
    OCRLanguageDevanagari = 7,
    /// Cyrillic
    OCRLanguageCyrillic = 8,
    /// Arabic
    OCRLanguageArabic = 9,
    /// Tamil
    OCRLanguageTamil = 10,
    /// Telugu 
    OCRLanguageTelugu = 11,
    /// Kannada 
    OCRLanguageKannada = 12,
    /// Thai 
    OCRLanguageThai = 13,
    /// Greek 
    OCRLanguageGreek = 14,
    /// Eslav
    OCRLanguageEslav = 15,
    /// Automatically select language 
    OCRLanguageAuto = 16
};

/// \brief Error code.
typedef NS_ENUM(NSInteger, ErrorCode) {
    /// Success, no error occurred
    ErrorCodeSuccess = 0,
    /// Conversion process was cancelled
    ErrorCodeCancel = 1,
    /// File not found or cannot be opened
    ErrorCodeFile = 2,
    /// Invalid password
    ErrorCodePDFPassword = 3,
    /// PDF page loading failed
    ErrorCodePDFPage = 4,
    /// Invalid format
    ErrorCodePDFFormat = 5,
    /// Unsupported security encryption
    ErrorCodePDFSecurity = 6,
    /// Out of memory
    ErrorCodeOutOfMemory = 7,
    /// System I/O error
    ErrorCodeIO = 8,
    /// Folder compression failed
    ErrorCodeCompress = 9,

    /// License invalid
    ErrorCodeLicenseInvalid = 20,
    /// License expired
    ErrorCodeLicenseExpire = 21,
    /// Unsupported platform
    ErrorCodeLicenseUnsupportedPlatform = 22,
    /// Unsupported application ID
    ErrorCodeLicenseUnsupportedID = 23,
    /// Unsupported device ID
    ErrorCodeLicenseUnsupportedDevice = 24,
    /// No function permission
    ErrorCodeLicensePermissionDeny = 25,
    /// License not initialized
    ErrorCodeLicenseUninitialized = 26,
    /// Illegal API access
    ErrorCodeLicenseIllegalAccess = 27,
    /// License file read failed
    ErrorCodeLicenseFileReadFailed = 28,
    /// No OCR permission
    ErrorCodeLicenseOCRPermissionDeny = 29,
    /// The current conversion concurrency exceeds the license limit
    ErrorCodeLicenseConcurrencyExceeded = 30,
    /// The current conversion pages exceed the license limit
    ErrorCodeLicensePageLimitExceeded = 31,
    /// The quota persistence file has been tampered with
    ErrorCodeLicenseQuotaCorrupted = 32,

    /// Table not found
    ErrorCodeNoTable = 40,
    /// OCR recognition failed
    ErrorCodeOCRFailure = 41,

    /// Converting
    ErrorCodeConverting = 60,

    /// Invalid argument provided.
    ErrorCodeInvalidArg = 80,

    /// The handle is invalid, possibly uninitialized or already released.
    ErrorCodeInvalidHandle = 81,

    /// The model file format is invalid or corrupted.
    ErrorCodeModelInvalidFormat = 82,

    /// The model does not support the requested function or operation.
    ErrorCodeModelFunctionUnsupported = 83,

    /// The model format is not supported by this system or SDK.
    ErrorCodeModelFormatUnsupported = 84,

    /// The model is incompatible with the current SDK version.
    ErrorCodeModelSDKMismatch = 85,

    /// The image data is empty or not provided.
    ErrorCodeImageDataEmpty = 86,

    /// The image width or height is invalid (e.g., less than or equal to zero).
    ErrorCodeImageWHError = 87,

    /// The image format is not supported (e.g., not RGB, YUV, etc.).
    ErrorCodeImageUnsupportedFormat = 88,

    /// The image is invalid or corrupted.
    ErrorCodeImageInvalid = 89,

    /// The resource (e.g., license, token) has expired.
    ErrorCodeExpire = 90,

    /// A required argument is missing.
    ErrorCodeMissingArg = 91,

    /// The current license does not support calling this API.
    ErrorCodeLicenseUnsupportedAPI = 92,

    /// The license does not match the device, module, or version.
    ErrorCodeLicenseMismatch = 93,

    /// The table data is invalid or null.
    ErrorCodeInvalidTable = 94,

    /// Unknown error
    ErrorCodeUnknown = 100
};

/// \brief Page layout mode.
typedef NS_ENUM(NSInteger, PageLayoutMode) {
    /// Box layout
    PageLayoutModeBox,
    /// Flow layout
    PageLayoutModeFlow
};

/// \brief Image color mode.
typedef NS_ENUM(NSInteger, ImageColorMode) {
    /// Color mode
    ImageColorModeColor,
    /// Grayscale mode
    ImageColorModeGray,
    /// Binary mode
    ImageColorModeBinary
};

/// \brief Image type.
typedef NS_ENUM(NSInteger, ImageType) {
    /// JPG format
    ImageTypeJPG,
    /// JPEG format
    ImageTypeJPEG,
    /// JPEG2 format
    ImageTypeJPEG2000,
    /// PNG format
    ImageTypePNG,
    /// BMP format
    ImageTypeBMP,
    /// TIFF format
    ImageTypeTIFF,
    /// TGA format
    ImageTypeTGA,
    /// GIF format
    ImageTypeGIF,
    /// WEBP format
    ImageTypeWEBP
};

/// \brief Excel Worksheet option.
typedef NS_ENUM(NSInteger, ExcelWorksheetOption){
    /// A worksheet to contain only one table.
    ExcelWorksheetForTable,
    /// A worksheet to contain table for PDF Page.
    ExcelWorksheetForPage,
    /// A worksheet to contain table for PDF Document.
    ExcelWorksheetForDocument
};

/// \brief Html Page option.
typedef NS_ENUM(NSInteger, htmlPageOption){
    /// Convert the entire PDF file into a single HTML file.
    HtmlOptionSinglePage,
    /// Convert the PDF file into a single HTML file with an outline for navigation at the beginning of the HTML page.
    HtmlOptionSinglePageWithBookmark,
    /// Convert the PDF file into multiple HTML files.
    HtmlOptionMultiPage,
    /// Convert the PDF file into multiple HTML files. Each HTML file corresponds to a PDF page, and users can navigate to the next HTML file via a link at the bottom of the HTML page.
    HtmlOptionMultiPageWithBookmark,
};

/// \brief OCR option.
typedef NS_ENUM(NSInteger, OCROption) {
    /// Recognize illegal characters in PDF documents.
    OCROptionInvalidCharacter,
    /// Recognize scanned pages in PDF documents.
    OCROptionScanPage,
    /// Recognize illegal characters and scanned pages in PDF documents.
    OCROptionInvalidCharacterAndScanPage,
    /// Recognize all characters on all pages.
    OCROptionAll,
};

/// \brief Convert options.
@interface ConvertOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// Whether to include tables when converting to JSON
@property (nonatomic, assign) BOOL jsonContainTable;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to export all content to Excel
@property (nonatomic, assign) BOOL excelAllContent;

/// Whether each worksheet contains only one table
@property (nonatomic, assign) ExcelWorksheetOption excelWorksheetOption;

/// Whether to save as CSV format
@property (nonatomic, assign) BOOL excelCSVFormat;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to make the text transparent in the output document.
@property (nonatomic, assign) BOOL transparentText;

/// Whether to format tables when converting to TXT
@property (nonatomic, assign) BOOL txtTableFormat;

/// Whether to enhance image paths
@property (nonatomic, assign) BOOL imagePathEnhance;

/// Image scaling ratio
@property (nonatomic, assign) float imageScaling;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to automatically create folder when exporting multiple documents.
@property (nonatomic, assign) BOOL auto_create_folder;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Specify the Html page option.
@property (nonatomic, assign) htmlPageOption htmlPageOption;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// Image color mode
@property (nonatomic, assign) ImageColorMode imageColorMode;

/// Image file type
@property (nonatomic, assign) ImageType imageType;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to Word conversion parameter object.
@interface WordOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to Excel conversion parameter object.
@interface ExcelOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to automatically create folder when exporting multiple documents.
@property (nonatomic, assign) BOOL auto_create_folder;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

/// Whether to save as CSV format
@property (nonatomic, assign) BOOL CSVFormat;

/// Whether to export all content to Excel
@property (nonatomic, assign) BOOL AllContent;

/// Whether each worksheet contains only one table
@property (nonatomic, assign) ExcelWorksheetOption excelWorksheetOption;

@end

/// \brief PDF to PPT conversion parameter object.
@interface PptOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to Html conversion parameter object.
@interface HtmlOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// html page option
@property (nonatomic, assign) htmlPageOption htmlPageOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to RTF conversion parameter object.
@interface RtfOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to Image conversion parameter object.
@interface ImageOptions : NSObject

/// Image color mode
@property (nonatomic, assign) ImageColorMode ColorMode;

/// Image file type
@property (nonatomic, assign) ImageType Type;

/// Whether to enhance image paths
@property (nonatomic, assign) BOOL PathEnhance;

/// Image scaling ratio
@property (nonatomic, assign) float Scaling;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

@end

/// \brief PDF to TXT conversion parameter object.
@interface TxtOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

/// Whether to format tables when converting to TXT
@property (nonatomic, assign) BOOL TableFormat;

@end

/// \brief PDF to Json conversion parameter object.
@interface JsonOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

/// Whether to include tables when converting to JSON
@property (nonatomic, assign) BOOL ContainTable;

@end

/// \brief PDF to SearchablePdf conversion parameter object.
@interface SearchablePdfOptions : NSObject

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to make the text transparent in the output document.
@property (nonatomic, assign) BOOL transparentText;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image; 

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to OFD conversion parameter object.
@interface OfdOptions : NSObject

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to make the text transparent in the output document.
@property (nonatomic, assign) BOOL transparentText;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to contain page background images when converting,which takes effect only when enable_ocr is true.
@property (nonatomic, assign) BOOL contain_page_background_image;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

/// \brief PDF to Markdown conversion parameter object.
@interface MarkdownOptions : NSObject

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// whether to output one document per page.
@property (nonatomic, assign) BOOL output_document_per_page;

/// OCR option scope
@property (nonatomic, assign) OCROption ocrOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Specify the font name to convert, e.g. @"Arial".
@property (nonatomic, copy) NSString *fontName;

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to enable AI table recognition during conversion
@property (nonatomic, assign) BOOL enableAITableRecognition;

/// OCR languages for the current task. Pass boxed OCRLanguage values, for example @[@(OCRLanguageEnglish)].
@property (nonatomic, copy) NSArray<NSNumber *> *languages;

@end

