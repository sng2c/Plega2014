# Class 3. File 전송

## UDP를 통한 파일전송


### 파일전송 프로토콜

파일이 전송될때에는 부가적인 정보가 필요합니다.
파일의 시작과 끝을 알수 있는 정보와, 파일의 이름등이죠.


```
파일열기 : CLIENT  --------- "FILENAME 파일의이름\n" ----------> SERVER : 파일열기
파일읽기 : CLIENT  --------- "파일의 내용" --------------------> SERVER : 파일에 쓰기
파일닫기 : CLIENT  --------- "EOF\n" -----------------------> SERVER : 파일닫기
```

그래서 간단하게 파일의 전송시작과 종료를 알리는 프로토콜을 구성했습니다.


### udp_filerecv.pl

```perl
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

	if( $in =~ /^FILENAME (.+)$/){ # 파일의 시작
		$filename = $1;

		open($out,">udp_recv/$filename");
		say "recv $filename";

		next; # continue
	}

	if( $in =~ /^EOF$/ ){
		say "done $filename"; # 파일의 끝
		last; # break
	}

	if( $out ){ # 파일이 열려있으면 
		print $out $in; # 파일에 쓰기
	}

}
close($out);
```

#### 프로토콜의 처리

```perl
	if( $in =~ /^FILENAME (.+)$/){ # 파일의 시작
		...
		next; # continue
	}

	if( $in =~ /^EOF$/ ){
		...
		last; # break
	}

	if( $out ){ # 파일이 열려있으면 
		...
	}
```

보내는 쪽에서 여러번에 걸쳐서 시작, 파일내용, 종료를 보내므로, 
루프를 돌면서 매번 체크하도록 합니다.

### udp_filesend_small.pl


```perl
#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use Socket;

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
send( SOCKET, $data, 0, $dest );
send( SOCKET, "EOF\n", 0, $dest);
close SOCKET;

```

#### 파일 읽기

```perl
my $filepath = $ARGV[0];
open(FILE, $filepath);
my $data;
read(FILE, $data, (-s $filepath));
close(FILE);
```

줄단위로 처리할 것이 아니라서 한번에 파일을 $data에 담고 파일을 닫아줍니다.

```perl
send( SOCKET, "FILENAME $filepath\n", 0 , $dest);
send( SOCKET, $data, 0, $dest );
send( SOCKET, "EOF\n", 0, $dest);
```

위에서 정의한 파일전송 프로토콜에 따라 이렇게 3번에 걸쳐서 데이터를 보냅니다.

send를 할때마다 별개의 패킷으로 날아가기 때문에 갈라주는 것만으로도
서버쪽에서는 따로따로 처리할 수 있습니다.

#### 전송하기

받는쪽 시작 

```bash
$ perl udp_filerecv.pl
UDP 9999 Broadcast Receiver Started
```

보내는쪽 시작

```bash
$ perl udp_filesend_small.pl small_file.txt
```

받는쪽 종료

```bash
$ ls udp_recv/
small_file.txt
$
```
종료후에 udp_recv 디렉토리에 보낸 파일이 생성된 것을 알 수 있습니다.

#### 그.러.나

```bash
$ perl udp_filesend_small.pl big_file.txt
```
을 해서 큰파일을 보내면, udp_recv/big_file.txt 는 빈파일인 것을 알 수 있습니다.

#### 무엇이 잘못되었을까요?

* 그것은 바로 UDP 패킷의 크기 제한 때문입니다.
* UDP 패킷은 우리가 통신요금을 매길때 패킷 당 얼마 할때의 부르는 바로 그 단위입니다.
* 보통 512~8192 바이트 즉 8kb까지 가능합니다.
* 네트워크장비나 OS에 따라서 다릅니다. 저는 해보니 1024 바이트까지는 괜찮더군요.

### udp_filesend.pl 

```perl
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

```

#### 파일의 내용을 쪼개서 여러번 보내기

