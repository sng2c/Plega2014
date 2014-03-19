#!/usr/bin/env perl

use v5.10;

use Socket;

my $port = 9999;

socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));

setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );

my $dest = sockaddr_in( $port, INADDR_ANY);

bind( SOCK, $dest );

say "UDP $port Broadcast Receiver Started";

my $in;

while( my $from = recv( SOCK, $in, 4096, 0 ) ){

	my ($fport,$faddr) = unpack_sockaddr_in($from);

	my $ipaddr = inet_ntoa($faddr);

	say "$ipaddr:$fport => $in";

}

