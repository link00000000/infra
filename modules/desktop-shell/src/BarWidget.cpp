#include "BarWidget.h"
#include "VolumeIconWidget.h"
#include "WorkspaceWidget.h"
#include "gtk/gtk.h"

BarWidget::BarWidget()
{
    auto box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_widget_set_halign(box, GTK_ALIGN_START);
    gtk_widget_set_valign(box, GTK_ALIGN_CENTER);

    GtkWidget* label = gtk_label_new("Hello, world");
    gtk_box_append(GTK_BOX(box), label);

    auto workspaceWidget = new WorkspaceWidget();
    gtk_box_append(GTK_BOX(box), workspaceWidget->getRootGtkWidget());

    auto volumeIconWidget = new VolumeIconWidget();
    gtk_box_append(GTK_BOX(box), volumeIconWidget->getRootGtkWidget());
}

