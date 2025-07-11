#include <gtk/gtk.h>
#include <gtk4-layer-shell.h>

#include "Application.h"

int main(int argc, char** argv)
{
    Application application;
    return application.run(argc, argv);
}
