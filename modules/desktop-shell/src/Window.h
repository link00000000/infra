#pragma once

#include <gtk/gtk.h>

class Application;

class Window
{
public:
    explicit Window(Application* application);

    GtkWidget* getGtkWidget() const;

private:
    GtkWidget* m_gtkWindowWidget;
};
