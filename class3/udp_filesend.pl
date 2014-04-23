#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use Socket ;


my $filepath = $ARGV[0];
open(FILE, $filepath);
my $data;
read(FILE, $data, (-s $filepath));
close(FILE);

my $port = 9999;

socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname("udp") );

setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );

my $dest = sockaddr_in( $port, INADDR_BROADCAST );

send( SOCKET, "FILENAME $filepath\n", 0 , $dest);
for(my $i=0; $i<length($data); $i+=1024){
	send( SOCKET, substr($data,$i,1024), 0, $dest );
}
send( SOCKET, "EOF\n", 0, $dest);

close SOCKET;

