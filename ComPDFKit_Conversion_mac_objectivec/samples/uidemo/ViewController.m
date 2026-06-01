#import "ViewController.h"
#include <objc/NSObjCRuntime.h>
#include <AppKit/AppKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ViewController ()

@property (atomic, assign) BOOL conversionCancelRequested;
@property (atomic, assign) BOOL isBatchConverting;

@end

@implementation ViewController

static const CGFloat kDemoViewWidth = 720.0;
static const CGFloat kDemoViewHeight = 900.0;
static const CGFloat kOptionsContainerTop = 720.0;
static const CGFloat kOptionsContainerBottom = 260.0;

- (void)loadView {
    NSRect frame = NSMakeRect(0, 0, kDemoViewWidth, kDemoViewHeight);
    NSView *view = [[NSView alloc] initWithFrame:frame];
    self.view = view;
    
    [self setupUI];
}

- (void)setupUI {
    self.inputPathField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 850, 500, 28)];
    self.inputPathField.placeholderString = @"Input Path";
    self.inputPathField.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
    [self.view addSubview:self.inputPathField];
    
    self.chooseInputBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 850, 140, 28)];
    [self.chooseInputBtn setTitle:@"Choose File"];
    [self.chooseInputBtn setBezelStyle:NSBezelStyleRounded];
    [self.chooseInputBtn setTarget:self];
    [self.chooseInputBtn setAction:@selector(chooseInput:)];
    self.chooseInputBtn.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [self.view addSubview:self.chooseInputBtn];

    self.outputPathField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 810, 500, 28)];
    self.outputPathField.placeholderString = @"Output Directory";
    self.outputPathField.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
    [self.view addSubview:self.outputPathField];
    
    self.chooseOutputBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 810, 140, 28)];
    [self.chooseOutputBtn setTitle:@"Choose Directory"];
    [self.chooseOutputBtn setBezelStyle:NSBezelStyleRounded];
    [self.chooseOutputBtn setTarget:self];
    [self.chooseOutputBtn setAction:@selector(chooseOutput:)];
    self.chooseOutputBtn.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [self.view addSubview:self.chooseOutputBtn];
    
    self.convertTypePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(20, 770, 220, 28)];
    [self.convertTypePopUp addItemWithTitle:@"Word"];
    [self.convertTypePopUp addItemWithTitle:@"Excel"];
    [self.convertTypePopUp addItemWithTitle:@"PPT"];
    [self.convertTypePopUp addItemWithTitle:@"HTML"];
    [self.convertTypePopUp addItemWithTitle:@"RTF"];
    [self.convertTypePopUp addItemWithTitle:@"Image"];
    [self.convertTypePopUp addItemWithTitle:@"TXT"];
    [self.convertTypePopUp addItemWithTitle:@"JSON"];
    [self.convertTypePopUp addItemWithTitle:@"Searchable PDF"];
    [self.convertTypePopUp addItemWithTitle:@"OFD"];
    [self.convertTypePopUp addItemWithTitle:@"Markdown"];
    [self.convertTypePopUp setTarget:self];
    [self.convertTypePopUp setAction:@selector(conversionTypeChanged:)];
    self.convertTypePopUp.autoresizingMask = NSViewMaxXMargin | NSViewMinYMargin;
    [self.view addSubview:self.convertTypePopUp];
    
    self.startConvertBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 770, 140, 28)];
    [self.startConvertBtn setTitle:@"Start Convert"];
    [self.startConvertBtn setBezelStyle:NSBezelStyleRounded];
    [self.startConvertBtn setTarget:self];
    [self.startConvertBtn setAction:@selector(startConvert:)];
    self.startConvertBtn.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [self.view addSubview:self.startConvertBtn];
    
    self.cancelConvertBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 730, 140, 28)];
    [self.cancelConvertBtn setTitle:@"Cancel Convert"];
    [self.cancelConvertBtn setBezelStyle:NSBezelStyleRounded];
    [self.cancelConvertBtn setTarget:self];
    [self.cancelConvertBtn setAction:@selector(cancelConvert:)];
    [self.cancelConvertBtn setEnabled:NO];
    self.cancelConvertBtn.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [self.view addSubview:self.cancelConvertBtn];
    
    self.logScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(20, 20, 680, 180)];
    self.logScrollView.hasVerticalScroller = YES;
    self.logScrollView.hasHorizontalScroller = NO;
    self.logScrollView.autohidesScrollers = YES;
    self.logScrollView.borderType = NSBezelBorder;
    self.logScrollView.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;
    
    self.logTextView = [[NSTextView alloc] initWithFrame:[[self.logScrollView contentView] bounds]];
    self.logTextView.minSize = NSMakeSize(0.0, 0.0);
    self.logTextView.maxSize = NSMakeSize(FLT_MAX, FLT_MAX);
    self.logTextView.verticallyResizable = YES;
    self.logTextView.horizontallyResizable = NO;
    self.logTextView.autoresizingMask = NSViewWidthSizable;
    self.logTextView.textContainer.containerSize = NSMakeSize(self.logScrollView.contentSize.width, FLT_MAX);
    self.logTextView.textContainer.widthTracksTextView = YES;
    self.logTextView.editable = NO;
    
    self.logTextView.font = [NSFont fontWithName:@"Menlo" size:12];
    
    [self.logScrollView setDocumentView:self.logTextView];
    [self.view addSubview:self.logScrollView];
    
    self.optionsContainerView = [[NSView alloc] initWithFrame:NSMakeRect(20, kOptionsContainerBottom, 680, kOptionsContainerTop - kOptionsContainerBottom)];
    self.optionsContainerView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:self.optionsContainerView positioned:NSWindowBelow relativeTo:self.convertTypePopUp];
    
    CGFloat baseY = 440;
    CGFloat stepY = 44;
    CGFloat labelWidth = 120;
    CGFloat fieldWidth = 200;
    CGFloat fieldHeight = 28;
    CGFloat labelX = 20;
    CGFloat fieldX = 150;
    CGFloat rightLabelX = 380;
    CGFloat rightFieldX = 510;
    

    self.pageRangesLabel = [[NSTextField alloc] initWithFrame:NSZeroRect]; 
    [self.pageRangesLabel setBezeled:NO];
    [self.pageRangesLabel setDrawsBackground:NO];
    [self.pageRangesLabel setEditable:NO];
    [self.pageRangesLabel setSelectable:NO];
    [self.pageRangesLabel setStringValue:@"Page Ranges:"]; 

    self.pageRangesTextField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    self.pageRangesTextField.stringValue = @"";

    self.ocrCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 240, 200, 20)];
    [self.ocrCheckBox setButtonType:NSButtonTypeSwitch];
    [self.ocrCheckBox setTitle:@"Enable OCR"];
    
    self.containImageCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 210, 200, 20)];
    [self.containImageCheckBox setButtonType:NSButtonTypeSwitch];
    [self.containImageCheckBox setTitle:@"Include Images"];
    
    self.containAnnotationCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 210, 200, 20)];
    [self.containAnnotationCheckBox setButtonType:NSButtonTypeSwitch];
    [self.containAnnotationCheckBox setTitle:@"Include Annotations"];
    
    self.enableAILayoutCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 180, 200, 20)];
    [self.enableAILayoutCheckBox setButtonType:NSButtonTypeSwitch];
    [self.enableAILayoutCheckBox setTitle:@"Enable AI Layout"];

    self.enableAITableRecognitionCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 180, 240, 20)];
    [self.enableAITableRecognitionCheckBox setButtonType:NSButtonTypeSwitch];
    [self.enableAITableRecognitionCheckBox setTitle:@"Enable AI Table Recognition"];
    
    self.csvFormatCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 180, 200, 20)];
    [self.csvFormatCheckBox setButtonType:NSButtonTypeSwitch];
    [self.csvFormatCheckBox setTitle:@"CSV Format"];
    
    self.allContentCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 150, 200, 20)];
    [self.allContentCheckBox setButtonType:NSButtonTypeSwitch];
    [self.allContentCheckBox setTitle:@"All Content"];
    
    NSTextField *excelWorksheetLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 174, 120, 20)];
    [excelWorksheetLabel setBezeled:NO];
    [excelWorksheetLabel setDrawsBackground:NO];
    [excelWorksheetLabel setEditable:NO];
    [excelWorksheetLabel setSelectable:NO];
    [excelWorksheetLabel setStringValue:@"Worksheet Option:"];
    
    self.excelWorksheetOptionPopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 150, 160, 24)];
    [self.excelWorksheetOptionPopUp addItemWithTitle:@"Single Table Page"];
    [self.excelWorksheetOptionPopUp addItemWithTitle:@"Table Per Page"];
    [self.excelWorksheetOptionPopUp addItemWithTitle:@"Table Per Document"];
    
    self.tableFormatCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 120, 200, 20)];
    [self.tableFormatCheckBox setButtonType:NSButtonTypeSwitch];
    [self.tableFormatCheckBox setTitle:@"Table Format"];
    
    self.containTableCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 120, 200, 20)];
    [self.containTableCheckBox setButtonType:NSButtonTypeSwitch];
    [self.containTableCheckBox setTitle:@"Include Tables"];
    
    self.pathEnhanceCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 90, 200, 20)];
    [self.pathEnhanceCheckBox setButtonType:NSButtonTypeSwitch];
    [self.pathEnhanceCheckBox setTitle:@"Path Enhancement"];
    
    NSTextField *pageLayoutLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 84, 120, 20)];
    [pageLayoutLabel setBezeled:NO];
    [pageLayoutLabel setDrawsBackground:NO];
    [pageLayoutLabel setEditable:NO];
    [pageLayoutLabel setSelectable:NO];
    [pageLayoutLabel setStringValue:@"Page Layout:"];
    
    self.pageLayoutModePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(140, 60, 180, 24)];
    [self.pageLayoutModePopUp addItemWithTitle:@"Hybrid"];
    [self.pageLayoutModePopUp addItemWithTitle:@"Fixed"];
    [self.pageLayoutModePopUp selectItemAtIndex:0]; 

    self.pageRangesLabel = [[NSTextField alloc] initWithFrame:NSZeroRect]; 
    [self.pageRangesLabel setBezeled:NO];
    [self.pageRangesLabel setDrawsBackground:NO];
    [self.pageRangesLabel setEditable:NO];
    [self.pageRangesLabel setSelectable:NO];
    [self.pageRangesLabel setStringValue:@"Page Ranges:"]; 

    self.pageRangesTextField = [[NSTextField alloc] initWithFrame:NSZeroRect]; 
    self.pageRangesTextField.stringValue = @""; 

    NSTextField *imageColorModeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 84, 120, 20)];
    [imageColorModeLabel setBezeled:NO];
    [imageColorModeLabel setDrawsBackground:NO];
    [imageColorModeLabel setEditable:NO];
    [imageColorModeLabel setSelectable:NO];
    [imageColorModeLabel setStringValue:@"Color Mode:"];
    
    self.imageColorModePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 60, 160, 24)];
    [self.imageColorModePopUp addItemWithTitle:@"Color"];
    [self.imageColorModePopUp addItemWithTitle:@"Grayscale"];
    [self.imageColorModePopUp addItemWithTitle:@"Binary"];
    
    NSTextField *imageTypeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 54, 120, 20)];
    [imageTypeLabel setBezeled:NO];
    [imageTypeLabel setDrawsBackground:NO];
    [imageTypeLabel setEditable:NO];
    [imageTypeLabel setSelectable:NO];
    [imageTypeLabel setStringValue:@"Image Type:"];
    
    self.imageTypePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 30, 160, 24)];
    [self.imageTypePopUp addItemWithTitle:@"JPG"];
    [self.imageTypePopUp addItemWithTitle:@"JPEG"];
    [self.imageTypePopUp addItemWithTitle:@"JPEG2000"];
    [self.imageTypePopUp addItemWithTitle:@"PNG"];
    [self.imageTypePopUp addItemWithTitle:@"BMP"];
    [self.imageTypePopUp addItemWithTitle:@"TIFF"];
    [self.imageTypePopUp addItemWithTitle:@"TGA"];
    [self.imageTypePopUp addItemWithTitle:@"GIF"];
    [self.imageTypePopUp addItemWithTitle:@"WEBP"];
    
    NSTextField *scalingLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 30, 100, 20)];
    [scalingLabel setBezeled:NO];
    [scalingLabel setDrawsBackground:NO];
    [scalingLabel setEditable:NO];
    [scalingLabel setSelectable:NO];
    [scalingLabel setStringValue:@"Scaling Factor:"];
    
    self.scalingTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, 30, 50, 20)];
    self.scalingTextField.stringValue = @"1.0";

    self.fontNameTextField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    self.fontNameTextField.placeholderString = @"Default system font";
    self.fontNameTextField.stringValue = @"";
    
    NSTextField *htmlOptionLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 114, 120, 20)];
    [htmlOptionLabel setBezeled:NO];
    [htmlOptionLabel setDrawsBackground:NO];
    [htmlOptionLabel setEditable:NO];
    [htmlOptionLabel setSelectable:NO];
    [htmlOptionLabel setStringValue:@"HTML PAGE Option:"];
    
    self.htmlOptionPopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 90, 160, 24)];
    [self.htmlOptionPopUp addItemWithTitle:@"Single Page HTML"];
    [self.htmlOptionPopUp addItemWithTitle:@"Single Page HTML (With Bookmark)"];
    [self.htmlOptionPopUp addItemWithTitle:@"Multi Page HTML"];
    [self.htmlOptionPopUp addItemWithTitle:@"Multi Page HTML (With Bookmark)"];
    
    self.formulaToImageCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 210, 200, 20)];
    [self.formulaToImageCheckBox setButtonType:NSButtonTypeSwitch];
    [self.formulaToImageCheckBox setTitle:@"Formula to Image"];

    self.transparentTextCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(280, 180, 200, 20)];
    [self.transparentTextCheckBox setButtonType:NSButtonTypeSwitch];
    [self.transparentTextCheckBox setTitle:@"Transparent Text"];
    [self.transparentTextCheckBox setState:NSControlStateValueOn];
    
    NSTextField *ocrLanguageLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 244, 120, 20)];
    [ocrLanguageLabel setBezeled:NO];
    [ocrLanguageLabel setDrawsBackground:NO];
    [ocrLanguageLabel setEditable:NO];
    [ocrLanguageLabel setSelectable:NO];
    [ocrLanguageLabel setStringValue:@"OCR Language:"];
    
    self.ocrLanguagePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 240, 200, 24)];
    [self.ocrLanguagePopUp addItemWithTitle:@"Unknown"];                 // 0
    [self.ocrLanguagePopUp addItemWithTitle:@"Chinese (Simplified)"];   // 1
    [self.ocrLanguagePopUp addItemWithTitle:@"Chinese (Traditional)"];  // 2
    [self.ocrLanguagePopUp addItemWithTitle:@"English"];                // 3
    [self.ocrLanguagePopUp addItemWithTitle:@"Korean"];                 // 4
    [self.ocrLanguagePopUp addItemWithTitle:@"Japanese"];               // 5
    [self.ocrLanguagePopUp addItemWithTitle:@"Latin"];                  // 6
    [self.ocrLanguagePopUp addItemWithTitle:@"Devanagari"];             // 7
    [self.ocrLanguagePopUp addItemWithTitle:@"Cyrillic"];               // 8
    [self.ocrLanguagePopUp addItemWithTitle:@"Arabic"];                 // 9
    [self.ocrLanguagePopUp addItemWithTitle:@"Tamil"];                  // 10
    [self.ocrLanguagePopUp addItemWithTitle:@"Telugu"];                 // 11
    [self.ocrLanguagePopUp addItemWithTitle:@"Kannada"];                // 12
    [self.ocrLanguagePopUp addItemWithTitle:@"Thai"];                   // 13
    [self.ocrLanguagePopUp addItemWithTitle:@"Greek"];                  // 14
    [self.ocrLanguagePopUp addItemWithTitle:@"Eslav"];                  // 15
    [self.ocrLanguagePopUp addItemWithTitle:@"Auto"];                   // 16
    [self.ocrLanguagePopUp selectItemAtIndex:16];
    [self.ocrLanguagePopUp setTarget:self];
    [self.ocrLanguagePopUp setAction:@selector(ocrLanguageChanged:)];

    self.outputPerPageCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 120, 220, 20)];
    [self.outputPerPageCheckBox setButtonType:NSButtonTypeSwitch];
    [self.outputPerPageCheckBox setTitle:@"Output Per Page"];
    [self.outputPerPageCheckBox setState:NSControlStateValueOff];

    self.backgroundImageCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 90, 240, 20)];
    [self.backgroundImageCheckBox setButtonType:NSButtonTypeSwitch];
    [self.backgroundImageCheckBox setTitle:@"Contain Page Background Image"];
    [self.backgroundImageCheckBox setState:NSControlStateValueOff];

    if (self.ocrCheckBox) {
        [self.ocrCheckBox setTarget:self];
        [self.ocrCheckBox setAction:@selector(ocrCheckBoxToggled:)];
    }

    self.autoCreateFolderCheckBox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 60, 220, 20)];
    [self.autoCreateFolderCheckBox setButtonType:NSButtonTypeSwitch];
    [self.autoCreateFolderCheckBox setTitle:@"Auto Create Folder"];
    [self.autoCreateFolderCheckBox setState:NSControlStateValueOff];

    self.ocrOptionPopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 240, 160, 24)];
    [self.ocrOptionPopUp addItemWithTitle:@"All"];
    [self.ocrOptionPopUp addItemWithTitle:@"Invalid Character"];
    [self.ocrOptionPopUp addItemWithTitle:@"Scan Page"];
    [self.ocrOptionPopUp addItemWithTitle:@"Invalid Character + Scan Page"];
    
    [self initializeSDK];
    
    [self conversionTypeChanged:self.convertTypePopUp];
    
    self.progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20, 220, 680, 20)];
    self.progressIndicator.indeterminate = NO;
    self.progressIndicator.minValue = 0;
    self.progressIndicator.maxValue = 100;
    self.progressIndicator.doubleValue = 0;
    self.progressIndicator.hidden = YES;
    self.progressIndicator.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;
    [self.view addSubview:self.progressIndicator positioned:NSWindowAbove relativeTo:self.logScrollView];
}

