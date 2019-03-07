{ *****************************************************************************
Copyright (C) 2019 by Thomas Dannert
Author: Thomas Dannert <thomas@dannert.com>
Website: www.dannert.com
{ *****************************************************************************
Panorama3D for Delphi Firemonkey is free software: you can redistribute it
and/or modify it under the terms of the GNU Lesser General Public License
version 3as published by the Free Software Foundation and appearing in the
included file.
Panorama3D for Delphi Firemonkey is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public License
along with Dropbox Client Library. If not, see <http://www.gnu.org/licenses.
****************************************************************************** }

unit FMX.PanoRegs;

interface

resourcestring
  PAN_Category = 'Panorama3D';

procedure Register;

implementation

uses
  System.Classes, FMX.Panorama;

procedure Register;
begin
  RegisterComponents(PAN_Category, [TPanorama3D]);
end;

end.
