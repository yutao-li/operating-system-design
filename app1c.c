extern void clr();
extern void delay();
extern void show();
extern int readp();
extern void set();
extern void debug();
extern void clrkey();
extern int load();
extern void dofork();
extern void dowait();
extern void doexit(int);
extern void setall();
int NEW = 0;
int READY = 1;
int RUNNING = 2;
int EXIT = 3;
int BLOCKED = 4;
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
char num[10];
char input[80];
int CurrentPCBno = 0;
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
	int pcbfid;
	int pcbid;
	int Process_Status;
}PCB;
PCB pcb_list[2];
PCB* Current_Process();
void Save_Process(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int);
void Schedule();
void memcopy(PCB* F_PCB, PCB* C_PCB)
{
	C_PCB->regImg.GS = F_PCB->regImg.GS;
	C_PCB->regImg.SP = F_PCB->regImg.SP;
	C_PCB->regImg.ES = F_PCB->regImg.ES;
	C_PCB->regImg.DS = F_PCB->regImg.DS;
	C_PCB->regImg.CS = F_PCB->regImg.CS;
	C_PCB->regImg.FS = F_PCB->regImg.FS;
	C_PCB->regImg.IP = F_PCB->regImg.IP;
	C_PCB->regImg.AX = F_PCB->regImg.AX;
	C_PCB->regImg.BX = F_PCB->regImg.BX;
	C_PCB->regImg.CX = F_PCB->regImg.CX;
	C_PCB->regImg.DX = F_PCB->regImg.DX;
	C_PCB->regImg.DI = F_PCB->regImg.DI;
	C_PCB->regImg.SI = F_PCB->regImg.SI;
	C_PCB->regImg.BP = F_PCB->regImg.BP;
	C_PCB->regImg.FLAGS = F_PCB->regImg.FLAGS;
}
void init(PCB* pcb, int num)
{
	pcb->Process_Status = EXIT;
	pcb->pcbid = num;
	pcb->pcbfid = -1;
}

void do_exit(int ch) 
{
	pcb_list[pcb_list[CurrentPCBno].pcbfid].Process_Status = READY;
	pcb_list[pcb_list[CurrentPCBno].pcbfid].regImg.AX = ch;
	pcb_list[CurrentPCBno].Process_Status = EXIT;
	Schedule();
}

PCB* do_fork()
{
	PCB* p = pcb_list;
	while (p->Process_Status != EXIT)
		p++;
	if (p >= pcb_list + 5)
	{
		pcb_list[CurrentPCBno].regImg.AX = -1;
		return 0;
	}
	else
	{
		memcopy(pcb_list + CurrentPCBno, p);
		p->pcbid = p - pcb_list;
		p->pcbfid = CurrentPCBno;
		p->Process_Status = READY;
		pcb_list[CurrentPCBno].regImg.AX = p->pcbid;
		/*stackcopyÓÃÓÚ¸´ÖÆ¶ÑÕ»*/
		p->regImg.SS = p->pcbid * 0x200 + 0x1000;
		p->regImg.AX = 0;
		return p;
	}
}
void Schedule()
{
	do
	{
		CurrentPCBno++;
		if (CurrentPCBno > 4)
			CurrentPCBno = 0;
	} while (pcb_list[CurrentPCBno].Process_Status != READY);
}

void Save_Process(int gs, int fs, int es, int ds, int di, int si, int bp,
	int sp, int dx, int cx, int bx, int ax, int ss, int ip, int cs, int flags)
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
PCB* Current_Process()
{
	return &pcb_list[CurrentPCBno];
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
int read()
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
		else if (al == 0x1b)
		{
			return 1;
		}
		else if (al >= 0x20 && al <= 0x7e || al == 0x0d)
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
	} while (input[maxindex - 1] != 0x0d);
	ax = maxindex - 1;
	return 0;
}
hextodec(int ax)
{
	int remain;
	int i = 0;
	do
	{
		remain = ax % 10;
		ax /= 10;
		num[i] = '0';
		while (remain--)
			num[i]++;
		i++;
	} while (ax);
	for (i -= 1; i >= 0; i--)
	{
		al = num[i];
		showa();
	}
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
void cmain()
{
	int j;
	row = col = al = bl = cl = dl = 0;
	ax = bx = cx = dx = 0;
	for (j = 0; j < 2; j++)
		init(pcb_list + j, j);
	setall();
	while (1)
	{
		pcb_list[0].Process_Status = RUNNING;
		CurrentPCBno = 0;
		do
		{
			row = col = 0;
			clr();
			index = 0;
			introduction("This program can fork a sub program to count the length of string you have input.\n");
			introduction("Hence, please input a string only containing letters, numbers and punctuations \n");
			introduction("within 80 letters, other inputs will be omitted.Meanwhile, \n");
			introduction("you can press backspace and delete to modify, or press left or right arrow to shift the cursor.\n");
			introduction("Lastly, you can press Esc to return to kernel at any time.\n");
			row++; col = 0;
			set();
			cx = read();
			if (cx)
			{
				return;
			}
			row++; col = 0;
			if (!(ax >= 1 && ax < 80))
			{
				introduction("out of range, you should input less than 80 but no less than 1 character.\n");
				delay();
			}
		} while (!(ax >= 1 && ax < 80));
		row++; col = 0;
		debug();
		dofork();
		cx = load();

		if (cx == -1)
			introduction("error in fork.\n");
		else if (cx == 0)
		{
			doexit(ax);
		}
		else
		{
			dowait();
			dx = load();
			introduction("the length is \n");
			hextodec(dx);
		}
		delay();
	}
}