- (void)initializeSDK {
    [self appendLogMessage:@"Initializing SDK..."];
    
    @try {
        NSArray *possibleResourcePaths = @[
            [[NSBundle mainBundle] resourcePath],
        ];
        
        NSString *resourcePath = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for (NSString *path in possibleResourcePaths) {
            BOOL isDir = NO;
            BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
            
            if (exists && isDir) {
                BOOL hasModelDir = [fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"models"] isDirectory:&isDir] && isDir;
                BOOL hasFontsDir = [fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"fonts"] isDirectory:&isDir] && isDir;
                
                if (hasModelDir || hasFontsDir) {
                    resourcePath = path;
                    [self appendLogMessage:[NSString stringWithFormat:@"Contains models directory: %@", hasModelDir ? @"YES" : @"NO"]];
                    [self appendLogMessage:[NSString stringWithFormat:@"Contains fonts directory: %@", hasFontsDir ? @"YES" : @"NO"]];
                    break;
                }
            }
        }
        
        if (!resourcePath) {
            [self appendLogMessage:@"WARNING: Could not find a valid resource path! SDK may not function correctly."];
            resourcePath = @"../../../resource";
        }
        
        NSString *licenseFilePath = [resourcePath stringByAppendingPathComponent:@"license/license.xml"];
        NSInteger licenseResult = [LibraryManager licenseVerify:licenseFilePath];

        [self appendLogMessage:[NSString stringWithFormat:@"License verification result: %@", licenseResult==0 ? @"Success" : @"Failure"]];

        [LibraryManager initialize:resourcePath];
        [self appendLogMessage:@"SDK initialization completed"];


        NSString *modelPath = [resourcePath stringByAppendingPathComponent:@"models/documentai.model"];
        BOOL modelExists = [fileManager fileExistsAtPath:modelPath];
        
        if (modelExists) {
        } else {
            [self appendLogMessage:@"Model not found at primary location, trying alternative paths..."];
            
            NSString *altModelPath = @"../../../resource/models/documentai.model";
            NSString *fullAltPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:altModelPath];
            
            if ([fileManager fileExistsAtPath:fullAltPath]) {
                modelPath = fullAltPath;
            } else {
                [self appendLogMessage:@"WARNING: Could not find the OCR model file! OCR functionality may not work."];
                modelPath = altModelPath;
            }
        }
        
        if (modelPath && modelPath.length > 0) {
            ErrorCode result = [LibraryManager setDocumentAIModel:modelPath];
            [self appendLogMessage:[NSString stringWithFormat:@"OCR model setup result: %@", result==0 ? @"Success" : @"Failure"]];
            [self appendLogMessage:[NSString stringWithFormat:@"Default OCR language: %@", [self selectedOCRLanguageTitle]]];
            
            if (result != 0) {
                [self appendLogMessage:@"Failed to set OCR model. Some conversion operations may not work properly."];
            }
        } else {
            [self appendLogMessage:@"No valid OCR model path found. OCR functionality will be disabled."];
        }

        // Progress callbacks are now provided per conversion call (startPDFToXxx).
        
        [self appendLogMessage:[NSString stringWithFormat:@"SDK version: %@", [LibraryManager getVersion]]];
    }
    @catch (NSException *exception) {
        [self appendLogMessage:[NSString stringWithFormat:@"ERROR during SDK initialization: %@: %@", exception.name, exception.reason]];
    }
}

