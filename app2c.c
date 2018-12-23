extern void clr();
extern void delay();
extern void show();
extern int readp();
extern void set();
extern void debug();
extern void setClock();
extern void clrkey();
int NEW = 0;
int READY = 1;
int RUNNING = 2;
int EXIT = 3;
int index = 0;
char al, bl, cl, dl, ah, bh, ch, dh;
int ax;
int bx;
int cx;
int dx;
int es;
int di;
char row;
char col;
int Segment = 0x1000;
char paget[38] = "please press any key to turn the page.";
char input[80];
int CurrentPCBno = 0;
int Program_Num = 0;
typedef struct RegisterImage
{
	int SS;
	int GS;
	int FS;
	int ES;
	int DS;
	int DI;
	int SI;
	int BP;
	int SP;
	int BX;
	int DX;
	int CX;
	int AX;
	int IP;
	int CS;
	int FLAGS;
}RegisterImage;

typedef struct PCB
{
	RegisterImage regImg;
	int Process_Status;
}PCB;
PCB pcb_list[5];
PCB* Current_Process();
void Save_Process(int,int, int, int, int, int, int, int,int,int,int,int, int,int, int,int );
void init(PCB*, int, int);
void Schedule();
void special();
void Save_Process(int gs,int fs,int es,int ds,int di,int si,int bp,
		int sp,int dx,int cx,int bx,int ax,int ss,int ip,int cs,int flags)
{
	pcb_list[CurrentPCBno].regImg.AX = ax;
	pcb_list[CurrentPCBno].regImg.BX = bx;
	pcb_list[CurrentPCBno].regImg.CX = cx;
	pcb_list[CurrentPCBno].regImg.DX = dx;

	pcb_list[CurrentPCBno].regImg.DS = ds;
	pcb_list[CurrentPCBno].regImg.ES = es;
	pcb_list[CurrentPCBno].regImg.FS = fs;
	pcb_list[CurrentPCBno].regImg.GS = gs;
	pcb_list[CurrentPCBno].regImg.SS = ss;

	pcb_list[CurrentPCBno].regImg.IP = ip;
	pcb_list[CurrentPCBno].regImg.CS = cs;
	pcb_list[CurrentPCBno].regImg.FLAGS = flags;
	
	pcb_list[CurrentPCBno].regImg.DI = di;
	pcb_list[CurrentPCBno].regImg.SI = si;
	pcb_list[CurrentPCBno].regImg.SP = sp;
	pcb_list[CurrentPCBno].regImg.BP = bp;
}
void maintain()
{
	Program_Num = ax;
}
void Schedule()
{
	pcb_list[CurrentPCBno].Process_Status = READY;
	CurrentPCBno ++;
	if( CurrentPCBno > Program_Num )
		CurrentPCBno = 1;
	if( pcb_list[CurrentPCBno].Process_Status != NEW )
		pcb_list[CurrentPCBno].Process_Status = RUNNING;
	Program_Num = ax;
	return;
}
PCB* Current_Process()
{

	return &pcb_list[CurrentPCBno];
}

void init(PCB* pcb,int segement, int offset)
{
	pcb->regImg.GS = 0xb800;
	pcb->regImg.SS = segement;
	pcb->regImg.ES = segement;
	pcb->regImg.DS = segement;
	pcb->regImg.CS = segement;
	pcb->regImg.FS = segement;
	pcb->regImg.IP = offset;
	pcb->regImg.SP = offset - 4;
	pcb->regImg.AX = 0;
	pcb->regImg.BX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.FLAGS = 512;
	pcb->Process_Status = NEW;
}

void special()
{
	if(pcb_list[CurrentPCBno].Process_Status==NEW)
		pcb_list[CurrentPCBno].Process_Status=RUNNING;
}

