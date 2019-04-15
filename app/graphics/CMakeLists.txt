file(GLOB GRAPHICS_FILES *.png *.svg)

# Make the files visible on qtcreator
add_custom_target(mircast_graphics_Files ALL SOURCES ${GRAPHICS_FILES})

install(FILES ${GRAPHICS_FILES} DESTINATION ${MIRCAST_DIR}/graphics)