- (void)appendLogMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *formattedMessage = [NSString stringWithFormat:@"%@: %@\n", dateString, message];
        [self.logTextView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:formattedMessage]];
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.string.length, 0)];
    });
}

- (void)conversionTypeChanged:(NSPopUpButton *)sender {
    for (NSView *subview in self.optionsContainerView.subviews.copy) {
        [subview removeFromSuperview];
    }

    [self resetOptionControlAvailability];
    
    CGFloat baseY = self.optionsContainerView.bounds.size.height - 40.0;
    CGFloat rightY = self.optionsContainerView.bounds.size.height - 40.0;
    CGFloat stepY = 44;
    CGFloat labelWidth = 120;
    CGFloat fieldWidth = 200;
    CGFloat fieldHeight = 28;
    CGFloat labelX = 20;
    CGFloat fieldX = 150;
    CGFloat rightLabelX = 300;
    CGFloat rightFieldX = 430;
    self.pageRangesLabel.frame = NSMakeRect(labelX, baseY, labelWidth, 20);
    [self.optionsContainerView addSubview:self.pageRangesLabel];
    self.pageRangesTextField.frame = NSMakeRect(fieldX, baseY, fieldWidth, 20);
    [self.optionsContainerView addSubview:self.pageRangesTextField];
    baseY -= stepY;
    rightY -= stepY;

    self.fontNameTextField.stringValue = self.fontNameTextField.stringValue ?: @"";
    
    NSString *selectedTypeStr = [sender titleOfSelectedItem];
    if ([selectedTypeStr isEqualToString:@"Word"]) {
        self.selectedConversionType = ConversionTypePDFToWord;
    } else if ([selectedTypeStr isEqualToString:@"Excel"]) {
        self.selectedConversionType = ConversionTypePDFToExcel;
    } else if ([selectedTypeStr isEqualToString:@"PPT"]) {
        self.selectedConversionType = ConversionTypePDFToPPT;
    } else if ([selectedTypeStr isEqualToString:@"HTML"]) {
        self.selectedConversionType = ConversionTypePDFToHTML;
    } else if ([selectedTypeStr isEqualToString:@"RTF"]) {
        self.selectedConversionType = ConversionTypePDFToRTF;
    } else if ([selectedTypeStr isEqualToString:@"Image"]) {
        self.selectedConversionType = ConversionTypePDFToImage;
    } else if ([selectedTypeStr isEqualToString:@"TXT"]) {
        self.selectedConversionType = ConversionTypePDFToText;
    } else if ([selectedTypeStr isEqualToString:@"JSON"]) {
        self.selectedConversionType = ConversionTypePDFToJSON;
    } else if ([selectedTypeStr isEqualToString:@"Searchable PDF"]) {
        self.selectedConversionType = ConversionTypePDFToSearchablePDF;
    } else if ([selectedTypeStr isEqualToString:@"OFD"]) {
        self.selectedConversionType = ConversionTypePDFToOFD;
    } else if ([selectedTypeStr isEqualToString:@"Markdown"]) {
        self.selectedConversionType = ConversionTypePDFToMarkdown;
    }
    else {
        self.selectedConversionType = ConversionTypeUnknown;
    }
    
#define ADD_OPTION_VIEW(view) do { \
    view.frame = NSMakeRect(labelX, baseY, 200, 24); \
    [self.optionsContainerView addSubview:view]; \
    baseY -= stepY; \
} while(0)
#define ADD_OPTION_VIEW_RIGHT(view) do { \
    view.frame = NSMakeRect(rightLabelX, rightY, 240, 24); \
    [self.optionsContainerView addSubview:view]; \
    rightY -= stepY; \
} while(0)
#define ADD_LABEL_RIGHT(label) do { \
    label.frame = NSMakeRect(rightLabelX, rightY, 120, 24); \
    [self.optionsContainerView addSubview:label]; \
} while(0)
#define ADD_POPUP_RIGHT(popup) do { \
    popup.frame = NSMakeRect(rightFieldX, rightY, 160, 24); \
    [self.optionsContainerView addSubview:popup]; \
    rightY -= stepY; \
} while(0)
#define ADD_FONT_NAME_RIGHT() do { \
    NSTextField *fontNameLabel = [[NSTextField alloc] init]; \
    fontNameLabel.stringValue = @"Font Name:"; \
    fontNameLabel.bezeled = NO; \
    fontNameLabel.drawsBackground = NO; \
    fontNameLabel.editable = NO; \
    fontNameLabel.selectable = NO; \
    ADD_LABEL_RIGHT(fontNameLabel); \
    ADD_POPUP_RIGHT(self.fontNameTextField); \
} while(0)

    if ([selectedTypeStr isEqualToString:@"Image"]) {
        [self.pathEnhanceCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.pathEnhanceCheckBox);
        NSTextField *imageColorModeLabel = [[NSTextField alloc] init];
        imageColorModeLabel.stringValue = @"Color Mode:";
        imageColorModeLabel.bezeled = NO;
        imageColorModeLabel.drawsBackground = NO;
        imageColorModeLabel.editable = NO;
        imageColorModeLabel.selectable = NO;
        
        ADD_LABEL_RIGHT(imageColorModeLabel);
        ADD_POPUP_RIGHT(self.imageColorModePopUp);
        baseY -= stepY;
        NSTextField *imageTypeLabel = [[NSTextField alloc] init];
        imageTypeLabel.stringValue = @"Image Type:";
        imageTypeLabel.bezeled = NO;
        imageTypeLabel.drawsBackground = NO;
        imageTypeLabel.editable = NO;
        imageTypeLabel.selectable = NO;
        ADD_LABEL_RIGHT(imageTypeLabel);
        ADD_POPUP_RIGHT(self.imageTypePopUp);
        NSTextField *scalingLabel = [[NSTextField alloc] init];
        scalingLabel.stringValue = @"Scaling Factor:";
        scalingLabel.bezeled = NO;
        scalingLabel.drawsBackground = NO;
        scalingLabel.editable = NO;
        scalingLabel.selectable = NO;
        ADD_LABEL_RIGHT(scalingLabel);
        ADD_POPUP_RIGHT(self.scalingTextField);
    } else if ([selectedTypeStr isEqualToString:@"Excel"]) {
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.csvFormatCheckBox setState:NSControlStateValueOff];
        [self.allContentCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.csvFormatCheckBox);
        ADD_OPTION_VIEW(self.allContentCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_OPTION_VIEW(self.autoCreateFolderCheckBox);
        {
            NSTextField *fontNameLabel = [[NSTextField alloc] init];
            fontNameLabel.stringValue = @"Font Name:";
            fontNameLabel.bezeled = NO;
            fontNameLabel.drawsBackground = NO;
            fontNameLabel.editable = NO;
            fontNameLabel.selectable = NO;
            ADD_LABEL_RIGHT(fontNameLabel);
            ADD_POPUP_RIGHT(self.fontNameTextField);
        }
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        NSTextField *excelWorksheetLabel = [[NSTextField alloc] init];
        excelWorksheetLabel.stringValue = @"Worksheet Option:";
        excelWorksheetLabel.bezeled = NO;
        excelWorksheetLabel.drawsBackground = NO;
        excelWorksheetLabel.editable = NO;
        excelWorksheetLabel.selectable = NO;
        ADD_LABEL_RIGHT(excelWorksheetLabel);
        ADD_POPUP_RIGHT(self.excelWorksheetOptionPopUp);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
    } else if ([selectedTypeStr isEqualToString:@"TXT"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.tableFormatCheckBox setState:NSControlStateValueOn];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.tableFormatCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }

        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);

    } else if ([selectedTypeStr isEqualToString:@"JSON"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.containTableCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.containTableCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"Searchable PDF"]) {
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        [self.transparentTextCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOn];
        self.ocrCheckBox.enabled = NO;
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.transparentTextCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"OFD"]) {
        [self.ocrCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        [self.transparentTextCheckBox setState:NSControlStateValueOn];
        [self.backgroundImageCheckBox setState:NSControlStateValueOn];
        self.ocrCheckBox.enabled = NO;
        self.containImageCheckBox.enabled = NO;
        self.transparentTextCheckBox.enabled = NO;
        self.backgroundImageCheckBox.enabled = NO;
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.transparentTextCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"HTML"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        NSTextField *pageLayoutLabel = [[NSTextField alloc] init];
        pageLayoutLabel.stringValue = @"Page Layout:";
        pageLayoutLabel.bezeled = NO;
        pageLayoutLabel.drawsBackground = NO;
        pageLayoutLabel.editable = NO;
        pageLayoutLabel.selectable = NO;
        ADD_LABEL_RIGHT(pageLayoutLabel);
        ADD_POPUP_RIGHT(self.pageLayoutModePopUp);
        NSTextField *htmlOptionLabel = [[NSTextField alloc] init];
        htmlOptionLabel.stringValue = @"HTML Option:";
        htmlOptionLabel.bezeled = NO;
        htmlOptionLabel.drawsBackground = NO;
        htmlOptionLabel.editable = NO;
        htmlOptionLabel.selectable = NO;
        ADD_LABEL_RIGHT(htmlOptionLabel);
        ADD_POPUP_RIGHT(self.htmlOptionPopUp);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
    } else if ([selectedTypeStr isEqualToString:@"PPT"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        {
            NSTextField *fontNameLabel = [[NSTextField alloc] init];
            fontNameLabel.stringValue = @"Font Name:";
            fontNameLabel.bezeled = NO;
            fontNameLabel.drawsBackground = NO;
            fontNameLabel.editable = NO;
            fontNameLabel.selectable = NO;
            ADD_LABEL_RIGHT(fontNameLabel);
            ADD_POPUP_RIGHT(self.fontNameTextField);
        }
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"RTF"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"Word"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.backgroundImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        {
            NSTextField *fontNameLabel = [[NSTextField alloc] init];
            fontNameLabel.stringValue = @"Font Name:";
            fontNameLabel.bezeled = NO;
            fontNameLabel.drawsBackground = NO;
            fontNameLabel.editable = NO;
            fontNameLabel.selectable = NO;
            ADD_LABEL_RIGHT(fontNameLabel);
            ADD_POPUP_RIGHT(self.fontNameTextField);
        }
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        NSTextField *pageLayoutLabel = [[NSTextField alloc] init];
        pageLayoutLabel.stringValue = @"Page Layout:";
        pageLayoutLabel.bezeled = NO;
        pageLayoutLabel.drawsBackground = NO;
        pageLayoutLabel.editable = NO;
        pageLayoutLabel.selectable = NO;
        ADD_LABEL_RIGHT(pageLayoutLabel);
        ADD_POPUP_RIGHT(self.pageLayoutModePopUp);
    } else if ([selectedTypeStr isEqualToString:@"Markdown"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.enableAITableRecognitionCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW_RIGHT(self.enableAITableRecognitionCheckBox);
        ADD_OPTION_VIEW(self.outputPerPageCheckBox);
        ADD_FONT_NAME_RIGHT();
        // OCR Option (right)
        {
            NSTextField *ocrOptionLabel = [[NSTextField alloc] init];
            ocrOptionLabel.stringValue = @"OCR Option:";
            ocrOptionLabel.bezeled = NO;
            ocrOptionLabel.drawsBackground = NO;
            ocrOptionLabel.editable = NO;
            ocrOptionLabel.selectable = NO;
            ADD_LABEL_RIGHT(ocrOptionLabel);
            ADD_POPUP_RIGHT(self.ocrOptionPopUp);
        }
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW(self.ocrLanguagePopUp);
    }

    [self syncBackgroundContainmentWithOCR];
    [self updateOCRDependentControlsEnabledState];
    [self.optionsContainerView setNeedsLayout:YES];
    [self.optionsContainerView layoutSubtreeIfNeeded];
    [self.optionsContainerView setNeedsDisplay:YES];

#undef ADD_OPTION_VIEW
#undef ADD_OPTION_VIEW_RIGHT
#undef ADD_LABEL_RIGHT
#undef ADD_POPUP_RIGHT
#undef ADD_FONT_NAME_RIGHT
}

- (void)resetOptionControlAvailability {
    self.ocrCheckBox.enabled = YES;
    self.containImageCheckBox.enabled = YES;
    self.enableAITableRecognitionCheckBox.enabled = YES;
    self.transparentTextCheckBox.enabled = YES;
    self.backgroundImageCheckBox.enabled = YES;
}

- (void)ocrCheckBoxToggled:(NSButton *)sender {
    [self syncBackgroundContainmentWithOCR];
    [self updateOCRDependentControlsEnabledState];
}

- (void)syncBackgroundContainmentWithOCR {
    if (self.backgroundImageCheckBox && self.ocrCheckBox) {
        self.backgroundImageCheckBox.state = self.ocrCheckBox.state;
    }
}

- (void)updateOCRDependentControlsEnabledState {
    BOOL enableOCR = (self.ocrCheckBox.state == NSControlStateValueOn);
    if (self.ocrOptionPopUp) {
        self.ocrOptionPopUp.enabled = enableOCR;
    }
    if (self.ocrLanguagePopUp) {
        self.ocrLanguagePopUp.enabled = enableOCR;
    }
}

- (void)chooseInput:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    panel.message = @"Please select a PDF file or a folder containing PDF files";
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *selectedURL = panel.URLs.firstObject;
            self.inputPathField.stringValue = selectedURL.path;
            
            BOOL isDirectory;
            [[NSFileManager defaultManager] fileExistsAtPath:selectedURL.path isDirectory:&isDirectory];
            if (isDirectory) {
                [self appendLogMessage:@"Folder selected. All PDF files in this folder will be converted."];
            }
        }
    }];
}