void introduction(char a[])
{
	int i;
	char cha = al;
	i = 0;
	do
	{
		al = a[i];
		showa();
		i++;
	} while (a[i] != '\n');
	al = cha;
}
void read()
{
	int maxindex = 0, i = 0;
	do
	{
		ax = readp();
		al = ax % 0x100;
		ah = ax >> 8;
		if (al == 8)
		{
			if (index > 0)
			{
				index--;
				for (i = index; i < maxindex - 1; i++)
					input[i] = input[i + 1];
				maxindex--;
				col = index;
				set();
			}
		}
		else if (al == 0)
		{
			if (ah == 0x4b)
			{
				if (index>0)
				{
					index--;
					col = index;
					set();
				}
			}
			else if (ah == 0x4d)
			{
				if (index<maxindex)
				{
					index++;
					col = index;
					set();
				}
			}
			else if (ah == 0x53)
			{
				if (index < maxindex)
				{
					for (i = index; i <maxindex - 1; i++)
					{
						input[i] = input[i + 1];
					}
					maxindex--;
				}
			}
		}
		else
		{
			for (i = maxindex; i > index; i--)
			{
				input[i] = input[i - 1];
			}
			input[index++] = al;
			maxindex++;
			if (al != 0x0d)
			{
				col = index;
				set();
			}
		}
		if (maxindex >= 80)
			break;	
		col = 0;
		for (i = 0; i < 80; i++)
		{
			al = ' ';
			showa();
		}
		col = 0;
		for (i = 0; i < maxindex; i++)
		{
			al = input[i];
			if (!(al == 0xd && i == maxindex - 1))
				showa();
		}
	} while (input[maxindex-1] != 0x0d);
	ax = maxindex-1;
}
int dulplicate()
{
	char a;
	int count, i = count = 0;
	for (a = '1'; a < '5'; a++)
	{
		for (i = 0; i < ax; i++)
		{
			if (input[i] == a)
				count++;
		}
		if (count>1)
			return 0;
		count = 0;
	}
	return 1;
}
int check()
{
	int i = 0;
	for (i = 0; i < ax; i++)
	{
		if (!(input[i] >= '1'&&input[i] <= '4'))
			return 0;
	}
	return 1;
}
void cmain()
{
	int j;
	row = col = al = bl = cl = dl = 0;
	ax = bx = cx = dx = 0;
	CurrentPCBno = 0;
	Program_Num = 0;
	setClock();
	do
	{
		row = col = 0;
		clr();
		index = 0;
		introduction("please input the number(1-4) of programs you want to execute successively and press enter to confirm.\n");
		row++; col = 0;
		introduction("1  for the upper left part, 2 for the upper right part, 3 for the lower left part, 4 for the lower right part.\n");
		row++; col = 0;
		introduction("you can press backspace, delete to modify, or press left or right arrow to shift the cursor.\n");
		row++; col = 0;
		set();
		read();
		row++; col = 0;
		if (!(ax >= 1 && ax <= 4))
		{
			introduction("out of range, you should input no more than 4 but no less than 1 digit.\n");
			delay();
		}
		else if (!check())
		{
			introduction("invalid input,please try again.\n");
			delay();
		}
		else if (!dulplicate())
		{
			introduction("dulplicate input,please try again.\n");
			delay();
		}
	} while (!(ax >= 1 && ax <= 4 && check()&&dulplicate()));
	clr();
	for (j = 0; j < ax; j++)
	{
		bl = input[j] - '0';
		switch (bl)
		{
		case 1:
		{
				  init(&pcb_list[j+1], 0x4000, 0x100);
				  break;
		}
		case 2:
		{
				  init(&pcb_list[j+1], 0x4500, 0x100);
				  break;
		}
		case 3:
		{
				  init(&pcb_list[j+1], 0x5000, 0x100);
				  break;
		}
		case 4:
		{
				  init(&pcb_list[j+1], 0x6000, 0x100);
				  break;
		}
		default:
			break;
		}
	}
	Program_Num = ax;
}

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
}
