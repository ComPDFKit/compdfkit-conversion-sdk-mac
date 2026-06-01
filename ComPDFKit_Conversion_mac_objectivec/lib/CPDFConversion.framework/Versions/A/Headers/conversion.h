#import <Foundation/Foundation.h>
#import "common.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * @class CPDFConversion
 * @brief Provides functionalities to convert PDF files into various formats such as Word, Excel, PPT, HTML, etc.
 */
@interface CPDFConversion : NSObject

/**
 * @brief Starts the conversion of a PDF file to a Word document.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output Word file path
 * @param options Conversion settings (WordOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToWord:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(WordOptions * _Nonnull)options;

/// Per-call callback version (progress/cancel).
+ (ErrorCode)startPDFToWord:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(WordOptions * _Nonnull)options
                   progress:(COMProgressBlock _Nullable)progress
                     cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to an RTF document.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output RTF file path
 * @param options Conversion settings (RtfOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToRtf:(NSString * _Nonnull)filePath
                     password:(NSString * _Nonnull)password
                   outputPath:(NSString * _Nonnull)outputPath
                      options:(RtfOptions * _Nonnull)options;

+ (ErrorCode)startPDFToRtf:(NSString * _Nonnull)filePath
                  password:(NSString * _Nonnull)password
                outputPath:(NSString * _Nonnull)outputPath
                   options:(RtfOptions * _Nonnull)options
                  progress:(COMProgressBlock _Nullable)progress
                    cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to an Excel document.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output Excel file path
 * @param options Conversion settings (ExcelOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToExcel:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(ExcelOptions * _Nonnull)options;

+ (ErrorCode)startPDFToExcel:(NSString * _Nonnull)filePath
                    password:(NSString * _Nonnull)password
                  outputPath:(NSString * _Nonnull)outputPath
                     options:(ExcelOptions * _Nonnull)options
                    progress:(COMProgressBlock _Nullable)progress
                      cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to an HTML document.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output HTML file path
 * @param options Conversion settings (HtmlOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToHtml:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(HtmlOptions * _Nonnull)options;

+ (ErrorCode)startPDFToHtml:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(HtmlOptions * _Nonnull)options
                   progress:(COMProgressBlock _Nullable)progress
                     cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to images.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output image file path
 * @param options Conversion settings (ImageOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToImage:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(ImageOptions * _Nonnull)options;

+ (ErrorCode)startPDFToImage:(NSString * _Nonnull)filePath
                    password:(NSString * _Nonnull)password
                  outputPath:(NSString * _Nonnull)outputPath
                     options:(ImageOptions * _Nonnull)options
                    progress:(COMProgressBlock _Nullable)progress
                      cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to a TXT file.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output TXT file path
 * @param options Conversion settings (TxtOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToTxt:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(TxtOptions * _Nonnull)options;

+ (ErrorCode)startPDFToTxt:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(TxtOptions * _Nonnull)options
                   progress:(COMProgressBlock _Nullable)progress
                     cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to a JSON file.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output JSON file path
 * @param options Conversion settings (JsonOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToJson:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(JsonOptions * _Nonnull)options;

+ (ErrorCode)startPDFToJson:(NSString * _Nonnull)filePath
                    password:(NSString * _Nonnull)password
                  outputPath:(NSString * _Nonnull)outputPath
                     options:(JsonOptions * _Nonnull)options
                    progress:(COMProgressBlock _Nullable)progress
                      cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to a PowerPoint presentation.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output PPT file path
 * @param options Conversion settings (PptOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToPpt:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(PptOptions * _Nonnull)options;

+ (ErrorCode)startPDFToPpt:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(PptOptions * _Nonnull)options
                   progress:(COMProgressBlock _Nullable)progress
                     cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to a searchable PDF.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output searchable PDF file path
 * @param options Conversion settings (SearchablePdfOptions)

 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToSearchablePDF:(NSString * _Nonnull)filePath
                      password:(NSString * _Nonnull)password
                    outputPath:(NSString * _Nonnull)outputPath
                       options:(SearchablePdfOptions * _Nonnull)options;

+ (ErrorCode)startPDFToSearchablePDF:(NSString * _Nonnull)filePath
                          password:(NSString * _Nonnull)password
                        outputPath:(NSString * _Nonnull)outputPath
                           options:(SearchablePdfOptions * _Nonnull)options
                          progress:(COMProgressBlock _Nullable)progress
                            cancel:(COMCancelBlock _Nullable)cancel;

+ (ErrorCode)startPDFToMarkdown:(NSString * _Nonnull)filePath
                       password:(NSString * _Nonnull)password
                     outputPath:(NSString * _Nonnull)outputPath
                        options:(MarkdownOptions * _Nonnull)options;

+ (ErrorCode)startPDFToMarkdown:(NSString * _Nonnull)filePath
                       password:(NSString * _Nonnull)password
                     outputPath:(NSString * _Nonnull)outputPath
                        options:(MarkdownOptions * _Nonnull)options
                       progress:(COMProgressBlock _Nullable)progress
                         cancel:(COMCancelBlock _Nullable)cancel;

/**
 * @brief Starts the conversion of a PDF file to an OFD document.
 * @param filePath The input PDF file path
 * @param password Password for opening the PDF file (if required)
 * @param outputPath The output OFD file path
 * @param options Conversion settings (ConvertOptions)
 * @return Error code, 0 for success
 */
+ (ErrorCode)startPDFToOFD:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(OfdOptions * _Nonnull)options;

+ (ErrorCode)startPDFToOFD:(NSString * _Nonnull)filePath
                   password:(NSString * _Nonnull)password
                 outputPath:(NSString * _Nonnull)outputPath
                    options:(OfdOptions * _Nonnull)options
                   progress:(COMProgressBlock _Nullable)progress
                     cancel:(COMCancelBlock _Nullable)cancel;

@end

NS_ASSUME_NONNULL_END