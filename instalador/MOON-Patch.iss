; INSTALADOR MOON. PATCH PT-BR 1.0
; Estrutura de pastas esperada ao lado deste arquivo:
;   embedded\  -> License.txt, WizardImage1.bmp, WizardSmallImage0.bmp
;   game\      -> MOON_PT-BR, MOON_PT-BR.exe, MOON_PT-BR.lst   (era "{code_GetGameDir}")
;   fonts\     -> Kika-Gothic.ttf                              (era "{userfonts}")
;   tmp\       -> wizard_intro.bmp, wizard.bmp                 (era "{tmp}")

[Setup]
AppName=MOON. - Patch PT-BR
AppId=MOON-PT-BR
AppVersion=1.0
DefaultDirName={autopf}\MOON. - Patch PT-BR
OutputBaseFilename=MOON-Patch
Compression=lzma2
Uninstallable=no
PrivilegesRequired=lowest
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableWelcomePage=no
ChangesAssociations=no
ShowLanguageDialog=yes
InfoBeforeFile=embedded\License.txt
WizardStyle=modern light
WizardImageFile=embedded\WizardImage1.bmp
WizardSmallImageFile=embedded\WizardSmallImage0.bmp

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Messages]
brazilianportuguese.FinishedLabelNoIcons=O instalador terminou de aplicar o patch no seu computador.

[Files]
Source: "game\MOON_PT-BR"; DestDir: "{code:GetGameDir}"; Flags: ignoreversion
Source: "game\MOON_PT-BR.exe"; DestDir: "{code:GetGameDir}"; Flags: ignoreversion
Source: "game\MOON_PT-BR.lst"; DestDir: "{code:GetGameDir}"; Flags: ignoreversion
Source: "fonts\*"; DestDir: "{code:GetGameDir}\fonts"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "fonts\Kika-Gothic.ttf"; DestDir: "{userfonts}"; Flags: uninsneveruninstall onlyifdoesntexist
Source: "game\Guia.txt"; DestDir: "{code:GetGameDir}"; Flags: ignoreversion
Source: "game\snd\*"; DestDir: "{code:GetGameDir}\snd"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "embedded\WizardImage0.bmp"; DestDir: "{tmp}"; Flags: dontcopy
Source: "tmp\wizard_intro.bmp"; DestDir: "{tmp}"; Flags: dontcopy
Source: "tmp\wizard.bmp"; DestDir: "{tmp}"; Flags: dontcopy

[Run]
Filename: "{code:GetGameDir}\MOON_PT-BR.exe"; WorkingDir: "{code:GetGameDir}"; Description: "Iniciar MOON. agora!"; Flags: postinstall skipifsilent nowait

[Code]
var
  GameDirPage: TInputDirWizardPage;

function GetGameDir(Param: String): String;
begin
  Result := RemoveBackslashUnlessRoot(GameDirPage.Values[0]);
end;

procedure InitializeWizard;
begin
  WizardForm.WelcomeLabel1.Caption := 'MOON. - Patch PT-BR';
  WizardForm.WelcomeLabel2.Caption :=
    'Olá! Este é o patch de tradução de MOON., feito pela' #13#10 'Kikachan Games.' + #13#10#13#10 +
    'Certifique-se de ter o jogo instalado e funcionando antes' #13#10 'de continuar.' + #13#10#13#10 +
    'Clique em ''Avançar'' para prosseguir com a instalação.';

  GameDirPage := CreateInputDirPage(wpInfoBefore,
    'Pasta do jogo',
    'Onde MOON. está instalado?',
    'Selecione a pasta onde está o arquivo MOON.EXE e clique em Avançar.',
    False, '');
  GameDirPage.Add('');
  GameDirPage.Values[0] := ExpandConstant('{autopf}\MOON');

  // Imagem diferente na tela final
  ExtractTemporaryFile('WizardImage0.bmp');
  WizardForm.WizardBitmapImage2.Bitmap.LoadFromFile(ExpandConstant('{tmp}\WizardImage0.bmp'));
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedHeadingLabel.Caption := 'MOON. - Patch PT-BR instalado com sucesso!';
    // Linha em branco
    WizardForm.FinishedLabel.Caption := #13#10 + WizardForm.FinishedLabel.Caption;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = GameDirPage.ID then
  begin
    if not FileExists(AddBackslash(GameDirPage.Values[0]) + 'MOON.EXE') then
    begin
      MsgBox('O arquivo original MOON.EXE não foi encontrado nesta pasta.' + #13#10 +
             'Selecione a pasta correta do jogo.', mbError, MB_OK);
      Result := False;
    end;
  end;
end;
