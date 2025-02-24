unit GameViewMain;

interface

uses Classes,
  CastleUIState, CastleVectors, CastleComponentSerialize,
  CastleUIControls, CastleControls, CastleKeysMouse, CastleLog, CastleWindow, CastleScene, GameViewPlay;

type
  { Main view, where most of the application logic takes place. }
  TViewMain = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    PlayButton : TCastleButton;
    QuitButton : TCastleButton;
  private
    ViewPlay : TViewPlay;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure PlayButtonClicked(Sender: TObject);
    procedure QuitButtonClicked(Sender: TObject);
    procedure Update(const SecondsPassed: Single; var HandleInput: Boolean); override;
    function Press(const Event: TInputPressRelease): Boolean; override;
  
  end;

var
  ViewMain: TViewMain;

implementation

uses SysUtils;

{ TViewMain ----------------------------------------------------------------- }

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
begin
  inherited;
  InitializeLog;
  ViewPlay := TViewPlay.Create(Application);
  PlayButton := DesignedComponent('PlayButton') as TCastleButton;
  PlayButton.OnClick := {$ifdef FPC}@{$endif} PlayButtonClicked;
  QuitButton := DesignedComponent('QuitButton') as TCastleButton;
  QuitButton.OnClick := {$ifdef FPC}@{$endif} QuitButtonClicked;
end;

// The play button on main menu
procedure TViewMain.PlayButtonClicked(Sender : TObject);
begin
  WriteLnLog ('Play Button is clicked');
  Container.View := ViewPlay;
end;

procedure TViewMain.QuitButtonClicked(Sender : TObject);
begin
  WriteLnLog ('Quit Button is clicked');
end;

procedure TViewMain.Update(const SecondsPassed: Single; var HandleInput: Boolean);
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil, 'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
end;

function TViewMain.Press(const Event: TInputPressRelease): Boolean;
begin
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  { This virtual method is executed when user presses
    a key, a mouse button, or touches a touch-screen.

    Note that each UI control has also events like OnPress and OnClick.
    These events can be used to handle the "press", if it should do something
    specific when used in that UI control.
    The TViewMain.Press method should be used to handle keys
    not handled in children controls.
  }

  // Use this to handle keys:
  {
  if Event.IsKey(keyXxx) then
  begin
    // DoSomething;
    Exit(true); // key was handled
  end;
  }
end;

end.