- (void)chooseOutput:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
    panel.message = @"Please select output directory";
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *dirURL = panel.URLs.firstObject;
            self.outputPathField.stringValue = dirURL.path;
        }
    }];
}

- (void)startConvert:(id)sender {
    NSString *inputPath = self.inputPathField.stringValue;
    NSString *outputDirPath = self.outputPathField.stringValue;
    
    [self appendLogMessage:@"Conversion request starting to process"];
    [self appendLogMessage:[NSString stringWithFormat:@"Input path: %@", inputPath]];
    [self appendLogMessage:[NSString stringWithFormat:@"Output path: %@", outputDirPath]];
    
    if (inputPath.length == 0 || outputDirPath.length == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Error";
        alert.informativeText = @"Please select input file/folder and output directory";
        [alert addButtonWithTitle:@"OK"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:inputPath]) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Error";
        alert.informativeText = @"Input file/folder does not exist";
        [alert addButtonWithTitle:@"OK"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:outputDirPath isDirectory:&isDir] || !isDir) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Error";
        alert.informativeText = @"Output directory does not exist or is not a directory";
        [alert addButtonWithTitle:@"OK"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    self.startConvertBtn.enabled = NO;
    self.cancelConvertBtn.enabled = YES;
    self.conversionCancelRequested = NO;
    
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:inputPath isDirectory:&isDirectory];
    
    if (isDirectory) {
        self.isBatchConverting = YES;
        [self appendLogMessage:@"Scanning directory for PDF files..."];
        
        NSError *error;
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:inputPath error:&error];
        
        if (error) {
            [self appendLogMessage:[NSString stringWithFormat:@"Failed to read directory: %@", error.localizedDescription]];
            self.startConvertBtn.enabled = YES;
            self.cancelConvertBtn.enabled = NO;
            return;
        }
        
        NSPredicate *pdfFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH[c] '.pdf'"];
        NSArray *pdfFiles = [contents filteredArrayUsingPredicate:pdfFilter];
        
        if (pdfFiles.count == 0) {
            [self appendLogMessage:@"No PDF files found in directory"];
            self.startConvertBtn.enabled = YES;
            self.cancelConvertBtn.enabled = NO;
            return;
        }
        
        [self appendLogMessage:[NSString stringWithFormat:@"Found %lu PDF files, starting batch conversion", (unsigned long)pdfFiles.count]];
        
        dispatch_queue_t queue = dispatch_queue_create("com.ComPDF.conversion.batchQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            NSUInteger totalCount = pdfFiles.count;
            __block NSUInteger finishedCount = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressIndicator.hidden = NO;
                self.progressIndicator.minValue = 0;
                self.progressIndicator.maxValue = totalCount;
                self.progressIndicator.doubleValue = 0;
            });
            for (NSString *pdfFile in pdfFiles) {
                if (self.conversionCancelRequested) {
                    break;
                }
                NSString *fullPath = [inputPath stringByAppendingPathComponent:pdfFile];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self appendLogMessage:[NSString stringWithFormat:@"Processing: %@", pdfFile]];
                });
                [self performSingleFileConversion:fullPath outputDirectory:outputDirPath];
                finishedCount++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressIndicator.doubleValue = finishedCount;
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self appendLogMessage:(self.conversionCancelRequested ? @"Batch conversion cancelled" : @"Batch conversion completed")];
                self.startConvertBtn.enabled = YES;
                self.cancelConvertBtn.enabled = NO;
                self.progressIndicator.hidden = YES;
                self.progressIndicator.doubleValue = 0;
            });
            self.isBatchConverting = NO;
        });
    } else {
        self.isBatchConverting = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSingleFileConversion:inputPath outputDirectory:outputDirPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startConvertBtn.enabled = YES;
                self.cancelConvertBtn.enabled = NO;
            });
        });
    }
}

