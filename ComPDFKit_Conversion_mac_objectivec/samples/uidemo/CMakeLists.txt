cmake_minimum_required(VERSION 3.12)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    set(CMAKE_OSX_ARCHITECTURES "x86_64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm")
    set(CMAKE_OSX_ARCHITECTURES "arm64")
endif()

message(${CMAKE_SYSTEM_PROCESSOR})
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15")

if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    set(PROJECT_TEST_NAME "uidemo_x64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm")
    set(PROJECT_TEST_NAME "uidemo_arm64")
endif()

message(${PROJECT_TEST_NAME})

project(${PROJECT_TEST_NAME} LANGUAGES C CXX OBJC OBJCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_OBJC_STANDARD 11)
set(CMAKE_OBJCXX_STANDARD 17)

set(COMPDKIT_CONVERSION_SDK_VERSION ${PROJECT_VERSION})


include_directories(${CMAKE_SOURCE_DIR}/include)

set(RESOURCE_FILES)
file(GLOB RESOURCE_FILES "${CMAKE_SOURCE_DIR}/resource/*")

set(UIDEMO_SRC
    main.m
    AppDelegate.m
    ViewController.m
)

add_executable(${PROJECT_TEST_NAME} ${UIDEMO_SRC})

set_target_properties(${PROJECT_TEST_NAME} PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER com.compdfkit.conversion
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
    RESOURCE "MainMenu.xib"
    INSTALL_RPATH "@executable_path/../Frameworks"
    BUILD_WITH_INSTALL_RPATH TRUE
)

target_compile_options(${PROJECT_TEST_NAME} PRIVATE
    -fobjc-arc
)

find_library(COCOA_LIBRARY Cocoa REQUIRED)
find_library(FOUNDATION_LIBRARY Foundation REQUIRED)
find_library(APPKIT_LIBRARY AppKit REQUIRED)
find_library(UNIFORM_TYPE_IDENTIFIERS_LIBRARY UniformTypeIdentifiers)

set(COMPDFKIT_WRAPPER_LIB ${CMAKE_SOURCE_DIR}/../../lib/compdfkitconversionsdk_objective_c)


target_link_libraries(${PROJECT_TEST_NAME} PRIVATE
    objc
    ${COCOA_LIBRARY}
    ${FOUNDATION_LIBRARY}
    ${APPKIT_LIBRARY}
    ${UNIFORM_TYPE_IDENTIFIERS_LIBRARY}
    ${COMPDFKIT_WRAPPER_LIB}
)

file(COPY ${RESOURCE_FILES} DESTINATION ${CMAKE_BINARY_DIR}/resource)


if(CMAKE_OSX_ARCHITECTURES MATCHES "x86_64")
    file(GLOB MODEL_FILES "${CMAKE_SOURCE_DIR}/../../resource/models/*")
    file(GLOB FONT_FILES "${CMAKE_SOURCE_DIR}/../../resource/fonts/*")
    file(COPY ${MODEL_FILES} DESTINATION "${CMAKE_BINARY_DIR}/uidemo_x64.app/Contents/Resources/models")
    file(COPY ${FONT_FILES} DESTINATION "${CMAKE_BINARY_DIR}/uidemo_x64.app/Contents/Resources/fonts")

    add_custom_command(TARGET uidemo_x64 POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Resources/models"
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Resources/fonts"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/../../resource/models"
        "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Resources/models"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/../../resource/fonts"
        "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Resources/fonts"
    )
    add_custom_command(TARGET uidemo_x64 POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Frameworks"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${CMAKE_SOURCE_DIR}/../../lib"
            "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_x64>/Frameworks"
    )
elseif(CMAKE_OSX_ARCHITECTURES MATCHES "arm64")
    file(GLOB MODEL_FILES "${CMAKE_SOURCE_DIR}/../../resource/models/*")
    file(GLOB FONT_FILES "${CMAKE_SOURCE_DIR}/../../resource/fonts/*")
    file(COPY ${MODEL_FILES} DESTINATION "${CMAKE_BINARY_DIR}/uidemo_arm64.app/Contents/Resources/models")
    file(COPY ${FONT_FILES} DESTINATION "${CMAKE_BINARY_DIR}/uidemo_arm64.app/Contents/Resources/fonts")

    add_custom_command(TARGET uidemo_arm64 POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Resources/models"
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Resources/fonts"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/../../resource/models"
        "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Resources/models"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/../../resource/fonts"
        "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Resources/fonts"
    )

    add_custom_command(TARGET uidemo_arm64 POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Frameworks"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/../../lib"
        "$<TARGET_BUNDLE_CONTENT_DIR:uidemo_arm64>/Frameworks"
    )
endif()


