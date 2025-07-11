#pragma once

#include <gtk/gtk.h>

#include "Widget.h"

class BarWidget : public Widget
{
public:
    BarWidget();

    GtkWidget* GetGtkWidget() const;

private:
    GtkWidget* m_gtkBoxWidget;
};
