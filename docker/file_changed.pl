#!/usr/bin/env perl 
use AnyEvent;
use AnyEvent::Filesys::Notify;
use Data::Dumper;

$|++;

my $cv = AE::cv;

my $notifier = AnyEvent::Filesys::Notify->new(
    dirs     => [ './' ],
	filter   => sub { shift =~ /\.md$/ },
    cb       => sub {
        my (@events) = @_;
        print "File Changed\n";
		system(qw(./build.sh));
    },
);

$cv->recv;
