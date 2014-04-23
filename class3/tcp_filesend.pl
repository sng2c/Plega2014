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

my $server_ip = $ARGV[1];

my $port = 9998;

my $dest = pack_sockaddr_in($port, inet_aton($server_ip));

socket( SOCKET, PF_INET, SOCK_STREAM, (getprotobyname("tcp"))[2] );

connect( SOCKET, $dest ) or die "Can't connect to port $port! \n";

send( SOCKET, "FILENAME $filepath\n", 0 , $dest);
send( SOCKET, $data, 0, $dest );
send( SOCKET, "EOF\n", 0, $dest);

close SOCKET;

