/*
	c programming course task

	count rows, chars and reserved strings from c source 

*/
#include <stdio.h>
#include <string.h>
#include <ctype.h> 

int Menu(void);
int SourceFileNameCheck(char fname[256]);
int SourceFile(char sfile[256]);
int ResultFile(char rfile[256]);
int Keyboard(void);
void Display(void);

int row_number, chars_number, idents_number;

char reserved[20][8] = {"auto",
			"char",
			"const",
			"double",
			"enum",
			"extern",
			"float",
			"int",
			"long",
			"register",
			"short",
			"signed",
			"static",
			"struct",
			"typedef",
			"union",
			"unsigned",
			"void",
			"volatile",
			"FILE"};

int main(void)
{
//	printf("%d\n",menu());
	while(Menu() != 48);
	
	return 0;	
}

int SourceFileNameCheck(char fname[256])
{
	int i, success = 1;
	i = strlen(fname);
	if( i < 3 )
	{
		printf("Too short file name.\n");
	}
	else if((fname[i-2] == '.') && ((fname[i-1] == 'C') || (fname[i-1] == 'c'))) /* */
	{
		 success = 0;
	}
	else
	{
		printf("Source file name must end with '.c' or '.C'.\n");
	}
	
	return success;
}

int SourceFile(char sfile[256])
{
	int rows = 0, i, chars, count, check_row = 0, find = 0;
	char *temp, row_str[256], delims[] = "\t ,[];()*";

	FILE *fps;
	fps = fopen(sfile, "r");
	if(!fps)
	{
		printf("Cannot open source file.\n");
		return 1;
	}
	while(!feof(fps))
	{
		count = 0;
		fgets(row_str, 256, fps);
		rows++;
		chars = strlen(row_str);
		for(i = 0; i < chars; i++)
		{
			if(isgraph(row_str[i]))
			{
				count++;
			}
		}
		if(count >= chars_number)
		{
			row_number = rows;
			chars_number = count;
		}
		temp = strtok(row_str, delims);
		
		for(i = 0; i < 20; i++)
			if(!strcmp(temp,reserved[i]))
				check_row = 1;
		if(check_row)
		{
			temp = strtok(NULL, delims);	
			while(temp != NULL)
			{
				for(i = 0; i < 20; i++)
					if(!strcmp(temp,reserved[i]))
						find = 1;
				if(!find)
					idents_number++;
				find = 0;
				temp = strtok(NULL, delims); 
			}
			idents_number--;
		}	
		check_row = 0;
	}
	fclose(fps);
	return 0;
}

int ResultFile(char rfile[256])
{
	FILE *fpr;
	fpr = fopen(rfile, "w");
	if(!fpr)
	{
		printf("Cannot open result file.\n");
		return 1;
	}
	fprintf(fpr,"Row - %d, Chars - %d\nIdents - %d\n", row_number, chars_number, idents_number);
	fclose(fpr);
	return 0;
}

int Keyboard(void)
{
	FILE *fp;
	int ch;

	fp = fopen("_temp","w");
	if(!fp)
	{
		printf("Cannot create temporary file!\n");
		return 1;
	}
	printf("Enter source code:\n");
	while (ch != EOF)
	{
		ch = getchar();
		putc(ch, fp);
	}
	fclose(fp);
	return 0;
}

void Display(void)
{
	printf("Row - %d, Chars - %d\nIdents - %d\n", row_number, chars_number, idents_number);
}

int Menu(void)
{
	int check = 1, i, status, key;
	char rfile[256], sfile[256];

	row_number = 0; chars_number = 0; idents_number = 0;
	printf("\033[2J");
	printf("===========================\n");
	printf("[1] file file\n");
	printf("[2] file display\n");
	printf("[3] keyboard file\n");
	printf("[4] keyboard display\n");
	printf("[0] Exit\n");
	printf("===========================\n");
	printf("Enter value: ");
	fflush(stdin);
	key = 1;
	key = getchar();
	switch(key){
		case '1':
			while(check)
			{
				printf("Enter source file name:");
				scanf("%s",sfile);
				check = SourceFileNameCheck(sfile);
				
			}
			printf("Enter result file name:");
			scanf("%s",rfile);
			status = SourceFile(sfile);
			if(status)
				break;
			ResultFile(rfile);
			break;
		case '2':
			while(check)
			{
				printf("Enter source file name:");
				scanf("%s",sfile);
				check = SourceFileNameCheck(sfile);
			}
			status = SourceFile(sfile);
			if(status)
				break;
			Display();		
			break;
		case '3':
			printf("Enter result file name:");
			scanf("%s",rfile);
			status = Keyboard();
			if(status)
				break;
			status = SourceFile("_temp");
			if(status)
				break;
			ResultFile(rfile);
			break;
		case '4':
			status = Keyboard();
			if(status)
				break;
			status = SourceFile("_temp");
			if(status)
				break;
			Display();
			break;
		case '0':
			break;
		default:
			printf("%d\n",key);
	}
	return key;
}
