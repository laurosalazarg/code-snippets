# Donator kits generator, GOD, Leyenda, Elite, Magnate, MiRey,Lady, VIP (hunger games), SkyMaster (skyblock)
# 
# Usage: python donatorGen.py server user rank
#											   
# 
import shlex
import subprocess
import sys

server = sys.argv[1]
user = sys.argv[2]

print 'Running commands for server: ' + server
print 'Gving user blocks and permissions: ' + user

# runConsole enters minecraft console, executes commands
def runConsole(screenCommands):
	for cmd in screenCmds:
		completeCmd = "screen -p 0 -S %s -X eval \'%s\'"%(server,cmd)
		#print completeCmd
		args = shlex.split(completeCmd)
		subprocess.call(args)
	
def runConsoleHG(screenCommands):
	for cmd in screenCmds:
		completeCmdhg1 = "screen -p 0 -S %s -X eval \'%s\'"%('hg1',cmd)
		completeCmdhg2 = "screen -p 0 -S %s -X eval \'%s\'"%('hg2',cmd)
		completeCmdhg3 = "screen -p 0 -S %s -X eval \'%s\'"%('hg3',cmd)
		completeCmdhg4 = "screen -p 0 -S %s -X eval \'%s\'"%('hg4',cmd)
		completeCmdhg5 = "screen -p 0 -S %s -X eval \'%s\'"%('hg5',cmd)
		#print completeCmd
		args1 = shlex.split(completeCmdhg1)
		subprocess.call(args1)
		args2 = shlex.split(completeCmdhg2)
		subprocess.call(args2)
		args3 = shlex.split(completeCmdhg3)
		subprocess.call(args3)
		args4 = shlex.split(completeCmdhg4)
		subprocess.call(args4)
		args5 = shlex.split(completeCmdhg5)
		subprocess.call(args5)
		
# group GOD
if sys.argv[3]=='GOD':
	screenCmds = ["stuff \"give %s diamondblock 5\"\015"%user,      
			  "stuff \"give %s ironblock 5\"\015"%user,         
			  "stuff \"give %s goldblock 5\"\015"%user,
			  "stuff \"ar add %s 2700\"\015"%user,
			  "stuff \"pex user %s group set GOD\"\015"%user]   
	runConsole(screenCmds)
	print 'Done.Gave GOD'
# group Leyenda
elif sys.argv[3]=='Leyenda':
	screenCmds = ["stuff \"give %s diamondblock 5\"\015"%user,      
			  "stuff \"give %s ironblock 5\"\015"%user,         
			  "stuff \"give %s goldblock 5\"\015"%user,
			  "stuff \"ar add %s 5400\"\015"%user,
			  "stuff \"eco give %s 20000\"\015"%user,
			  "stuff \"give %s 133 5\"\015"%user,
			  "stuff \"pex user %s group set Leyenda\"\015"%user]   
	runConsole(screenCmds)
	print 'Done.Gave Leyenda'
# group Elite
elif sys.argv[3]=='Elite':
	screenCmds = ["stuff \"give %s diamondblock 5\"\015"%user,      
			  "stuff \"give %s ironblock 5\"\015"%user,         
			  "stuff \"give %s goldblock 5\"\015"%user,
			  "stuff \"ar add %s 4500\"\015"%user,
			  "stuff \"xp set %s 120L\"\015"%user,
			  "stuff \"eco give %s 10000\"\015"%user,
			  "stuff \"give %s 133 5\"\015"%user,
			  "stuff \"pex user %s group set Elite\"\015"%user]   
	runConsole(screenCmds)
	print 'Done.Gave Elite'
# group Magnate
elif sys.argv[3]=='Magnate':
	screenCmds = ["stuff \"give %s diamondblock 5\"\015"%user,      
			  "stuff \"give %s ironblock 5\"\015"%user,         
			  "stuff \"give %s goldblock 5\"\015"%user,
			  "stuff \"ar add %s 3600\"\015"%user,
			  "stuff \"xp set %s 90L\"\015"%user,
			  "stuff \"give %s 133 5\"\015"%user,
			  "stuff \"pex user %s group set Magnate\"\015"%user]   
	runConsole(screenCmds)
	print 'Done.Gave Magnate'
# group MiRey
elif sys.argv[3]=='MiRey':
	screenCmds = ["stuff \"pex user %s group set MiRey\"\015"%user,
				  "stuff \"give %s diamondblock 5\"\015"%user, 
				  "stuff \"ar add %s 900\"\015"%user] 
	runConsole(screenCmds)
	print 'Done.Gave MiRey'
# group Lady
elif sys.argv[3]=='Lady':
	screenCmds = ["stuff \"pex user %s group set Lady\"\015"%user,
				  "stuff \"give %s diamondblock 5\"\015"%user, 
				  "stuff \"ar add %s 900\"\015"%user] 
	runConsole(screenCmds)
	print 'Done.Gave Lady'
# group HG VIP
elif sys.argv[3]=='VIP':
	screenCmds = ["stuff \"pex user %s group set VIP\"\015"%user]  
	runConsoleHG(screenCmds)
	print 'Done. Gave Hunger Games VIP'
# group SkyMaster, skyblocks
elif sys.argv[3]=='SkyMaster':
	screenCmds = ["stuff \"give %s 264 5\"\015"%user,      # 5 diamonds
			  "stuff \"give %s ironblock 5\"\015"%user,         
			  "stuff \"give %s goldblock 5\"\015"%user,
			  "stuff \"give %s 133 1\"\015"%user,			# 1 emerald block
			  "stuff \"give %s 2 64\"\015"%user,			# 64 grass
			  "stuff \"give %s 12 32\"\015"%user,			# 32 sand
			  "stuff \"give %s 152 5\"\015"%user,			# 5 redstone block
			  "stuff \"give %s 383:91 1\"\015"%user,			# 1 sheep
			  "stuff \"give %s 383:92 1\"\015"%user,			# 1 cow
			  "stuff \"give %s 383:90 1\"\015"%user,			# 1 pig
			  "stuff \"give %s 383:120 1\"\015"%user,			# 1 villager
			  "stuff \"give %s 383:93 1\"\015"%user,			# 1 chicken
			  "stuff \"pex user %s group set SkyMaster\"\015"%user]   
	runConsole(screenCmds)
	print 'Done.Gave SkyMaster'

	
	
	
	
	
	
	
	
	
	
	
	
	
	