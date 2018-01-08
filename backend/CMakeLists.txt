include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Mircastbackend_SRCS
    modules/Mircast/backend.cpp
    modules/Mircast/launcher.cpp
)

# Make the unit test files visible on qtcreator
add_custom_target(Mircastbackend_UNITTEST_QML_FILES ALL SOURCES "tests/unit/tst_launcher.qml")

add_library(Mircastbackend MODULE
    ${Mircastbackend_SRCS}
)

set_target_properties(Mircastbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Mircast)

qt5_use_modules(Mircastbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Mircastbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Mircast/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Mircast
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS Mircastbackend DESTINATION ${QT_IMPORTS_DIR}/Mircast/)
install(FILES   modules/Mircast/qmldir DESTINATION ${QT_IMPORTS_DIR}/Mircast/)
