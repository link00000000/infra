#pragma once

#include <gtk/gtk.h>

class Application;

class Window
{
public:
  explicit Window(Application* Application);

  GtkWidget* GetGtkWidget() const;

private:
  GtkWidget* m_GtkWindowWidget;
};
