extern void clr();
extern void delay();
extern void show();
extern int readp();
extern void set();
extern void debug();
extern void clrkey();
extern int load();
extern int dofork();
extern void dowait();
extern void doexit(int);
extern void setall();
extern void restart();
extern void retrieve();
extern void clint();
extern void stint();
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
int sonin = 0;
char row;
char col;
int Segment = 0x1000;
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
PCB pcb_list[3];

typedef struct semaphore
{
	int count;
	int used;
	int index;
	int next[3];
}semaphore;
semaphore semlist[3];

int SemaGet(int value) 
{
	int i = -1;
	while (semlist[++i].used);
	if (i< 3) 
	{
		semlist[i].used = 1;
		semlist[i].count = value;
		semlist[i].index = 0;
		return i;
	}
	else
		return (-1);
}

p(int s) 
{
	semlist[s].count--;
	if (semlist[s].count < 0)
		block(s);
}

v(int s) 
{
	semlist[s].count++;
	if (semlist[s].count <= 0)  
		waitUp(s);
}

block(int s)
{
	semlist[s].next[semlist[s].index++] = CurrentPCBno;
	if (semlist[s].index > 2)
		semlist[s].index = 0;
	dowait();
}

waitUp(int s)
{
	int i = semlist[s].index - 1;
	if (i<0)
		i = 2;
	pcb_list[CurrentPCBno].Process_Status = READY;
	pcb_list[semlist[s].next[i]].Process_Status = READY;
}

int SemaFree(int s) 
{
	semlist[s].used = 0;
	semlist[s].index = 0;

	retrieve();
}

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
	if (p >= pcb_list + 3)
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
		/*stackcopyÓÃÓÚ¸´ÖÆ¶ÑÕ»*/
		p->regImg.SS = p->pcbid * 0x200 + 0x1000;
		return p;
	}
}

void Schedule()
{
	CurrentPCBno = 0;
	if (pcb_list[CurrentPCBno].Process_Status == READY)
		return;
	else
	{
		CurrentPCBno = 1 + sonin % 2;
		sonin++;
	}
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
	if (row == 25)
	{
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
	int j, s;
	for (j = 0; j < 3; j++)
	{
		init(pcb_list + j, j);
		semlist[j].used = 0;
		semlist[j].index = 0;
	}
	s = SemaGet(0);
	row = col = al = bl = cl = dl = 0;
	sonin=ax = bx = cx = dx = 0;
	clr();
	introduction("Welcome to the semaphore control multiprocess program. In this program, there is a father and his two sons.\n");
	introduction("The two sons will consistently send fruit or congratulations to their father.\n");
	introduction("Only after the two sons have given their congratulations or fruit respectively will the father accept both.\n");
	introduction("You can press any key at any time to return to the kernel.\n");
	row++; col = 0;
		pcb_list[0].Process_Status = RUNNING;
		CurrentPCBno = 0;
		setall();
		cx += dofork();
		if (CurrentPCBno==0)
		{
			while (1) 
			{ 
				p(s); p(s); 
				clint();
				introduction("Father : Thanks, my sons. I will take your word and fruit.\n");
				row++; col = 0;
				stint();
				if (readp())
				{
					clint();
					SemaFree(s);
					return;
				}
				delay();
			}
		}
		else  if ((cx==2)&&(cx-=dofork()))
		{
			while (1)
			{
				clint();
				introduction("Older son: Father will live one year after another forever!\n"); 
				row++; col = 0;
				stint();
				if (readp())
				{
					SemaFree(s);
					return;
				}
				debug();
				v(s);
				delay();
			}
		}
		else
		{
			while (1) 
			{
				clint();
				introduction("Younger son: Father, I have brought you an apple.\n");
				row++; col = 0;
				stint();
				if (readp())
				{
					SemaFree(s);
					return;
				}
				debug();
				v(s);
				delay();
			}
		}
}
