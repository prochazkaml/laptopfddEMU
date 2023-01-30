#define F_CPU 16000000UL
#include <stdint.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

// A B C DP F G E D
// D E G F DP C B A

volatile char rxbuffer[32];
volatile char rxptr = 0;

volatile char buffer[32];
volatile char buffptr = -1;
volatile int timeout = 0;

const uint8_t font[] = {
	0b10000100, // .

	0b11010111, // 0
	0b00000110, // 1
	0b11100011, // 2
	0b10100111, // 3
	0b00110110, // 4
	0b10110101, // 5
	0b11110101, // 6
	0b00000111, // 7
	0b11110111, // 8
	0b10110111, // 9

	0b01110111, // A
	0b11110100, // b
	0b11010001, // C
	0b11100110, // d
	0b11110001, // E
	0b01110001, // F
	0b11010101, // G
	0b01110110, // H
	0b00000110, // I
	0b11000110, // J
	0b11110010, // K (a weird one, but whatevs)
	0b11010000, // L
	0b01000101, // M (with a bit of imagination)
	0b01100100, // n
	0b11100100, // o
	0b01110011, // P
	0b00110111, // q
	0b01100000, // r
	0b10110101, // S (same as 5)
	0b11110000, // t
	0b11010110, // U
	0b01010010, // V (again, with a bit of imagination)
	0b10010010, // W (you have to be on hard drugs to figure this one out)
	0b01010110, // X (in an abstract form)
	0b10110110, // y
	0b11000011, // Z (with the middle bit missing)
};

ISR(USART_RXC_vect) {
	uint8_t c = UDR;

	if(c == '$' || rxptr == (sizeof(rxbuffer) - 1)) {
		// String termination

		rxbuffer[rxptr] = 0;
		buffptr = 0;
		rxptr = 0;
		timeout = 2000;

		for(uint8_t i = 0; i < sizeof(rxbuffer); i++) {
			buffer[i] = rxbuffer[i];
		}
	} else {
		if(rxptr == 0) for(uint8_t i = 0; i < sizeof(rxbuffer); i++) {
			rxbuffer[i] = 0;
		}

		rxbuffer[rxptr++] = c;
	}
}

int main() {
	UCSRA |= (1 << U2X);
	UCSRB |= (1 << RXCIE) | (1 << RXEN) | (1 << TXEN); // Turn on TX & RX (with interrupt)
	UCSRC |= (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1); // Use 8-bit character sizes
	UBRRH = 0;
	UBRRL = 16;

	sei();

	DDRC = 0x07;
	DDRA = 0xFF;

	uint8_t digit = 0;

	uint8_t butts[5] = { 0 };

	while(1) {
		if(buffptr >= 0) {
			uint8_t c = buffer[buffptr + digit];

			PORTC = 0xFF;

			if(c == '.')
				PORTA = font[0];
			else if(c >= '0' && c <= '9')
				PORTA = font[1 + c - '0'];
			else if(c >= 'A' && c <= 'Z')
				PORTA = font[11 + c - 'A'];
			else if(c >= 'a' && c <= 'z')
				PORTA = font[11 + c - 'a'];
			else
				PORTA = 0;

			PORTC = ~(1 << digit);

			timeout--;
			if(timeout < 0) {
				if(buffer[buffptr + 3] != 0) {
					timeout = 500;
					buffptr++;

					if(buffer[buffptr + 3] == 0) timeout += 1500;
				} else {
					buffptr = -1;
				}
			}
		} else {
			PORTC = 0xFF;
			PORTA = 0x00;
		}

		for(uint8_t i = 0; i < 5; i++) {
			if(!(PINC & (1 << (i + 3)))) {
				if(butts[i] == 0) {
					UDR = "elsnp"[i];
				}

				butts[i] = 100;
			} else {
				if(butts[i] > 0) butts[i]--;
			}
		}

		digit++;
		if(digit >= 3) digit = 0;

		_delay_ms(1);
	}
}