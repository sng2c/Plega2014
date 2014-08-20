% Python 기초
% 김현승
% 2014-08-18

## Python 에 대하여

파이썬의 특징에 대해서 간단히 알아본다.

### Python의 장점과 단점
#### 장점
* 문법이 단순하게 제약되어 있다.
* 다양한 모듈이 있어 도움받기 쉽다.
* 대부분은 OS에서 똑같이 작동한다.
* GUI모듈이 기본으로 포함되어 있다.
* 다양한 포트가 있다.
	* IronPython : On .NET
	* Jython : On JVM
	* PyPy : Fast on JIT
	* CPython : C based
	* QPython : Android

#### 단점
* 들여쓰기로 구분하는 코드블럭에 적응이 어렵다.
* 문법이 제약적이다 보니 예외적인 문법이 있다.
* 표현력이 떨어진다.

### Python2? Python3?

#### Python3의 장점
* 유니코드가 기본이다.
* 기본적으로 List대신 Generator를 사용한다.
* 언어 설계가 좀 더 탄탄해졌다.
	* Exception Chaining
	* non-local
	* 함수 어노테이션

#### Python3의 단점
* 아직은 Python2기준으로 세팅된 시스템이 많다.
* 인기있는 써드파티 프레임웍들을 모두 사용할 수 없다.
* 검색 결과가 Python2 기준이 많다.

#### 결론
* 실무에서는 아직 Python2를 사용하여야 한다.
* 포팅에 따르는 비용은 적은 편. 2to3 명령으로 포팅.
* 재학습 비용도 적다.
* 모든 프레임웍이 3를 지원할때를 기다린다.
* 또는 프레임웍이 3를 지원하도록 참여한다.
* 개인적인 도전이 필요하면 3를 선택한다.

### 설치
* 교육에 사용하는 버전 : Python 2.7
* Windows : https://www.python.org/download/
* OSX : 2.7 기본설치
* linux : 2.7 기본설치
* Android : Play Store에서 QPython 설치

### REPL
* Read, Evaluate, Print, Loop 의 약자

```python
$ python
Python 2.7.5 (default, Mar  9 2014, 22:15:05) 
[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>	print "hello"
hello
>>>
```

### 추천하는 편집기

* 여러분은 생산성을 위해 Python을 선택했으므로, 이를 극대화하기 위해서 적절한 IDE를 선택하는 것이 맞다.
	* Sublime Text
	* PyCharm : 인텔리J 기반, 인텔리J에 PyCharm 플러그인을 설치해도 된다.

## 기초

Python의 기초를 빠른 속도로 습득해본다.

### 파일인코딩

* Python은 소스코드의 인코딩을 지정해야 한다.

```python
#!/usr/bin/python
print "한글"
```

```python
#!/usr/bin/python
#-*- coding: utf-8 -*-
print "한글"
```

### 들여쓰기

```python
if True :
	print "True!!"
else:
	print "False!!"

def func(msg):
	print msg

class MyClass:
	pass
```

* 들여쓰기로 코드블럭을 구분한다.
* 내용이 아무것도 없을 때에는 pass를 써서 채운다.(예외적인 문법의 하나)
* 들여쓰기는 White Space의 갯수를 맞추게 되는데, tab을 이용하는 것이 좋다.

### 기본자료형의 종류

* Python도 모든 것이 객체다!!
* Python의 연산자와 문들은 약속된 함수를 호출한다.
* 연산자 오버라이드는 객체의 함수 구현을 바꾸는 것일 뿐이다.

#### None

* None은 null을 표현한다.
* is 를 써도 되고 ==을 써도 된다.
* is 는 객체의 주소를 비교한다.
* == 는 객체의 \__eq__를 이용한다.

```python
>>>	value == None
True
>>>	value is None
True
```

#### True, False

* True, False는 Python에서의 불린값이다.
* 이 역시 명백한 상수 Object이므로 is 가 사용가능하다.
* 표현식을 넣고 bool()함수를 이용하면 정의여부로 True, False를 판별한다.

```python
>>>	True == True
True
>>>	True is not False
True
>>>	not "abc"
False
>>>	bool(None)
False
>>>	bool("abc")
True
```

#### 정수,실수

* 정수와 실수는 각각 int, long과 float객체이다.
* int가 sys.maxint 보다 커지면 자동으로 long객체로 바뀐다.

```python
>>>	1
1
>>>	int("1")
1
>>>	int("0b10",2)
2
>>>	int("010",8)
8
>>>	int("0x10",16)
16
>>>	1.0
1.0
>>>	float("1.0")
1.0
>>>	long("1111111111111111111")
1111111111111111111L
>>>	int("1111111111111111111")
1111111111111111111L
```

#### 복소수

* 복소수는 complex 객체이다.

```python
>>>	complex("8+3j")
8+3j
>>>	(8+3j) + (5+2j)
(13+5j)
```

#### 문자열

