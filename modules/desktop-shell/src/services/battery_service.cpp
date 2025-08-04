#include <cassert>

#include "battery_service.h"

Services::BatteryDevice::BatteryDevice(std::filesystem::path path)
    : m_path(path)
{
}

Percentage Services::BatteryDevice::get_percentage() const
{
    auto energy_now = read_device_file<int64_t>("energy_now");
    auto energy_full = read_device_file<int64_t>("energy_full");

    return Percentage(static_cast<float>(energy_now) / static_cast<float>(energy_full));
}

Services::BatteryDevice::CapacityLevel Services::BatteryDevice::get_capcity_level() const
{
    auto v = read_device_file("capacity_level");

    if (v == "Critical")
    {
        return BatteryDevice::CapacityLevel::Critical;
    }
    if (v == "Low")
    {
        return BatteryDevice::CapacityLevel::Low;
    }
    if (v == "Normal")
    {
        return BatteryDevice::CapacityLevel::Normal;
    }
    if (v == "High")
    {
        return BatteryDevice::CapacityLevel::High;
    }
    if (v == "Full")
    {
        return BatteryDevice::CapacityLevel::Full;
    }
    else
    {
        return BatteryDevice::CapacityLevel::Unknown;
    }
}

Services::BatteryDevice::Status Services::BatteryDevice::get_status() const
{
    auto v = read_device_file("status");

    if (v == "Charging")
    {
        return BatteryDevice::Status::Charging;
    }
    else if (v == "Discharging")
    {
        return BatteryDevice::Status::Discharging;
    }
    else
    {
        assert(false);
    }
}

Services::BatteryDevice Services::BatteryService::get_battery_device() const
{
    // TODO: Resolve
    return BatteryDevice("/sys/class/power_supply/BAT1");
}
