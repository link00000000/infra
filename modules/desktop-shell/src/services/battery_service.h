#pragma once

#include <filesystem>
#include <fstream>

#include "../percentage.h"

namespace Services
{
    class BatteryDevice
    {
    public:
        enum class CapacityLevel
        {
            Unknown,
            Critical,
            Low,
            Normal,
            High,
            Full,
        };

        enum class Status
        {
            Charging,
            Discharging,
            Full,
        };

        BatteryDevice(std::filesystem::path path);

        Percentage get_percentage() const;
        CapacityLevel get_capcity_level() const;
        Status get_status() const;

        const std::filesystem::path m_path;

    protected:
        template <typename T = std::string>
        T read_device_file(std::filesystem::path relativePath) const
        {
            auto f = std::ifstream(m_path / relativePath);

            T v{};
            f >> v;

            f.close();

            return v;
        }
    };

    class BatteryService
    {
    public:
        BatteryDevice get_battery_device() const;
    };
} // namespace Services