* 문자열은 "" 또는 '' 로 표현한다.
* 여러줄에 걸친 문자열은 """ 또는 ''' 으로 표현한다.

```python
>>>	"abc"
"abc"
>>>	"abc" + "cde"
"abccde"
>>>	"abc %s" % 'cde'
'abc cde'
>>>	"abc %(name)s" % {'name':'KHS'}
'abc KHS'
>>>	'''
... Hello
... World
... '''
'\nHello\nWorld\n'
>>>
```

##### str 과 unicode

###### unicode를 써야하는 이유

* str은 ""로, unicode는 u"" 로 표현된다.

```python
>>> len("한글")
6
>>> len(u"한글")
2

>>> "한글"
'\xed\x95\x9c\xea\xb8\x80'
>>> u"한글"
u'\ud55c\uae00'
```

* str은 한글이 들어갔더라도 바이트의 나열일뿐이다. 바이트를 출력하지만 쉘이 한글로 변환해 보여주는 것이다.
* unicode로 만들어야 문자단위로 다룰수 있다.

###### 인코딩간 변환

```python
>>> "한글" # utf-8표에서의 좌표값들( 1~3바이트짜리 부분집합 )
'\xed\x95\x9c\xea\xb8\x80'

>>> '\xed\x95\x9c\xea\xb8\x80'.decode('utf-8') # 유니코드표에서의 좌표값(4바이트짜리 전체집합)
u'\ud55c\uae00'

>>> '\xed\x95\x9c\xea\xb8\x80'.decode('utf-8').encode('euc-kr') # euc-kr표에서의 좌표값들(2바이트짜리 부분집합)
'\xc7\xd1\xb1\xdb'

>>> '\xc7\xd1\xb1\xdb'.decode('euc-kr').encode('utf-8') # 다시 3바이트짜리 부분집합으로 변환
'\xed\x95\x9c\xea\xb8\x80'
```

* 유니코드는 모든 문자열을 담을수 있는 표와 같다.
* 실제로 우리가 출력해서 보게되는 것은 unicode가 encode된 결과이다.
* 유니코드를 다룰때에는 아래표를 기억하자.

```
A로 인코딩된거 -- 디코딩 --> 유니코드표 좌표 -- 인코딩 --> B로 인코딩된거
```

#### tuple

* tuple은 변경불가능한 List이다.
* tuple은 순서가 있고, 원소들이 중복해서 들어갈수 있다.
* 속도에 이점이 있다.
* : 으로 range를 지정하면 sub tuple을 만들수 있다.

```python
>>>	(1,2,3)
(1,2,3)
>>>	t = (1,2,3,4)
>>>	t[2]
3
>>>	t[1:2]
(2, 3)
>>>	t[1:]
(2, 3, 4)
>>>	t[:-2]
(1, 2)
>>>	t[1:-1]
(2, 3)
```

##### 하나의 인자

* 하나의 인자를 가진 Tuple을 만들때에는 , 를 첫번째 인자 뒤에 넣어줘야 한다.

```python
>>>	(1)
1
>>>	(1,)
(1,)
>>>	type((1,))
<type 'tuple'>
```

##### 대입

* Tuple은 좌변에 들어가면 우변의 Tuple을 하나씩 대입시킨다.

```python
>>>	a,b,c = (1,2,3)
>>>	c
3
```

##### 중첩 Tuple

* Tuple안에 Tuple을 담을 수 있다.

```python
>>>	(1, (2,3), 4)
(1, (2, 3), 4)
```

##### List -> Tuple

* List를 Tuple로 변환할수도 있다.

```python
>>>	arr = [1,2,3]
>>>	arr
[1,2,3]
>>>	tuple(arr)
(1,2,3)
```

#### list

* list는 변경가능하다.
* tuple의 사용방법과 동일하다.
* () 대신 []을 이용한다.
* tuple을 list로 변환할 수 있다.

```python
>>>	[]
[]
>>>	[1]
[1]
>>>	[1,2,3]
[1,2,3]
>>>	list( (1,2,3) )
[1,2,3]
```

##### 추가 

* 리스트에 추가할때는 append를 이용한다.

```python
>>>	l = [1,2,3]
>>>	l.append(4)
>>>	l
[1,2,3,4]
```

##### 삽입

* 임의의 위치에 삽입할때는 insert를 이용한다.

```python
>>>	l = [1,2,3]
>>>	l.insert(1,4)
>>>	l
[1,4,2,3]
```

##### 꺼내기

* 꺼내면서 list에서 지울때는 pop을 이용한다.

```python
>>>	l.pop()
3
>>>	l
[1,4,2]
>>>	l.pop(0) # 위치지정
1
>>>	l
[4,2]
```

##### 원소의 수정 

* 원소의 수정시

```python
>>>	l[0] = 5
>>>	l
[5,2]
```


##### 그외의 기능

```python
>>>	l.sort()
>>>	l
[2,5]
>>>	l.reverse()
>>>	l
[5,2]
>>>	l.insert(0,5)
>>>	l
[5,2,5]
>>>	l.remove(5) # 첫번째로 만난 같은 원소를 없앤다.
>>>	l
[2,5]
>>>	l.remove(5)
>>>	l
[2]
```

#### set

* set은 집합을 의미하며 순서가 없고, 같은 원소가 두개이상 들어갈 수 없다.
* set은 원소의 포함 체크 성능이 뛰어나서 in 연산자로 조회할때 좋다.
* 변경불가능한 set은 frozenset 이다.
* set끼리 교집합 차집합 합집합 등을 표현할 수도 있다.

```python
>>>	s = set( (1,2,1) )
>>>	s
set([1, 2])
>>>	s.add(4)
>>>	s
set([1, 2, 4])
>>>	4 in s
True
>>>	5 in s
False
```

#### dict

* dict는 딕셔너리를 의미하며, 자바의 HashMap과 같다.
* tuple 이나 list 가 짝수개의 인자를 가지면 key:value쌍으로 변환할 수 있다.
* list와 함께 중요한 자료구조이다.

```python
>>>	d = {'name':'KHS'}
>>>	d
{'name': 'KHS'}
>>>	d.has_key('age')
False
>>>	d['age'] = 36
>>>	d['age']
36
>>>	d.items()
[('k', 'v'), ('age', 36)]
```


### Operator
#### 산술

##### +, -, *, /

```python
>>>	1+1
2
>>>	1-1
0
>>>	2*2
4
>>>	3/4
0
>>>	3.0/4
0.75
```
##### **

* n제곱

```python
>>>	2 ** 4
16
```

##### //, %

* // 는 몫
* % 는 나머지 
* divmod()를 이용하면 몫,나머지를 한번에 얻을 수 있다.

```python
>>>	5 // 3
1
>>>	5 % 3
2
>>>	divmod(5,3)
(1, 2)
```

#### 논리

* 논리연산자에는 and, or, not의 3가지가 있다.

##### and, or

```python
>>>	True and True
True
>>>	True and False
False
>>>	False or True
True
>>>	False or False
False
```

##### not

```python
>>>	not True
False
>>>	not False
True
>>>	not None
True
>>>	not "a"
False
>>>	not not "a"
True
```

##### 비교

* 크기를 비교하는 연산자는 우리가 알고 있는것과 크게 다르지 않다.

```python
>>>	1 > 1
False
>>>	1 < 1
False
>>>	1 == 1
True
>>>	1 >= 1
True
>>>	1 <= 1
True
```

##### is

* is 는 객체의 값이 아닌 주소를 비교한다.
* 반드시 객체간의 동일여부를 체크할 때만 사용해야 한다.

```python
>>>	a = [1,3,4]
>>>	b = a
>>>	a is b
True

>>>	b = [1,3,4]
>>>	a is b
False
```

##### is 의 변덕

* 숫자,알파벳,'_' 만으로 이루어진 값은, 상수로 사용한다고 판단하여 같은 주소를 `재사용`한다.
* 그래서 is 로 비교하면 True로 판별된다.
* 그러나 알파벳, 숫자, '_' 가 아닌 문자가 하나라도 들어가면 다른 주소에 할당하므로 False로 판별한다.
* 같은 이유로 None, True, False 등도 is 를 사용할 수 있지만 피해야 한다.
* 영어같은 표현이라 가독성이 좋아보인다고, 즐겨쓰게 되면 도저히 찾아낼 수 없는 버그를 만들수 있다.

```python
>>>	a = True
True
>>>	a is True
True
>>>	a = 'Hello'
>>>	b = 'Hello'
>>>	a is b
True
>>>	a = 'Hello!'
>>>	b = 'Hello!'
>>>	a is b
False
```

#### bitwise

* 비트연산자 또한 우리가 알고 있는 것과 크게 다르지 않다.

```python
>>>	x = 0b1111
>>>	y = 0b0010
>>>	n = 1
>>>	bin(x | y)
'0b1111'
>>>	bin(x ^ y)
'0b1101'
>>>	bin(x & y)
'0b10'
>>>	bin(x << n)
'0b11110'
>>>	bin(x >> n)
'0b111'
>>>	bin(~x)
'-0b10000'
```

### Statement

함수가 아닌 문법에 해당하는 키워드들을 설명한다.

#### assert

* assert는 그 값이 참이 아닐때 프로그램을 종료하며 경고를 준다.
* type체크에 이용될 수 있으며, PyCharm 에서는 이를 인식하여 변수타입을 유추한다.

```python
>>>	assert 1
>>>	assert 0
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AssertionError
>>>	assert isinstance("abc", str)
>>>	assert isinstance("abc", int)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AssertionError
>>>	
```

#### pass

* pass는 그 자체로는 아무것도 하지 않으며, 
* 빈 코드블럭을 표현하기 위해 문법구조를 지탱해주는 역할을 한다.

```python
>>>	if 1 == 1:
...		pass
... else:
...		print "Hello"
... 
>>>	def empty():
...		pass
...
```

#### del

* del은 변수에 할당된 객체나, import한 모듈을 메모리에서 제거할때 사용한다.

##### 변수의 제거
```python
>>>	a = 1
>>>	del a
>>>	a
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'a' is not defined
```

##### 모듈의 제거
```python
>>>	import math
>>>	math
<module 'math' from '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/lib-dynload/math.so'>
>>>	del math
>>>	math
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'math' is not defined
```

#### print

* STDOUT 으로 데이터를 출력합니다.

```python
>>>	print "hello"
hello
>>>	print [1,2,3]
[1,2,3]
>>>	class MyClass:
...		pass
... 
>>>	print MyClass()
<__main__.MyClass instance at 0x105b51e18>
```
 
##### \__str__() 과 \__unicode__()

* 사용자 정의 클래스는 \__str__() 과 \__unicode__() 를 정의함으로써, 출력문자열을 바꿔줄 수 있다. 

```python
>>>	class MyClass2:
...		def __str__(self):
...		        return "MyClass!! "+hex(id(self))
...		def __unicode__(self):
...		        return u"내클래스야!! "+hex(id(self))
... 
>>>	print MyClass2()
MyClass!! 0x105b5c998
>>>	print unicode(MyClass2())
내클래스야!! 0x105b5c976
```

##### STDERR 로 출력하기

```python
>>>	import sys
>>>	print >> sys.stderr, "error"
```

#### return

* 함수내에서 값을 리턴할때 사용한다.
* 함수내에서는 yield 와 return을 함께 사용할 수 없다.

```python
>>>	def testfunc():
...		return "wow"
...
>>>	testfunc()
"wow"
```

#### yield

* 함수내에서 값을 호출한 쪽과 주고 받기 위해서 사용한다.
* yield를 사용한 함수를 generator 라고 부른다.
* 함수내에서는 yield 와 return을 함께 사용할 수 없다.
* testfunc()를 사용하는 바깥쪽 루프와 함께 숫자가 증가하는 것을 볼 수 있다.
* 한번에 List에 담지 않기 때문에 메모리를 효율적으로 사용할수 있다.

```python
>>>	def testfunc():
...		for i in range(1,5):
...		        print "<------------ generate : %d" % i
...		        yield i
... 
>>>	for i in testfunc():
...		print "received : %d" % i
... 
<------------ generate : 1
received : 1
<------------ generate : 2
received : 2
<------------ generate : 3
received : 3
<------------ generate : 4
received : 4
<------------ generate : 5
received : 5
```

#### raise

* 예외를 일으킨다.

```python
>>>	raise Exception("MyErr")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
Exception: MyErr
>>>	
```

#### try ... except ... else

* 에외를 처리한다.

```python
>>> try:
... 	raise Exception("MyErr")
... except Exception, e:
... 	print e
... else:
... 	print "no exception"
...
MyErr
>>> try:
...     pass
... except Exception, e:
...     print e
... else:
...     print "no exception"
... 
ok
```

#### break

* for 나 while 루프에서 중지할때 사용한다.

```python
>>>	i = 0
>>>	while(True):
...		i += 1
...		if i>5:
...		        break
...		print i
... 
1
2
3
4
5
```

#### continue

* for 나 while 루프에서 다음 루프로 넘어갈때 사용한다.

```python
>>>	i = 0
>>>	while(True):
...		i += 1
...		if i>5:
...		        break
...		if i % 2 == 0:
...		        continue
...		print i
... 
1
3
5
```

#### import

* 모듈을 로딩한다.
* del로 메모리에서 제거할 수 있다.

```python
>>>	import math
>>>	math.ceil(1.1)
2.0
>>>	del math
>>>	math
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'math' is not defined
```

#### global

* 함수내에서 함수밖에 정의된 변수를 사용하기 위해 선언한다.

```python
>>>	gvalue = 1
>>>	def inc():
...		global gvalue
...		gvalue += 1
... 
>>>	inc()
>>>	inc()
>>>	gvalue
3
```

#### exec

* 스트링에 들어있는 Python 코드(statement)를 실행하기 위해 사용된다.

```python
>>>	mycode = 'print "hello world"'
>>>	exec mycode
Hello world
```

##### eval()

* 값(expression)을 계산하여 받기 위한 것이라면 eval()을 사용한다.
* 아래 코드를 보면 exec와 eval의 차이를 알 수 있다.

```python
>>>	exec("x = 2 + 2")
>>>	x
4
>>>	x = eval("2 + 2")
>>>	x
4
```

#### if ... elif ... else

* 누구나 아는 분기문이다.

```python
>>>	i = 0
>>>	if i == 0:
...		print "First"
... elif i == 1:
...		print "Second"
... else:
...		print "Other"
... 
First
```

##### 3항연산자

* 한줄에 쓰면 3항 연산자로 쓸 수 있다.

```python
>>>	i = 0
>>>	print "First" if i == 0 else ("Second" if i == 1 else "Other")
First
```

#### for ... in ... else

* Python의 for 문은 무조건 in 과 함께 쓰인다.
* in 뒤에는 range 또는 tuple, list, set 등이 쓰일수 있다.
* for문 에서 조건을 걸수 없으므로 Python은 Generator 테크닉을 이용한다.

```python
>>>	for i in range(0, 5):
...		print i
... 
0
1
2
3
4
>>>	for i in ["hello","world"]:
...		print i
... 
hello
world
```

##### else

* break 없이 끝까지 완주(?) 하면 else 절로 들어간다. (예외적 문법의 하나)

```python
>>>	for i in [1,2,3]:
...		break
... else:
...		print "ALL DONE"
... 

>>>	for i in [1,2,3]:
...		pass
... else:
...		print "ALL DONE"
... 
ALL DONE
```

#### while

* while 은 루프를 돌리고 조건에 따라 종료한다.
* for 처럼 break없이 완주(?)를 성공하면 else 절로 들어가게 된다.

```python
>>>	i = 0
>>>	while i < 3:
...		break
... else:
...		print "ALL DONE"
... 

>>>	while i < 3:
...		i += 1
... else:
...		print "ALL DONE"
... 
ALL DONE
```

#### with ... as

* with는 파일핸들처럼 사용이 끝나면 반드시 닫거나 반환해야하는 자원에 사용하면 효과적이다.
* 여기에 사용되는 클래스는 \__enter__()와 \__exit__()를 구현하면 시작과 끝에 각각이 호출된다.
* 아래 예에서는 with 블럭이 끝나고 나서는 파일핸들이 닫혀있는 것을 알수 있다.

```python
>>>	with open("out.txt","wb") as out:
...		out.write("bye bye")
... 
>>>	out
<closed file 'out.txt', mode 'wb' at 0x100751780>
>>>
```

### 함수
#### 사용자정의 함수
##### 선언

```python

def 함수이름():
	코드
	return 값

def 함수이름(인자, 인자):
	코드

def 함수이름(*args, **keywords):
	코드
```

* 함수의 인자는 직접 수와 이름을 지정하여 선언하거나
* *args 와 **keywords 로 가변적으로 받을수 있다.
* 리턴값은 선언해두지 않는다. 
* return은 선택이며, return을 쓰지 않으면 None이 리턴된다.


##### lambda 함수

* lambda 는 간단한 함수일 경우 따로 함수 정의를 하지 않고, 한줄로 정의할 수 있게 해준다.
* 함수인자를 받는 함수를 사용할 때 유용하다.

```python
>>>	l = (1,2,5,55,32,190)
>>>	def gt50(n):
...		return n>50
... 
>>>	filter(gt50, l)
(55, 190)
```

* 위와 같은 함수는 lambda를 이용하면 아래와 같이 바꿀 수 있다.

```python
>>>	filter(lambda n: n>50, l)
(55, 190)
```

##### 변수의 Scope

* 변수의 Scope 는 함수단위이다.
* Java 등의 Scope가 코드블럭 단위인 언어에서, 아래와 같이 코드 바깥쪽에 선언하던 것을

```java
int lastValue = 0;
for(int i=0; i<5; i++){
	lastValue = i;
}
System.out.println(lastValue);
```

* Python에서는 아래와 같이 한다.

```python
for i in range(0,5):
	lastValue = i
print lastValue
```

* 편리해 보이지만, 코드가 길어지면 다른용도로 같은 변수를 쓸 수 있으므로 주의해야 한다.

### 모듈

* Python의 모듈은 파일뿐만 아니라 디렉토리에도 기능을 부여할수 있다.
* 디렉토리의 경로를 . 으로 이어 표현한다.(자바와 유사)
* 모듈명의 마지막은 파일이 아닌 디렉토리를 가리킬수도 있다.

#### 파일 모듈

##### ./mymodule.py 

```python
# -*- coding: utf-8 -*-
"""my module #1"""

