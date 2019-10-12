CFLAGS = -g -Wall -Wshadow -Wconversion -Wstrict-prototypes \
  -Wmissing-prototypes
#CFLAGS = $(CFLAGS) -DNDEBUG -O3
CC = gcc
OBJS= toymetro.o
TARGET = toymetro

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) -lm
clean :
	rm -f core junk* *.o *.aux *.dvi *.log

