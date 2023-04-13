using Godot;
using System;
using MonoCustomResourceRegistry;

[Tool]
[RegisteredType(nameof(MenuItem), "", nameof(PanelContainer))]
public partial class MenuItem : PanelContainer
{
    [Signal]
    public delegate void MenuItemWasClickedEventHandler();
    
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
    
    public override void _GuiInput(InputEvent @event)
    {
        if (@event is InputEventMouseButton button)
        {
            if (button.ButtonIndex == MouseButton.Left && button.IsPressed())
            {
                EmitSignal("MenuItemWasClicked");
            }
        }
    }
}
