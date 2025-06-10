#import <Cocoa/Cocoa.h>
#import "include/common.h"
#import "include/conversion.h"

typedef NS_ENUM(NSInteger, ConversionType) {
    ConversionTypeUnknown = 0,
    ConversionTypePDFToWord,
    ConversionTypePDFToExcel,
    ConversionTypePDFToHTML,
    ConversionTypePDFToText,
    ConversionTypePDFToImage,
    ConversionTypePDFToPPT,
    ConversionTypePDFToJSON,
    ConversionTypePDFToRTF,
    ConversionTypePDFToSearchablePDF,
    ConversionTypePDFToMarkdown
};

@interface ViewController : NSViewController

@property (strong) NSTextField *inputPathField;
@property (strong) NSTextField *outputPathField;
@property (strong) NSButton *chooseInputBtn;
@property (strong) NSButton *chooseOutputBtn;
@property (strong) NSPopUpButton *convertTypePopUp;
@property (strong) NSButton *startConvertBtn;
@property (strong) NSButton *cancelConvertBtn;
@property (strong) NSScrollView *logScrollView;
@property (strong) NSTextView *logTextView;
@property (strong) NSProgressIndicator *progressIndicator;

@property (strong) NSView *optionsContainerView;
@property (strong) NSButton *ocrCheckBox;
@property (strong) NSButton *containImageCheckBox;
@property (strong) NSButton *containAnnotationCheckBox;
@property (strong) NSButton *enableAILayoutCheckBox;
@property (strong) NSButton *csvFormatCheckBox;
@property (strong) NSButton *allContentCheckBox;
@property (strong) NSPopUpButton *excelWorksheetOptionPopUp;
@property (strong) NSPopUpButton *htmlOptionPopUp;
@property (strong) NSButton *tableFormatCheckBox;
@property (strong) NSButton *containTableCheckBox;
@property (strong) NSButton *pathEnhanceCheckBox;
@property (strong) NSPopUpButton *pageLayoutModePopUp;
@property (strong) NSPopUpButton *imageColorModePopUp;
@property (strong) NSPopUpButton *imageTypePopUp;
@property (strong) NSTextField *scalingTextField;
@property (strong) NSTextField *pageRangesTextField;
@property (strong) NSTextField *pageRangesLabel;
@property (strong) NSButton *formulaToImageCheckBox;
@property (nonatomic, strong) NSPopUpButton *ocrLanguagePopUp;

@property (nonatomic, assign) BOOL isConverting;

@property (nonatomic, copy) NSString *selectedInputFile;
@property (nonatomic, copy) NSString *outputDirectoryPath;
@property (nonatomic, assign) ConversionType selectedConversionType;

- (void)performSingleFileConversion:(NSString *)inputFilePath outputDirectory:(NSString *)outputDirPath;
- (NSString *)conversionTypeToString:(ConversionType)type;

@end