#import "base_type.h"
#import <Foundation/Foundation.h>




NS_ASSUME_NONNULL_BEGIN

@interface LayoutAnalysisResult : NSObject

@property (nonatomic, copy)   NSString  *label;
@property (nonatomic, assign) float     score;
@property (nonatomic, strong) NSArray   *rect;


@end

@interface CLine : NSObject

@property (nonatomic, assign) int startX;
@property (nonatomic, assign) int startY;
@property (nonatomic, assign) int endX;
@property (nonatomic, assign) int endY;

@end

@interface CRect : NSObject
@property (nonatomic, assign) int left;
@property (nonatomic, assign) int top;
@property (nonatomic, assign) int right;
@property (nonatomic, assign) int bottom;
@end


@interface CTextLine : NSObject
@property (nonatomic, assign) float score;
@property (nonatomic, assign) int textLength;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) CRect *bbox;
@end

@interface CTABResult : NSObject

@property (nonatomic, assign)  int num;
@property (nonatomic, assign)  int rowCount;
@property (nonatomic, assign)  int colCount;
@property (nonatomic, assign)  int angle;
@property (nonatomic, assign)  int score;
@property (nonatomic, copy)   NSString  *type;
@property (nonatomic, strong) NSArray   *rect;
@property (nonatomic, strong) NSArray   *heightOfRows;
@property (nonatomic, strong) NSArray   *widthOfCols;
@property (nonatomic, strong) NSArray<NSArray<CTextLine *> *>   *cellsText;
@property (nonatomic, strong) NSArray<CLine *>   *horizonLines;
@property (nonatomic, strong) NSArray<CLine *>   *verticalLines;
@property (nonatomic, strong) NSArray   *cells;
@property (nonatomic, copy) NSString   *jsonStr;
@property (nonatomic, copy) NSString   *htmlStr;

@end



@interface CTableCell : NSObject
@property (nonatomic, assign) int startRow;
@property (nonatomic, assign) int endRow;
@property (nonatomic, assign) int startCol;
@property (nonatomic, assign) int endCol;
@property (nonatomic, assign) int textLength;
@property (nonatomic, assign) int lineCount;
@property (nonatomic, assign) int cellBackgroundColorR;
@property (nonatomic, assign) int cellBackgroundColorG;
@property (nonatomic, assign) int cellBackgroundColorB;

@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) NSArray<CTextLine *> *lines;
@property (nonatomic, strong) CRect *bbox;
@end


@interface COCRResult : NSObject

@property (nonatomic, copy)   NSString  *text;
@property (nonatomic, assign) float     score;
@property (nonatomic, strong) NSArray   *rect;
@end

@interface CMAGICCOLORResult : NSObject

@property (nonatomic, strong) NSImage *image;

@end

@interface CDEWARPResult : NSObject

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSImage *image;

@end



@interface CPDFDocumentAI : NSObject

+ (ErrorCode)LayoutAnalysis:(NSString*)inputPath andResults:(NSMutableArray<LayoutAnalysisResult*> *)LayoutResult; 

+ (ErrorCode)Ocr:(NSString*)inputPath andResult:(NSMutableArray<COCRResult*> *)ocrResult;

+ (ErrorCode)MagicColor:(NSString*)inputPath andOutputImage:(CMAGICCOLORResult*)outputImage;

+ (ErrorCode)Dewarp:(NSString*)inputPath andOutputImage:(CDEWARPResult*)outputImage;

+ (ErrorCode)TableRec:(NSString*)inputPath andResult:(NSMutableArray<CTABResult*>*)tabResult;



@end


NS_ASSUME_NONNULL_END