#include "VolumeIconWidget.h"
#include "gtk/gtk.h"

VolumeIconWidget::VolumeIconWidget()
{
    GtkWidget* levelBarGtkWidget = gtk_level_bar_new();
    setRootGtkWidget(levelBarGtkWidget);

    gtk_level_bar_add_offset_value(GTK_LEVEL_BAR(levelBarGtkWidget), GTK_LEVEL_BAR_OFFSET_LOW, 0.10);
}