- (void)cancelConvert:(id)sender {
    [self appendLogMessage:@"Attempting to cancel conversion..."];

    self.conversionCancelRequested = YES;
    [self appendLogMessage:@"Cancellation request has been sent. The current conversion will stop at the next callback check."];
    
    self.startConvertBtn.enabled = YES;
    self.cancelConvertBtn.enabled = NO;
    self.progressIndicator.doubleValue = 0;
    self.progressIndicator.hidden = YES;
}

- (NSString *)conversionTypeToString:(ConversionType)type {
    switch (type) {
        case ConversionTypePDFToWord:
            return @"Word";
        case ConversionTypePDFToExcel:
            return @"Excel";
        case ConversionTypePDFToPPT:
            return @"PPT";
        case ConversionTypePDFToHTML:
            return @"HTML";
        case ConversionTypePDFToRTF:
            return @"RTF";
        case ConversionTypePDFToImage:
            return @"Image";
        case ConversionTypePDFToText:
            return @"TXT";
        case ConversionTypePDFToJSON:
            return @"JSON";
        case ConversionTypePDFToSearchablePDF:
            return @"Searchable PDF";
        case ConversionTypePDFToOFD:
            return @"OFD";
        case ConversionTypePDFToMarkdown:
            return @"Markdown";
        default:
            return @"Unknown";
    }
}

