{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 64000,0,655360}
{
 �����প� ���
 ॠ��� � ���饭�� ०��
  2-12-01
  (�� ����� ��஭��� �.�)
}
unit mouse;
                INTERFACE
uses DOS;

{������ ���}
CONST
  LEFT_BUTTON   = 1;
  RIGHT_BUTTON  = 2;



function  mouseEnable:boolean; {����㯭� �� ����}
procedure mouseInit;           {���樠������ ���}
procedure mouseClose;          {�����襭�� ࠡ��� � �����}
procedure mouseShow;           {����� 㪠��⥫�}
procedure mouseHide;
procedure mouseCurrPos(var x:integer;  var y:integer); {⥪�騥 ���न����}
procedure mouseCurrButton(var button:integer); {⥪�饥 ���ﭨ� ������}
{���ଠ�� � ��᫥���� ����⨨ �������� ������ button}
procedure mouseButtonDown(button:integer;          {����� ������}
                          var countPress:integer;  {᪮�쪮 ࠧ �뫠 �����}
                          var lastX:integer;       {���न���� ��᫥�����}
                          var lastY:integer        {������}
                          );


{���ଠ�� � ��᫥���� ���᪠��� �������� ������ button}
procedure mouseButtonUp(button:integer;            {����� ������}
                          var countPress:integer;  {᪮�쪮 ࠧ �뫠 �����}
                          var lastX:integer;       {���न���� ��᫥�����}
                          var lastY:integer        {������}
                          );
{᪮���� ��६�饭��}
procedure mouseSpeed(delX,delY:integer);
procedure mouseSetVisualPage(N:integer);

                IMPLEMENTATION
CONST
 __mouseEnable:boolean = false;
 __mouseShow:boolean   = false;
VAR
 regs: Registers;



{᪮���� ��६�饭��}
procedure mouseSpeed(delX,delY:integer);
begin
   with regs do
    begin
       ax := $0F;
       cx := delX;
       dx := delY;
       intr($33,regs);
    end;
end;

function mouseEnable:boolean;
begin
    with regs do
    begin
       ax := 0;
       intr($33,regs);
       mouseEnable := ax = $FFFF;
       __mouseShow := false;
    end;
end;

procedure mouseInit;
begin
    with regs do
    begin
       ax := 0;
       intr($33,regs);
       __mouseEnable := ax = $FFFF;
       __mouseShow   := false;
    end;
end;

procedure mouseClose;
begin
    with regs do
    begin
       ax := 0;
       intr($33,regs);
       __mouseEnable := false;
       __mouseShow   := false;
    end;
end;


procedure mouseShow;
begin
  if __mouseEnable  and  not __mouseShow   then
  begin
      regs.ax := 1;
      intr($33,regs);
      __mouseShow := true;
  end;
end;


procedure mouseHide;
begin
  if __mouseEnable  and  __mouseShow   then
  begin
      regs.ax := 2;
      intr($33,regs);
      __mouseShow := false;
  end;
end;

procedure mouseSetVisualPage(N:integer);
begin
  if __mouseEnable  then
  begin
      regs.ax := $1D;
      regs.bx := N;
      intr($33,regs);
  end;
end;


procedure mouseCurrPos(var x:integer;  var y:integer);
begin
  if __mouseEnable then
  begin
      with regs do
      begin
        ax := 3;
        intr($33,regs);
        x := cx;
        y := dx;
      end;
  end;
end;


procedure mouseCurrButton(var button:integer);
begin
  if __mouseEnable then
  begin
      with regs do
      begin
        ax := 3;
        intr($33,regs);
        button := bx;
      end;
  end;
end;

procedure mouseButtonDown(button:integer;          {����� ������}
                          var countPress:integer;  {᪮�쪮 ࠧ �뫠 �����}
                          var lastX:integer;       {���न���� ��᫥�����}
                          var lastY:integer        {������}
                          );
begin
  if __mouseEnable then
  begin
       case button of
          LEFT_BUTTON:button := 0;
          RIGHT_BUTTON:button := 1;
          else exit;
       end;
       with regs do
       begin
         ax := 5;
         bx := button;
         intr($33,regs);
         countPress := bx;
         lastX := cx;
         lastY := dx;
       end;
  end;
end;



procedure mouseButtonUp(button:integer;          {����� ������}
                          var countPress:integer;  {᪮�쪮 ࠧ �뫠 �����}
                          var lastX:integer;       {���न���� ��᫥�����}
                          var lastY:integer        {������}
                          );
begin
  if __mouseEnable then
  begin
      case button of
          LEFT_BUTTON:button := 0;
          RIGHT_BUTTON:button := 1;
          else exit;
       end;
       with regs do
       begin
         ax := 6;
         bx := button;
         intr($33,regs);
         countPress := bx;
         lastX := cx;
         lastY := dx;
       end;
  end;
end;

                END.