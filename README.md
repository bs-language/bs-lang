BS language Compiler
=
based on LLVM

## 계획

타이핑이랑 리스트, 맵 리터럴 생성은 파이썬, 타입스트립트 스타일을 따를 생각. for, if는 Go lang 스타일로.

IR에서 [동적할당](https://releases.llvm.org/1.1/docs/LangRef.html#i_malloc)이 생각보다 간단하고, [구조체](https://llvm.org/doxygen/classllvm_1_1StructType.html)도 있어서 클래스랑 동적 할당 추가를 해볼만 함. 근데 처음부터 다 개발하면 너무 어려우니까 스택 할당 100%로 구현해보고, 차차 추가하는 느낌.

1. 변수, 함수, if, for, 포인터 (가능하면 참조자도) 구현하기
2. 구조체 및 클래스 구현하기 -> 추후엔 상속도 제작해보기
3. 동적 할당 어떤식으로 할지 설계
    - RAII 방식
    - GC 방식
    - new & delete
4. 분할 컴파일 (모듈 import) 구현하기
5. 제네릭(템플릿) 구현하기

## 코드 예시

```go
import 'iostream' // 모듈 import (문자열에 "이랑 '구분 안함)

fn main() int { //함수 정의는 fn으로. void 아니면 반환 자료형 붙여줘야됨 
    print('Hello, World!') //세미콜론 안 씀

    a : int //선언만 할 때는 : 쓰고 자료형 써야함.
    arr := [1,2,3,4,5] //선언과 초기화 동시에 할 때는 := 쓰기. 배열은 []로 생성 가능
    //아직 런타임 타입 기능이 없어서 하나의 배열에 서로 다른 자료형은 안됨.

    mymap := {"key1":1, "key2":2} //{}리터럴로 map 생성 가능

    for i := 0; i < 5; i++ { //go 스타일 for문. ++ --는 for문에서만 사용 가능함
        if arr[i] % 2 == 0 {
            print(arr[i])
        }
        else if arr[i] % 3 == 0 and arr[i] != 6 { 
            print(arr[i])
        }
    }

    for key,val in mymap { //범위기반 for문은 파이썬처럼. 자동 언패킹 가능
        print('value: ${val}') //문자열 보간 기능 탑재
    }

    return 0
}

```

## 추가 명세

- 전역변수 없음. 스택 100% (리터럴 문자열만 예외적으로 데이터 세그먼트에 저장)
- switch case, while, goto, label 없음
- 동시성 프로그래밍은 일단 뭐든지 불가능 (비동기, 코루틴, 이벤트루프, 시스템 스레드 싹 다 안됨.)
- 함수 오버로딩 허용
- 연산자 오버로딩 허용
- 타입
    - char (8bit)
    - byte (8bit)
    - int (32bit)
    - long (64bit)
    - float (32bit)
    - double (64bit)
    - string (mutable함)
    - list (기본 배열이 동적배열)
    - map (hash)
    - set (hash)

  unsigned 없음. short 없음. 기본 타입들은 이름이 소문자로 시작했으면 좋겠음

- interface랑 class 있음
- class랑 struct가 구분됐으면 좋겠음
- 상속 가능. 근데 다중상속은 안됨
- 모듈 단위로 암묵적 namespace 적용
