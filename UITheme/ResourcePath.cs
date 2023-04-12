using Godot;
using System;

public static class ResourcePath
{
    public static readonly string Theme = "res://UITheme/main_ui_theme.tres";
    
    public static class Background
    {
        public static readonly string Dark = "res://UITheme/flat_panel_brown.tres";
    }

    public static class Content
    {
        public static readonly string Medium = "res://UITheme/flat_panel_inset_beige.tres";
        public static readonly string Light = "res://UITheme/flat_panel_inset_light_beige.tres";
    }
}