```
send( SOCKET, "FILENAME $filepath\n", 0 , $dest);
for(my $i=0; $i<length($data); $i+=1024){
	send( SOCKET, substr($data,$i,1024), 0, $dest );
}
send( SOCKET, "EOF\n", 0, $dest);
```

substr를 이용해서 1024바이트만큼 건너뛰면서 여러번 전송합니다.

```
										 +----------+
------------------------------------>	 | FILENAME | 
										 +----------+
 
									 +------+
									 |packet|
									 +------+
 
								 +------+
								 |packet|
								 +------+
 
							 +------+
							 |packet|
							 +------+
							 
						 +------+
						 |packet|
						 +------+
 
					 +------+
					 |packet|
					 +------+
 
				 +---+
				 |EOF|
				 +---+

```

이렇게 전송되겠죠?


```

										 +----------+
------------------------------------>	 | FILENAME | 
										 +----------+
 
									 +------+
									 |packet|
									 +------+

							 +------+
							 |packet|
							 +------+
	
 
								 +------+
								 |packet|
								 +------+
 
 
					 +------+
					 |packet|
					 +------+
 
						 
						 +------+
						 |packet|
						 +------+
 
 
										 +---+
										 |EOF|
										 +---+

```

* 하지만 실제로는 이렇게 순서가 뒤죽박죽으로 전송될 수 있습니다.
* 패킷들은 TTL(Time To Live)라는 생명값이 있어서 라우터를 지날때마다 차감합니다.
* TTL값이 0이 되면 라우터가 전달을 그만두게 되고, 결과적으로 패킷이 소멸됩니다.
* 각 패킷들은 서로 다른 경로를 거쳐서 도착할 수 있기 때문에 지연이 생길수 있고, 
* 길을 잃고 헤메다가 TTL 이 0이 되어서 사라지기도 합니다.
* UDP는 손실 가능성이 많습니다.


#### 어떻게 극복하지?

1. 각 패킷에 번호를 매겨서 전송
1. 순서에 따라서 재배치 
1. 시간이 지나도 오지 않는게 있으면 빠진 번호를 재전송 요청.


이 3가지 요구조건에 의해 태어난 것이 TCP 입니다.

## TCP를 통한 파일 전송

* TCP는 전송되는 모든 패킷을 추적해야하므로 Broadcast 형태로 쏘지는 못합니다.
* 그래서 반드시 Connect를 통해서 연결을 확립(즉, 패킷의 트래킹을 시작)하여야 합니다.
* DB나 API등을 쓰다보면 Connect 라는 키워드들을 많이 볼 수 있는데
* 이 Connect가 TCP의 Connect 를 의미합니다.


### tcp_filerecv.pl

```perl
#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use Socket;

my $port = 9998;

 # udp -> tcp
my $proto = getprotobyname('tcp');

 # SOCK_DGRAM -> SOCK_STREAM
socket( SOCKET, PF_INET, SOCK_STREAM, $proto);

 # SO_BROADCAST -> SO_REUSEADDR
setsockopt( SOCKET, SOL_SOCKET, SO_REUSEADDR, 1 );

my $dest = sockaddr_in( $port, INADDR_ANY);

bind( SOCKET, $dest );

 # listen 의 추가
listen(SOCKET, 5) or die "listen: $!";

say "TCP $port Receiver Started";


my $client_addr;

 # accept를 통해서 트래킹을 수행할 새 소켓생성
while ($client_addr = accept(NEW_SOCKET, SOCKET)) {
	say "Accept new socket";
	my $in;
	my $out;	
	my $filename;
	while(my $in = <NEW_SOCKET>){ # recv없이 소켓을 죽자고 읽으면 됨.
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

```

#### 소켓 옵션의 변화

```perl
 # udp -> tcp
my $proto = getprotobyname('tcp');

 # SOCK_DGRAM -> SOCK_STREAM
socket( SOCKET, PF_INET, SOCK_STREAM, $proto);

 # SO_BROADCAST -> SO_REUSEADDR
setsockopt( SOCKET, SOL_SOCKET, SO_REUSEADDR, 1 );
```

