#!/usr/bin/env perl

use v5.10;
use strict;

use Socket;
use IO::Select;

my $port = 9999;
my $nickname = $ARGV[0];
if( !$nickname ){
	say "Nickname plz";
	exit;
}

socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );
my $dest = sockaddr_in( $port, INADDR_ANY);
bind( SOCK, $dest );
say "UDP $port Broadcast Receiver Started";

my $sel = IO::Select->new();
$sel->add(\*STDIN);
$sel->add(\*SOCK);

system('perl','udp_client.pl',$nickname,"--> $nickname 님이 입장하셨습니다. <--");

while( 1 ){

	my @ready = $sel->can_read(1);

	foreach my $r (@ready){
		my $in;

		if( $r eq \*SOCK ){
			my $from = recv( SOCK, $in, 4096, 0 );
			chomp($in);

			my ($fport,$faddr) = unpack_sockaddr_in($from);
			my $ipaddr = inet_ntoa($faddr);

			my ($from_nick,$msg) = split(/\s+/, $in, 2);

			if( $msg =~ /^\/who/ ){
				system('perl','udp_client.pl',$nickname,"--> $nickname 님이 있습니다. <--");
			}
			elsif( $msg =~ /^\/p / ){
				my ($to_nick, $msg2) = split(/\s+/, $', 2);
				if( $to_nick eq $nickname ){ # 내꺼일때만 보여준다.
					say "[귓말] $from_nick : $msg2";
				}
			}
			else{
				say "$from_nick : $msg";
			}
		}
		elsif( $r eq \*STDIN ){
			$in = <STDIN>;
			chomp($in);
			system('perl','udp_client.pl', $nickname, $in);
		}

	}
	
	
}

