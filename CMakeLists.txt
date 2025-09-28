cmake_minimum_required(VERSION 3.16)

project(BarcodeGenerator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appBarcodeGenerator
    main.cpp
)

qt_add_qml_module(appBarcodeGenerator
    URI BarcodeGenerator
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES barcodegenerator.h barcodegenerator.cpp
        SOURCES symbologies.h symbologies.cpp
        SOURCES barcodeimageprovider.h barcodeimageprovider.cpp
)

if(ANDROID)
    set(OpenCV_DIR "C:/opencv/OpenCV-android-sdk/sdk/native/jni")
else()
    set(OpenCV_DIR "C:/opencv/OpenCV-MinGW-Build-OpenCV-4.5.5-x64")
endif()
find_package(OpenCV REQUIRED)

if(ANDROID)
    set(ZINT_ROOT "C:/zint-android-install")
else()
    set(ZINT_ROOT "C:/zint")
endif()

target_include_directories(appBarcodeGenerator PRIVATE
    ${ZINT_ROOT}/include
    ${OpenCV_INCLUDE_DIRS}
)

if(ANDROID)
    # Import Zint shared library
    add_library(zint SHARED IMPORTED)
    set_target_properties(zint PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/android/libs/${ANDROID_ABI}/libzint.so"
    )

    target_link_libraries(appBarcodeGenerator PRIVATE
        Qt6::Quick
        ${OpenCV_LIBS}
        zint
    )
else()
    target_link_libraries(appBarcodeGenerator PRIVATE
        Qt6::Quick
        ${OpenCV_LIBS}
        ${ZINT_ROOT}/lib/zint.lib
    )
endif()



# --- Install ---
set_target_properties(appBarcodeGenerator PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)



include(GNUInstallDirs)
install(TARGETS appBarcodeGenerator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
