program snake;
// Zach Dobbs
// Started on - 4/22/2014
// Last update - 5/16/2014
// Created Junior Year, 2014 - RBHS
// Generic snake game, made to test ability in coding
uses crt;

var
	speed:		integer; // Speed of snake
	diff:		char; // Difference
	score:		integer; // Score
	quit:		boolean; // Restarts the program
	gamemode:	integer; // Mode selector
	snakecolor: integer; // Color of snake
	CChoice:	char; // Choice of color
	ee:			boolean; // Easter egg

	procedure startscreen(); // The first screen to appear
	var
		SSx:		integer; // X coord
		SSy:		integer; // Y coord
		SSybool:	boolean; // Checks to make sure SSy is not on the title
	begin // Begin startscreen
		repeat // Begin print
			gotoxy(35,12);
			writeln('SNAKE');
			gotoxy(32,13);
			writeln('PRESS ENTER');
			repeat // Begin finding random spot
				SSybool:=FALSE;
				SSx:=random(79)+1;
				SSy:=random(24)+1;
				if (SSy>14) OR (SSy<11) then SSybool:=true
			until SSybool=TRUE; // End finding random spot
			gotoxy(SSx,SSy);
			textcolor(random(9)+8);
			write('o');
			delay(10)
		until keypressed // End print
	end; // End startscreen
	


	procedure MOVE(MVEspeed:integer; var MVElink:integer; MVEmode:integer); // Main procedure, basically the entire snake game
	var
		MVEwhere:		char; // moves where?
		// M = >
		// K = <
		// H = V
		// P = ^
        MVEquit:		boolean; // quits
        MVEX:			array[1..100] of integer; // x
        MVEY:			array[1..100] of integer; // y
		MVEXDOT:		array[1..3] of integer; // x to get
		MVEYDOT:		array[1..3] of integer; // y to get
		MVEBX:			array[1..3] of integer; // X of bombs
		MVEBY:			array[1..3] of integer; // Y of bombs
		MVEkey:			char; // Direction
		MVEi:			integer; // counts
		MVEprev:		char; // Backup for direction
		MVEtally:		integer; // Keeps track of movement for bombs
		MVEbombnum:		integer; // Num of bomb being dropped
        MVEsec:			integer; // Seconds
	begin // Begin MVE
		MVEquit:=false;
		MVElink:=4;
		cursoroff;
		MVEtally:=0;
		MVEbombnum:=1;
		MVEX[1]:=30;
		MVEY[1]:=15;
		MVEsec:=5;
		MVEkey:='M';
		MVEprev:=MVEkey;
		
		for MVEi:=1 to 3 do
		begin // Fills random dots for segment
			MVEXDOT[MVEi]:=random(80)+1;
			MVEYDOT[MVEi]:=random(25)+1;
			MVEBX[MVEi]:=random(80)+1;
			MVEBY[MVEi]:=1
		end; // End random dot filling
		
		repeat // Begin game loop
			repeat // Begin moving
			
				if ee then snakecolor:=random(9)+8;
				for MVEi:=MVElink downto 2 do
				begin // Move segments
					MVEX[MVEi]:=MVEX[MVEi-1];
					MVEY[MVEi]:=MVEY[MVEi-1]
				end; // End move
				
				case MVEkey of // Change pos of head
					'M': MVEX[1]:=MVEX[1]+1;
					'K': MVEX[1]:=MVEX[1]-1;
					'H': MVEY[1]:=MVEY[1]-1;
					'P': MVEY[1]:=MVEY[1]+1;
					'q': MVEquit:=true;
				else
					MVEkey:=MVEprev; // Prevents pausing game
					case MVEkey of // Change pos of head
				               'M': MVEX[1]:=MVEX[1]+1;
				               'K': MVEX[1]:=MVEX[1]-1;
					       'H': MVEY[1]:=MVEY[1]-1;
				               'P': MVEY[1]:=MVEY[1]+1;
				               'q': MVEquit:=true
                    			end // end inner case
				end; // end outer case
				
				for MVEi:=1 to 3 do
				begin // Begin placing random dots
					gotoxy(MVEXDOT[MVEi],MVEYDOT[MVEi]);
					textcolor(yellow);
					write('o')
				end; // end place dots
				
				for MVEi:=1 to 3 do
				begin // Check if head of snake has hit a dot
					if (MVEX[1]=MVEXDOT[MVEi]) AND (MVEY[1]=MVEYDOT[MVEi]) then
					begin // begin if
						MVElink:=MVElink+1;
						MVEsec:=5;
						MVEXDOT[MVEi]:=random(80)+1;
						MVEYDOT[MVEi]:=random(25)+1
					end // end inner if
				end; // end outer if
				
				MVEprev:=MVEkey; // Prevents pausing of game by spamming keys
				
				if (MVEX[1]=MVEX[3]) AND (MVEY[1]=MVEY[3]) then
				begin // Prevents user from accidently colliding on back segment
					case MVEkey of // Checks if Opposite key has been pressed
						'M': begin
								MVEkey:='K';
								MVEX[1]:=MVEX[1]-2
							 end;
						'K': begin
								MVEkey:='M';
								MVEX[1]:=MVEX[1]+2
							 end;
						'H': begin
								MVEkey:='P';
								MVEY[1]:=MVEY[1]+2
							 end;
						'P': begin
								MVEkey:='H';
								MVEY[1]:=MVEY[1]-2
							 end					
					end // End case
				end; // End prevention check
				
				for MVEi:=2 to MVElink do
				begin // Check if head has hit segment
					if (MVEX[1]=MVEX[MVEi]) AND (MVEY[1]=MVEY[MVEi]) then MVEquit:=TRUE
				end; // end head check
				
				for MVEi:=2 to MVElink do
				begin // Write segments
					gotoxy(MVEX[MVEi],MVEY[MVEi]);
					textcolor(snakecolor);
					write('o')
				end; // end write segments
				
				gotoxy(MVEX[1],MVEY[1]);
				textcolor(snakecolor);
				write('o'); // Write head
				
				if MVEmode=1 then // BOMB MODE
				begin // DROP BOMBS!
				        MVEtally:=MVEtally+1;

					for MVEi:=1 to 3 do
					begin // Begin writing bombs
						gotoxy(MVEBX[MVEi],MVEBY[MVEi]);
						textcolor(lightred);
						write('o')
					end; // End writing bombs

					for MVEi:=1 to MVEbombnum do
					begin // Change bomb position
						MVEBY[MVEi]:=MVEBY[MVEi]+1;
						if MVEBY[MVEi]=25 then
						begin // Reset bomb position
							MVEBY[MVEi]:=1;
							MVEBX[MVEi]:=random(80)+1
						end // End bomb position
					end; // End bomb pos change

					if MVEtally=10 then
					begin // Tells other bombs to start dropping
						MVEbombnum:=MVEbombnum+1;
						if MVEbombnum=4 then MVEbombnum:=3;
					        MVEtally:=0
					end; // End the bomb num drops

					for MVEi:=1 to MVElink do
					begin // Check if snake hit bomb
						if (MVEX[MVEi]=MVEBX[1]) AND (MVEY[MVEi]=MVEBY[1]) then MVEquit:=TRUE;
						if (MVEX[MVEi]=MVEBX[2]) AND (MVEY[MVEi]=MVEBY[2]) then MVEquit:=TRUE;
						if (MVEX[MVEi]=MVEBX[3]) AND (MVEY[MVEi]=MVEBY[3]) then MVEquit:=TRUE
					end // End check
				end; // End bomb mode

				if MVEmode=3 then // TIME MODE
				begin // Begin timer
					MVEtally:=MVEtally+1;
					if MVEtally=20 then
					begin // Change second
						MVEsec:=MVEsec-1;
						MVEtally:=1;
					end; // End change second
					if MVEsec=0 then MVEquit:=TRUE;
					gotoxy(40,2);
					Textcolor(lightcyan);
					writeln(MvEsec)
				end; // End time
					
				if (MVEX[1]=81) or (MVEX[1]=0) or (MVEY[1]=0) or (MVEY[1]=26) then
				begin // Check if snake has hit wall of screen
					if (MVEmode=2) or (MVEmode=3) then // LOOP MODE
					begin // Begin loop mode commands
						case MVEX[1] of // Change x pos of head
							81: MVEX[1]:=1;
							0: MVEX[1]:=80
						end; // End x pos
						case MVEY[1] of // Change y pos of head
							26: MVEY[1]:=1;
							0: MVEY[1]:=25
						end // End y pos
					end // End loop mode
					else
						MVEquit:=TRUE;
				end; // End check
				delay(MVEspeed);
				clrscr;
			until keypressed or MVEquit; // End moving
			textcolor(yellow);
			if MVEquit=TRUE then writeln('GAME OVER               Press Enter');
			MVEkey:=readkey;
		until MVEquit; // End game
	end; // End MOVE



	procedure restart(var RSTquit: boolean); // Determines if a restart is called
	var
		RSTchar:		char;// Y or N
	begin // Begin restart
		RSTquit:= false;
		repeat // Waits for valid input
			writeln('Would you like to play again?');
			write('Please type y to restart or n to quit: ');
			readln(RSTchar);
			if (RSTchar='n') or (RSTchar='N') then RSTquit:=TRUE;
			clrscr
		until (RSTchar='y') or (RSTchar='Y') or RSTquit // Exits at valid input
	end; // End restart



	procedure SCOREME(SEscore: integer; SEdiff: char); // Displays high scores
        var
		SEfile: 		text; // File containing scores
		SElist: 		array[1..7] of integer; // high scores
		SEi: 			integer; // Counts
		SEj: 			integer; // Also counts
		SEh: 			integer; // Also also counts
		SEname: 		array[1..7] of string; // name of high score holders
		SEtemp: 		integer; // Placeholder variable
		SEuser: 		string; // Name of user
		SEhold: 		string; // name placeholder
                SEhigh: 		boolean; // Determines if there is a new high score
	begin
		SEj:=1;
		SEh:=1;
		SEhigh:=FALSE;
		case SEdiff of // Assigns path of highscore files, currently needs to be changed upon changing computers
			'E','e': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\easy\score.txt');
			'M','m': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\medium\score.txt');
			'H','h': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\hard\score.txt');
			'B','b': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\bomb\score.txt');
			'L','l': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\loop\score.txt');
			'T','t': assign(SEfile,'C:\Users\Zach\Dropbox\Pascal\Snake\scoreboard\time\score.txt')
		end; // End assigning
		reset(SEfile);
		for SEi:=1 to 10 do
		begin // Begin reading files
			if (SEi mod 2 = 1) then
			begin // Get names
				readln(SEfile,SEname[SEj]);
				SEj:=SEj+1
			end // End names
			else
			begin // Get scores
				readln(SEfile,SElist[SEh]);
				SEh:=SEh+1
			end // End scores
		end; // End reading file
		close(SEfile);
		for SEi:=1 to 5 do
		begin // Begin high check
			if SEscore>=SElist[SEi] then SEhigh:=TRUE
		end; // End high check
		if SEhigh=TRUE then
		begin // Allow user to input name
			writeln('NEW HIGH SCORE!');
			write('ENTER YOUR NAME: ');
			readln(SEuser)
		end; // end input
		for SEi:=1 to 5 do
		begin // Begin changing scores
			if SEscore>SElist[SEi] then
			begin // Changes the pos if new high score
				SEtemp:=SElist[SEi];
				SElist[SEi]:=SEscore;
				SEscore:=SEtemp;
				SEhold:=SEname[SEi];
				SEname[SEi]:=SEuser;
				SEuser:=SEhold
			end // End change
		end; // End score changes
		SEj:=1;
		SEh:=1;
		rewrite(SEfile);
		for SEi:=1 to 10 do
		begin // Rewrite highscore file
			if (SEi mod 2 = 1) then
			begin // Write name
				writeln(SEfile,SEname[SEj]);
				SEj:=SEj+1
			end // End name
			else
			begin // Write score
				writeln(SEfile,SElist[SEh]);
				SEh:=SEh+1
			end // End score
		end; // End rewriting
		close(SEfile);
		textcolor(lightgray);
		write('HIGH SCORES FOR ');
		case diff of // Write score chosen
			'E','e': write('EASY');
			'M','m': write('MEDIUM');
			'H','h': write('HARD');
			'B','b': write('BOMB');
			'L','l': write('LOOP');
			'T','t': write('TIME ATTACK');
		end; // End writing
		writeln(' MODE');
		writeln;
		for SEi:=1 to 5 do
		begin // Begin displaying high scores
			textcolor(lightgray);
			write(SEi,':   ',SEname[SEi],' - ');
			textcolor(yellow);
			writeln(SElist[SEi])
		end // End high score display
	end;



