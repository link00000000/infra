#include <gtk/gtk.h>

#include "Application.h"
#include "Window.h"

void OnGtkActivateSignalCallback(GtkApplication* GtkApplication, gpointer UserData)
{
  static_cast<class Application*>(UserData)->OnActivated();
}

Application::Application()
{
  m_GtkApplication = gtk_application_new("com.github.link00000000.DesktopShell", G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect(m_GtkApplication, "activate", G_CALLBACK(OnGtkActivateSignalCallback), this);
}

Application::~Application()
{
  g_object_unref(m_GtkApplication);
}

GtkApplication* Application::GetGtkApplication() const
{
  return m_GtkApplication;
}

void Application::OnActivated()
{
  m_Window = std::make_unique<Window>(this);
  m_BarWidget = std::make_unique<BarWidget>();

  gtk_widget_set_halign(m_BarWidget->GetGtkWidget(), GTK_ALIGN_START);
  gtk_widget_set_valign(m_BarWidget->GetGtkWidget(), GTK_ALIGN_CENTER);

  gtk_window_set_child(GTK_WINDOW(m_Window->GetGtkWidget()), m_BarWidget->GetGtkWidget());

  gtk_widget_show(m_Window->GetGtkWidget());
}

int Application::Run(int argc, char** argv)
{
  return g_application_run(G_APPLICATION(m_GtkApplication), argc, argv);
}


