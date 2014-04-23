#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use Socket;

my $port = 9999;

socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));

setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );

my $dest = sockaddr_in( $port, INADDR_ANY);

bind( SOCK, $dest );

say "UDP $port Broadcast Receiver Started";

my $in;
my $out;	
my $filename;
while( my $from = recv( SOCK, $in, 4096, 0 ) ){

	if( $in =~ /^FILENAME (.+)$/){
		$filename = $1;

		open($out,">udp_recv/$filename");
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
