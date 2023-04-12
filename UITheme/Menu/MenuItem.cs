using Godot;
using System;
using MonoCustomResourceRegistry;

[Tool]
[RegisteredType(nameof(MenuItem), "", nameof(PanelContainer))]
public partial class MenuItem : PanelContainer
{
  
    public MenuItem()
    {
        var stylebox = ResourceLoader.Load<StyleBox>(ResourcePath.Content.Light);
        AddThemeStyleboxOverride("panel", stylebox);
        SizeFlagsHorizontal = SizeFlags.ExpandFill;
        SizeFlagsVertical = SizeFlags.ShrinkEnd;

    }

    public override void _Ready()
    {
    }
}
