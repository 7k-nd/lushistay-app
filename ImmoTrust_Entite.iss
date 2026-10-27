#ifndef MyAppVersion
  #error MyAppVersion must be passed from Build_ImmoTrust_Entite_Windows.bat
#endif

[Setup]
AppId={{A9B4B7FC-445A-4B44-A353-0479F88D5E70}
AppName=ImmoTrust Entite
AppVersion={#MyAppVersion}
AppPublisher=ImmoTrust
DefaultDirName={autopf}\ImmoTrust Entite
DefaultGroupName=ImmoTrust Entite
UninstallDisplayName=ImmoTrust Entite
UninstallDisplayIcon={app}\immotrust_entite.exe
OutputDir=build\windows\installer
OutputBaseFilename=ImmoTrust-Entite-Setup-{#MyAppVersion}
SetupIconFile=windows\runner\resources\app_icon.ico
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
DisableProgramGroupPage=yes
WizardStyle=modern
Compression=lzma2
SolidCompression=yes

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "Creer un raccourci sur le Bureau"; GroupDescription: "Raccourcis supplementaires :"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\ImmoTrust Entite"; Filename: "{app}\immotrust_entite.exe"
Name: "{autodesktop}\ImmoTrust Entite"; Filename: "{app}\immotrust_entite.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\immotrust_entite.exe"; Description: "Lancer ImmoTrust Entite"; Flags: postinstall nowait skipifsilent
