#include "BarWidget.h"

BarWidget::BarWidget()
{
  m_GtkBoxWidget = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
  gtk_widget_set_halign(m_GtkBoxWidget, GTK_ALIGN_START);
  gtk_widget_set_valign(m_GtkBoxWidget, GTK_ALIGN_CENTER);

  GtkWidget* label = gtk_label_new("Hello, world");
  gtk_box_append(GTK_BOX(m_GtkBoxWidget), label);
}

GtkWidget* BarWidget::GetGtkWidget() const
{
  return m_GtkBoxWidget;
}

