file(GLOB QML_JS_FILES *.qml *.js)

# Make the files visible on qtcreator
add_custom_target(mircast_components_QMlFiles ALL SOURCES ${QML_JS_FILES})

install(FILES ${QML_JS_FILES} DESTINATION ${MIRCAST_DIR}/components)

