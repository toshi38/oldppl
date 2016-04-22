// DumpBinaryData.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <fstream>

using namespace std;

int main()
{
  ifstream myfile;
  myfile.open("rawdata.bin", ios::in|ios::binary|ios::ate);
  
  if (myfile.is_open()) {
    char * memblock;
    auto size = myfile.tellg();
    memblock = new char[size];
    myfile.seekg(0, ios::beg);
    myfile.read(memblock, size);

    auto width = ((int32_t*)memblock)[0];
    auto height = ((int32_t*)memblock)[1];
    printf("Width: 0x%X\n", width);
    printf("Height: 0x%X\n", height);

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        printf("%d\t", ((int32_t*)memblock)[width * i + j + 2]/30); //divide by 30 for seconds of movement per pixel.
      }
      printf("\n");
    }
    
     
  }
  else {
    cout << "Failed to open file.";
  }
  
    return 0;
}

