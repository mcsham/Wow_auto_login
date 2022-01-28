unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, XPMan, Spin, ExtCtrls;

type
  TForm1 = class(TForm)
    Button3: TButton;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    XPManifest1: TXPManifest;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    key: byte;
    function hexToInt(Value: string): Integer;
    procedure sendkey(h: Thandle; p: dword);
    procedure generateSimleKey;
    function encodeString(str: string): string;
    function getPass(str: string): string;
    function decodeString(str: string): string;

    { Private declarations }
  public

    { Public declarations }
  end;

var
  Form1: TForm1;
  PATH, path_new, wow_path: string;
  stp: boolean;
  wow_handle: THandle;

implementation

uses
  uLkJSON, shellapi, ShlObj, CommCtrl;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  js_list: TlkJSONlist;
  js_obj, js: TlkJSONobject;
begin
  ListBox1.Items.Add(Edit1.Text);
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONobject;
  if not Assigned(js) then
  begin
    js := TlkJSONobject.Create;
    js.Add('delay_login', SpinEdit1.Value);
  end;
  js_list := js.Field['accounts'] as TlkJSONlist;
  if not Assigned(js_list) then
  begin
    js_list := TlkJSONlist.Create;
    js.Add('accounts', js_list);
  end;
  js_obj := TlkJSONobject.Create;
  js_obj.Add('login', Edit1.Text);
  js_obj.Add('pass', encodeString(Edit2.Text));
  js_list.Add(js_obj);
  TlkJSONstreamed.SaveToFile(js, PATH);
  js.Free;
  Edit1.Text := '';
  Edit2.Text := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  js: TlkJSONobject;
  js_list: TlkJSONlist;
begin
  InitCommonControls;
  PATH := GetCurrentDir + '\psw_config.json';
  wow_path := GetCurrentDir + '\Wow.exe';
//  wow_path := 'c:\game\WoWCircle 3.3.5a\wow.exe';
  GenerateSimleKey;
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONobject;
  if not Assigned(js) then
    exit;
  SpinEdit1.Value := js.Field['delay_login'].Value;
  js_list := js.Field['accounts'] as TlkJSONlist;
  if not Assigned(js_list) then
    exit;
  for i := 0 to js_list.Count - 1 do
    ListBox1.Items.Add((js_list.Child[i] as TlkJSONobject).getString('login'));
  js.Free;
  Form1.Color := clBtnShadow
end;

procedure settext(h: THandle; s: string);
var
  c, i: integer;
begin
  c := length(s);
  for i := 1 to c do
  begin
    SendMessage(h, WM_CHAR, ord(s[i]), 0);
    Sleep(30);
  end;

end;

function EnumProc(h: DWORD; p: PProcessInformation): DWORD; stdcall;
var
  id: DWORD;
  s: string;
begin
  Result := 1;
  try
    GetWindowThreadProcessID(h, @id);
    if id = p.dwProcessId then
    begin
      WaitForInputIdle(p.hProcess, INFINITE);
      sleep(round(form1.SpinEdit1.Value));
      s := Form1.ListBox1.Items[form1.ListBox1.ItemIndex];
      settext(h, s);
      form1.sendkey(h, vk_tab);
      s := Form1.getPass(s);
      settext(h, s);
      form1.sendkey(h, VK_RETURN);
      Result := 0;
      stp := true;
      wow_handle := h;
    end;
  except
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
  js_list: TlkJSONlist;
  js: TlkJSONobject;
  i, count: integer;
  login: string;
begin
  if ListBox1.ItemIndex < 0 then
    exit;
  if MessageDlg('Delete this account?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  login := ListBox1.Items[ListBox1.ItemIndex];
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONobject;
  js_list := js.field['accounts'] as TlkJSONlist;
  count := js_list.Count;
  for i := 0 to count do
    if (js_list.Child[i] as TlkJSONobject).getString('login') = login then
    begin
      js_list.Delete(i);
      Break;
    end;
  TlkJSONstreamed.SaveToFile(js, path);
  js.Free;
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

function TForm1.decodeString(str: string): string;
var
  i, len: Integer;
begin
  Result := '';
  len := length(str);
  for i := 1 to len do
    if i mod 2 <> 0 then
      Result := Result + Chr(HexToInt(Copy(str, i, 2)) xor key);

end;

function TForm1.encodeString(str: string): string;
var
  i, len: Integer;
begin
  Result := '';
  len := length(str);
  for i := 1 to len do
    Result := Result + IntToHex(Ord(str[i]) xor key, 2);
end;

procedure TForm1.GenerateSimleKey;
var
  tmp_str: array[0..25] of char;
  serial: DWORD;
  lkey: Byte;
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
        mov     eax, serial
        mov     ecx, 4
        XOR     bl, bl

@@loop:
        XOR     bl, al
        SHR     eax, 8
        loop    @@loop
        mov     lkey, bl
  end;
  key := lkey;
end;

function TForm1.HexToInt(Value: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := 1;
  if Value = '' then
    Exit;
  if Value[1] = '$' then
    Inc(I);
  while I <= Length(Value) do
  begin
    if Value[I] in ['0'..'9'] then
      Result := (Result shl 4) or (Ord(Value[I]) - Ord('0'))
    else if Value[I] in ['A'..'F'] then
      Result := (Result shl 4) or (Ord(Value[I]) - Ord('A') + 10)
    else if Value[I] in ['a'..'f'] then
      Result := (Result shl 4) or (Ord(Value[I]) - Ord('a') + 10)
    else
      Break;
    Inc(I);
  end;
end;

function TForm1.getPass(str: string): string;
var
  js_list: TlkJSONlist;
  js: TlkJSONobject;
  count, i: integer;
begin
  Result := '';
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONobject;
  js_list := js.Field['accounts'] as TlkJSONlist;
  if not Assigned(js) then
    Exit;
  count := js_list.Count;
  for i := 0 to count - 1 do
    with js_list.Child[i] as TlkJSONobject do
    begin
      if getString('login') = str then
      begin
        Result := decodeString(getString('pass'));
        break;
      end;
    end;
  js.Free;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
var
  js: TlkJSONobject;
begin
  if SpinEdit1.Text = '' then
    Exit;
  js := TlkJSONstreamed.loadfromfile(PATH) as TlkJSONobject;
  js.Field['delay_login'].Value := SpinEdit1.Value;
  TlkJSONstreamed.SaveToFile(js, path);
  js.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  buf: array[1..255] of Char;
  i: dword;
begin
  if wow_handle = 0 then
    exit;
  if not CheckBox1.Checked then
  begin
    Timer1.Enabled := false;
    exit;
  end;
  if GetWindowText(wow_handle, @buf, 255) = 0 then
  begin
    wow_handle := 0;
    CreateThread(nil, 0, @Thread, nil, 0, i);
  end;

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

end.

