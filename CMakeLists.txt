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

set(OpenCV_DIR "C:/opencv/OpenCV-MinGW-Build-OpenCV-4.5.5-x64")
find_package(OpenCV REQUIRED)
message(STATUS "OpenCV library status:")
message(STATUS "    config: ${OpenCV_DIR}")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

# --- Zint setup (direct include) ---
set(ZINT_ROOT "C:/zint")

target_include_directories(appBarcodeGenerator PRIVATE
    ${ZINT_ROOT}/include
    ${OpenCV_INCLUDE_DIRS}
)

target_link_libraries(appBarcodeGenerator PRIVATE
    Qt6::Quick
    ${ZINT_ROOT}/lib/zint.lib
    ${OpenCV_LIBS}
)

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