- (void)performSingleFileConversion:(NSString *)inputFilePath outputDirectory:(NSString *)outputDirPath {
    if (!inputFilePath || !outputDirPath) {
        [self appendLogMessage:@"Error: Invalid input or output path"];
        return;
    }
    
    [self appendLogMessage:[NSString stringWithFormat:@"Starting conversion of file: %@", [inputFilePath lastPathComponent]]];
    
    NSString *pageRanges = self.pageRangesTextField.stringValue;
    
    NSString *fileNameBase = [[inputFilePath lastPathComponent] stringByDeletingPathExtension];
    NSString *outputPath = nil;
    
    ConversionType conversionType = self.selectedConversionType;
    NSArray<NSNumber *> *selectedOCRLanguages = [self selectedOCRLanguages];
    NSString *selectedFontName = [self.fontNameTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    __block BOOL conversionInProgress = YES;
    __block id keepAliveObject = self;

#if __has_feature(objc_arc)
    __weak typeof(self) weakSelf = self;
#else
    __unsafe_unretained typeof(self) weakSelf = self;
#endif
    __block int lastProgressCurrent = -1;
    __block int lastProgressTotal = -1;

    COMProgressBlock progressBlock = ^(int current_page, int total_page) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        if (current_page == lastProgressCurrent && total_page == lastProgressTotal) {
            return;
        }
        lastProgressCurrent = current_page;
        lastProgressTotal = total_page;

        dispatch_async(dispatch_get_main_queue(), ^{
            if (!strongSelf.isBatchConverting) {
                if (total_page > 0) {
                    strongSelf.progressIndicator.hidden = NO;
                    strongSelf.progressIndicator.minValue = 0;
                    strongSelf.progressIndicator.maxValue = total_page;
                    strongSelf.progressIndicator.doubleValue = current_page;
                } else {
                    strongSelf.progressIndicator.hidden = YES;
                }
            }

            if (total_page > 0) {
                [strongSelf appendLogMessage:[NSString stringWithFormat:@"conversion progress: %d/%d", current_page, total_page]];
            }

            if (!strongSelf.isBatchConverting && total_page > 0 && current_page >= total_page) {
                strongSelf.progressIndicator.hidden = YES;
                strongSelf.progressIndicator.doubleValue = 0;
            }

            if (total_page > 0 && current_page >= total_page) {
                conversionInProgress = NO;
                keepAliveObject = nil;
            }
        });
    };

    COMCancelBlock cancelBlock = ^BOOL{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return YES;
        return strongSelf.conversionCancelRequested;
    };
    
    if (conversionType == ConversionTypePDFToWord) {
        WordOptions *wordOptions = [[WordOptions alloc] init];
        wordOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        wordOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        wordOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        wordOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        wordOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        wordOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        wordOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        wordOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        wordOptions.ocrOption = [self currentOCROption];
        wordOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            wordOptions.fontName = selectedFontName;
        }
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        wordOptions.pageLayoutMode = (layoutMode == 0) ? PageLayoutModeFlow : PageLayoutModeBox;
        
        if (pageRanges.length > 0) {
            wordOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"docx"]];
        outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting Word conversion..."];
        [self logOptionsDetails:wordOptions];
        
                ErrorCode result = [CPDFConversion startPDFToWord:inputFilePath
                                                                                                password:@""
                                                                                            outputPath:outputPath
                                                                                                 options:wordOptions
                                                                                                progress:progressBlock
                                                                                                    cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToExcel) {
        ExcelOptions *excelOptions = [[ExcelOptions alloc] init];
        excelOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        excelOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        excelOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        excelOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        excelOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        excelOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        excelOptions.CSVFormat = self.csvFormatCheckBox.state == NSControlStateValueOn;
        excelOptions.AllContent = self.allContentCheckBox.state == NSControlStateValueOn;
        excelOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        excelOptions.auto_create_folder = (self.autoCreateFolderCheckBox.state == NSControlStateValueOn);
        excelOptions.ocrOption = [self currentOCROption];
        excelOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            excelOptions.fontName = selectedFontName;
        }
        
        NSInteger worksheetIndex = [self.excelWorksheetOptionPopUp indexOfSelectedItem];
        switch (worksheetIndex) {
            case 0:
                excelOptions.excelWorksheetOption = ExcelWorksheetForTable;
                break;
            case 1:
                excelOptions.excelWorksheetOption = ExcelWorksheetForPage;
                break;
            case 2:
                excelOptions.excelWorksheetOption = ExcelWorksheetForDocument;
                break;
            default:
                excelOptions.excelWorksheetOption = ExcelWorksheetForTable;
                break;
        }
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        excelOptions.pageLayoutMode = (layoutMode == 0) ? PageLayoutModeFlow : PageLayoutModeBox;
        
        if (pageRanges.length > 0) {
            excelOptions.pageRanges = pageRanges;
        }
        
        if (excelOptions.CSVFormat) {
            outputPath = outputDirPath;
        } else {
            NSString *extension = @"xlsx";
            outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:extension]];
            outputPath = [self ensureUniquePathForFile:outputPath];
        }
        
        [self appendLogMessage:@"Starting Excel conversion..."];
        [self logOptionsDetails:excelOptions];
        
                ErrorCode result = [CPDFConversion startPDFToExcel:inputFilePath
                                                                                                 password:@""
                                                                                             outputPath:outputPath
                                                                                                    options:excelOptions
                                                                                                 progress:progressBlock
                                                                                                     cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToPPT) {
        PptOptions *pptOptions = [[PptOptions alloc] init];
        pptOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        pptOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        pptOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        pptOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        pptOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        pptOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        pptOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        pptOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        pptOptions.ocrOption = [self currentOCROption];
        pptOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            pptOptions.fontName = selectedFontName;
        }
        
        if (pageRanges.length > 0) {
            pptOptions.pageRanges = pageRanges;
        }
        
    outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"pptx"]];
    outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting PPT conversion..."];
        [self logOptionsDetails:pptOptions];
        
                ErrorCode result = [CPDFConversion startPDFToPpt:inputFilePath
                                                                                             password:@""
                                                                                         outputPath:outputPath
                                                                                                options:pptOptions
                                                                                             progress:progressBlock
                                                                                                 cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToHTML) {
        HtmlOptions *htmlOptions = [[HtmlOptions alloc] init];
        htmlOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        htmlOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        htmlOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        htmlOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        htmlOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        htmlOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        htmlOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        htmlOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        htmlOptions.ocrOption = [self currentOCROption];
        htmlOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            htmlOptions.fontName = selectedFontName;
        }
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        htmlOptions.pageLayoutMode = (layoutMode == 0) ? PageLayoutModeFlow : PageLayoutModeBox;
        
        if (pageRanges.length > 0) {
            htmlOptions.pageRanges = pageRanges;
        }
        
    outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"html"]];
    outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting HTML conversion..."];
        [self logOptionsDetails:htmlOptions];
        
        NSInteger htmlOptionIndex = [self.htmlOptionPopUp indexOfSelectedItem];
        switch (htmlOptionIndex) {
            case 0:
                htmlOptions.htmlPageOption = HtmlOptionSinglePage;
                break;
            case 1:
                htmlOptions.htmlPageOption = HtmlOptionSinglePageWithBookmark;
                break;
            case 2:
                htmlOptions.htmlPageOption = HtmlOptionMultiPage;
                break;
            case 3:
                htmlOptions.htmlPageOption = HtmlOptionMultiPageWithBookmark;
                break;
            default:
                htmlOptions.htmlPageOption = HtmlOptionSinglePage;
                break;
        }
        
        ErrorCode result = [CPDFConversion startPDFToHtml:inputFilePath 
                                                                                                password:@""
                                                                                            outputPath:outputPath
                                                                                                 options:htmlOptions
                                                                                                progress:progressBlock
                                                                                                    cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToRTF) {
        RtfOptions *rtfOptions = [[RtfOptions alloc] init];
        rtfOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        rtfOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        rtfOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        rtfOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        rtfOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        rtfOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        rtfOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        rtfOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        rtfOptions.ocrOption = [self currentOCROption];
        rtfOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            rtfOptions.fontName = selectedFontName;
        }
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        
        if (pageRanges.length > 0) {
            rtfOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"rtf"]];
        outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting RTF conversion..."];
        [self logOptionsDetails:rtfOptions];
        
                ErrorCode result = [CPDFConversion startPDFToRtf:inputFilePath
                                                                                             password:@""
                                                                                         outputPath:outputPath
                                                                                                options:rtfOptions
                                                                                             progress:progressBlock
                                                                                                 cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToImage) {
        ImageOptions *imageOptions = [[ImageOptions alloc] init];
        imageOptions.PathEnhance = self.pathEnhanceCheckBox.state == NSControlStateValueOn;
        
        NSInteger colorMode = [self.imageColorModePopUp indexOfSelectedItem];
        NSInteger imageType = [self.imageTypePopUp indexOfSelectedItem];

        switch (imageType) {
            case 0:
                imageOptions.Type = ImageTypeJPG;
                break;
            case 1:
                imageOptions.Type = ImageTypeJPEG;
                break;
            case 2:
                imageOptions.Type = ImageTypeJPEG2000;
                break;
            case 3:
                imageOptions.Type = ImageTypePNG;
                break;
            case 4:
                imageOptions.Type = ImageTypeBMP;
                break;
            case 5:
                imageOptions.Type = ImageTypeTIFF;
                break;
            case 6:
                imageOptions.Type = ImageTypeTGA;
                break;
            case 7:
                imageOptions.Type = ImageTypeGIF;
                break;
            case 8:
                imageOptions.Type = ImageTypeWEBP;
                break;
            default:
                imageOptions.Type = ImageTypeJPG;
                break;
        }
        
        switch (colorMode) {
            case 0:
                imageOptions.ColorMode = ImageColorModeColor;
                break;
            case 1:
                imageOptions.ColorMode = ImageColorModeGray;
                break;
            case 2:
                imageOptions.ColorMode = ImageColorModeBinary;
                break;
            default:
                imageOptions.ColorMode = ImageColorModeColor;
                break;
        }
        
        float scaling = [self.scalingTextField.stringValue floatValue];
        if (scaling <= 0) scaling = 1.0;
        imageOptions.Scaling = scaling;
        
        if (pageRanges.length > 0) {
            imageOptions.pageRanges = pageRanges;
        }
        
    NSString *imgOutputDir = [outputDirPath stringByAppendingPathComponent:fileNameBase];
    imgOutputDir = [self ensureUniqueDirectory:imgOutputDir];
        
        NSError *dirError;
        [[NSFileManager defaultManager] createDirectoryAtPath:imgOutputDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&dirError];
        
        if (dirError) {
            [self appendLogMessage:[NSString stringWithFormat:@"Failed to create image output directory: %@", dirError.localizedDescription]];
            return;
        }
        
        outputPath = imgOutputDir;
        
        [self appendLogMessage:@"Starting Image conversion..."];
        [self logOptionsDetails:imageOptions];
        
                ErrorCode result = [CPDFConversion startPDFToImage:inputFilePath
                                                                                                password:@""
                                                                                            outputPath:outputPath
                                                                                                 options:imageOptions
                                                                                                progress:progressBlock
                                                                                                    cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
        if (result == ErrorCodeSuccess) {
            NSError *countError;
            NSArray *outputFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imgOutputDir error:&countError];
            
            if (!countError) {
                [self appendLogMessage:[NSString stringWithFormat:@"Generated %lu image files", (unsigned long)outputFiles.count]];
            }
        }
        
    } else if (conversionType == ConversionTypePDFToText) {
        TxtOptions *txtOptions = [[TxtOptions alloc] init];
        txtOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        txtOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        txtOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        txtOptions.TableFormat = self.tableFormatCheckBox.state == NSControlStateValueOn;
        txtOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        txtOptions.ocrOption = [self currentOCROption];
        txtOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            txtOptions.fontName = selectedFontName;
        }
        
        if (pageRanges.length > 0) {
            txtOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"txt"]];
        outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting TXT conversion..."];
        [self logOptionsDetails:txtOptions];
        
                ErrorCode result = [CPDFConversion startPDFToTxt:inputFilePath
                                                                                             password:@""
                                                                                         outputPath:outputPath
                                                                                                options:txtOptions
                                                                                             progress:progressBlock
                                                                                                 cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToJSON) {
        JsonOptions *jsonOptions = [[JsonOptions alloc] init];
        jsonOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        jsonOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        jsonOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        jsonOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        jsonOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        jsonOptions.ContainTable = self.containTableCheckBox.state == NSControlStateValueOn;
        jsonOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        jsonOptions.ocrOption = [self currentOCROption];
        jsonOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            jsonOptions.fontName = selectedFontName;
        }
        
        if (pageRanges.length > 0) {
            jsonOptions.pageRanges = pageRanges;
        }
        
        NSString *jsonBase = [fileNameBase stringByAppendingString:@"_json"];
        outputPath = [outputDirPath stringByAppendingPathComponent:[jsonBase stringByAppendingPathExtension:@"json"]];
        outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting JSON conversion..."];
        [self logOptionsDetails:jsonOptions];
        
        ErrorCode result = [CPDFConversion startPDFToJson:inputFilePath 
                                                                                                password:@""
                                                                                            outputPath:outputPath
                                                                                                 options:jsonOptions
                                                                                                progress:progressBlock
                                                                                                    cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToSearchablePDF) {
        SearchablePdfOptions *searchablePdfOptions = [[SearchablePdfOptions alloc] init];
        searchablePdfOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        searchablePdfOptions.transparentText = (self.transparentTextCheckBox.state == NSControlStateValueOn);
        searchablePdfOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        searchablePdfOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        searchablePdfOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        searchablePdfOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        searchablePdfOptions.ocrOption = [self currentOCROption];
        searchablePdfOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            searchablePdfOptions.fontName = selectedFontName;
        }
        
        if (pageRanges.length > 0) {
            searchablePdfOptions.pageRanges = pageRanges;
        }
        
    outputPath = [outputDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_searchable.pdf", fileNameBase]];
    outputPath = [self ensureUniquePathForFile:outputPath];
        
        [self appendLogMessage:@"Starting Searchable PDF conversion..."];
        [self logOptionsDetails:searchablePdfOptions];
        
                ErrorCode result = [CPDFConversion startPDFToSearchablePDF:inputFilePath
                                                                                                                 password:@""
                                                                                                             outputPath:outputPath
                                                                                                                    options:searchablePdfOptions
                                                                                                                 progress:progressBlock
                                                                                                                     cancel:cancelBlock];
        
        [self handleConversionResult:result outputPath:outputPath];

    } else if (conversionType == ConversionTypePDFToOFD) {
        OfdOptions *ofdOptions = [[OfdOptions alloc] init];
        ofdOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        ofdOptions.transparentText = (self.transparentTextCheckBox.state == NSControlStateValueOn);
        ofdOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        ofdOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        ofdOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        ofdOptions.contain_page_background_image = (self.backgroundImageCheckBox.state == NSControlStateValueOn);
        ofdOptions.ocrOption = [self currentOCROption];
        ofdOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            ofdOptions.fontName = selectedFontName;
        }

        if (pageRanges.length > 0) {
            ofdOptions.pageRanges = pageRanges;
        }

        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"ofd"]];
        outputPath = [self ensureUniquePathForFile:outputPath];

        [self appendLogMessage:@"Starting OFD conversion..."];
        [self logOptionsDetails:ofdOptions];

        ErrorCode result = [CPDFConversion startPDFToOFD:inputFilePath
                                                password:@""
                                              outputPath:outputPath
                                                 options:ofdOptions
                                                progress:progressBlock
                                                  cancel:cancelBlock];

        [self handleConversionResult:result outputPath:outputPath];

    } else if (conversionType == ConversionTypePDFToMarkdown) {
        MarkdownOptions *markdownOptions = [[MarkdownOptions alloc] init];
        markdownOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        markdownOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        markdownOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        markdownOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        markdownOptions.enableAITableRecognition = self.enableAITableRecognitionCheckBox.state == NSControlStateValueOn;
        markdownOptions.output_document_per_page = (self.outputPerPageCheckBox.state == NSControlStateValueOn);
        markdownOptions.ocrOption = [self currentOCROption];
        markdownOptions.languages = selectedOCRLanguages;
        if (selectedFontName.length > 0) {
            markdownOptions.fontName = selectedFontName;
        }
        if (pageRanges.length > 0) {
            markdownOptions.pageRanges = pageRanges;
        }
        NSString *mdBase = [fileNameBase stringByAppendingString:@"_md"];
        NSString *desiredMdPath = [outputDirPath stringByAppendingPathComponent:[mdBase stringByAppendingPathExtension:@"md"]];
        outputPath = [self ensureUniquePathForFile:desiredMdPath];

        [self appendLogMessage:[NSString stringWithFormat:@"Starting Markdown conversion..., outputPath: %@", outputPath]];
        [self logOptionsDetails:markdownOptions];
                ErrorCode result = [CPDFConversion startPDFToMarkdown:inputFilePath
                                                                                                     password:@""
                                                                                                 outputPath:outputPath
                                                                                                        options:markdownOptions
                                                                                                     progress:progressBlock
                                                                                                         cancel:cancelBlock];
        [self handleConversionResult:result outputPath:outputPath];
    } else {
        [self appendLogMessage:[NSString stringWithFormat:@"Unsupported conversion type: %@", [self conversionTypeToString:conversionType]]];
    }
}

