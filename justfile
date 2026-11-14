default:
    @just --list

# Render every preset and the breakpoint slice with --hardwarnings, and check their geometry
check:
    python3 tests/check_presets.py
