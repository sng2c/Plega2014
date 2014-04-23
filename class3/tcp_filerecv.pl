#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use Socket;

my $port = 9998;

my $proto = getprotobyname('tcp');

socket( SOCKET, PF_INET, SOCK_STREAM, $proto);
setsockopt( SOCKET, SOL_SOCKET, SO_REUSEADDR, 1 );

my $dest = sockaddr_in( $port, INADDR_ANY);

bind( SOCKET, $dest );

listen(SOCKET, 5) or die "listen: $!";

say "TCP $port Receiver Started";


my $client_addr;
while ($client_addr = accept(NEW_SOCKET, SOCKET)) {
	say "Accept new socket";
	my $in;
	my $out;	
	my $filename;
	while(my $in = <NEW_SOCKET>){
		if( $in =~ /^FILENAME (.+)$/){
			$filename = $1;

			open($out,">tcp_recv/$filename");
			say "recv $filename";

			next;
		}

		if( $in =~ /^EOF$/ ){
			say "done $filename";
			last;
		}

		if( $out ){
			print $out $in;
		}
	}
	close($out);
}

