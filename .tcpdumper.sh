#!/bin/sh - 

# requires tcpdump

# -i : Select interface that the capture is to take place on, this will often be an ethernet card or wireless adapter but could also be a vlan or something more unusual. Not always required if there is only one network adapter.
# -nn : A single (n) will not resolve hostnames. A double (nn) will not resolve hostnames or ports. This is handy for not only viewing the IP / port numbers but also when capturing a large amount of data, as the name resolution will slow down the capture.
# -s0 : Snap length, is the size of the packet to capture. -s0 will set the size to unlimited - use this if you want to capture all the traffic. Needed if you want to pull binaries / files from network traffic.
# -v : Verbose, using (-v) or (-vv) increases the amount of detail shown in the output, often showing more protocol specific information.
# port 80 : this is a common port filter to capture only traffic on port 80, that is of course usually HTTP.

# display ascii strings from capture

tcpd_ascii() {
	sudo tcpdump -A -s0 port 80
}

# filter on udp traffic (protocol 17)

tcpd_udp() {
	sudo tcpdump -i eth0 udp 
}

# capture via ip (src and dst)

tcpd_host() {
	sudo tcpdump -i eth0 host $1
}

tcpd_src() {
	sudo tcpdump -i eth0 src $1
}

tcpd_dst() {
	sudo tcpdump -i eth0 dst $1
}

tcpd_capture() {
	sudo tcpdump -i etho -s0 capture.pcap
}

tcpd_extract_user_agents() {
	sudo tcpdump -nn -A -s1500 -l | grep "User-Agent:"
}

# capture only HTTP GET and POST packets
tcpd_capture_GET() {
	sudo tcpdump -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
}

tcpd_capture_POST() {
	sudo tcpdump -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354'
}

tcpd_capture_ftp_creds() {
	sudo tcpdump -nn -v port ftp or ftp-data
}

tcpd_ipv6() {
	sudo tcpdump -nn ip6 proto 6
}

# capture http data packets
tcpd_http_data() {
	sudo tcpdump 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2))>>2)) != 0)'
}

# Other than manually moving the file from the remote system to the local workstation it is possible to feed the capture to Wireshark over the SSH connection in real time. This tip is a favorite, pipe the raw tcpdump output right into wireshark on your local machine. Don't forget the not port 22 so you are not capturing your SSH traffic.

tcpd_over_ssh_to_wireshark() {
	ssh $1@$2 'tcpdump -s0 -c 1000 -nn -w - not port 22' | wireshark -k -i -
}

tcpd_top_hosts_by_packet() {
	sudo tcpdump -nnn -t -c 200 | cut -f 1,2,3,4 -d '.' | sort | uniq -c | sort -nr | head -n 20
}

tcpd_capture_plaintext_passwords() {
	sudo tcpdump port http or port ftp or port smtp or port imap or port pop3 or port telnet -l -A | egrep -i -B5 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd=|password=|pass:|user:|username:|password:|login:|pass |user '
}

tcpd_dhcp_requests() {
	sudo tcpdump -v -n port 67 or 68
}
