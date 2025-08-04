#include <gtk4-layer-shell/gtk4-layer-shell.h>
#include <gtkmm/application.h>
#include <gtkmm/box.h>
#include <gtkmm/cssprovider.h>
#include <gtkmm/enums.h>
#include <gtkmm/label.h>
#include <gtkmm/levelbar.h>
#include <gtkmm/object.h>
#include <gtkmm/widget.h>
#include <gtkmm/window.h>

#include "widgets/battery_indicator_widget.h"
#include "widgets/style.h"

class MainWindow : public Gtk::Window
{
public:
    MainWindow();
};

MainWindow::MainWindow()
{
    // Init layer shell
    gtk_layer_init_for_window(gobj());
    gtk_layer_set_layer(gobj(), GTK_LAYER_SHELL_LAYER_TOP);
    gtk_layer_auto_exclusive_zone_enable(gobj());
    gtk_layer_set_anchor(gobj(), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(gobj(), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(gobj(), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);

    set_decorated(false);
    set_resizable(false);
    set_default_size(1920, 20);

    auto box = Gtk::make_managed<Gtk::Box>(Gtk::Orientation::VERTICAL);
    box->set_halign(Gtk::Align::FILL);
    box->set_valign(Gtk::Align::FILL);
    set_child(*box);

    auto batteryIndicatorWidget = Gtk::make_managed<Widgets::BatteryIndicatorWidget>();
    box->append(*batteryIndicatorWidget);
}

int main(int argc, char** argv)
{
    auto application = Gtk::Application::create("com.github.link00000000.DesktopShell");

    auto css_provider = Gtk::CssProvider::create();
    css_provider->load_from_data(Widgets::Style);
    Gtk::StyleContext::add_provider_for_display(
        Gdk::Display::get_default(),
        css_provider,
        GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

    return application->make_window_and_run<MainWindow>(argc, argv);
}
