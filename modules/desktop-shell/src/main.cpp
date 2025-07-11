#include "Application.h"
#include <gtk/gtk.h>
#include <gtk4-layer-shell.h>

int main(int argc, char** argv) {
  Application Application;
  return Application.Run(argc, argv);
}
