cmake_minimum_required(VERSION 3.16)
project(desktop-shell VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED gtk4)
pkg_check_modules(GTK_LAYER_SHELL REQUIRED gtk4-layer-shell-0)

add_executable(desktop-shell
  src/Application.cpp
  src/BarWidget.cpp
  src/Window.cpp
  src/main.cpp
)
install(TARGETS desktop-shell
        RUNTIME DESTINATION bin)

target_include_directories(desktop-shell PRIVATE
    ${GTK4_INCLUDE_DIRS}
    ${GTK_LAYER_SHELL_INCLUDE_DIRS}
)

target_link_libraries(desktop-shell
    ${GTK4_LIBRARIES}
    ${GTK_LAYER_SHELL_LIBRARIES}
)

add_compile_options(${GTK4_CFLAGS_OTHER} ${GTK_LAYER_SHELL_CFLAGS_OTHER})
