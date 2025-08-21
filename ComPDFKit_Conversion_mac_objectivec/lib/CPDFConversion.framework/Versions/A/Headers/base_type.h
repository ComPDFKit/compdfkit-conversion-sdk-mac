#import <Foundation/Foundation.h>

/// \brief OCR language.
typedef NS_ENUM(NSInteger, OCRLanguage) {
    /// Unknown language
    OCRLanguageUnknown = 0,
    /// Simplified Chinese
    OCRLanguageChinese,
    /// Traditional Chinese
    OCRLanguageChineseTraditional,
    /// English
    OCRLanguageEnglish,
    /// Korean
    OCRLanguageKorean,
    /// Japanese
    OCRLanguageJapanese,
    /// Latin
    OCRLanguageLatin,
    /// Devanagari (Sanskrit)
    OCRLanguageDevanagari,
    /// Cyrillic.
    OCRLanguageCyrillic,
    /// Arabic.
    OCRLanguageArabic,
    /// Tamil.
    OCRLanguageTamil,
    /// Telugu.
    OCRLanguageTelugu,
    /// Kannada.
    OCRLanguageKannada,
    /// Automatically select language.
    OCRLanguageAuto
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
    ImageTypeGIF
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

/// \brief Convert options.
@interface ConvertOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

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

/// Whether to format tables when converting to TXT
@property (nonatomic, assign) BOOL txtTableFormat;

/// Whether to enhance image paths
@property (nonatomic, assign) BOOL imagePathEnhance;

/// Image scaling ratio
@property (nonatomic, assign) float imageScaling;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

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

@end

/// \brief PDF to Word conversion parameter object.
@interface WordOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

@end

/// \brief PDF to Excel conversion parameter object.
@interface ExcelOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

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

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

@end

/// \brief PDF to Html conversion parameter object.
@interface HtmlOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page layout mode
@property (nonatomic, assign) PageLayoutMode pageLayoutMode;

/// html page option
@property (nonatomic, assign) htmlPageOption htmlPageOption;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

@end

/// \brief PDF to RTF conversion parameter object.
@interface RtfOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

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

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Whether to format tables when converting to TXT
@property (nonatomic, assign) BOOL TableFormat;

@end

/// \brief PDF to Json conversion parameter object.
@interface JsonOptions : NSObject

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Whether to include tables when converting to JSON
@property (nonatomic, assign) BOOL ContainTable;

@end

/// \brief PDF to SearchablePdf conversion parameter object.
@interface SearchablePdfOptions : NSObject

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Convert formulas to images
@property (nonatomic, assign) BOOL formulaToImage;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

@end

/// \brief PDF to Markdown conversion parameter object.
@interface MarkdownOptions : NSObject

/// Whether to enable OCR
@property (nonatomic, assign) BOOL enableOCR;

/// Whether to include images (only effective when OCR is disabled)
@property (nonatomic, assign) BOOL containImage;

/// Whether to include annotations
@property (nonatomic, assign) BOOL containAnnotation;

/// Page ranges for conversion (e.g. @"1-3,5,7-9")
@property (nonatomic, copy) NSString *pageRanges;

/// Whether to remove AI content during conversion
@property (nonatomic, assign) BOOL enableAILayout;

@end

