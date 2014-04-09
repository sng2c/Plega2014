#!/usr/bin/env perl

use v5.10;
use strict;
use Socket;

my $port = 9999;
my $nickname = $ARGV[0];
if( !$nickname ){
	say "usage: perl udp_server.pl NICKNAME";
	exit;
}

socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );
my $dest = sockaddr_in( $port, INADDR_ANY);
bind( SOCK, $dest );
say "UDP $port Broadcast Receiver Started";

use IO::Select;
my $sel = IO::Select->new();
$sel->add(\*STDIN);
$sel->add(\*SOCK);

system('perl','udp_client.pl',$nickname,">>> $nickname 입장 <<<");

while( 1 ){

	my @ready = $sel->can_read();

	foreach my $r (@ready){
		my $in;

		if( $r eq \*SOCK ){
			my $from = recv( SOCK, $in, 4096, 0 );
			chomp($in);

			my ($fport,$faddr) = unpack_sockaddr_in($from);
			my $ipaddr = inet_ntoa($faddr);

			my ($from_nick,$msg) = split(/\s+/, $in, 2);

			if( $msg =~ /^\/ping/ ){
				system('perl','udp_client.pl',$nickname,"/p $from_nick >>> $nickname 있음 <<<");
			}
			elsif( $msg =~ /^\/p / ){
				my ($to_nick, $submsg) = split(/\s+/, $', 2);
				if( $to_nick eq $nickname ){ # 내꺼일때만 보여준다.
					say "\t[귓말] $from_nick : $submsg";
				}
			}
			else{
				say "\t$from_nick : $msg";
			}
		}
		elsif( $r eq \*STDIN ){
			$in = <STDIN>;
			chomp($in);
			system('perl','udp_client.pl', $nickname, $in);
		}

	}
	
	
}