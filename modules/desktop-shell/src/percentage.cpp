#include <algorithm>
#include <format>

#include "percentage.h"

Percentage::Percentage(float value)
    : m_value(clampValue(value))
{
}

float Percentage::clampValue(float value)
{
    return std::clamp(value, 0.0f, 1.0f);
}

std::string Percentage::to_string() const
{
    return std::format("{:.0f}%", m_value * 100.0f);
}
