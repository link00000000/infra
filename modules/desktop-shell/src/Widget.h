#pragma once

#include <gtk/gtk.h>

class Widget
{
public:
    GtkWidget* GetRootGtkWidget() const;

protected:
    void SetRootGtkWidget(GtkWidget* inGtkWidget);

private:
    GtkWidget* m_RootGtkWidget;
};
