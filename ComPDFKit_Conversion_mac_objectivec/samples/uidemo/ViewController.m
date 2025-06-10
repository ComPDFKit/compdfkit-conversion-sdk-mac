#import "ViewController.h"
#include <AppKit/AppKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    NSRect frame = NSMakeRect(0, 0, 700, 900); 
    NSView *view = [[NSView alloc] initWithFrame:frame];
    self.view = view;
    
    [self setupUI];
}

- (void)setupUI {
    self.inputPathField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 850, 500, 28)];
    self.inputPathField.placeholderString = @"Input PDF Path";
    [self.view addSubview:self.inputPathField];
    
    self.chooseInputBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 850, 140, 28)];
    [self.chooseInputBtn setTitle:@"Choose File"];
    [self.chooseInputBtn setBezelStyle:NSBezelStyleRounded];
    [self.chooseInputBtn setTarget:self];
    [self.chooseInputBtn setAction:@selector(chooseInput:)];
    [self.view addSubview:self.chooseInputBtn];

    self.outputPathField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 810, 500, 28)];
    self.outputPathField.placeholderString = @"Output Directory";
    [self.view addSubview:self.outputPathField];
    
    self.chooseOutputBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 810, 140, 28)];
    [self.chooseOutputBtn setTitle:@"Choose Directory"];
    [self.chooseOutputBtn setBezelStyle:NSBezelStyleRounded];
    [self.chooseOutputBtn setTarget:self];
    [self.chooseOutputBtn setAction:@selector(chooseOutput:)];
    [self.view addSubview:self.chooseOutputBtn];
    
    self.convertTypePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(20, 770, 220, 28)];
    [self.convertTypePopUp addItemWithTitle:@"PDF to Word"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to Excel"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to PPT"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to HTML"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to RTF"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to Image"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to TXT"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to JSON"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to Searchable PDF"];
    [self.convertTypePopUp addItemWithTitle:@"PDF to Markdown"];
    [self.convertTypePopUp setTarget:self];
    [self.convertTypePopUp setAction:@selector(conversionTypeChanged:)];
    [self.view addSubview:self.convertTypePopUp];
    
    self.startConvertBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 770, 140, 28)];
    [self.startConvertBtn setTitle:@"Start Convert"];
    [self.startConvertBtn setBezelStyle:NSBezelStyleRounded];
    [self.startConvertBtn setTarget:self];
    [self.startConvertBtn setAction:@selector(startConvert:)];
    [self.view addSubview:self.startConvertBtn];
    
    self.cancelConvertBtn = [[NSButton alloc] initWithFrame:NSMakeRect(540, 730, 140, 28)];
    [self.cancelConvertBtn setTitle:@"Cancel Convert"];
    [self.cancelConvertBtn setBezelStyle:NSBezelStyleRounded];
    [self.cancelConvertBtn setTarget:self];
    [self.cancelConvertBtn setAction:@selector(cancelConvert:)];
    [self.cancelConvertBtn setEnabled:NO];
    [self.view addSubview:self.cancelConvertBtn];
    
    self.logScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(20, 20, 660, 260)];
    self.logScrollView.hasVerticalScroller = YES;
    self.logScrollView.hasHorizontalScroller = NO;
    self.logScrollView.autohidesScrollers = YES;
    self.logScrollView.borderType = NSBezelBorder;
    
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
    
    self.optionsContainerView = [[NSView alloc] initWithFrame:NSMakeRect(20, 300, 660, 500)];
    [self.view addSubview:self.optionsContainerView];
    
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
    [self.pageLayoutModePopUp addItemWithTitle:@"Flow Layout"];
    [self.pageLayoutModePopUp addItemWithTitle:@"Box Layout"];
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
    [self.imageTypePopUp addItemWithTitle:@"PNG"];
    [self.imageTypePopUp addItemWithTitle:@"BMP"];
    [self.imageTypePopUp addItemWithTitle:@"TIFF"];
    
    NSTextField *scalingLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 30, 100, 20)];
    [scalingLabel setBezeled:NO];
    [scalingLabel setDrawsBackground:NO];
    [scalingLabel setEditable:NO];
    [scalingLabel setSelectable:NO];
    [scalingLabel setStringValue:@"Scaling Factor:"];
    
    self.scalingTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, 30, 50, 20)];
    self.scalingTextField.stringValue = @"1.0";
    
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
    
    NSTextField *ocrLanguageLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(280, 244, 120, 20)];
    [ocrLanguageLabel setBezeled:NO];
    [ocrLanguageLabel setDrawsBackground:NO];
    [ocrLanguageLabel setEditable:NO];
    [ocrLanguageLabel setSelectable:NO];
    [ocrLanguageLabel setStringValue:@"OCR Language:"];
    
    self.ocrLanguagePopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 240, 160, 24)];
    [self.ocrLanguagePopUp addItemWithTitle:@"Auto"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Chinese (Simplified)"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Chinese (Traditional)"];
    [self.ocrLanguagePopUp addItemWithTitle:@"English"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Korean"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Japanese"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Latin"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Devanagari"];
    [self.ocrLanguagePopUp addItemWithTitle:@"Unknown"];
    [self.ocrLanguagePopUp setTarget:self];
    [self.ocrLanguagePopUp setAction:@selector(ocrLanguageChanged:)];
    
    [self initializeSDK];
    
    [self conversionTypeChanged:self.convertTypePopUp];
    
    self.progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20, 280, 660, 20)];
    self.progressIndicator.indeterminate = NO;
    self.progressIndicator.minValue = 0;
    self.progressIndicator.maxValue = 100;
    self.progressIndicator.doubleValue = 0;
    self.progressIndicator.hidden = YES;
    [self.view addSubview:self.progressIndicator positioned:NSWindowAbove relativeTo:self.logScrollView];
}

