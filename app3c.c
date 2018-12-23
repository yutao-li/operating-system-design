#define right 1
#define down 2
#define left 3 
#define up 4
char  al,ah,bl, bh, cl, ch, dl, dh;
int ax, bx, cx, dx;
char dire = right;
char hrow = 0;
char hcol = 3;
char trow = 0;
char tcol = 0;
char row = 0, col = 0;
char state = 0;
extern char lodsb();
extern void show();
extern void showal();
extern int getrand();
extern char input();
extern void delay();
extern void debug();
extern int setd();
extern void clr();
extern void set();
extern char readp();
char w[] = "you win!";
char l[] = "you lose...";
char try[] = "try again?<Y/n>";
int diffculty;
char xy[2000][2];
int hindex, tindex;
showa()
{
	bx = 80 * row + col;
	bx *= 2;
	show();
}
showh()
{
	bx = 80 * hrow + hcol;
	bx *= 2;
	al = 0x70;
	show();
}
cleart()
{
	bx = 80 * trow + tcol;
	bx *= 2;
	al = 0;
	show();
}
int test()
{
	if (hrow >= 25 || hrow < 0 || hcol>79 || hcol < 0)
		return 1;
	bx = 80 * hrow + hcol;
	bx *= 2;
	al = lodsb();
	if (al == 0x70)
		return 1;
	return 0;
}
sett()
{
	trow = xy[tindex][0];
	tcol = xy[tindex][1];
	tindex++;
	if (tindex >= 2000)
		tindex = 0;
}
lose()
{
	int i;
	row = 12;
	col = 33;
	for (i = 0; i < 12; i++)
	{
		al = l[i];
		bx = 80 * row + col;
		bx *= 2;
		showal();
		col++;
	}
	row++;
	col = 32;
	for (i = 0; i < 15; i++)
	{
		al = try[i];
		bx = 80 * row + col;
		bx *= 2;
		showal();
		col++;
	}
	set();
	while (1)
	{
		al = readp();
		if (al == 'y' || al == 'Y')
		{
			al = 1;
			break;
		}
		else if (al == 'n' || al == 'N')
		{
			al = 0;
			break;
		}
	}
}
win()
{
	int i;
	row = 12;
	col = 35;
	for (i = 0; i < 9; i++)
	{
		al = w[i];
		bx = 80 * row + col;
		bx *= 2;
		showal();
		col++;
	}
	row++;
	col = 32;
	for (i = 0; i < 15; i++)
	{
		al = try[i];
		bx = 80 * row + col;
		bx *= 2;
		showal();
		col++;
	}
	set();
	while (1)
	{
		al = readp();
		if (al == 'y' || al == 'Y')
		{
			al = 1;
			break;
		}
		else if (al == 'n' || al == 'N')
		{
			al = 0;
			break;
		}
	}
}
char finish()
{
	int i, k;
	for (i = 0; i < 25;i++)
	for (k = 0; k < 80; k++)
	{
		bx = 80 * i + k;
		bx *= 2;
		al = lodsb();
		if (al != 0x70)
			return 0;
	}
	return 1;
}
greedysnake()
{
	int i,m;
	hindex = 4;
	tindex = 1;
	state = 0;
	dire = 1;
	hrow = 0;
	hcol = 3;
	trow = 0;
	tcol = 0;
	row = 0; col = 0;
	diffculty = setd();
	clr();
	for (i = 0; i < 4; i++)
	{
		xy[i][0] = 0;
		xy[i][1] = i;
	}
	while (col < 4)
	{
		al = 0x70;
		showa();
		col++;
	}
	ax = getrand();
	row = ax % 25;
	col = ax % 80;
	bx = 80 * row + col;
	bx *= 2;
	al = lodsb();
	while (al == 0x70)
	{
		bx += 2;
		if (bx > 3998)
			bx = 0;
		al = lodsb();
	}
	al = 0x40;
	show();
	while (1)
	{
		showh();
		if (dire==right||dire==left)
		for (i = 0; i < diffculty;i++)
		for(m=0;m<10;m++)
			delay(); 
		else
		for (i = 0; i < 2*diffculty; i++)
		for(m=0;m<10;m++)
			delay();
		if (state)
		{
			cleart();
			sett();
		}
		else
			state = 1;
		al = input();
		if (al != dire&&al != 0&&al!=5)
		{
			if (!(al == up&&dire == down || al == down&&dire == up || al == left&&dire == right || al == right&&dire == left))
				dire = al;
		}
		debug();
		switch (dire)
		{
		case right:
		{
					  hcol++;
					  break;
		}
		case left:
		{
					 hcol--;
					 break;
		}
		case up:
		{
				   hrow--;
				   break;
		}
		case down:
		{
					 hrow++;
					 break;
		}
		default:
			break;
		}

		xy[hindex][0] = hrow;
		xy[hindex][1] = hcol;
		hindex++;
		if (hindex >= 2000)
			hindex = 0;
		bx = 80 * hrow + hcol;
		bx *= 2;
		al = lodsb();
		if (al == 0x40)
		{ 
			state = 0;
			ax = getrand();
			row = ax % 25;
			col = ax % 80;
			bx = 80 * row + col;
			bx *= 2;
			al = lodsb();
			while (al == 0x70||al==0x40)
			 {
				bx += 2;
				if (bx > 3998)
					bx = 0;
				al = lodsb();
			 }
			al = 0x40;
			show();
		}

		if (test())
		{
			lose();
			break;
		}
		else if (finish())
		{
			win();
			break;
		}
	}
}
