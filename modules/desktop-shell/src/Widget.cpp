#include "Widget.h"

GtkWidget* Widget::getRootGtkWidget() const
{
    return m_RootGtkWidget;
}

void Widget::setRootGtkWidget(GtkWidget* inGtkWidget)
{
    m_RootGtkWidget = inGtkWidget;
}