- (void)initializeSDK {
    [self appendLogMessage:@"Initializing SDK..."];
    
    @try {
        NSInteger licenseResult = [LibraryManager licenseVerify:@"Pp60eH7/N9zSmJ9xTVVfYN3uKqW9HS2Vhhn7+LwHS3SbUtAsPQ84pJsMmqYu978Jz1TqrN8RjUp2ulRhGBHQ/aDBpwlkB0HUE75qz1ShXH0jr08yUkYl8XYnpmUG5OCPO7EjaPg0rukCDhRBfIPhi8TzeRLRDMoxNQXoceZL6nyKWW8lJ3ojqZ4380w+BRbCLVJc0zwjLlEFyKCRlEE0NBIBfYhmkoFyvpkbdMrMTDDtxJWTjAnTWUNORbub1BNcBTsZtSSJM5PaOltHcRmfXlaEjWIkrbX4WB/Szcjl2yVLkqHIK/4EBg8VP/BEmOJjkvNiKWSaY4aJ84vTgITBnK8kD+Q9C95FZo3W7DLPF5KHAYEs2RF7Z9toqEufbP3GkrSF8rrxDKX4enQyBHWqvLoHJxrWJG5/gzw4n+Iq587xlhKlaQWpSC71NmpYZS0Vkt5212I0f8MrprqSa2YdKs/4Wu10G7037suVOaNLq7oe1jpq/rY86x/3DCADjT8SEbQQ9Xg4/3r+aORj1MId+0gVusE/Tqjcp3dmNqQj/Ph0jJj9jGp7Z4V/0TqXDvJitafo14hiD8c+XZHmibaf0mSc1iVtuHBhZTFhkup+L6Qgh7kq7soeyX4bU2tS9R8/jF7i0/jKom3qTkre1u0IGRqKi/fNKu/e5CeMvqysL8EPO/pADHF3Jh+dAhOW0mnbj0AS+u6O6+BW4LrMR7cuVaekwwQvAr6a7Jt34MeZafigJYGkKbPZ1JJFMu1zbWRryFlTWilteBjIVCBY2NZalNy23wNRqyp7wrBUC7V7CW89KBUo0LkjrL4ZBCUfIBBAG/B1tCmblU/dMaf/0iiTsuubqZ7NNd50kLpVVQKy2BqM6sQqacODSuEteLvrE2lS"];
        
        [self appendLogMessage:[NSString stringWithFormat:@"License verification result: %@", licenseResult==0 ? @"Success" : @"Failure"]];
        
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
            NSInteger result = [LibraryManager setDocumentAIModel:modelPath ocrLanguage:OCRLanguageUnknown];
            [self appendLogMessage:[NSString stringWithFormat:@"OCR model setup result: %@", result==0 ? @"Success" : @"Failure"]];
            
            if (result != 0) {
                [self appendLogMessage:@"Failed to set OCR model. Some conversion operations may not work properly."];
            }
        } else {
            [self appendLogMessage:@"No valid OCR model path found. OCR functionality will be disabled."];
        }

        __weak typeof(self) weakSelf = self;
        [LibraryManager setProgress:^(int current, int total) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (total > 0) {
                    strongSelf.progressIndicator.hidden = NO;
                    strongSelf.progressIndicator.maxValue = total;
                    strongSelf.progressIndicator.doubleValue = current;
                } else {
                    strongSelf.progressIndicator.hidden = YES;
                }
                [strongSelf appendLogMessage:[NSString stringWithFormat:@"conversion rate: %d/%d", current, total]];
                if (current >= total && total > 0) {
                    strongSelf.progressIndicator.hidden = YES;
                    strongSelf.progressIndicator.doubleValue = 0;
                }
            });
        } isMT:YES];
        
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
    for (NSView *subview in [self.optionsContainerView subviews]) {
        [subview removeFromSuperview];
    }
    
    CGFloat baseY = 440;
    CGFloat rightY = 440;
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
    
    NSString *selectedTypeStr = [sender titleOfSelectedItem];
    if ([selectedTypeStr isEqualToString:@"PDF to Word"]) {
        self.selectedConversionType = ConversionTypePDFToWord;
    } else if ([selectedTypeStr isEqualToString:@"PDF to Excel"]) {
        self.selectedConversionType = ConversionTypePDFToExcel;
    } else if ([selectedTypeStr isEqualToString:@"PDF to PPT"]) {
        self.selectedConversionType = ConversionTypePDFToPPT;
    } else if ([selectedTypeStr isEqualToString:@"PDF to HTML"]) {
        self.selectedConversionType = ConversionTypePDFToHTML;
    } else if ([selectedTypeStr isEqualToString:@"PDF to RTF"]) {
        self.selectedConversionType = ConversionTypePDFToRTF;
    } else if ([selectedTypeStr isEqualToString:@"PDF to Image"]) {
        self.selectedConversionType = ConversionTypePDFToImage;
    } else if ([selectedTypeStr isEqualToString:@"PDF to TXT"]) {
        self.selectedConversionType = ConversionTypePDFToText;
    } else if ([selectedTypeStr isEqualToString:@"PDF to JSON"]) {
        self.selectedConversionType = ConversionTypePDFToJSON;
    } else if ([selectedTypeStr isEqualToString:@"PDF to Searchable PDF"]) {
        self.selectedConversionType = ConversionTypePDFToSearchablePDF;
    } else if ([selectedTypeStr isEqualToString:@"PDF to Markdown"]) {
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
    view.frame = NSMakeRect(rightLabelX, rightY, 200, 24); \
    [self.optionsContainerView addSubview:view]; \
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

    if ([selectedTypeStr isEqualToString:@"PDF to Image"]) {
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to Excel"]) {
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.csvFormatCheckBox setState:NSControlStateValueOff];
        [self.allContentCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW(self.csvFormatCheckBox);
        ADD_OPTION_VIEW(self.allContentCheckBox);
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to TXT"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.tableFormatCheckBox setState:NSControlStateValueOn];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW(self.tableFormatCheckBox);

        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);

    } else if ([selectedTypeStr isEqualToString:@"PDF to JSON"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.containTableCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW(self.containTableCheckBox);
        NSTextField *ocrLanguageLabel = [[NSTextField alloc] init];
        ocrLanguageLabel.stringValue = @"OCR Language:";
        ocrLanguageLabel.bezeled = NO;
        ocrLanguageLabel.drawsBackground = NO;
        ocrLanguageLabel.editable = NO;
        ocrLanguageLabel.selectable = NO;
        ADD_LABEL_RIGHT(ocrLanguageLabel);
        ADD_POPUP_RIGHT(self.ocrLanguagePopUp);
        baseY -= stepY;
    } else if ([selectedTypeStr isEqualToString:@"PDF to Searchable PDF"]) {
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.containImageCheckBox);
        self.ocrCheckBox.state = NSControlStateValueOn;
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to HTML"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to PPT"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to RTF"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to Word"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        [self.formulaToImageCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
        ADD_OPTION_VIEW(self.formulaToImageCheckBox);
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
    } else if ([selectedTypeStr isEqualToString:@"PDF to Markdown"]) {
        [self.enableAILayoutCheckBox setState:NSControlStateValueOn];
        [self.containAnnotationCheckBox setState:NSControlStateValueOn];
        [self.containImageCheckBox setState:NSControlStateValueOn];
        [self.ocrCheckBox setState:NSControlStateValueOff];
        ADD_OPTION_VIEW(self.ocrCheckBox);
        ADD_OPTION_VIEW(self.containImageCheckBox);
        ADD_OPTION_VIEW(self.containAnnotationCheckBox);
        ADD_OPTION_VIEW(self.enableAILayoutCheckBox);
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

#undef ADD_OPTION_VIEW
#undef ADD_OPTION_VIEW_RIGHT
#undef ADD_LABEL_RIGHT
#undef ADD_POPUP_RIGHT
}

- (void)chooseInput:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    if (@available(macOS 11.0, *)) {
        UTType *pdfType = [UTType typeWithIdentifier:@"com.adobe.pdf"];
        panel.allowedContentTypes = @[pdfType];
    } else {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        panel.allowedFileTypes = @[@"pdf"];
        #pragma clang diagnostic pop
    }
    
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
    
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:inputPath isDirectory:&isDirectory];
    
    if (isDirectory) {
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
        
        dispatch_queue_t queue = dispatch_queue_create("com.compdfkit.conversion.batchQueue", DISPATCH_QUEUE_SERIAL);
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
                [self appendLogMessage:@"Batch conversion completed"];
                self.startConvertBtn.enabled = YES;
                self.cancelConvertBtn.enabled = NO;
                self.progressIndicator.hidden = YES;
                self.progressIndicator.doubleValue = 0;
            });
        });
    } else {
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
    
    [CPDFConversion cancel];
    [self appendLogMessage:@"Conversion has been cancelled"];
    
    self.startConvertBtn.enabled = YES;
    self.cancelConvertBtn.enabled = NO;
    self.progressIndicator.doubleValue = 0;
    self.progressIndicator.hidden = YES;
}

