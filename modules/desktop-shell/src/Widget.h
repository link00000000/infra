#pragma once

#include <gtk/gtk.h>

class Widget
{
public:
    GtkWidget* getRootGtkWidget() const;

protected:
    void setRootGtkWidget(GtkWidget* inGtkWidget);

private:
    GtkWidget* m_RootGtkWidget;
};
