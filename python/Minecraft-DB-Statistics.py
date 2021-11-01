#!"C:\Python27\python.exe"
import MySQLdb
#import cgitb

#cgitb.enable()

#print "Content-type: text/html\n"
mcServer = 'hg4'
db = MySQLdb.Connect(host="localhost",user="user",passwd="pass",db=mcServer)
cur = db.cursor()

# show player names, and number of coins from HG
print 'Data for: ' + mcServer
print 'Top Players\n'
cur.execute("select name,coins from reward join (players) on (reward.id=players.id) where coins > 100 order by coins desc")
i=0
for data in cur.fetchall():
    if i<30:
        i+=1
        print '#' + str(i) + '. ' + data[0],'| Coins: ' + str(data[1])
        
idNum=1;

print '\nPrimeros jugadores en entrar a ' + mcServer +'\n'
# second query
for x in range(1,11):
    # show players names according to id
    cur.execute("select name from players where id=" + str(idNum))
    idNum+=1
    for data2 in cur.fetchall():
        print '#' + str(x) + '. '+ data2[0]
        
        
        
print '\nXauth Numero de jugadores registrados por mes Enero-Agosto 2013'
db2 = MySQLdb.Connect(host="localhost",user="user",passwd="pass",db="mcxauth")
cur2 = db2.cursor()

for dateNum in range(1,9):
    cur2.execute("select count(*) from accounts where registerdate like '2013-0"+str(dateNum)+ "%'" )
    for data3 in cur2.fetchall():
        print 'Mes: '+ str(dateNum)+' '+'Numero de cuentas registradas: '   + str(data3[0])
        
idXauth = 30       
print '\nFirst players in server\n'

cur2.execute("select playername from accounts where id <" + str(idXauth))

x=0
for data4 in cur2.fetchall():
        x+=1
        print '#' + str(x) + '. ' + data4[0]
        
db3 = MySQLdb.Connect(host="localhost",user="user",passwd="pass",db="griefprevention")
cur3 = db3.cursor()

print '\nbloques acumulados'
cur3.execute("select name,accruedblocks from griefprevention_playerdata where accruedblocks > 40000 order by accruedblocks desc")

for data5 in cur3.fetchall():
    print data5[0] + ' |'+ ' Blocks: ' + str(data5[1])
    
print '\nclaims\n'
cur3.execute("select owner, count(id) from griefprevention_claimdata group by owner having count(id) > 30 order by count(id) desc")

nm = 0
for data6 in cur3.fetchall():
    nm+=1
    print '# '+ str(nm) + ' ' + data6[0] + '. |'+ ' Propiedades: ' + str(data6[1])
    
db4 = MySQLdb.Connect(host="localhost",user="user",passwd="pass",db="craftconomy3")
cur4 = db4.cursor()

print '\neconomy'
cur4.execute("select name,balance from cc3_account join (cc3_balance) on (cc3_account.id=cc3_balance.id) where balance >= 1000000 order by balance desc")

mm=0
for data7 in cur4.fetchall():
    mm += 1
    print '#' + str(mm) + '. ' +data7[0] + ' |'+ ' Balance: $' + str(data7[1])
        
        
    

        
    
    
    
    