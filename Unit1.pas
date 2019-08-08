unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    Label2: TLabel;
    Button3: TButton;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure sendkey(h: Thandle; p: dword);
    
    { Public declarations }
  end;

var
  Form1: TForm1;
  PATH, path_new, wow_path: string;
  stp: boolean;

implementation

uses
  IniFiles, shellapi;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  f: TIniFile;
  i: integer;
begin
  ListBox1.Items.Add(Edit1.Text);
  f := TIniFile.Create(path);
  f.WriteInteger('root', 'count', ListBox1.Items.Count);
  for i := 1 to ListBox1.Items.Count do
  begin
    f.WriteString(IntToStr(i), 'login', Edit1.Text);
    f.WriteString(IntToStr(i), 'pass', Edit2.Text);
  end;
  Edit1.Text := '';
  Edit2.Text := '';
  f.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f: TIniFile;
  i, count_records: integer;
begin
  PATH := GetCurrentDir + '\psw_config.ini';
  PATH_new := GetCurrentDir + '\psw_config2.ini';
  wow_path := GetCurrentDir + '\Wow.exe';
  f := TIniFile.Create(path);
  count_records := f.ReadInteger('root', 'count', 0);
  for i := 1 to count_records do
    ListBox1.Items.Add(f.ReadString(IntToStr(i), 'login', ''));
  f.Free;
end;

function EnumProc(h: DWORD; p: PProcessInformation): DWORD; stdcall;
var
  id: DWORD;
  c, i: integer;
  s: string;
  f: TIniFile;
begin
  Result := 1;
  GetWindowThreadProcessID(h, @id);
  if id = p.dwProcessId then
  begin
    WaitForInputIdle(p.hProcess, INFINITE);
    sleep(500);
    f := TIniFile.Create(path);
    s := f.ReadString(inttostr(form1.ListBox1.ItemIndex + 1), 'login', '');
    c := length(s);
    for i := 1 to c do
      SendMessage(h, WM_CHAR, ord(s[i]), 0);
    form1.sendkey(h, vk_tab);
    s := f.ReadString(inttostr(form1.ListBox1.ItemIndex + 1), 'pass', '');
    c := length(s);
    for i := 1 to c do
      SendMessage(h, WM_CHAR, ord(s[i]), 0);
    form1.sendkey(h, VK_RETURN);
    f.Free;
    Result := 0;
    stp := true;
  end;
end;

procedure Thread(p: pointer);
var
  pi: TProcessInformation;
  si: TStartupInfo;
begin
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_SHOWMAXIMIZED;
  if not CreateProcess(pchar(wow_path), '', nil, nil, false, 0, nil, nil, si, pi) then
    ShowMessage(SysErrorMessage(GetLastError));
  stp := false;
  while not stp do
  begin
    EnumWindows(@EnumProc, longword(@pi));
    sleep(1000);
  end;
end;

procedure TForm1.sendkey(h: Thandle; p: dword);
begin
  SendMessage(h, WM_KEYDOWN, p, 0);
  SendMessage(h, WM_KEYUP, p, 0);
  sleep(100);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  i: DWORD;
begin
  if ListBox1.ItemIndex < 0 then
    exit;
  CreateThread(nil, 0, @Thread, nil, 0, i);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  f_new, f_old: TIniFile;
  s: string;
  i, j: integer;
begin
  if ListBox1.ItemIndex < 0 then
    exit;
  s := ListBox1.Items[ListBox1.ItemIndex];
  f_old := TIniFile.Create(path);
  f_new := TIniFile.Create(path_new);
  j := 1;
  f_new.WriteInteger('root', 'count', ListBox1.Items.Count - 1);
  for i := 1 to ListBox1.Items.Count do
  begin
    if i = ListBox1.ItemIndex + 1 then
      Continue;
    f_new.WriteString(inttostr(j), 'login', f_old.ReadString(inttostr(i), 'login', ''));
    f_new.WriteString(inttostr(j), 'pass', f_old.ReadString(inttostr(i), 'pass', ''));
    inc(j);
  end;
  f_old.Free;
  f_new.Free;
  DeleteFile(pchar(path));
  MoveFile(pchar(path_new), pchar(path));
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

end.

