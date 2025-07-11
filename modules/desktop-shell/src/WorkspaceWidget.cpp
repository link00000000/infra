#include "WorkspaceWidget.h"

WorkspaceWidget::WorkspaceWidget()
{
    m_gtkLabelWidget = gtk_label_new("OTHER");
}

GtkWidget* WorkspaceWidget::getGtkWidget() const
{
    return m_gtkLabelWidget;
}