begin // Begin MAIN
	repeat // Begin main repeat
		randomize;
		snakecolor:=10;
		score:=0;
		speed:=0;
		ee:=FALSE;
		gamemode:=0;
		cursoroff;
		startscreen;
		clrscr;
		textcolor(lightgray);
		writeln('Press enter');
		readln;
		repeat; // Main display, prompts for difficulty
			clrscr;
			gotoxy(15,1);
			textcolor(lightgreen);
			writeln('SNAKE');
			gotoxy(12,2);
			writeln('ZACH DOBBS');
			gotoxy(1,5);
			textcolor(yellow);
			writeln('Welcome to the Snake game!');
			textcolor(lightgray);
			write('You will control a snake ');
			textcolor(snakecolor);
			write('oooo ');
			writeln;
			textcolor(lightgray);
			write('and attempt to eat all the dots ');
			textcolor(yellow);
			write('o');
			writeln;
			textcolor(lightgray);
			writeln('Every dot you eat will make your snake longer.');
			write('In bomb mode, you must avoid falling bombs ');
			textcolor(lightred);
			write('o');
			textcolor(lightgray);
			writeln;
			writeln('In loop mode and time mode, you only lose by hitting yourself, not walls');
			writeln('In time attack mode, you have 5 seconds to get a dot');
			writeln('You control your snake with the arrow keys.');
			writeln('You will lose the game if your snake hits the edge of the screen');
			writeln('or the snake hits itself.');
			writeln('You may quit the game at any time by pressing the q key.');
			writeln('Your score will be displayed at the end of the game.');
			writeln;
			textcolor(yellow);
			writeln('SELECT YOUR DIFFICULTY');
			writeln('Easy, Medium, Hard, Bomb, Loop, or Time Attack Mode?');
			writeln('Type option to change snake color.');
			cursoron;
			readln(diff);
			case diff of // Choices for gamemodes
				'E','e': speed:=100;
				'M','m': speed:=70;
				'H','h': speed:=40;
				'B','b': begin // Same speed as medium, drops bombs
						speed:=70;
						gamemode:=1
					 end; // end bomb
				'L','l': begin // Higher speed than medium, no collision
						speed:=50;
						gamemode:=2
					 end; // end loop
				'O','o': begin // Choose color
						clrscr;
						writeln('Select the color of your snake!');
						writeln;
						writeln;
						textcolor(lightmagenta);
						writeln('	Purple');
						textcolor(lightgreen);
						writeln('	Green');
						textcolor(red);
						writeln('	Red');
						textcolor(yellow);
						writeln('	Yellow');
						textcolor(white);
						writeln('	White');
						textcolor(lightcyan);
						writeln('	Blue');
						writeln;
						textcolor(lightgray);
						write('Make your selection: ');
						readln(CChoice);
						case CChoice of // Choices of color
							'P','p': snakecolor:=13;
							'G','g': snakecolor:=10;
							'R','r': snakecolor:=4;
							'Y','y': snakecolor:=14;
							'W','w': snakecolor:=15;
							'B','b': snakecolor:=11;
							'*': 	 ee:=TRUE;
						end; // End choice of color
					 end; // End choose color
				'T','t': begin // Higher speed than medium, time limit, no collision
						speed:=50;
						gamemode:=3
					 end
			end // End choices
		until (speed>0); // Repeats until a valid gamemode has been selected
		MOVE(speed,score,gamemode);
		cursoron;
		clrscr;
		textcolor(lightgray);
		write('Score: ');
		textcolor(yellow);
		write(score);
		writeln;
		textcolor(lightgray);
		write('Difficulty: ');
		textcolor(yellow);
		case diff of // Write difficulty
			'E','e': write('EASY');
			'M','m': write('MEDIUM');
			'H','h': write('HARD');
			'B','b': write('BOMB');
			'L','l': write('LOOP');
			'T','t': write('TIME ATTACK')
		end; // End writing difficulty
		writeln;
		writeln;
		writeln;
		restart(quit);
	until quit; // End main repeat block, program will end
end. // END MAIN