- (NSString *)conversionTypeToString:(ConversionType)type {
    switch (type) {
        case ConversionTypePDFToWord:
            return @"PDF to Word";
        case ConversionTypePDFToExcel:
            return @"PDF to Excel";
        case ConversionTypePDFToPPT:
            return @"PDF to PPT";
        case ConversionTypePDFToHTML:
            return @"PDF to HTML";
        case ConversionTypePDFToRTF:
            return @"PDF to RTF";
        case ConversionTypePDFToImage:
            return @"PDF to Image";
        case ConversionTypePDFToText:
            return @"PDF to TXT";
        case ConversionTypePDFToJSON:
            return @"PDF to JSON";
        case ConversionTypePDFToSearchablePDF:
            return @"PDF to Searchable PDF";
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
    
    __block BOOL conversionInProgress = YES;
    __block id keepAliveObject = self;
    
    void(^completionCallback)(NSString *) = ^(NSString * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![progress isEqualToString:@"100"]) {
                [self appendLogMessage:[NSString stringWithFormat:@"Conversion progress: %@%%", progress]];
            } else {
                [self appendLogMessage:@"Conversion completed (100%)"];
                conversionInProgress = NO;
                keepAliveObject = nil;
            }
        });
    };
    
    if (conversionType == ConversionTypePDFToWord) {
        WordOptions *wordOptions = [[WordOptions alloc] init];
        wordOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        wordOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        wordOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        wordOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        wordOptions.formulaToImage = self.formulaToImageCheckBox.state == NSControlStateValueOn;
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        wordOptions.pageLayoutMode = (layoutMode == 0) ? PageLayoutModeFlow : PageLayoutModeBox;
        
        if (pageRanges.length > 0) {
            wordOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"docx"]];
        
        [self appendLogMessage:@"Starting PDF to Word conversion..."];
        [self logOptionsDetails:wordOptions];
        
        ErrorCode result = [CPDFConversion startPDFToWord:inputFilePath 
                                                      password:@""
                                                    outputPath:outputPath
                                                       options:wordOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToExcel) {
        ExcelOptions *excelOptions = [[ExcelOptions alloc] init];
        excelOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        excelOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        excelOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        excelOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        excelOptions.CSVFormat = self.csvFormatCheckBox.state == NSControlStateValueOn;
        excelOptions.AllContent = self.allContentCheckBox.state == NSControlStateValueOn;
        
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
        
        NSString *extension = excelOptions.CSVFormat ? @"csv" : @"xlsx";
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:extension]];
        
        [self appendLogMessage:@"Starting PDF to Excel conversion..."];
        [self logOptionsDetails:excelOptions];
        
        ErrorCode result = [CPDFConversion startPDFToExcel:inputFilePath 
                                                       password:@""
                                                     outputPath:outputPath
                                                        options:excelOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToPPT) {
        PptOptions *pptOptions = [[PptOptions alloc] init];
        pptOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        pptOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        pptOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        pptOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        
        if (pageRanges.length > 0) {
            pptOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"pptx"]];
        
        [self appendLogMessage:@"Starting PDF to PPT conversion..."];
        [self logOptionsDetails:pptOptions];
        
        ErrorCode result = [CPDFConversion startPDFToPpt:inputFilePath 
                                                     password:@""
                                                   outputPath:outputPath
                                                      options:pptOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToHTML) {
        HtmlOptions *htmlOptions = [[HtmlOptions alloc] init];
        htmlOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        htmlOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        htmlOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        htmlOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        htmlOptions.pageLayoutMode = (layoutMode == 0) ? PageLayoutModeFlow : PageLayoutModeBox;
        
        if (pageRanges.length > 0) {
            htmlOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"html"]];
        
        [self appendLogMessage:@"Starting PDF to HTML conversion..."];
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
                                                       options:htmlOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToRTF) {
        RtfOptions *rtfOptions = [[RtfOptions alloc] init];
        rtfOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        rtfOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        rtfOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        rtfOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        
        NSInteger layoutMode = [self.pageLayoutModePopUp indexOfSelectedItem];
        
        if (pageRanges.length > 0) {
            rtfOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"rtf"]];
        
        [self appendLogMessage:@"Starting PDF to RTF conversion..."];
        [self logOptionsDetails:rtfOptions];
        
        ErrorCode result = [CPDFConversion startPDFToRtf:inputFilePath 
                                                     password:@""
                                                   outputPath:outputPath
                                                      options:rtfOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToImage) {
        ImageOptions *imageOptions = [[ImageOptions alloc] init];
        imageOptions.PathEnhance = self.pathEnhanceCheckBox.state == NSControlStateValueOn;
        
        NSInteger colorMode = [self.imageColorModePopUp indexOfSelectedItem];
        NSInteger imageType = [self.imageTypePopUp indexOfSelectedItem];
        
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
        
        NSError *dirError;
        [[NSFileManager defaultManager] createDirectoryAtPath:imgOutputDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&dirError];
        
        if (dirError) {
            [self appendLogMessage:[NSString stringWithFormat:@"Failed to create image output directory: %@", dirError.localizedDescription]];
            return;
        }
        
        outputPath = outputDirPath;
        
        [self appendLogMessage:@"Starting PDF to Image conversion..."];
        [self logOptionsDetails:imageOptions];
        
        ErrorCode result = [CPDFConversion startPDFToImage:inputFilePath 
                                                       password:@""
                                                     outputPath:outputPath
                                                        options:imageOptions];
        
        [self handleConversionResult:result outputPath:imgOutputDir];
        
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
        txtOptions.TableFormat = self.tableFormatCheckBox.state == NSControlStateValueOn;
        
        if (pageRanges.length > 0) {
            txtOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"txt"]];
        
        [self appendLogMessage:@"Starting PDF to TXT conversion..."];
        [self logOptionsDetails:txtOptions];
        
        ErrorCode result = [CPDFConversion startPDFToTxt:inputFilePath 
                                                     password:@""
                                                   outputPath:outputPath
                                                      options:txtOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToJSON) {
        JsonOptions *jsonOptions = [[JsonOptions alloc] init];
        jsonOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        jsonOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        jsonOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        jsonOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        jsonOptions.ContainTable = self.containTableCheckBox.state == NSControlStateValueOn;
        
        if (pageRanges.length > 0) {
            jsonOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"json"]];
        
        [self appendLogMessage:@"Starting PDF to JSON conversion..."];
        [self logOptionsDetails:jsonOptions];
        
        ErrorCode result = [CPDFConversion startPDFToJson:inputFilePath 
                                                      password:@""
                                                    outputPath:outputPath
                                                       options:jsonOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    } else if (conversionType == ConversionTypePDFToSearchablePDF) {
        SearchablePdfOptions *searchablePdfOptions = [[SearchablePdfOptions alloc] init];
        searchablePdfOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        searchablePdfOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        
        if (pageRanges.length > 0) {
            searchablePdfOptions.pageRanges = pageRanges;
        }
        
        outputPath = [outputDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_searchable.pdf", fileNameBase]];
        
        [self appendLogMessage:@"Starting PDF to Searchable PDF conversion..."];
        [self logOptionsDetails:searchablePdfOptions];
        
        ErrorCode result = [CPDFConversion startPDFToSearchablePDF:inputFilePath 
                                                               password:@""
                                                             outputPath:outputPath
                                                                options:searchablePdfOptions];
        
        [self handleConversionResult:result outputPath:outputPath];
        
    }else if (conversionType == ConversionTypePDFToMarkdown) {
        MarkdownOptions *markdownOptions = [[MarkdownOptions alloc] init];
        markdownOptions.enableOCR = self.ocrCheckBox.state == NSControlStateValueOn;
        markdownOptions.containImage = self.containImageCheckBox.state == NSControlStateValueOn;
        markdownOptions.containAnnotation = self.containAnnotationCheckBox.state == NSControlStateValueOn;
        markdownOptions.enableAILayout = self.enableAILayoutCheckBox.state == NSControlStateValueOn;
        if (pageRanges.length > 0) {
            markdownOptions.pageRanges = pageRanges;
        }
        outputPath = [outputDirPath stringByAppendingPathComponent:[fileNameBase stringByAppendingPathExtension:@"md"]];
        [self appendLogMessage:@"Starting PDF to Markdown conversion..."];
        [self logOptionsDetails:markdownOptions];
        ErrorCode result = [CPDFConversion startPDFToMarkdown:inputFilePath
                                                    password:@""
                                                    outputPath:outputPath
                                                    options:markdownOptions];
        [self handleConversionResult:result outputPath:outputPath];
    } else {
        [self appendLogMessage:[NSString stringWithFormat:@"Unsupported conversion type: %@", [self conversionTypeToString:conversionType]]];
    }
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
    
    if ([options respondsToSelector:@selector(pageLayoutMode)]) {
        PageLayoutMode layoutMode = [options pageLayoutMode];
        NSString *left = [@"Page Layout Mode:" stringByPaddingToLength:22 withString:@" " startingAtIndex:0];
        [optionsDescription appendFormat:@"%@%@\n", left, (layoutMode == PageLayoutModeBox) ? @"Box Mode" : @"Flow Mode"];
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
            case ImageTypeJPG:
                imageType = @"JPG";
                break;
            case ImageTypePNG:
                imageType = @"PNG";
                break;
            case ImageTypeBMP:
                imageType = @"BMP";
                break;
            case ImageTypeTIFF:
                imageType = @"TIFF";
                break;
            default:
                imageType = @"Unknown";
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
    
    [self appendLogMessage:optionsDescription];
}

- (void)dealloc {

}

- (void)ocrLanguageChanged:(NSPopUpButton *)sender {
    NSInteger idx = [sender indexOfSelectedItem];
    OCRLanguage lang = OCRLanguageAuto;
    switch (idx) {
        case 0: lang = OCRLanguageAuto; break;
        case 1: lang = OCRLanguageChinese; break;
        case 2: lang = OCRLanguageChineseTraditional; break;
        case 3: lang = OCRLanguageEnglish; break;
        case 4: lang = OCRLanguageKorean; break;
        case 5: lang = OCRLanguageJapanese; break;
        case 6: lang = OCRLanguageLatin; break;
        case 7: lang = OCRLanguageDevanagari; break;
        case 8: lang = OCRLanguageUnknown; break;
    }
    [LibraryManager setOCRLanguage:lang];
}

@end