* TCP의 옵션들을 채워줍니다.

#### listen?

```perl
bind( SOCKET, $dest );

 # listen 의 추가
listen(SOCKET, 5) or die "listen: $!";
```

* SOCKET을 bind 하면 시스템으로부터 빌려온다고 했습니다. 그리고 양방향 통신이 가능합니다.
* listen을 하게 되면 듣기 전용 소켓이 됩니다. connect 전용입니다.
* accept를 하게 되면 읽고 쓰기가 가능한 소켓을, 새로 connect된 소켓으로부터 새로이 생성합니다.
* http 는 이 listen 포트가 80.

#### Accept된 소켓을 읽기

```perl
while(my $in = <NEW_SOCKET>){ # recv없이 소켓을 죽자고 읽으면 됨.
    ...
}
```

* UDP에서는 소켓에 recv 함수를 이용해서 받아왔습니다.
* TCP는 모든 패킷을 기다리고, 정렬하고, 재전송요청등을 하기 때문에, 패킷을 바로 전달하지 않고 내부의 버퍼에 쌓아둡니다.
* 이 버퍼가 채워질때 <NEW_SOCKET>은 버퍼의 내용을 가져오게 되는 것입니다.
* 처리가 끝나면 다시 accept를 호출해서 새 접속자를 기다립니다.
* while문 안쪽 부분을 쓰레드로 만들면 상용화 가능한 서버가 됩니다.
  * 쓰레드갯수의 제한에 따라서 동시접속자가 몇명이냐가 정해지겠죠? 
  * 쓰레드 대신 프로세스를 복제하는 fork를 이용하기도 합니다.
  * Apache 웹서버 설정을 보면 thread와 prefork 란 단어가 있어요.
  * 이게 while문 안쪽을 어떻게 비동기로 처리할건지를 지정하는 겁니다.
  * nginx는 IO::Select와 비슷한 방법으로 각 소켓을 골고루 탐색하면서 처리합니다. 요즘은 이게 고성능이죠.
  
### tcp_filesend.pl

```perl
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

 # udp -> tcp
my $proto = getprotobyname('tcp');

 # SOCK_DGRAM -> SOCK_STREAM
socket( SOCKET, PF_INET, SOCK_STREAM, $proto);

connect( SOCKET, $dest ) or die "Can't connect to port $port! \n";

send( SOCKET, "FILENAME $filepath\n", 0 , $dest);
send( SOCKET, $data, 0, $dest );
send( SOCKET, "EOF\n", 0, $dest);

close SOCKET;
```

#### IP의 지정
```perl
my $server_ip = $ARGV[1];
```

* TCP는 특성상 Broadcast를 할 수 없습니다.
* 그래서 IP를 지정해줘야 합니다.

#### connect

```perl
connect( SOCKET, $dest ) or die "Can't connect to port $port! \n";
```

* connect를 통해서 보내는 쪽에서도 패킷의 트래킹을 준비합니다.
* 이 준비과정에서는 서로 전송키를 정하고 각각의 패킷 번호를 공유하게 됩니다.
* 이 과정을 HandShake 라고 합니다. 핸드쉐이킹!!
* HTTPS나 SSL은 암호화의 대한 핸드쉐이킹도 따로해서 암호화키를 주고 받습니다.
* 그 뒤에는 암호화된 패킷내용을 주고 받는 겁니다.

#### 한방에 전송!!

```perl
send( SOCKET, $data, 0, $dest );
```

* TCP는 내부적으로 큰 데이터를 쪼개서 안정적으로 발송해줍니다.
* 그래서 UDP의 크기제한 같은 것이 없고, 무한정 보낼 수 있습니다.
* 영화같은걸 다운로드 할때 생각해보세요.


#### 전송!!

받는쪽 시작 

```bash
$ perl tcp_filerecv.pl
TCP 9998 Receiver Started
```

보내는쪽 시작

```bash
$ perl tcp_filesend.pl big_file.txt localhost
```