- (NSString *)ensureUniquePathForFile:(NSString *)path {
    if (path.length == 0) return path;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return path;
    }
    NSString *dir = [path stringByDeletingLastPathComponent];
    NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
    NSString *ext = [path pathExtension];
    NSUInteger counter = 1;
    NSString *candidate = path;
    while ([fm fileExistsAtPath:candidate]) {
        NSString *suffix = [NSString stringWithFormat:@"(%lu)", (unsigned long)counter];
        NSString *fileName = [name stringByAppendingString:suffix];
        candidate = [dir stringByAppendingPathComponent:[fileName stringByAppendingString:(ext.length ? [@"." stringByAppendingString:ext] : @"")]];
        counter++;
        if (counter > 10000) {
            break;
        }
    }
    return candidate;
}

- (NSString *)ensureUniqueDirectory:(NSString *)dirPath {
    if (dirPath.length == 0) return dirPath;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fm fileExistsAtPath:dirPath isDirectory:&isDir]) {
        return dirPath;
    }
    if (!isDir) { // if file exists with same name, still need a new folder name
        dirPath = [dirPath stringByAppendingString:@"_dir"];
    }
    NSString *base = [dirPath lastPathComponent];
    NSString *parent = [dirPath stringByDeletingLastPathComponent];
    NSUInteger counter = 1;
    NSString *candidate = dirPath;
    while ([fm fileExistsAtPath:candidate isDirectory:&isDir]) {
        NSString *suffix = [NSString stringWithFormat:@"（%lu）", (unsigned long)counter];
        NSString *nameWithSuffix = [base stringByAppendingString:suffix];
        candidate = [parent stringByAppendingPathComponent:nameWithSuffix];
        counter++;
        if (counter > 10000) {
            break;
        }
    }
    return candidate;
}

- (void)handleConversionResult:(ErrorCode)result outputPath:(NSString *)outputPath {
    if (result == ErrorCodeSuccess) {
        [self appendLogMessage:[NSString stringWithFormat:@"The conversion task started successfully, output will be saved to: %@", outputPath]];
    } else {
        [self appendLogMessage:[NSString stringWithFormat:@"Failed to start conversion task, error code: %d", (int)result]];
    }
}

