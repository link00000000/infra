#pragma once

#include <gtk/gtk.h>

class WorkspaceWidget
{
public:
    explicit WorkspaceWidget();

    GtkWidget* getGtkWidget() const;

private:
    GtkWidget* m_gtkLabelWidget;
};
