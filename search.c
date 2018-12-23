extern void clr();
extern void delay();
extern void ReadSector();
extern char readp();
extern void show();
extern char lodsb();
extern int lodsw();
extern void LABEL_FILE_LOADED();
extern void LABEL_FILE_LOADED1();
extern void set();
extern void debug();
char differ;
char kernalFileName[11];
char app1[] = "APP1    COM";
char app2[] = "APP2    COM";
char app3[] = "APP3    COM";
char app4[] = "APP4    COM";
char app6[] = "APP6    COM";
char app7[] = "APP7    COM";
char display1[] = "DISPLAY1COM";
char display2[] = "DISPLAY2COM";
char display3[] = "DISPLAY3COM";
char display4[] = "DISPLAY4COM";
char al, bl, cl, dl, ah, bh, ch, dh;
int ax;
int bx;
int cx;
int dx;
int es;
int di;
char row;
char col;
int wSectorNo = 0;
char bOdd;
int wRootDirSizeForLoop;
char match;
int i, j,k;
char correct;
char input[80];
char paget[38] = "please press any key to turn the page.";
showa()
{
	int j;
	char al1;
	int bx1 = bx;
	al1 = al;
	if (col == 80)
	{
		col = 0;
		row++;
	}
	if (row == 23)
	{
		row++;
		col = 0;
		es = 0xb800;
		for (j = 0; j < 38; j++)
		{
			bx = 80 * row + col;
			bx *= 2;
			al = paget[j];
			show();
			col++;
		}
		readp();
		row = 0;
		col = 0;
		clr();
	}
	al = al1;
	bx = 80 * row + col;
	bx *= 2;
	show();
	es = 0x7000;
	col++;
	bx = bx1;
	set();
}
showa2()
{
	int bx1 = bx;
	es = 0xb800;
	bx = 80 * row + col;
	bx *= 2;
	show();
	col++;
	bx = bx1;
}
showa1()
{
	int j;
	int bx1 = bx;
	if (col == 40)
	{
		col = 0;
		row++;
	}
	if (row == 24)
	{
		col = 0;
		es = 0xb800;
		for (j = 0; j < 38; j++)
		{
			bx = 80 * row + col;
			bx *= 2;
			al = paget[j];
			show();
			col++;
		}
		readp();
		row = 0;
		col = 0;
		clr();
	}
	bx = 80 * row + col;
	bx *= 2;
	show();
	es = 0x7000;
	col++;
	bx = bx1;
	set();
}
searchstart()
{

		clr();
		bOdd = 0;
		wSectorNo = 19;
		ax = 19;
		cl = 1;
		es = 0x7000;
		bx = 0x100;
		ReadSector();
		for (j = 1; j < 11; j++)
		{
			switch (j) 
			{
			case 1:
			{
				for (i = 0; i < 11; i++)
					kernalFileName[i] = display1[i];
				break;
			}
			case 2:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = display2[i];
					  break;
			}
			case 3:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = display3[i];
					  break;
			}
			case 4:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = display4[i];
					  break;
			}
			case 5:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app1[i];
					  break;
			}
			case 6:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app2[i];
					  break;
			}
			case 7:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app3[i];
					  break;
			}
			case 8:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app4[i];
					  break;
			}
			case 9:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app6[i];
					  break;
			}
			case 10:
			{
					  for (i = 0; i < 11; i++)
						  kernalFileName[i] = app7[i];
					  break;
			}
			default:
			{
					   for (i = 0; i < 11; i++)
						   kernalFileName[i] = ' ';
					   break;
			}
			}
			wRootDirSizeForLoop = 14;
			match = 0;
			bx = 0x100;
			di = bx;
			LABEL_SEARCH_IN_ROOT_DIR_BEGIN();
			if (match)
			{
				LABEL_FILENAME_FOUND();
			}
	    }
}
LABEL_FILENAME_FOUND()
{ 
	int es1;
	es = 0x7000;
	di &= 0xffe0;
	di += 0x1a;
	cx = lodsw();
	i = cx;
	cx += 14;
	cx += 17;	
	ax = cx;
	bx = 0x100;
	switch (j)
	{
	case 1:
	{
			  es = 0x4000;
			  break;
	}
	case 2:
	{
			  es = 0x4500;
			  break;
	}
	case 3:
	{
			  es = 0x5000;
			  break;
	}
	case 4:
	{
			  es = 0x6000;
			  break;
	}	
	case 5:
	{
			  es = 0x5500;
			  break;
	}
	case 6:
	{
			  es = 0x6500;
			  break;
	}
	case 7:
	{
			  es = 0x8000;
			  break;
	}
	case 8:
	{
			  es = 0x3000;
			  break;
	}
	case 9:
	{
			  es = 0x8500;
			  break;
	}
	case 10:
	{
			  es = 0x3500;
			  break;
	}
	default:
		break;
	}
	es1 = es;
	do
	{
		es = es1;
		cl = 1;
		ReadSector();
		ax = i;
		GetFATEntry();
		debug();
		if (ax >= 0xff8||ax==0)
			break;
		i = ax;
		ax += 17;
		ax += 14;
		bx += 512;
	} while (1);
}
LABEL_SEARCH_IN_ROOT_DIR_BEGIN()
{
	while (wRootDirSizeForLoop > 0&&!match)
	{
		dx = 16;
		differ = 0;
		wRootDirSizeForLoop -= 1;
		LABEL_SEARCH_FOR_kernalBIN();
		while (differ)
		{
			if (dx == 0)
			{
				wSectorNo += 1;
				break;
			}
			dx--;
			di &= 0xffe0;
			di += 32;
			differ = 0;
			LABEL_SEARCH_FOR_kernalBIN();
		}
	}
}

LABEL_SEARCH_FOR_kernalBIN()
{
	cx = 11;
	es = 0x7000;
	while (cx)
	{
		cx--;
		al = lodsb();
		if (kernalFileName[10 - cx] != al)
		{
			differ = 1;
			break;
		}
		else if (cx == 0)
			match = 1;
		di++;
	}
}
GetFATEntry()
{
	int di1 = di;
	int bx1 = bx;
	es = 0x7500;
	bOdd = 0;
	ax *= 3;
	if (ax % 2)
		bOdd = 1;
	ax /= 2;
	dx = ax % 512;
	ax /= 512;
	ax++;
	al = 2;
	bx = 0;
	cl = 2;
	ReadSector();
	di = dx;
	ax = lodsw();
	if (bOdd)
		ax /= 16;
	ax &= 0xfff;
	bx = bx1;
	di = di1;
}
