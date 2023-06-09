class_name AngleUtil

# keep rotation angle between 0-360.
static func apply_range(a: float) -> float:
    return 360 - fmod(-a, 360.0) if a < 0 else fmod(a, 360.0)