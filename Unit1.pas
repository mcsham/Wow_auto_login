unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    Button3: TButton;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    key: byte;
    procedure sendkey(h: Thandle; p: dword);
    procedure GenerateSimleKey;
    function encodeString(str: string): string;
    function decodeString(str: string): string;

    { Private declarations }
  public

    { Public declarations }
  end;

var
  Form1: TForm1;
  PATH, path_new, wow_path: string;
  stp: boolean;

implementation

uses
  uLkJSON, shellapi, ShlObj;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  js_file: TlkJSONstreamed;
  js: TlkJSONlist;
  js_obj: TlkJSONobject;
  i: integer;
begin
  ListBox1.Items.Add(Edit1.Text);
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONlist;
  if not Assigned(js) then
    js := TlkJSONlist.Create;
  js_obj := TlkJSONobject.Create;
  js_obj.Add('login', Edit1.Text);
  js_obj.Add('pass', Edit2.Text);
  js.Add(js_obj);
  TlkJSONstreamed.SaveToFile(js, PATH);
  js.Free;
  Edit1.Text := '';
  Edit2.Text := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  js_list: TlkJSONlist;
begin
  PATH := GetCurrentDir + '\psw_config.json';
  wow_path := GetCurrentDir + '\Wow.exe';
  js_list := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONlist;
  if Assigned(js_list) then
  begin
    for i := 0 to js_list.Count - 1 do
      ListBox1.Items.Add((js_list.Child[i] as TlkJSONobject).getString('login'));
    js_list.Free;
  end;
end;

function EnumProc(h: DWORD; p: PProcessInformation): DWORD; stdcall;
var
  id: DWORD;
  c, i: integer;
  s: string;
begin
  Result := 1;
  GetWindowThreadProcessID(h, @id);
  if id = p.dwProcessId then
  begin
    WaitForInputIdle(p.hProcess, INFINITE);
    sleep(500);
//    f := TIniFile.Create(path);
//    s := f.ReadString(inttostr(form1.ListBox1.ItemIndex + 1), 'login', '');
//    c := length(s);
//    for i := 1 to c do
//      SendMessage(h, WM_CHAR, ord(s[i]), 0);
//    form1.sendkey(h, vk_tab);
//    s := f.ReadString(inttostr(form1.ListBox1.ItemIndex + 1), 'pass', '');
//    c := length(s);
//    for i := 1 to c do
//      SendMessage(h, WM_CHAR, ord(s[i]), 0);
//    form1.sendkey(h, VK_RETURN);
//    f.Free;
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
begin
  if ListBox1.ItemIndex < 0 then
    exit;
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

function TForm1.decodeString(str: string): string;
begin

end;

function TForm1.encodeString(str: string): string;
begin

end;

procedure TForm1.GenerateSimleKey;
var
  tmp_str: array of char;
  serial: array[0..25] of char;
  lkey:Byte;
begin
  SHGetSpecialFolderPath(0, @tmp_str[0], CSIDL_DESKTOP, false);
  tmp_str[3] := #0;
  asm
        push    0
        push    0
        push    0
        push    0
        lea     edi, serial
        push    edi
        push    0
        push    0
        lea     edi, tmp_str
        push    edi
        call    GetVolumeInformation
        mov     ecx, 4
        XOR     bl, bl
@@1:
        XOR     bl, al
        SHR     eax, 8
        loop    @@1
        mov     lkey, bl
  end;

end;

end.

