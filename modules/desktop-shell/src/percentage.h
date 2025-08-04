#pragma once

#include <string>

struct Percentage
{
    Percentage() = default;
    Percentage(float value);

    std::string to_string() const;

protected:
    static float clampValue(float value);

    float m_value = 0.0f;
};
