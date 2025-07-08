#include <gtk/gtk.h>
#include <gtk4-layer-shell.h>

static void activate(GtkApplication* app, gpointer user_data) {
    GtkWidget* window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Desktop Shell Bar");

    // Init layer shell
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_TOP);
    gtk_layer_auto_exclusive_zone_enable(GTK_WINDOW(window));
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);

    gtk_window_set_decorated(GTK_WINDOW(window), FALSE);
    gtk_window_set_resizable(GTK_WINDOW(window), FALSE);
    gtk_window_set_default_size(GTK_WINDOW(window), 1920, 20);

    GtkWidget* box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_widget_set_halign(box, GTK_ALIGN_START);
    gtk_widget_set_valign(box, GTK_ALIGN_CENTER);

    GtkWidget* label = gtk_label_new("Hello, world");
    gtk_box_append(GTK_BOX(box), label);
    gtk_window_set_child(GTK_WINDOW(window), box);

    gtk_widget_show(window);
}

int main(int argc, char** argv) {
    GtkApplication* app = gtk_application_new("com.example.DesktopShell", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
