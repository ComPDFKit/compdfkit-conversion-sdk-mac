# ComPDF Conversion SDK for Mac

As part of the KDAN ecosystem, ComPDF Conversion SDK empowers your macOS applications to convert PDF files into editable Office documents, images, HTML, and more — with a native Objective-C API. Whether you're building a document editor, a file converter, or a productivity tool for Mac users, you can integrate high-quality PDF conversion that preserves layout, tables, and formatting.

> If you find this library helpful, please consider giving us a ⭐ **Star** on GitHub! Have feedback or questions? Join the conversation in our [Discussions](https://github.com/ComPDFKit/compdfkit-conversion-sdk-mac/discussions).

**Supported Features**

* Convert PDF to Word (.docx)

* Convert PDF to Excel (.xlsx)

* Convert PDF to PowerPoint (.pptx)

* Convert PDF to HTML (.html)

* Convert PDF to CSV (.csv)

* Convert PDF to Image (.png, .jpg, .jpeg, .jpeg2000, .bmp, .tiff, .tga, .gif, .webp)

* Convert PDF to Plain Text (.txt)

* Convert PDF to Rich Text Format (.rtf)

* Convert PDF to Searchable PDF (.pdf)

* Convert PDF to Structured Data (.json)

* Convert PDF to Markdown (.md)

* Convert PDF to OFD (.ofd)

* Optical Character Recognition (OCR)

* Layout Analysis

* Table Recognition

## Table of Contents

* [Why ComPDF Conversion SDK](#why-compdf-conversion-sdk)

* [Conversion Quality Preview](#conversion-quality-preview)

* [Requirements](#requirements)

* [How to Run a Demo](#how-to-run-a-demo)

* [How to Make a Mac Program in Objective-C with ComPDF Conversion SDK](#how-to-make-a-mac-program-in-objective-c-with-compdf-conversion-sdk)

* [License and Free Trial](#license-and-free-trial)

* [Changelog](#changelog)

* [Technical Support](#technical-support)

* [Developer Guides for All Features](#developer-guides-for-all-features)

* [FAQ](#faq)
  
## **Why ComPDF Conversion SDK**
- **Mature Technology:** With years of technology accumulation, we have established a complete mechanism of product iteration to offer a continuous guarantee for product competitiveness.

- **High-Fidelity Conversion:** Designed to preserve layout, tables, text structure, and formatting in the output files.

- **AI-Enhanced Conversion:** Continuously improved for complex layout analysis, table recognition, OCR, and editable output.

- **Independent Intellectual Property Rights:** Our technology is independent and compliant with ISO, helping enterprises conduct international business without considering copyright risks.

- **High-quality Service:** We provide 24/7 professional one-to-one technical support, including onsite service and remote assistance via phone and email.

## Conversion Quality Preview

With **AI table recognition, AI layout analysis, and OCR capabilities**, ComPDF Conversion SDK delivers accurate PDF conversion results. Simply select the appropriate conversion parameters based on your document type to achieve accurate document reconstruction. Below, we demonstrate the power of the ComPDF Conversion SDK by converting PDFs to Word, Excel, or searchable PDF files. Contact us to get a demo and experience our product's performance firsthand.

![conversion sdk performance GIF](./Images/conversion%20sdk%20performance%20GIF.gif)

### Convert PDF to Word

ComPDF Conversion SDK accurately restores all content and images, complex structures, paragraph aggregation, natural reading order, text styles, bold formatting, fonts, multi‑column layouts, image-text positioning, ordered lists, and more. Get a fully editable Word document that looks exactly like the original PDF.

![conversion sdk performance GIF](./Images/Performance%20-%20PDF%20to%20Word.png)

### Convert PDF to Excel

Extract standard tables and borderless tables with precision, preserve the content and images inside table cells, and retain text styles such as bold and color. ComPDF Conversion SDK turns PDF tables into fully functional Excel spreadsheets without losing structure or formatting.

![Conversion SDK: PDF to Excel](./Images/Performance%20-%20PDF%20to%20Excel.png)

### Convert Scanned PDF to editable text

Convert scanned documents and scanned PDFs into searchable PDFs while perfectly preserving the original layout and formatting. Every word becomes searchable, locatable, and selectable – ready for copying just like native digital text.

![conversion sdk performance GIF](./Images/Performance%20-%20PDF%20to%20searchable%20PDF.png)

## Requirements

| Platform | System Requirements                              | Development Environment | Notes                                                        |
| -------- | ------------------------------------------------ | ----------------------- | ------------------------------------------------------------ |
| Mac      | macOS 10.14 or higher (Intel and Apple Silicon). | Xcode 13.0 or later.    | Samples have been tested on Mac Intel and Mac Apple Silicon. |

## How to Run a Demo

ComPDF Conversion SDK for Mac provides a demo in the **"samples"** folder. Follow these steps to run it:

1. Open a terminal window and navigate to the **"samples"** folder of the Mac SDK package.
2. Enter the following command to run the demo:

```shell
./RunDemo.sh
```

Output files will be generated in the **"samples/output_files"** folder.

## How to Make a Mac Program in Objective-C with ComPDF Conversion SDK

### Create a New Mac Project

1. Fire up Xcode, choose **File** -> **New** -> **Project...**, and then select **macOS** -> **App**.
2. Choose the options for your new project and click **Next**.
3. Place the project to the location as desired. Then, click **Create**.

### Add ComPDF Conversion SDK Package

Once Xcode creates the project, add the _**CPDFConversion.framework**_ to it by following steps:

* In the Project navigator, click on the project name at the top of the left sidebar.

* Click on the target you want to add the framework to.

* Select the **General** tab at the top of the main editor area.

* Scroll down to the **Linked Frameworks and Libraries** section.

* Click the **+** button to add a new framework.
  
  * In the dialog that appears, select ***"CPDFConversion.framework"***, and click **Add**.
  
  * Ensure that the **Embed** option for the content added in **General** -> **Frameworks, Libraries, and Embedded Content** is set to **Embed & Sign**.
  
  * Ensure that the **Signing Certificate** option in **Signing & Capabilities** -> **Signing** is set to **Development**.

Now that you've added the ***"CPDFConversion.framework"*** to your project.

## License and Free Trial

### Get Free Trial License

[Contact our sales team](https://www.compdf.com/contact-sales?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac) and we'll send you a 30-day free trial license for ComPDF Conversion SDK.

### Get Commercial License

ComPDF Conversion SDK is a commercial SDK that requires a license for application release. Any documents, sample code, or source code distribution from the released package of ComPDF to any third party is prohibited. To get commercial license for ComPDF Conversion SDK, feel free to [contact our sales team](https://www.compdf.com/contact-sales?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac).

For Mac Conversion SDK, the commercial license must be bound to your developer device ID ([How to find the developer device ID](https://www.compdf.com/faq/how-to-find-the-device-id?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac)), and each license is only valid for one device ID in development mode.

### Apply the License Key

If you haven't get a license key, please check out [how to obtain a license key](/guides/conversion-sdk/objectivec/requirements). ComPDF Conversion SDK currently supports offline authentication to verify license keys.

*Learn more:* [*What is the authentication mechanism of ComPDF's license?*](https://www.compdf.com/faq/authentication-mechanism-of-compdfkit-license?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac)

**Copy the License Key:**

Accurately obtaining the license key is crucial for the application of the license.

1. In the email you received, locate the XML file containing the license key.
2. Open the XML file, and determine the license type based on the `<type>` field. If `<type>online</type>` is present, it indicates an online license. If `<type>offline</type>` is present or if the field is absent, it indicates an offline license.
- **Online License:**
  
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <license version="1">
          <platform>mac</platform>
          <starttime>xxxxxxxx</starttime>
          <endtime>xxxxxxxx</endtime>
          <type>online</type>
          <key>LICENSE_KEY</key>
      </license>

- **Offline License**:
  
  ```xml
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <license version="1">
      <platform>mac</platform>
      <starttime>xxxxxxxx</starttime>
      <endtime>xxxxxxxx</endtime>
      <key>LICENSE_KEY</key>
  </license>
  ```
3. Copy the value located at the LICENSE_KEY position within the `<key>LICENSE_KEY</key>` field. This is your license key.

**Apply the License Key**

You can perform offline authentication using the following method:

Before using the classes and methods of the ComPDF Conversion SDK in your project, you need to initialize the SDK with a valid license key. If you don't have a license key, feel free to contact the [ComPDF team](https://www.compdf.com/contact-sales?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac) to obtain one.

```objective-c
#import <Foundation/Foundation.h>
#import "conversion.h"
#import "common.h"

ErrorCode code = [LibraryManager licenseVerify:@"<your_license_string>"];
if (code != ErrorCodeSuccess) {
    return;
}

ErrorCode xmlCode = [LibraryManager licenseVerify:@"/path/to/license.xml"];
if (xmlCode != ErrorCodeSuccess) {
    return;
}
```

## Developer Guides for All Features

ComPDF Conversion SDK provides a wide range of customizable conversion options, such as whether to include images or annotations in PDF documents during file conversion, enable OCR, perform layout analysis, and more. Explore the [guides](https://www.compdf.com/guides/conversion-sdk/objectivec/overview?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac) for sample code and learn how to customize conversions for the following features.

- Initialize Library Resources
- Get Conversion Progress
- Cancel Conversion Task
- Select Page Range
- Conversion Options: Contain Image & Annotation
- Page Layout Mode
- OCR
- Layout Analysis
- Table Recognition
- Use Custom AI Models via Callbacks (v4.1.0+)
- Output Font Option
- Convert PDF to Word
- Convert PDF to Excel
- Convert PDF to PPT
- Convert PDF to HTML
- Convert PDF to CSV
- Convert PDF to Image
- Convert PDF to RTF
- Convert PDF to TXT
- Convert PDF to Searchable PDF
- Convert PDF to OFD
- Releasing Library Resources
- Extract PDF to JSON
- Extract PDF to Markdown

### FAQ

* Does OCR work on x86 architecture?
  Currently, the OCR only works on x64 architecture.
- [More FAQ](https://www.compdf.com/faq?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac)

## Changelog

Go to our [changelog](https://www.compdf.com/conversion-sdk/changelog-mac?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac) to keep up with the latest updates, improvements, and bug fixes.

## Technical Support

Thanks for your interest in ComPDF Conversion SDK, the easy-to-use and powerful development solution. If you encounter technical questions or bug issues when using ComPDF Conversion SDK, please submit the problem report to the [ComPDF team](mailto:support@compdf.com). More information as follows would help us to solve your problem:

- ComPDF Conversion SDK product and version.
- Your operating system and IDE version.
- Detailed descriptions of the problem.
- Any other related information, such as an error screenshot.

Home link: [https://www.compdf.com](https://www.compdf.com/?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac)

Technical Support: [https://www.compdf.com/support](https://www.compdf.com/support?utm_source=github_readme_conversion_sdk_mac&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_mac)

Email: [support@compdf.com](mailto:support@compdf.com)

