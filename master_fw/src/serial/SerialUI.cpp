// -----------------------------------------------------------------------------
// This file is part of fddEMU "Floppy Disk Drive Emulator"
// Copyright (C) 2021 Acemi Elektronikci
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
// -----------------------------------------------------------------------------

#include "fddEMU.h"
#include "SerialUI.h"
#include "FloppyDrive.h" //drive
#include "DiskFile.h" //sdfile

#if ENABLE_SERIAL
  class SerialUI ser;
#endif //ENABLE_SERIAL

SerialUI::SerialUI(void)
{
    file_index = 0;    
}

void SerialUI::readRx()
{
  char ch = Serial.read();

  switch(ch)
	{
        case 'S': 
        case 's':           
            statusInfo();
            break;
	    case 'p':
	    case 'P':
            file_index -=2;  		  
	    case 'n':
	    case 'N':
            file_index++;
            if (file_index < 0) file_index = 0;
            if (file_index >= sdfile.nFiles) file_index=sdfile.nFiles;      
            sdfile.openDir((char *)s_RootDir); //rewind directory
            for (int16_t i = 0; i <= file_index; i++) sdfile.getNextFile(); //skip files                        
            if (sdfile.getFileName()[0] != 0) Serial.print(sdfile.getFileName());
            else Serial.print_P(str_label);
            Serial.write('$');
		    break;      
	    case 'l':	//Load
	    case 'L':
            char filename[13];
            
            memcpy(filename, sdfile.getFileName(), 13);
            if (filename[0] != 0) drive[0].load(filename);
            else drive[0].loadVirtualDisk();
            Serial.print(drive[0].diskInfoStr());
            Serial.write('$');
		    break;		
	    case 'e':	//Cancel
	    case 'E':
            Serial.print("Ejt$");
            drive[0].eject();
		    break; 
	}
}

void SerialUI::intro()
{
  Serial.print("fddrdy$");
}

void SerialUI::statusInfo()
{
  if(drive[0].fName[0] != 0) {
    Serial.print(drive[0].fName);
    Serial.write(' ');
  }
  Serial.print(drive[0].diskInfoStr());
  Serial.write('$');
}
