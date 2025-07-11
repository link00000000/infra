#pragma once

#include <gtk/gtk.h>
#include <memory>

#include "BarWidget.h"

class Window;

class Application
{
public:
    Application();
    ~Application();

    GtkApplication* getGtkApplication() const;

    void onActivated();

    int run(int argc, char** argv);

private:
    GtkApplication* m_gtkApplication;

    std::unique_ptr<Window> m_window;
    std::unique_ptr<BarWidget> m_barWidget;
};