def hello():
	"""hello() DOES say hello"""
	print "hello"
```

##### 모듈의 사용

```python
>>>	import mymodule1
>>>	print mymodule1.__doc__
my module #1
>>>	mymodule1.hello.__doc__
hello() DOES say hello
>>>	mymodule1.hello()
hello
```

* 위 예제를 보면 파일이 시작할때 """ 로 시작하는 멀티라인 문자열이 있다.
* 함수에서도 코드블럭이 시작할때 """ 로 시작하는 부분이 있다.
* 이 부분은 모듈과 함수, 클래스의 선언시에 \__doc__ 에 저장이 되는 자기 문서화 주석이다.
* javadoc 와 같다고 보면되는데, 자바는 따로 변환기를 둔 반면, Python은 언어 스펙에서 지원한다.

#### 디렉토리 모듈

* 모듈의 이름이 디렉토리의 이름으로 끝날경우
* \__init__.py 파일을 읽어들이게 된다.


##### ./mymodule2/__init__.py

```python
# -*- coding: utf-8 -*-
"""my module #1"""

def hello():
	"""hello() DOES say hello"""
	print "hello"
```


##### 모듈의 사용

```python
>>>	import mymodule2
>>>	print mymodule2.__doc__
my module #1
>>>	mymodule2.hello.__doc__
hello() DOES say hello
>>>	mymodule2.hello()
hello
```

* 파일의 구성단위가 다를 뿐이지 크게 다르지 않다.
* 하위에 더 많은 패키지가 있을때 디렉토리 모듈을 사용한다.

#### 다른위치에 있는 모듈의 import

* ./mylib/draft 에 있는 모듈을 `우선해서` import하고 싶다면.

```python
>>>	import sys
>>> import os.path
>>>	sys.path.insert(0,os.path.join("mylib","draft")
>>>	import mymodule3
```


## 1일차 끝~!

* 수고하셨습니다.
* 과제가 이어집니다.

### 과제

```python
>>> data = (2, 45, 55, 200, -100, 99, 37, 10284)
>>> 
```

* 위 data에서 3의 배수를 추려내는 코드를 작성하세요.
* sng2nara@daumcorp.com 으로
* "[파이썬기초서울B과제1] 팀/성함/사번" 을 제목으로 해서 메일을 보내주세요~ 

### A차수 수강자분들의 제출된 답안

* 42명제출중
	* 순환방법 
		* filter + lambda   : 25명
		* for .. in         : 11명
		* filter + function : 5명
		* for .. in .. if   : 1명
	* 조건식
		* n % 3 == 0 : 35명
		* not n % 3  :  4명
		* n % 3 > 0  :  1명
		* divmod     :  1명
		* eval       :  1명

#### 대세 답안

```python
>>> filter(lambda n: n%3 == 0, data)
```

```python
>>> def cond(n):
... 	return (n % 3) == 0
>>> filter(cond, data)
```

```python
>>> for i in data:
... 	if i%3 == 0:
... 		print i
```

### 마이너리티 리포트

#### for .. in .. if : 1명

```python
>>> tuple(x for x in data if x % 3 == 0)
(45, 99, 10284)
```

* Generator 선행학습을 하셨습니다.
* 이 분은 두렵습니다.

#### n % 3 > 0

```python
#!/usr/bin/python
#-*- coding: utf-8 -*-

data = (2, 45, 55, 200, -100, 99, 37, 10284)
list_data = list(data)

for i in data:
        if i%3 > 0:
                list_data.remove(i)

data = tuple(list_data)

print '3배수 Tuple : ' + str(data)
```

* 특이하게도 소거법을 이용하셨습니다.

#### divmod

```python
data = (2, 45, 55, 200, -100, 99, 37, 10284)

for i in data:
a, b = divmod(i, 3)
if b == 0:
print i
```

* divmod 의 몫,나머지중 나머지만 추려서 사용하셨습니다.

#### eval

```python
>>> data = (2, 45, 55, 200, -100, 99, 37, 10284)
>>> def mul3(n):
...     i=eval("n % 3")
...     if i == 0:
...             return n
...
>>> filter(mul3,data)
(45, 99, 10284)
```

* eval의 용법에 맞게 정확하게 사용하셨습니다.
* 뜻밖의 eval이라 신선했습니다.

## 2일차


### 클래스

* Python은 모든 것이 객체이다.
* 연산자나 문들은 약속된 메소드를 객체에게 호출함으로써 구현된다.

#### 선언

* 선언은 class 키워드를 이용한다.
* 인스턴스를 만들때는 클래스이름을 함수처럼 호출한다.
* new 키워드를 사용하지 않는다.

```python
>>>	class MyClass:
...		pass
...
>>>	mycls = MyClass()
```

##### 생성자

* \__init__() 을 정의한다.
* Python의 생성자는 하나만 존재한다.
* 대신 named 파라미터를 받을수 있어 이를 보완한다.
* Python의 메소드 구현은 첫번째 인자로 객체가 넘어오는 형태이다.

```python
>>>	class MyClass:
...		def __init__(self, name, age=None):
...		        self.name = name
...		        self.age = age
... 
>>>	mycls1 = MyClass('KHS')
>>>	mycls1.name
'KHS'
>>>	mycls1.age
>>>	mycls2 = MyClass('sng2c', 36)
>>>	mycls2.name
'sng2c'
>>>	mycls2.age
36
```

##### 소멸자

* 변수를 소멸시킬때는 del문을 이용한다고 앞에서 배웠다.
* 객체의 \__del__()은 del함수를 통해 호출된다.

```python
>>>	class MyClass:
...		def __del__(self):
...		        print "del"
... 
>>>	mycls = MyClass()
>>>	del mycls
del
>>>	
```

##### member

###### class member

* class member는 클래스단위의 scope를 갖는다.
* 새로운 인스턴스를 생성하는 것과 상관없이 하나의 변수만이 존재한다.

```python
>>>	class MyClass:
...		name = "NoName"
...		def __init__(self,name):
...		        self.name = name
... 
>>>	mycls = MyClass("KHS")
>>>	mycls.name
'KHS'
>>>	MyClass.name
'NoName'
```


###### instance member
* 인스턴스 멤버는 \__init__()에서 self.멤버변수 를 초기화하는 것으로 시작한다.
* 여기서 명시해줘야 멤버변수를 조회할때 안전하다.

```python
>>>	class MyClass:
...		def __init__(self, name, age=None):
...		        self.name = name
...		        self.age = age
... 
>>>	mycls = MyClass('KHS')
>>>	mycls.gender
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: MyClass instance has no attribute 'gender'
```

###### method
* method는 self를 첫번째 인자로 받는 함수를 class블럭안에 선언해서 만든다.

```python
>>>	class MyClass:
...		def __init__(self, name):
...		        self.name = name
...		def say_hello(self):
...		        print "Hello %s" % self.name
... 
>>>	mycls = MyClass()
>>>	mycls.say_hello()
Hello KHS
```

##### 객체 멤버들의 목록

* dir()을 이용하면 클래스에서 사용할수 있는 멤버들을 List로 받을 수 있다.
* 어떤 메소드가 있는지 확인할 때에는 이를 응용하면 된다.

```python
>>>	mycls = MyClass()
>>>	dir(mycls)
['__doc__', '__init__', '__module__', 'name', 'say_hello']
>>>	'say_hello' in dir(mycls)
True
>>>	'say_bye' in dir(mycls)
False
```

##### classmethod? staticmethod?

* 클래스메소드와 스태틱메소드는 어노테이션을 이용해서 선언한다.
* 결정적인 차이는 클래스메소드는 class를 첫번째 인자로 받는 것이다.
* 이는 class member/method를 이용한다는 의미를 줄 수 있다.

```python
>>>	class MyClass:
...		@staticmethod
...		def static_hello(name):
...		        print name
...		@classmethod
...		def class_hello(cls, name):
...		        cls.name = name
...		        print name
... 
>>>	mycls = MyClass()
>>>	mycls.static_hello('KHS')
KHS
>>>	mycls.class_hello('KHS')
KHS
>>>	mycls.name
'KHS'
```
#### \__str__() 과 \__repr__()

* \__str__()을 정의하면 인스턴스를 str로 만들어준다고 했다.
* 유사한 것으로 \__repr__()이 있다.
* \__str__()은 읽기가능한 표현을 보여주는 것이라 한다면,
* \__repr__()은 인스턴스를 재현하기 위한 특성을 출력한다는 것이다.
* 그래서 \__repr__()이 보다 명백한 내용을 출력해야 한다.
* 하지만 보통은 둘을 같은 형태로 쓴다.

```python
>>>	l = [1,2,3]
>>>	str(l)
'[1, 2, 3]'
>>>	repr(l)
'[1, 2, 3]'
```

##### 응용 예시

* 이는 json 출력과 디버깅정보의 출력을 함께 필요로 할때 유용하다.

```python
>>>	class MyClass:
...		def __init__(self, name, age):
...		        self.name = name
...		        self.age = age
...		def __str__(self):
...		        return json.dumps({"name":self.name, "age":self.age})
...		def __repr__(self):
...		        return "name is %s, age is %d" % (self.name, self.age)
... 
>>>	mycls = MyClass("KHS", 36)
>>>	str(mycls)
'{"age": 36, "name": "KHS"}'
>>>	repr(mycls)
'name is KHS, age is 36'
```

### 연산자 오버로딩

* Python은 연산자 오버로딩을 할때
* 각 연산자와 약속된 메소드를 구현하는 것이라 했다.
* https://docs.python.org/2/library/operator.html
* 아래 MyVar 클래스에 메소드를 덧붙여보자

```python
class MyVar:
	pass
```



#### 사칙연산

```python
class MyVar:
	def __add__(self, other):
		print "self + other"
	def __sub__(self, other):
		print "self - other"
```

```python
>>>	(a, b) = (MyVar(), MyVar())
>>>	a + b
self + other
>>>	a - b
self - other
```

#### 크기 비교

```python
class MyVar:
	def __lt__(self, other):
		print "self < other"
	def __eq__(self, other):
		print "self == other"
```

```python
>>>	(a, b) = (MyVar(), MyVar())
>>>	a == b
self == other
>>>	a < b
self < other
```

#### str, unicode : \__str__(), \__unicode__

```python
class MyVar:
	def __str__(self):
		print "Hello Str"
	def __unicode__(self):
		print u"Hello Unicode"
```

```python
>>>	a = MyVar()
>>>	str(a)
"Hello Str"
>>>	unicode(a)
u"Hello Unicode"
```

* 모든 것이 객체다라는 것의 실감이 난다.

### 상속과 구현

* class를 상속하지 못한다면 그냥 함수를 담은 dict에 불과하다.
* 추상화를 통해 우리는 문제를 개념적으로 단순하게 정리할 수 있다.

#### 상속

* 상속은 클래스의 선언시 함께 적어주기만 하면 된다.
* 아래 예는 list를 상속한 MyList를 만들었고,
* 서로 다른 메소드 목록을 set(집합) 연산으로 보면 3개의 메소드만 추가된 것을 알수 있고
* 그래서 잘 상속되었다고 볼 수 있다.

```python
>>>	class MyList(list):
...		pass
... 
>>>	set(dir(MyList)) - set(dir(list))
set(['__module__', '__dict__', '__weakref__'])
>>>	ml = MyList([1,2,3])
>>>	type(ml)
<class '__main__.MyList'>
```

#### 다중상속

```python
>>>	class Dog:
...		def sound(self):
...		        print "bark"
... 
>>>	class Cat:
...		def sound(self):
...		        print "meow"
... 
>>>	class Chimera(Dog, Cat):
...		pass
... 
>>>	Chimera().sound()
bark
```

* Python은 다중상속을 허용한다. 요즘은 이걸 믹스인이라고도 한다.
* 다중상속시 발생하는 문제중에 하나는 두개 이상의 부모가 같은 메소드를 가지고 있을때다.
* Python은 먼저 정의된 쪽이 남는다.

##### 부모 메소드의 지정 

* 직접 정해줘도 된다.
* Python의 객체모델은 첫번째 인자로 인스턴스가 넘어가면 되므로 아래와 같이 표현할 수 있다.

```python
>>>	class Chimera2(Dog, Cat):
...		def sound(self):
...		        Cat.sound(self)
... 
>>>	Chimera2().sound()
meow
```

#### 인터페이스 & 추상클래스

* 보다 엄격한 메타클래스를 이용하면 조밀한 컨트롤이 가능하다.
* 그러나 개념적인 표현도 충분히 실용적이므로 메타클래스는 다루지 않는다.

```python
>>>	class IPet:
...		def feed(self):
...		        raise NotImplementedError
... 
>>>	class Dog(IPet):
...		def feed(self):
...		        print "dog sound"
... 
```

##### 사용

```python
>>>	Dog().feed()
dog sound
>>>	class Cat(IPet):
...		pass
... 
>>>	Cat().feed()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 3, in feed
NotImplementedError
```

## Generator
### Why Generator?

* Generator는 List와 비슷하다.
* item을 앞에서부터 한번씩만 참조할수 있다.
* 길이를 구할 수 없다.
* 결과적으로 LISP언어와 유사한 효과를 준다.
	* 자연수의 전체집합, 짝수의 전체집합을 표현할 수 있다.
	* 필요한 만큼만 그때 그때 만들어내므로 메모리낭비가 없다.
	* Generator를 여러겹으로 합쳐도 같은 효과를 낸다.

### generator의 구현

* 아래 코드는 지정한 값까지의 짝수를 만들어내는 generator이다.
* next() 에서 더이상의 item을 만들수 없는 조건이 되면, StopIteration 예외를 던져야 한다.
* for .. in 은 StopIteration 을 직접 처리해서 루프를 종료한다.
* 직접 generator를 다루게 되면, try .. except 를 구현하여 break를 걸어야 한다.

#### Generator Class

```python
class Even:
	def __init__(self, n=None):
		self.n = n
		self.now = 0

	def __iter__(self):
		return self

	def next(self):
		ret = self.now
		self.now += 2
		if self.n == None:
			return ret
		elif ret <= self.n:
			return ret
		else:
			raise StopIteration()
```

##### 사용

```python
>>>	even10 = Even(10)
>>>	print sum(even10)
30

>>>	all_even = Even()
>>>	for i in range(0,100):
...		ev = next(all_even)
...		print ev
0
2
.
.
100
```

##### Generator의 중지

```python
>>>	even10 = Even(10)
>>>	for i in range(0,100):
...		try:
...			ev = next(even10)
...			print ev
...		except StopIteration:
...			print "done"
...			break
0
.
.
10
done
```

#### Generator Function

* 함수내에서 yield 를 사용하면, generator가 된다.
* 함수내에서는 yield 부분에서 block된다.

```python
def get_even(n):
	for i in xrange(0,n+1,2):
		yield i

even = get_even(10)
print sum(even)
```

#### Generator Expression

* for ... in 의 다른 활용으로 한줄로 Generator를 만들수 있다.
* 단 다른 list나 Generator를 입력으로 가져야 한다.

```python
>>>	sharp = ("#%d" % item for item in [1,2,3,4])
>>>	even = (item for item in [1,2,3,4] if item % 2 == 0)
>>>	class Allint:
... 	def __init__(self):
... 		self.now = 0
... 	def __iter__(self):
... 		return self
... 	def next(self):
... 		ret = self.now
... 		self.now += 1
... 		return ret
... 
# 아직 연산되지 않았다.
>>>	alleven = (item for item in Allint() if item % 2 == 0) 
>>>	next(alleven)
0
>>>	next(alleven)
2
>>>	next(alleven)
4
```

## Point Lesson

### 유닛테스트

* test.py

```python
import unittest

class TestFunctions(unittest.TestCase):
	def test_equal(self):
		self.assertEqual(10, 10, "equal test")

if __name__ == '__main__':
	unittest.main()
```

* if \__name__ == '\__main__':  은 직접 실행되었을 때를 의미한다.

#### 실행

* 위와 같이 파일을 작성하고 실행하면..

```bash
$ python test.py 
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

### 함수의 전달

* 함수는 이름만 쓰면 인자로 전달할수 있다. 함수도 객체라서!!
* callable() 로 call이 가능한지, 즉 함수인지 확인한다.
* 클래스에 \__call__() 을 구현하면 함수처럼 사용이 가능하다.

```python
>>>	def hello( name ):
...		print "hello %s" % name
... 
>>>	def yo_man( callback ):
...		if callable(callback):
... 	    callback("man~")
... 
>>>	yo_man( hello )
hello man~
>>>	yo_man( "hello" )
>>>
```

### 커맨드라인 인자

* args.py

```python
import sys
print sys.argv
```

```bash
$ python args.py hello world
['argv.py', 'hello', 'world']
```

### 표준입출력
#### STDIN

* 표준입력은 | (파이프)로 전달되거나 키보드로 입력하는 경우에 들어오는 데이터이다.

* stdin.py

```python
import sys 

for line in sys.stdin:
	print line
```

```bash
$ ls | python stdin.py
```

##### STDIN의 여부판별

* stdin_detect.py

```python
import sys
import select

if select.select([sys.stdin,],[],[],0.0)[0]:
	print "Have data!"
	for line in sys.stdin:
		print line
else:
	print "No data"
```

```bash
$ ls | python stdin_detect.py
Have data!
...
...
$ python stdin_detect.py
No data
```

#### STDOUT

* STDOUT은 쉘상에서 우리가 보는 출력채널이다.
* print 또는 sys.stdout.write() 를 이용한다.
* print는 "\n" 자동으로 붙여주고, write()는 그대로 출력한다.

```python
>>>	import sys
>>>	sys.stdout.write("aaa")
aaa>>> print "aaa"
aaa
```

#### STDERR

* STDERR 은 쉘상에서 우리가 보는 출력채널이다.
* STDOUT과 구분하여 볼수 있어, 에러나 경고등을 출력하는데 사용된다.

```python
>>>	import sys
>>>	sys.stderr.write("aaa")
aaa>>> print >> sys.stderr, "aaa"
aaa
```

### 문자열 처리

* str 객체는 자르고 붙이고 바꿔치기 하는 등의 기능을 제공한다.

#### strip, lstrip, rstrip

* strip은 문자열의 앞뒤에 붙은 white space를 제거해주는 역할을 한다.
* chars를 지정해주면 해당하는 글자들을 지워준다.

```python
>>>	s = "  hello   "
>>>	s.strip()
'hello'
>>>	s = "...hello..."
>>>	s.rstrip(".")
'...hello'
>>>	s.lstrip(".")
'hello...'
```

#### 정규표현식

* 정규표현식은 re 모듈을 import해야한다.

##### re.match 와 re.search

* re.match()의 경우 대상 문자열이 처음부터 매칭되어야 한다.
* re.search()함수는 대상 문자열의 일부만 매칭되어도 된다.
* 웬만하면 re.search()를 쓰자

```python
>>>	m = re.search(r"([0-9-]+)(.+)", "tel: 02-6718-xxxx")
>>>	m.groups()
('02-6718-', 'xxxx')
>>>	m.group(0)
'02-6718-xxxx'
>>>	m.group(1)
'02-6718-'
>>>	m.group(2)
'xxxx'
```

* 매칭에 성공하면 match Object가 리턴되고, 아니면 None이 리턴된다.
* match Object는 groups() 와 group() 함수로 매칭된 값을 이용하게 된다.
* groups 는 표현식 내에 () 로 그룹을 만들어놓은 것들만 나오고
* group(n) 의 경우 0에는 매칭한 전체문자열, 그다음부터 괄호 순서대로 나온다.

##### re.split()

* 첫번째 패턴에 매칭하는 문자열을 기준으로 잘라서 list를 리턴한다.
* 패턴내에 ()로 그룹을 만들어놓으면 결과에 포함된다.

```python
>>>	re.split(r'[-\s]+', "tel: 02-6718-xxxx")
['tel:', '02', '6718', 'xxxx']
>>>	re.split(r'([-\s])+', "tel: 02-6718-xxxx")
['tel:', ' ', '02', '-', '6718', '-', 'xxxx']
```

##### re.findall()

* 검색 문자열에서 패턴과 매칭되는 모든 경우를 찾아 List로 반환

```python
>>>	m = re.findall(r"[0-9]+", "tel: 02-6718-xxxx")
>>>	m
['02', '6718']
```

##### re.sub()

* 패턴과 일치하는 문자열 변경에 사용
* 패턴에 ()로 그룹을 만들고, 바꿔치기할 문자열내에서 \1, \2, ... 들로 치환할수 있다.

```python
>>>	re.sub(r'\D', '_', "tel: 02-6718-xxxx")
'_____02_6718_____'
>>>	re.sub(r'-(\d+)-', r'!!\1!!', "tel: 02-6718-xxxx")
'tel: 02!!6718!!xxxx'
```

### subprocess

* 다른 프로그램을 실행하고 입출력을 다루는 것은 의외로 어렵지 않다.

#### 다른 프로그램을 실행하기

```python
>>>	import subprocess
>>>	subprocess.call('ls')
```

#### 소통하기

* 프로그램간에 소통하는 것을 IPC(Inter Process Communication) 라고 한다.
* 표준입출력을 이용한다.

```python
>>>	import subprocess
>>>	p = subprocess.Popen('ls', stdout=subprocess.PIPE)
>>>	next(p.stdout)
'argv.py\n'
>>>	next(p.stdout)
'meta.md\n'
>>>	next(p.stdout)
'mydir\n'
```

* stdin으로 데이터를 넣어줄수도 있다.
* (출력,에러) = p.communicate("STDIN데이터") 로 표준 입출력을 한번에 처리할수 있다.

```python
>>>	p = subprocess.Popen('grep .py', stdout=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
>>>	(out,err) = p.communicate("test.py\ntest.txt")
>>>	out
'test.py\n'
```

#### 다른 Python 코드를 실행하기

* 다른 Python 코드를 따로 실행시키고 싶다면, 
* python경로를 지정하는 것이 골치아프다. 시스템에 따라 다를수 있으니까.

```python
>>>	import sys
>>>	sys.executable
'/usr/bin/python'
>>>	subprocess.check_output([sys.executable,"test.py"])
```

### 파일과 디렉토리
#### 파일경로의 조립

* OS별로 경로 구분자가 다르므로 os.path.join을 쓰도록 한다.

```python
>>>	import os.path
>>>	os.path.join("test", "src.zip")
'test/src.zip'
```

* windows 에서는..

```python
>>>	import os.path
>>>	os.path.join("test", "src.zip")
'test\\src.zip'
```

#### 파일을 읽고 쓰기

```python
>>>	with open('write.txt', 'w') as w:
...		print >> w, "hello"
...		w.write("world")
...		w.write("!!")
... 
>>>	with open('write.txt') as r:
...		print r.read()
... 
hello
world!!
```

#### 파일을 복사하고 지우기

* 복사하기

```python
>>>	import shutil
>>>	shutil.copyfile('read.txt', 'write.txt')
>>>	shutil.copytree('dir1', 'dir2')
```

* 지우기

```python
>>>	import os
>>>	os.remove("read.txt")
```

#### 파일의 존재여부

```python
>>>	import os.path
>>>	os.path.isfile("read.txt")
```

### HTTP
#### HTTP 요청

* HTTP요청은 urllib2 를 이용한다.
* httplib도 있는데 이는 프로토콜을 구현한 정도의 저수준API이다.

#### HTTP 주소의 조립
##### 직접입력하기

```python
>>>	import urllib2
>>>	f = urllib2.urlopen("http://www.daum.net")
>>>	f.read()
...HTML CONTENT...
>>>	f.close()
```

##### base와 합치기

```python
>>>	import urlparse
>>>	urlbase = "http://www.daum.net/hello/world"
>>>	urlparse.urljoin( urlbase, "daum") # base를 상대경로로 대체
'http://www.daum.net/hello/daum'

>>>	urlparse.urljoin( urlbase+"/", "daum") # base에 상대경로 추가
'http://www.daum.net/hello/world/daum'

>>>	urlparse.urljoin( urlbase+"/", "../daum") # base에 상대경로로 대체(../ 로 상위 대체)
'http://www.daum.net/hello/daum'

>>>	urlparse.urljoin( urlbase+"/", "/daum") # base에 절대 경로로 대체
'http://www.daum.net/daum'
```

##### QueryString 조립

```python
>>>	import urllib
>>>	urllib.urlencode({"q":"test", "name":"KHS"})
'q=test&name=KHS'
>>>	urlparse.urljoin("http://www.daum.net/search","?"+qs)
'http://www.daum.net/search?q=test&name=KHS'
```

#### 파일 다운로드

```python
>>>	content = urllib2.urlopen(url)
>>>	with open("downfile", 'wb') as downfile:
... 	downfile.write(content.read())
```

#### pip의 사용

* pip는 Python 모듈을 검색하고 설치해주는 툴이다.
* https://pypi.python.org/pypi 에 투고되는 모듈들을 확인할 수 있다.

```bash
$ pip search django
...
...
Django                    - A high-level Python Web framework that encourages
                            rapid development and clean, pragmatic design.
...
...
$ sudo pip install Django
Downloading/unpacking Django
  Downloading Django-1.6.5-py2.py3-none-any.whl (6.7MB): 6.7MB downloaded
Installing collected packages: Django
Successfully installed Django
Cleaning up...
$ sudo pip uninstall Django
...
...
...
Proceed (y/n)? y
  Successfully uninstalled Django
$
```

## 드디어 끝났습니다!!

* 그러나 과제가 이어집니다

### 과제2

<img src="http://icon.daumcdn.net/w/icon/1312/19/152729032.png">

* http://icon.daumcdn.net/w/icon/1312/19/152729032.png
* 위 이미지를 다운받아 저장하는 코드를 작성해주세요.
* 어떤 방법이든 상관없습니다.
* sng2nara@daumcorp.com 으로
* "[파이썬기초서울B과제2] 팀/성함/사번" 을 제목으로 해서 메일을 보내주세요~ 
