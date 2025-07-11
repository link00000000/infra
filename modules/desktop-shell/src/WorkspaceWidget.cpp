#include "WorkspaceWidget.h"

WorkspaceWidget::WorkspaceWidget()
{
    auto label = gtk_label_new("OTHER");
    setRootGtkWidget(label);
}

