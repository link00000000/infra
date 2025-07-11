#include "Widget.h"

GtkWidget* Widget::GetRootGtkWidget() const
{
    return m_RootGtkWidget;
}

void Widget::SetRootGtkWidget(GtkWidget* inGtkWidget)
{
    m_RootGtkWidget = inGtkWidget;
}
