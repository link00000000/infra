#pragma once

#include <gtk/gtk.h>
#include <memory>

#include "BarWidget.h"

class Application
{
public:
  Application();
  ~Application();

  GtkApplication* GetGtkApplication() const;

  void OnActivated();

  int Run(int argc, char** argv);

private:
  GtkApplication* m_GtkApplication;

  std::unique_ptr<class Window> m_Window;
  std::unique_ptr<BarWidget> m_BarWidget;
};

