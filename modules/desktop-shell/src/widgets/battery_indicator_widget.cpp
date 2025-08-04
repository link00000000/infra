#include <format>
#include <glibmm/main.h>
#include <gtkmm/label.h>
#include <gtkmm/levelbar.h>

#include "battery_indicator_widget.h"

using namespace Services;

Widgets::BatteryIndicatorWidget::BatteryIndicatorWidget()
{
    m_labelWidget = Gtk::make_managed<Gtk::Label>();
    update_label_widget();
    Glib::signal_timeout().connect_seconds([this]
        {
        update_label_widget();
        return true; },
        15);
    append(*m_labelWidget);

    m_levelBarWidget = Gtk::make_managed<Gtk::LevelBar>();
    m_levelBarWidget->set_mode(Gtk::LevelBar::Mode::CONTINUOUS);
    m_levelBarWidget->set_max_value(1.0);
    m_levelBarWidget->set_min_value(0.0);
    m_levelBarWidget->set_value(0.5);
    m_levelBarWidget->set_hexpand(true);
    m_levelBarWidget->set_vexpand(true);

    append(*m_levelBarWidget);
}

void Widgets::BatteryIndicatorWidget::update_label_widget()
{
    auto dev = m_batteryService.get_battery_device();

    std::string capacityLevel;
    switch (dev.get_capcity_level())
    {
    case BatteryDevice::CapacityLevel::Critical:
        capacityLevel = "Critical";
        break;
    case BatteryDevice::CapacityLevel::Low:
        capacityLevel = "Low";
        break;
    case BatteryDevice::CapacityLevel::Normal:
        capacityLevel = "Normal";
        break;
    case BatteryDevice::CapacityLevel::High:
        capacityLevel = "High";
        break;
    case BatteryDevice::CapacityLevel::Full:
        capacityLevel = "Full";
        break;
    default:
        capacityLevel = "Unknown";
    }

    if (m_labelWidget->has_css_class("red"))
    {
        m_labelWidget->remove_css_class("red");
    }
    else
    {
        m_labelWidget->add_css_class("red");
    }

    m_labelWidget->set_text(std::format("Level: {}, Remaining: {}", capacityLevel, dev.get_percentage().to_string()));
}
