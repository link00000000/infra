#include "gtk4-layer-shell/gtk4-layer-shell.h"
#include "gtkmm/application.h"
#include "gtkmm/box.h"
#include "gtkmm/enums.h"
#include "gtkmm/label.h"
#include "gtkmm/levelbar.h"
#include "gtkmm/widget.h"
#include "gtkmm/window.h"

class BatteryIndicatorWidget : public Gtk::Box
{
public:
    BatteryIndicatorWidget();
};

class MainWindow : public Gtk::Window
{
public:
    MainWindow();
};

BatteryIndicatorWidget::BatteryIndicatorWidget()
{
    Gtk::Label label{"Battery Indicator:"};
    append(label);

    Gtk::LevelBar levelBar{};
    levelBar.set_mode(Gtk::LevelBar::Mode::CONTINUOUS);
    levelBar.set_max_value(1.0);
    levelBar.set_min_value(0.0);
    levelBar.set_value(0.5);
    append(levelBar);
}

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

    Gtk::Box box{Gtk::Orientation::VERTICAL};
    box.set_halign(Gtk::Align::FILL);
    box.set_valign(Gtk::Align::FILL);
    set_child(box);

    Gtk::Label label{"Hello from gtkmm"};
    BatteryIndicatorWidget batteryIndicatorWidget;
    box.append(batteryIndicatorWidget);
}

int main(int argc, char** argv)
{
    auto application = Gtk::Application::create("com.github.link00000000.DesktopShell");
    return application->make_window_and_run<MainWindow>(argc, argv);
}
