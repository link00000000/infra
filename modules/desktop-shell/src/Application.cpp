#include <gtk/gtk.h>

#include "Application.h"
#include "Window.h"

void OnGtkActivateSignalCallback(
    GtkApplication* GtkApplication, gpointer UserData)
{
    static_cast<class Application*>(UserData)->onActivated();
}

Application::Application()
{
    m_gtkApplication = gtk_application_new(
        "com.github.link00000000.DesktopShell", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(m_gtkApplication,
        "activate",
        G_CALLBACK(OnGtkActivateSignalCallback),
        this);
}

Application::~Application()
{
    g_object_unref(m_gtkApplication);
}

GtkApplication* Application::getGtkApplication() const
{
    return m_gtkApplication;
}

void Application::onActivated()
{
    m_window = std::make_unique<Window>(this);
    m_barWidget = std::make_unique<BarWidget>();

    gtk_widget_set_halign(m_barWidget->GetGtkWidget(), GTK_ALIGN_START);
    gtk_widget_set_valign(m_barWidget->GetGtkWidget(), GTK_ALIGN_CENTER);

    gtk_window_set_child(
        GTK_WINDOW(m_window->getGtkWidget()), m_barWidget->GetGtkWidget());

    gtk_widget_show(m_window->getGtkWidget());
}

int Application::run(int argc, char** argv)
{
    return g_application_run(G_APPLICATION(m_gtkApplication), argc, argv);
}
