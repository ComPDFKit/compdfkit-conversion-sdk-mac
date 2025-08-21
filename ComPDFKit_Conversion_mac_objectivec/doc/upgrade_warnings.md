# ComPDFKit Conversion SDK for Mac 3.1.0 Upgrade Warnings

This document contains a list of considerations that developers should be aware of when upgrading from previous versions to ComPDFKit Conversion SDK for Mac 3.1.0. Changes in the code may be necessary to ensure compatibility with the new version for your project to compile properly.

**Upgrading from version 3.0.0 to version 3.1.0**

If you are upgrading from version 3.0.0 to version 3.1.0, please note the following changes between version 3.0.0 and 3.1.0.

### Changes in the ImageType enum class:

1. Three new image format types have been added:

   - ImageTypeJPEG2000	
   - ImageTypeTGA     
   - ImageTypeGIF
   

### Changes in the ErrorCode enum class:

1. Added the following error codes to return the status when calling DocumentAI related interfaces:
   - ErrorCodeInvalidArg
   - ErrorCodeInvalidHandle
   - ErrorCodeModelInvalidFormat
   - ErrorCodeModelFunctionUnsupported
   - ErrorCodeModelFormatUnsupported
   - ErrorCodeModelSDKMismatch
   - ErrorCodeImageDataEmpty
   - ErrorCodeImageWHError
   - ErrorCodeImageUnsupportedFormat
   - ErrorCodeImageInvalid
   - ErrorCodeExpire
   - ErrorCodeMissingArg
   - ErrorCodeLicenseUnsupportedAPI
   - ErrorCodeLicenseMismatch
   - ErrorCodeInvalidTable