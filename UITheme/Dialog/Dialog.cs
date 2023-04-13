using Godot;
using System;

[Tool]
public partial class Dialog : PanelContainer
{
	private PanelContainer _headerContainer;
	private Label _titleLabel;
	private Label _bodyLabel;
	private Button _cancelButton;
	private Button _confirmButton;

	private bool _headerVisible = true;
	[Export]
	public bool HeaderVisible
	{
		get => _headerVisible;
		set
		{
			_headerVisible = value;
			EmitSignal("HeaderVisibleChanged", value);
		}
	}

	[Signal]
	public delegate void HeaderVisibleChangedEventHandler(bool isVisible);
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_headerContainer = FindChild("DialogHeaderContainer", true, false) as PanelContainer;
		_titleLabel = FindChild("DialogTitleLabel", true, false) as Label;
		_bodyLabel = FindChild("DialogBodyLabel", true, false) as Label;
		_cancelButton = FindChild("CancelButton", true, false) as Button;
		_confirmButton = FindChild("ConfirmButton", true, false) as Button;
		
		HeaderVisibleChanged += OnHeaderVisibleChanged;
		EmitSignal("HeaderVisibleChanged", _headerVisible);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void OnHeaderVisibleChanged(bool isVisible)
	{
		_headerContainer.Visible = isVisible;
	}
}
