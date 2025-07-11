#include <gtk4-layer-shell.h>

#include "Application.h"
#include "Window.h"

Window::Window(class Application* application)
{
    m_gtkWindowWidget =
        gtk_application_window_new(application->getGtkApplication());
    gtk_window_set_title(GTK_WINDOW(m_gtkWindowWidget), "Desktop Shell");

    // Init layer shell
    gtk_layer_init_for_window(GTK_WINDOW(m_gtkWindowWidget));
    gtk_layer_set_layer(
        GTK_WINDOW(m_gtkWindowWidget), GTK_LAYER_SHELL_LAYER_TOP);
    gtk_layer_auto_exclusive_zone_enable(GTK_WINDOW(m_gtkWindowWidget));
    gtk_layer_set_anchor(
        GTK_WINDOW(m_gtkWindowWidget), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(
        GTK_WINDOW(m_gtkWindowWidget), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(
        GTK_WINDOW(m_gtkWindowWidget), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);

    gtk_window_set_decorated(GTK_WINDOW(m_gtkWindowWidget), FALSE);
    gtk_window_set_resizable(GTK_WINDOW(m_gtkWindowWidget), FALSE);
    gtk_window_set_default_size(GTK_WINDOW(m_gtkWindowWidget), 1920, 20);
}

GtkWidget* Window::getGtkWidget() const
{
    return m_gtkWindowWidget;
}
