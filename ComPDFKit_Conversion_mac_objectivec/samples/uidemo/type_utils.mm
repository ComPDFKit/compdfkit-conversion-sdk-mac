#ifndef OBJC_CONVERT_UTILS_H
#define OBJC_CONVERT_UTILS_H

#import <Foundation/Foundation.h>
#import "include/base_type.h" 
#import "cpp-include/base_type.h" 

using namespace ComPDF;

inline
base::ConvertOptions ConvertFromObjectiveC(ConvertOptions *option) {
    if (!option) {
        return base::ConvertOptions(); 
    }   
    base::ConvertOptions cppOpt;

    // 基本布尔类型转换
    cppOpt.enable_ai_layout = option.enableAILayout;
    cppOpt.contain_image = option.containImage;
    cppOpt.json_contain_table = option.jsonContainTable;
    cppOpt.contain_annotation = option.containAnnotation;
    cppOpt.excel_all_content = option.excelAllContent;
    cppOpt.excel_csv_format = option.excelCSVFormat;
    cppOpt.formula_to_image = option.formulaToImage;
    cppOpt.enable_ocr = option.enableOCR;
    cppOpt.txt_table_format = option.txtTableFormat;
    cppOpt.image_path_enhance = option.imagePathEnhance;
    cppOpt.image_scaling = option.imageScaling;


    cppOpt.page_layout_mode = static_cast<base::PageLayoutMode>(option.pageLayoutMode);
    cppOpt.image_color_mode = static_cast<base::ImageColorMode>(option.imageColorMode);
    cppOpt.image_type = static_cast<base::ImageType>(option.imageType);
    cppOpt.excel_worksheet_option = static_cast<base::ExcelWorksheetOption>(option.excelWorksheetOption);
    cppOpt.html_option = static_cast<base::htmlPageOption>(option.htmlPageOption);


    if (option.pageRanges) {
        cppOpt.page_ranges = [option.pageRanges UTF8String];
    } else {
        cppOpt.page_ranges = "";
    }

    return cppOpt;
}


#endif // OBJC_CONVERT_UTILS_H