all: p c t

p:
	/bin/cp -v p.sh /usr/local/bin/p
	/bin/chmod +x /usr/local/bin/p

c:
	/bin/cp -v c.sh /usr/local/bin/c
	/bin/chmod +x /usr/local/bin/c

t:
	/bin/cp -v t.sh /usr/local/bin/t
	/bin/chmod +x /usr/local/bin/t
