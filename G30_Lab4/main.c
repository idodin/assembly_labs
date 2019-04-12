#include <stdio.h>
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"

#define __PARTTHREE

#define TRUE 1
#define FALSE 0

void test_char() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) {
		for (x=0; x<=79; x++) {
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) {
		for (x=0; x<=79; x+=3) {
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;
	
	for (y=0; y<=239; y++) {
		for (x=0; x<=319; x++) {
			VGA_draw_point_ASM(x,y,colour++);
		}
	}
}


int main(){

#ifdef __PARTONE

	while(TRUE){
		if(read_PB_data_ASM()==PB0){
			if(read_slider_switches_ASM()>0){
				test_byte();
			}
			else if(read_slider_switches_ASM()==0){
				test_char();
			}
		}
		else if(read_PB_data_ASM()==PB1){
			test_pixel();
		}
		else if(read_PB_data_ASM()==PB2){
			VGA_clear_charbuff_ASM();
		}
		else if(read_PB_data_ASM()==PB3){
			VGA_clear_pixelbuff_ASM();
		}
	}

#endif


#ifdef __PARTTWO
	int success = 0;
	int x_off = 0;
	int y_off = 0;
	char *c_pointer ;
	char c;
	c_pointer = &c; 
	while(TRUE){
		success = read_PS2_data_ASM(c_pointer);
		if (success == 1){
			VGA_write_byte_ASM(x_off,y_off,c);
			x_off+=3;						// Write row by row
			}
		if (x_off >= 79){
			y_off++;	// Down one row
			x_off = 0; 	// Reset X
			
		}
		if (y_off == 59){
			y_off = 0;	// Reset Y to 0
		}
	}	

#endif


#ifdef __PARTTHREE
	int i=0;

	while(TRUE){

		while(i<240){
			if(audio_ASM(0x00FFFFFF))i++;
		}
		i=0;

		while(i<240){
			if(audio_ASM(0x00000000))i++;
		}
		i=0;
	}

#endif

}