- (void)logOptionsDetails:(id)options {
    NSMutableString *optionsDescription = [NSMutableString string];
    
    if ([options respondsToSelector:@selector(enableOCR)]) {
        NSString *left = [@"\nOCR:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options enableOCR] ? @"Enabled" : @"Disabled"];
    }
    
    if ([options respondsToSelector:@selector(containImage)]) {
        NSString *left = [@"Include Images:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options containImage] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(containAnnotation)]) {
        NSString *left = [@"Include Annotations:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options containAnnotation] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(enableAILayout)]) {
        NSString *left = [@"AI Layout:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options enableAILayout] ? @"Enabled" : @"Disabled"];
    }

    if ([options respondsToSelector:@selector(enableAITableRecognition)]) {
        NSString *left = [@"AI Table Recognition:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options enableAITableRecognition] ? @"Enabled" : @"Disabled"];
    }

    if ([options respondsToSelector:@selector(formulaToImage)]) {
        NSString *left = [@"Formula to Image:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options formulaToImage] ? @"Yes" : @"No"];
    }

    if ([options respondsToSelector:@selector(transparentText)]) {
        NSString *left = [@"Transparent Text:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options transparentText] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(pageLayoutMode)]) {
        PageLayoutMode layoutMode = [options pageLayoutMode];
        NSString *left = [@"Page Layout Mode:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, (layoutMode == PageLayoutModeBox) ? @"Fixed" : @"Hybrid"];
    }
    
    if ([options respondsToSelector:@selector(CSVFormat)] && [options respondsToSelector:@selector(AllContent)]) {
        NSString *left1 = [@"CSV Format:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        NSString *left2 = [@"All Content:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left1, [options CSVFormat] ? @"Yes" : @"No"];
        [optionsDescription appendFormat:@"%@%@\n", left2, [options AllContent] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(TableFormat)]) {
        NSString *left = [@"Table Format:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options TableFormat] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(ContainTable)]) {
        NSString *left = [@"Include Tables:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options ContainTable] ? @"Yes" : @"No"];
    }
    
    if ([options respondsToSelector:@selector(PathEnhance)]) {
        NSString *left = [@"Path Enhancement:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, [options PathEnhance] ? @"Enabled" : @"Disabled"];
    }
    
    if ([options respondsToSelector:@selector(ColorMode)]) {
        NSString *colorMode;
        switch ([options ColorMode]) {
            case ImageColorModeColor:
                colorMode = @"Color";
                break;
            case ImageColorModeGray:
                colorMode = @"Grayscale";
                break;
            case ImageColorModeBinary:
                colorMode = @"Binary";
                break;
            default:
                colorMode = @"Unknown";
        }
        NSString *left = [@"Color Mode:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, colorMode];
    }
    
    if ([options respondsToSelector:@selector(Type)]) {
        NSString *imageType;
        switch ([options Type]) {
            case ImageTypeJPG:       imageType = @"JPG"; break;
            case ImageTypeJPEG:      imageType = @"JPEG"; break;
            case ImageTypeJPEG2000:  imageType = @"JPEG2000"; break;
            case ImageTypePNG:       imageType = @"PNG"; break;
            case ImageTypeBMP:       imageType = @"BMP"; break;
            case ImageTypeTIFF:      imageType = @"TIFF"; break;
            case ImageTypeTGA:       imageType = @"TGA"; break;
            case ImageTypeGIF:       imageType = @"GIF"; break;
            case ImageTypeWEBP:      imageType = @"WEBP"; break;
            default: break;
        }
        NSString *left = [@"Image Type:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, imageType];
    }
    
    if ([options respondsToSelector:@selector(Scaling)]) {
        NSString *left = [@"Scaling Factor:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%.2f\n", left, [options Scaling]];
    }
    
    if ([options respondsToSelector:@selector(pageRanges)]) {
        NSString *pageRanges = [options pageRanges];
        if (pageRanges.length > 0) {
            NSString *left = [@"Page Ranges:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
            [optionsDescription appendFormat:@"%@%@\n", left, pageRanges];
        }
    }

    if ([options respondsToSelector:@selector(output_document_per_page)]) {
        NSString *left = [@"Output Per Page:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        BOOL v = ((BOOL)[options output_document_per_page]);
        [optionsDescription appendFormat:@"%@%@\n", left, v ? @"Yes" : @"No"];
    }
    if ([options respondsToSelector:@selector(contain_page_background_image)]) {
        NSString *left = [@"Background Image:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        BOOL v = ((BOOL)[options contain_page_background_image]);
        [optionsDescription appendFormat:@"%@%@\n", left, v ? @"Yes" : @"No"];
    }
    if ([options respondsToSelector:@selector(auto_create_folder)]) {
        NSString *left = [@"Auto Create Folder:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        BOOL v = ((BOOL)[options auto_create_folder]);
        [optionsDescription appendFormat:@"%@%@\n", left, v ? @"Yes" : @"No"];
    }
    if ([options respondsToSelector:@selector(ocrOption)]) {
        NSString *left = [@"OCR Option:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        NSString *val = @"Unknown";
        if ([options ocrOption] == OCROptionAll) val = @"All";
        else if ([options ocrOption] == OCROptionInvalidCharacter) val = @"Invalid Character";
        else if ([options ocrOption] == OCROptionScanPage) val = @"Scan Page";
        else if ([options ocrOption] == OCROptionInvalidCharacterAndScanPage) val = @"Invalid+Scan";
        [optionsDescription appendFormat:@"%@%@\n", left, val];
    }
    if ([options respondsToSelector:@selector(languages)]) {
        NSArray<NSNumber *> *languages = [options languages];
        if (languages.count > 0) {
            NSMutableArray<NSString *> *labels = [NSMutableArray arrayWithCapacity:languages.count];
            for (NSNumber *language in languages) {
                [labels addObject:[self titleForOCRLanguage:(OCRLanguage)language.integerValue]];
            }
            NSString *left = [@"OCR Languages:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
            [optionsDescription appendFormat:@"%@%@\n", left, [labels componentsJoinedByString:@", "]];
        }
    }
    if ([options respondsToSelector:@selector(fontName)]) {
        NSString *fontName = [options fontName];
        if (fontName.length > 0) {
            NSString *left = [@"Font Name:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
            [optionsDescription appendFormat:@"%@%@\n", left, fontName];
        }
    }
    
    [self appendLogMessage:optionsDescription];
}

- (NSArray<NSNumber *> *)selectedOCRLanguages {
    NSInteger idx = [self.ocrLanguagePopUp indexOfSelectedItem];
    if (idx < 0) {
        idx = OCRLanguageAuto;
    }
    return @[@((OCRLanguage)idx)];
}

- (NSString *)selectedOCRLanguageTitle {
    NSInteger idx = [self.ocrLanguagePopUp indexOfSelectedItem];
    if (idx < 0) {
        idx = OCRLanguageAuto;
    }
    return [self titleForOCRLanguage:(OCRLanguage)idx];
}

- (NSString *)titleForOCRLanguage:(OCRLanguage)language {
    switch (language) {
        case OCRLanguageUnknown: return @"Unknown";
        case OCRLanguageChinese: return @"Chinese (Simplified)";
        case OCRLanguageChineseTraditional: return @"Chinese (Traditional)";
        case OCRLanguageEnglish: return @"English";
        case OCRLanguageKorean: return @"Korean";
        case OCRLanguageJapanese: return @"Japanese";
        case OCRLanguageLatin: return @"Latin";
        case OCRLanguageDevanagari: return @"Devanagari";
        case OCRLanguageCyrillic: return @"Cyrillic";
        case OCRLanguageArabic: return @"Arabic";
        case OCRLanguageTamil: return @"Tamil";
        case OCRLanguageTelugu: return @"Telugu";
        case OCRLanguageKannada: return @"Kannada";
        case OCRLanguageThai: return @"Thai";
        case OCRLanguageGreek: return @"Greek";
        case OCRLanguageEslav: return @"Eslav";
        case OCRLanguageAuto: return @"Auto";
    }
}

- (OCROption)currentOCROption {
    NSInteger idx = [self.ocrOptionPopUp indexOfSelectedItem];
    switch (idx) {
        case 0: return OCROptionAll;
        case 1: return OCROptionInvalidCharacter;
        case 2: return OCROptionScanPage;
        case 3: return OCROptionInvalidCharacterAndScanPage;
        default: return OCROptionAll;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)ocrLanguageChanged:(NSPopUpButton *)sender {
    (void)sender;
    [self appendLogMessage:[NSString stringWithFormat:@"Selected OCR language: %@", [self selectedOCRLanguageTitle]]];
}

@end