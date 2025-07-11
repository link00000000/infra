#pragma once

#include <gtk/gtk.h>

class BarWidget {
public:
  BarWidget();

  GtkWidget* GetGtkWidget() const;

private:
  GtkWidget* m_GtkBoxWidget;
};

