#include "BarWidget.h"
#include "WorkspaceWidget.h"

BarWidget::BarWidget()
{
    m_gtkBoxWidget = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_widget_set_halign(m_gtkBoxWidget, GTK_ALIGN_START);
    gtk_widget_set_valign(m_gtkBoxWidget, GTK_ALIGN_CENTER);

    GtkWidget* label = gtk_label_new("Hello, world");
    gtk_box_append(GTK_BOX(m_gtkBoxWidget), label);

    auto workspaceWidget = new WorkspaceWidget();
    gtk_box_append(GTK_BOX(m_gtkBoxWidget), workspaceWidget->getGtkWidget());
}

GtkWidget* BarWidget::GetGtkWidget() const
{
    return m_gtkBoxWidget;
}
