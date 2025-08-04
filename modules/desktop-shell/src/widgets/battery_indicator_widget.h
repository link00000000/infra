#pragma once

#include <gtkmm/box.h>

#include "../services/battery_service.h"
#include "glibmm/main.h"
#include "glibmm/refptr.h"
#include "gtkmm/label.h"
#include "gtkmm/levelbar.h"

namespace Widgets
{
    class BatteryIndicatorWidget : public Gtk::Box
    {
    public:
        BatteryIndicatorWidget();

    protected:
        void update_label_widget();

        Services::BatteryService m_batteryService;

        Gtk::Label* m_labelWidget;
        Gtk::LevelBar* m_levelBarWidget;

        Glib::RefPtr<Glib::TimeoutSource> m_timeoutSource;
    };
}; // namespace Widgets
