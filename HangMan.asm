.data
	tb1:.asciiz  "\n========\n|/    |\n|\n|\n|\n|\n|"
	tb2:.asciiz  "\n========\n|/    |\n|     O\n|\n|\n|\n|"
	tb3:.asciiz  "\n========\n|/    |\n|     O\n|     | \n|\n|\n|"
	tb4:.asciiz  "\n========\n|/    |\n|     O\n|    /| \n|\n|\n|"
	tb5:.asciiz  "\n========\n|/    |\n|     O\n|    /|\\\n|\n|\n|"
	tb6:.asciiz  "\n========\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|"
	tb7:.asciiz "\n========\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|"
	tb8:.asciiz "\nVi tri xuat hien la: "
	tb9:.asciiz "\n Nhap vao ky tu ban nghi la co: "
	tb10:.asciiz "\nDap an cua ban la: "
	line:.asciiz "==========\n"
	line1: .asciiz "\n-------------------------------------------\n"
	remind:.asciiz "\n Chua chinh xac. Can than hon nhe!"
	printmark:.asciiz "\n| Diem vong choi nay cua ban la: "
	printtotal:.asciiz "\nTong diem cua ban la: "
	newgame:.asciiz "\nNEW GAME\n"
	gameover:.asciiz "\n================\n|   THUA CUOC   |\n================\n"
	wingame:.asciiz "\n================\n|  CHIEN THANG  |\n================\n"
	endgame:.asciiz "\n1.Choi lai\n2. Dung lai.\n"
	menu1:.asciiz "\n=================\n| Tiep tuc doan |\n=================\n| 1. Mot ky tu. |\n| 2. Ca tu.     |\n| 0. Exit.      |\n=================\nChon: "
	fin: .asciiz "input.txt"
	fout: .asciiz "nguoichoi.txt"
	tbName: .asciiz "Ten nguoi choi: "
	tbName1: .asciiz "Ten hop le"
	tbName2: .asciiz "Ten k hop le, vui long nhap lai ten: "
	sao: .asciiz "*"
	gach: .asciiz "-"

	nameStr: .space 50
	
	n:.word 0
	check:.word 0
	doansai:.word 0
	score:.word 0
	totalscore:.word 0
	nword:.word 0
	
	Length :.word 0
	SLTu: .word 0
	Random: .word 0
	Vitri: .word 0
	nameStrLen: .word 0

	str_compare:.space 50
	markarr :.space 10
	guess_arr:.space 2

	str: .space 2000
	CauHoi: .space 50

	diem_str: .space 10
	set_str: .space 10
.text

	li $v0,4
	la $a0,newgame
	syscall 

	#Thong bao nhap ten
	li $v0,4
	la $a0, tbName
	syscall 	

	#Nhap Ten
	la $a0, nameStr
	jal _InputName

	#Xuong dong
	li $v0,4
	la $a0, line1
	syscall

Begin:

	#Cong don diem
	lw $a0, score
	lw $a1,totalscore
	add $a1,$a1,$a0
	sw $a1,totalscore

	#gan diem toi da la 1000 diem
	li $a0,1000
	sw $a0,score
	li $a0,0
	sw $a0,doansai
	
	# Doc file --> random --> cat chuoi --> ra de
	
		#openfile
	li $v0,13
	la $a0,fin
	li $a1,0
	li $a2,0
	syscall
	#Luu dia chi file vao $s0
	move $s0,$v0
	#Doc file
	li $v0,14
	move $a0,$s0
	la $a1,str
	li $a2,2000
	syscall
#str se luu chuoi duoc doc tu file

	#Truyen tham so cho ham tinh do dai chuoi
	la $a0, str
	la $a1, n
	#Goi ham tinh do dai chuoi
	jal _S.lengthh
	#Lay kq tra ve
	lw $t0,($a1)
	sw $t0, Length
	#Length se luu do dai chuoi doc duoc
	


	#Truyen tham so cho ham tinh so luong tu
	la $a0, str
	la $a1, n
	#Goi ham tinh so luong tu
	jal _S.Tu
	#Lay so luong tu tra ve
	lw $t0,($a1)
	sw $t0, SLTu
#SLTu se luu so luong tu trong str



	#Load SLTu vao $s0
	lw $s0,SLTu
	#Random
	li $v0,42
	move $a1,$s0
	syscall
	#Chuyen so vua duoc random vao $s1
	move $s1,$a0
	#Cong 1 de tru truong hop random = 0
	addi $s1,$s1,1
	#Store gia tri cua random vao Random
	sw $s1,Random
#Random se luu thu tu cua tu duoc random



	#Truyen tham so cho ham tinh vi tri cua dau * ma duoc random
	la $a0, str
	la $a1, Vitri
	lw $a2, Random
	#Goi ham tinh vi tri cua dau * ma duoc random
	jal _S.Vitri
	#Lay so luong tu tra ve
	lw $t0,($a1)
	sw $t0, Vitri
#Vitri se luu vi tri dau * ngay tai vi tri tu duoc random



	#Truyen tham so cho ham Strcpy
	la $a0, str
	la $a1, CauHoi
	lw $a2, Vitri
	lw $a3,Length
	#Goi ham _S.Copy
	jal _S.Copy
	#Lay CauHoi tra ve
	
	
	li $v0,4
	la $a0,CauHoi
	syscall
	li $v0,11
	la $a0,'\n'
	syscall 
MainLoop:

	#Xuong dong
	li $v0,4
	la $a0,line
	syscall
	#XUat chuoi co *
	la $a0,CauHoi
	la $a1,markarr
	jal _printStr
	li $v0,4
	la $a0,line
	syscall

	#Kiem tra xem da doan het ky tu chua
	la $a0,markarr 
	lw $a1,n
	la $a2,check
	jal _CheckWin

	lb $a2,check #doc gia tri bien check
	bne $a2,0,Wingame #Neu khac khong thi thang game
	lw $a2,doansai #doc gia tri so lan doan sai tu bien doansai
	bge $a2,7,LoseGame #neu so lan doan sai >= 7 thi thua cuoc
	j Continue
LoseGame:
	#in thong bao THUA CUOC
	li $v0,4
	la $a0,gameover
	syscall

	

	#in ra tong cong diem cua nguoi choi qua cac man choi
	li $v0,4
	la $a0, printtotal	
	syscall 
	li $v0,1
	lw $a0,totalscore
	syscall 

#Tan <3 Luan
	#In thong tin nguoi choi
	la $a0, fout
	la $a1, nameStr
	la $a2, totalscore
	la $a3, nword
	la $s5, sao
	la $s6, gach

	jal _WritePlayerInfo

	#Top 10 highscore
	#Doc file lay chuoi thong tin cac nguoi choi va tach diem ra mang
	#la $a0, n
	#la $a1, str
	#la $a2, arr
	#jal _ReadNguoiChoi
	#Sort diem nguoi choi
	#la $a0, n
	#la $a1, arr
	#la $a2, idArr
	#jal _SortDiem
	
	

	j EndGame  #Nhay den --> hoi nguoi choi: Choi lai hay Dung.
Wingame:
	#in thongbao thang gamme
	li $v0,4
	la $a0,wingame
	syscall
	
	#moi lan thang --> tang so tu doan duoc len 1
	lw $a0,nword 
	addi $a0,$a0,1 #nword = nword +1
	sw $a0,nword 
	
	#truyen tham so vao ham in diem
	la $a0, score #truyen diem
	lw $a1, doansai#truyen so lan doan sai
	jal PrintResult #goi ham
	j Begin
Continue:
	#Xuat thong bao lua chon
	li $v0,4
	la $a0,menu1
	syscall 
	
	li $v0,5 #lay  lenh nhap tu ban phim
	syscall 
	
	move $s0,$v0
	beq $s0,1, AChar #lenh =1 --> Aword
	beq $s0,2,WholeWord#lenh =2 --> wholeWord
	beq $s0,0, End #lenh =0 --> thoat Game

End:
	
	#Ket thuc chuong trinh
	li $v0,10
	syscall
AChar:
	
	#Xuat htong ba nhap ky tu
	li $v0,4
	la $a0,tb9
	syscall 
	

	#Nhap vao mot ky tu
	li $v0, 12
	syscall 
	move $a1,$v0

	#Xuong dong
	li $v0,11
	la $a0,'\n'
	syscall
	
	lw $t3,doansai #lay so lan doan sai truoc khi doan lan tiep theo
	la $a0,CauHoi
	la $a2,markarr
	la $a3,doansai  
	jal _CheckExistChar
	
	
	lw $t4,doansai#lay so lan doan sai sau khi da doan
	sub $t3,$t4,$t3 #tinh hieu $t3 va $t4
	bgt $t3,0, PrintNotifError #neu $t4 - $t3 >0 thi nguoi dung da doan sai
	j MainLoop
	PrintNotifError:
		move $a0,$t4 #truyen do lan da doan sai
		jal _Thongbao#goi ham in thong bao sai tuong ung
		j MainLoop
WholeWord:
	#Xuat thong bao nhap chuoi doan
	li $v0,4
	la $a0,tb10
	syscall
	
	#Nhap vao chuoi str_compare
	li $v0,8
	la $a0,str_compare
	li $a1,50
	syscall
	
	#so khop hai chuoi	
	#truyen tham so 
	la $a0,CauHoi
	la $a1,str_compare
	la $a3,check
	jal _StringCompare #goi ham so sanh hai chuoi
	lw $a0, check #doc gia tri tu bien check
	beq $a0,1,Wingame #neu bang 1 thi? CHIEN THANG 
	j LoseGame 
EndGame:
	#in thong bao hoi nguoi choi co tiep tuc choi hay dung lai
	li $v0,4
	la $a0,endgame
	syscall
	
	#lay lenh la so nguyen duoc nhap tu nguoi choi
	li $v0,5
	syscall
	#so sanh lenh nhap vao va di den Lenh tuong ung
	beq $v0,1,Begin
	beq $v0,2,End
Error1:
	#Xuat thong bao sai 1 luot
	li $v0,4
	la $a0,tb1
	syscall 
	j _Thongbao.end
Error2:
	#Xuat thong bao sai 2 luot
	li $v0,4
	la $a0,tb2
	syscall
	j _Thongbao.end
Error3:
	#Xuat thong bao sai 3 luot
	li $v0,4
	la $a0,tb3
	syscall
	j _Thongbao.end
Error4:
	#Xuat thong bao sai 4 luot
	li $v0,4
	la $a0,tb4
	syscall
	j _Thongbao.end
Error5:
	#Xuat thong bao sai 5 luot
	li $v0,4
	la $a0,tb5
	syscall
		j _Thongbao.end
Error6:
	#Xuat thong bao sai 6 luot
	li $v0,4
	la $a0,tb6
	syscall
		j _Thongbao.end
Error7:
	#Xuat thong bao sai 7 luot
	li $v0,4
	la $a0,tb7
	syscall
	j _Thongbao.end

#============= TINH CHIEU DAI CHUOI ===================
#Doi so truyen vao la chuoi can tinh do dai va so n
_S.lengthh:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1#n	
	#Khoi tao vong lap
	li $t0,0
#than thu tuc:
	_S.lengthh.Loop:
		lb $s2,($s0) #lay s[i]
		addi $t0,$t0,1 #tang bien dem 
		addi $s0,$s0,1 #tang dia chi
		bne $s2,'\n',_S.lengthh.Loop 

	addi $t0,$t0,-2
	sw $t0,($s1)
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra


#============= NHAP TEN ===================
#Doi so truyen vao la chuoi ten
_InputName:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	sw $t2, 28($sp)
	sw $t3, 32($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	
#than thu tuc:
_InputName.Start:
	#Doc ten
	move $a0, $s0
	addi $a1,$0,30
	addi $v0,$0,8
	syscall

	li $t0, 0 # $t0 la bien dem so ky tu chuoi
	add $t1,$s0,$t0 # $t1 la dia chi cua tung ki tu cua chuoi
	lb $s1,0($t1) # $s1 la gia tri cua tung ki tu cua chuoi

_InputName.Next:
	#Cap nhat $t1 va $s1
	add $t1,$s0,$t0
	lb $s1,0($t1)

	bne $s1, '\n', _InputName.VongLap #$s1 bang 0 thi het chuoi
	
	#Thay \n bang \0
	li $t2, '\0'
	sb $t2, ($t1)
	#Hop le
	addi $v0,$0,4
	la $a0, tbName1
	syscall

	j _InputName.Fin

_InputName.VongLap:
	li $s2,10
	beq $s1,$s2,_InputName.TangBienDem

	#Xet ki tu co la so
	slti $t3, $s1, ':'
	beq $t3,1,_InputName.XetSo

	#Xet ki tu co la chu hoa
	slti $t3, $s1, '['
	beq $t3,1,_InputName.XetChuHoa

	#Xet ki tu co la chu thuong
	slti $t3, $s1, '{'
	beq $t3, 1, _InputName.XetChuThuong

	j _InputName.End

_InputName.XetSo:
	slti $t3,$s1,'0'
	beq $t3,0,_InputName.TangBienDem
	j _InputName.End

_InputName.XetChuHoa:
	slti $t3,$s1,'A'
	beq $t3,0,_InputName.TangBienDem
	j _InputName.End

_InputName.XetChuThuong:
	slti $t3,$s1,'a'
	beq $t3,0,_InputName.TangBienDem
	j _InputName.End

_InputName.TangBienDem:
	addi $t0,$t0,1
	j _InputName.Next

_InputName.End:
	
	#In khong hop le
	addi $v0,$0,4
	la $a0, tbName2
	syscall
	j _InputName.Start

_InputName.Fin:
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	lw $t2, 28($sp)
	lw $t3, 32($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra

#============= DEM SO TU ===================
#Doi so truyen vao la chuoi can tinh do dai va so n
_S.Tu:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1 #n	
	#Khoi tao vong lap
	li $t0,0
#than thu tuc:
_S.Tu.Loop:
	lb $s2,($s0)
	beq $s2,'*',_S.Tu.TangTu
	j _S.Tu.Tangi
_S.Tu.TangTu:
	addi $t0,$t0,1
_S.Tu.Tangi:
	addi $s0,$s0,1
	bne $s2,'\n',_S.Tu.Loop

	addi $t0,$t0,-1
	sw $t0,($s1)
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
	
#============= VI TRI DAU * ===================
#Doi so truyen vao la chuoi can tinh do dai, so n va so random
_S.Vitri:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4, 20($sp)
	sw $t0,24($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1 #Vitri
	move $s4, $a2 #Random	
	#Khoi tao vong lap
	li $t0,0
	li $s3,0
#than thu tuc:
_S.Vitri.Loop:
	lb $s2,($s0)
	beq $s2,'*',_S.Vitri.TangSao
	j _S.Vitri.Tangi
_S.Vitri.TangSao:
	addi $t0,$t0,1
_S.Vitri.Tangi:
	addi $s0,$s0,1
	addi $s3,$s3,1
	bne $t0,$s4,_S.Vitri.Loop
	
	sw $s3,($s1)
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $t0,24($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra

#============= STRING COPY ===================
#Doi so truyen vao la chuoi str, chuoi chua cau hoi va vi tri dau *
_S.Copy:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $t0,24($sp)
	sw $t1,28($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1 #CauHoi
	move $s2, $a2 #Vitri
	move $s3, $a3 #Length
	#Khoi tao vong lap
	add $s0,$s0,$s2
	li $t0, 0
#than thu tuc:
_S.Copy.Loop:
	lb $s4, ($s0)
	sb $s4, ($a1)
	
	addi $s0, $s0, 1
	addi $a1, $a1, 1
	lb $s4,($s0)
	
	addi $t0,$t0,1
	bne $s4,'*',_S.Copy.Loop
	j _Scopy.End
		
#cuoi thu tuc
	#restore 
_Scopy.End:
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4, 20($sp)
	lw $t0,24($sp)
	lw $t1,28($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra

#===========HAM IN KET QUA ============
PrintResult:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0,20($sp)
	sw $t1,24($sp)
	sw $t2,28($sp)
	
	#Luu tham so vao thanh ghi
	move $s0,$a0 #score
	move $s1,$a1 #doansai
	lw $s2,($s0)
	#Tinh toan diem cua nguoi choi
	li $t4,100
	mul $t2,$s1,$t4
	sub $s2,$s2,$t2
	ble $s1,$t3,BonusMark
	j PrintResult.Continue
	BonusMark:
		li $t4,2
		mul $s2,$s2,$t4
	PrintResult.Continue:
	sw $s2,($s0)
	#in ra diem cua nguoi choi
	li $v0,4
	la $a0,printmark
	syscall 
	li $v0,1#$a0<--score
	move $a0,$s2
	syscall 
	
#cuoi thu tuc
	#restorE
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0,20($sp)
	lw $t1,24($sp)
	lw $t2,28($sp)
	#Xoa stack
	add $sp,$sp,32
	#tra VE
	jr $ra	
	
#============== KIEM TRA MANG DANH DAU ===============
_CheckWin:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	
	#Luu tham so vao thanh ghi
	move $s0,$a0#markarr
	move $s1,$a1#n
	move $s2,$a2 #check
	
#than thu tuc
	#Khoi tao bien check = 1
	
	#Khoi toa vong lap voi bien dem $t0
	li $t0,1
	_CheckWin.Loop:
		lb $s3,4($s0) #doc tung gia tri cua mang markarr len
		beq $s3,0,NotWin #neu van con phan tu bang 0 --> chua doan dung het cac ky tu
	_CheckWin.Inc:
		#tang dia chi va tang bien diem
		addi $s0,$s0,1
		addi $t0,$t0,1
		#Kiem tra dieu kien dung
		ble $t0,$s1,_CheckWin.Loop
		j _CheckWin.EndLoop
	NotWin:
		li $t0,0 #neu chua chien thang thi check = 0
	_CheckWin.EndLoop:
	sb $t0,($s2)
#cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#============== XUAT CHUOI - DE THI CO DAU * ==========
_printStr:
#doi so truyen vao la chuoi dethi va mang danh dau vi tri da doan trung
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)

	#Luu tham so vao thanh ghi
	move $s0,$a0#str
	move $s1,$a1#markarr

#than thu tuc

	_printStr.Loop:
		lb $s2,($s0)#lay str[i]
		lb $s3,4($s1)#lay markarr[i] 
		beq $s3,1,_printChar # Neu  markarr[i] =1 thi in str[i] 
		j _printStar#Nguoc lai thi in '*'
	_printChar.Continue:
		addi $s0,$s0,1#tang dia chi
		addi $s1,$s1,1#tang bien dem
		lb $s2,($s0)#doc str[i]
		bne $s2,'\0',_printStr.Loop#kiem tra dieu kien dung
		j printChar.EndLoop
		_printChar:
			li $v0,11
			move $a0,$s2
			syscall 
			j _printChar.Continue
		_printStar:	
			li $v0,11
			la $a0,'*'
			syscall 
			j _printChar.Continue
	printChar.EndLoop:
		#in dau xuong dong
		li $v0,11
		la $a0,'\n'
		syscall 
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
	
#============= TINH CHIEU DAI CHUOI ===================
#Doi so truyen vao la chuoi can tinh do dai va so n
_S.length:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1#n	
	#Khoi tao vong lap
	li $t0,0
#than thu tuc:
	_S.length.Loop:
		lb $s2,($s0)
		addi $t0,$t0,1
		addi $s0,$s0,1
		bne $s2,'\0',_S.length.Loop

	addi $t0,$t0,-1
	sw $t0,($s1)	
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#============ XUAT THONG BAO VOI SO LOI TUONG UNG ================
_Thongbao:
#dau thu tuc
	#Khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	#lay tham so ghi vao thanh ghi
	move $s0,$a0

	

#than thu tuc
	li $v0,4
	la $a0,remind
	syscall

	beq $s0,1,Error1
	beq $s0,2,Error2
	beq $s0,3,Error3
	beq $s0,4,Error4
	beq $s0,5,Error5
	beq $s0,6,Error6
	beq $s0,7,Error7
_Thongbao.end:
	li $v0,11
	la $a0,'\n'
	syscall
#cuoi thu tuc

	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#=============== HAM SO SANH HAI CHUOI ======================
_StringCompare:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0,20($sp)
	sw $t1,24($sp)
	li $t1,0
	#Luu tham so vao thanh ghi
	move $s0,$a0 #chuoi de thi
	move $s1,$a1 #chuoi nguoi choi nhap vao
	move $t0,$a3 #bien check (Neu trung nhau thi check bang 1)
#than thu tuc
_StringCompare.Loop:
	#Doc lan luot cac ky tu tuong ung tren ca 2 chuoi
	lb $s2,($s0) 
	lb $s3,($s1)
	bne $s2,$s3,_StringNotSame # so sanh neu khong trung thi tra ve 0
_StringCompare.Increase:
	#tang dia chi cua ca 2 chuoi
	addi $s1,$s1,1
	addi $s0,$s0,1
	lb $s2,($s0) #doc lai gia tri sau khi tang dia chi
	lb $s3,($s1)
	beq $s2,'\0',_ProcessRestString2 # Neu chuoi de thi gap ky tu ket thuc truoc thi ng?ng lap
	
	j _StringCompare.Loop
_ProcessRestString2:
	beq $s3,10,_StringSame
#_ProcessRestString1
_StringNotSame:
	#Xuat thong bao chuoi khong giong nhau va? thua cuoc
	sw $t1,($t0)
	j _StringCompare.EndLoop
_StringSame:
	li $t1,1 #gan $t1 =1
	sw $t1,($t0) #check =1 .
	j _StringCompare.EndLoop
_StringCompare.EndLoop:
	
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0,20($sp)
	lw $t1,24($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#=========== HAM KIEM TRA TON TAI KY TU TRONG CHUOI ===============
#tham so truyen vao la 1 chuoi ( de thi) , 1 ky tu can kiem tra
#va 1 mang danh dau vi tri da doan duoc luu vi tri xuat hien cua ky tu trong chuoi ky tu
_CheckExistChar:
#dau thu tuc
	addi, $sp,$sp,-40
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t2,20($sp)
	sw $t3,24($sp)
	sw $t4,28($sp)
	sw $s2,32($sp)
	sw $s3,36($sp)
	
	
	#Luu tham so vao thanh ghi
	move $s0,$a0 #Chuoi ky tu
	move $s1,$a1 #ky tu can kiem tra
	move $s2,$a2 #mang danh dau vi tri xuat hien cua ky tu trong chuoi ky tu
	move $s3,$a3 #so lan doan sai
	
	#Khoi tao bien dem cho vong lap
	li $t0,0 #bien dem
	li $t2,1#bien gia tri tra ve mac dinh =1
	li $t3,0 #bien dem =0
#than thu tuc
	#Vong lap so sanh tung ky tu
	_CheckExistChar.Loop:
		lb $t1,($s0) #doc tung ky tu cua dethi
		beq $s1,$t1,_CheckExistChar.Exist #kiem tra ky tu vau nhap voi ky tu vua doc duoc : Neu bang thi doa dung

	_CheckExistChar.Loop.Continue:
		addi $t0,$t0,1
		addi $s0,$s0,1
		bne $t1,'\0',_CheckExistChar.Loop
		j _CheckExistChar.EndLoop
	_CheckExistChar.Exist:
		addi $t3,$t3,1 #dem so ky tu doan dung trong 1 lan nhap
		add $s2,$s2,$t0# nahy den dia chi tuong ung trong mang danh dau 
		sb $t2,4($s2) #set gia tri 1 cho pahn tu tai vi tri do trong mang danh dau
		sub $s2,$s2,$t0 #reset lai dia chi ban dau cua mang danh dau.
		j _CheckExistChar.Loop.Continue
	_CheckExistChar.EndLoop:
		beq $t3,0,NotExist #neu $t3 van bang 0 thi co nghia la khong coky tu nao trung khop
		j _CheckExistChar.EndFunc
		NotExist:
			lw $t2,($s3) #lay gia tri cua doansai 
			addi $t3,$t2,1 #tang so lan dooansai len 1
			sw $t3,($s3)		#luu lai so lan dooansai vao bien
_CheckExistChar.EndFunc:
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	lw $t4,28($sp)
	lw $s2,32($sp)
	lw $s3,36($sp)
	#xoa stack
	addi $sp,$sp,40
	#tra ve
	jr $ra
#===================== XUAT MANG ====================
#Than thu tuc
_XuatMang:
	#khai bao kt stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)#n
	sw $s1,8($sp)#arr
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t3,20($sp)
	
	#Lay tham so luu vao thanh ghi
	move $s0,$a0
	move $s1,$a1
	
	#KHoi tao vong lap
	li $t0,1
_XuatMang.Lap:
	#Luu a[i] v0
	lb $t3,4($s1)
	li $v0,1
	move $a0,$t3
	syscall#Xuat a[i]

	#Xuat khaong trang
	li $v0,11
	la $a0,' '
	syscall
	#Tang dia chi
	addi  $s1,$s1,1
	#tang dem
	addi $t0,$t0,1
	#Kiem tra dien kien dung
	slt $t1,$s0,$t0
	beq $t1,$0,_XuatMang.Lap
	
	#Cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp)#n
	lw $s1,8($sp)#arr
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	addi $sp,$sp,32
	#tra ve
	jr $ra

#======== Ham ghi thong tin player xuong file =========	
_WritePlayerInfo:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0,20($sp)
	
	#truyen tham so
	move $s0,$a0 #ten file
	move $s1,$a1 #ten player
	move $s2,$a2 #diem
	move $s3,$a3 #van

#than thu tuc
	#open file
	li $v0,13
	move $a0, $s0
	li $a1,9 #flags write with create and append 
	li $a2,0 #mode ignored
	syscall

	#luu descriptor file vao t0
	move $t0,$v0

	#ghi dau *
	li $v0,15
	move $a0,$t0
	move $a1,$s5
	li $a2,1
	syscall

	#ghi ten player
	
	#truyen tham so
	move $a0,$s1
	la $a1, nameStrLen
	#goi ham tinh length	
	jal _S.length

	li $v0,15
	move $a0, $t0
	move $a1, $s1
	lw $a2, nameStrLen
	syscall

	#ghi dau -
	li $v0,15
	move $a0,$t0
	move $a1,$s6
	li $a2,1
	syscall

	#ghi diem
	#truyen tham so
	la $a0, diem_str
	move $a1,$s2
	#goi ham chuyen so thanh chuoi	
	jal _Itoa

	move $a2,$v0 #so chu so
	li $v0,15
	move $a0,$t0
	la $a1, diem_str
	syscall

	#ghi dau -
	li $v0,15
	move $a0,$t0
	move $a1,$s6
	li $a2,1
	syscall

	#ghi so van
	#truyen tham so
	la $a0,set_str
	move $a1,$s3
	#goi ham chuyen so thanh chuoi	
	jal _Itoa

	move $a2,$v0 #so chu so
	li $v0,15
	move $a0,$t0
	la $a1,set_str
	syscall

	#dong file
	li $v0,16
	move $a0,$t0
	syscall

#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	#xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra

#============= HAM CHUYEN SO THANH CHUOI ===============
_Itoa:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0,20($sp)
	sw $t1,24($sp)
	sw $t2,28($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	lw $s1, ($a1) #n	
	#so 10
	li $s3,10
	
	#bien dem so chu so
	li $t2,0 
#than thu tuc:
_Itoa.Chia:
	#khoi tao stack
	addi $sp,$sp,-1
	div $s1,$s3
	mfhi $t0 #phan du
	mflo $t1 #phan nguyen

	#luu phan du vao stack
	sb $t0,($sp)
	
	#tang so chu so
	addi $t2,$t2,1
	move $s1,$t1
	bnez $t1,_Itoa.Chia
	
	#tra ve so chu so
	move $v0,$t2

_Itoa.SaveByte:
	lb $t1,($sp)
	addi $t1,$t1,48 #chuyen sang ascii
	sb $t1,($s0)
	#tang chi so
	addi $s0,$s0,1
	addi $sp,$sp,1
	
	addi $t2,$t2,-1
	#kiem tra t2=0
	bnez $t2,_Itoa.SaveByte

#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0,20($sp)
	lw $t1,24($sp)
	lw $t2,28($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
	
# ===== Ham xu ly diem nguoi choi =====
_ReadNguoiChoi:
#Dau Thu Tuc
	addi $sp, $sp, -44
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $s1, 16($sp)
	sw $t2, 20($sp)
	sw $s2, 24($sp)
	sw $s3, 28($sp)
	sw $s4, 32($sp)
	sw $t3, 36($sp)
	sw $t4, 40($sp)
	sw $t5, 44($sp)

	la $s2, ($a0) #dia chi n
	la $s3, ($a1) #dia chi str
	la $s4, ($a2) #dia chi arr

#Than Thu Tuc

_ReadNguoiChoi.read:
	#open file
	li $v0, 13
	la $a0, fout
	li $a1, 0
	li $a2, 0
	syscall	
	#luu dia chi file vao s0
	move $s0, $v0
	#readfile
	li $v0, 14
	move $a0, $s0
	la $a1, ($s3)
	li $a2, 400
	syscall

	addi $s3, $s3, '\0'

	# Close the file 
  	li   $v0, 16
  	move $a0, $s0
  	syscall

	#findlength init
	li $t0, 0	#bien dem
	la $s0, ($s3)

#Tim do dai chuoi
FindStrLength:
	lb $t1, ($s0)
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	bne $t1, '\0' FindStrLength

#process init
	move $s1, $t0	#$s0 la s length	
	la $t0, ($s3) #dia chi str
	li $t4, 0 #so luong phan tu
	li $t1, 0 #bien dem string length
	la $t2, ($s4) #dia chi arr
	li $t5, 10 #nhan 10 moi lan doc 1 ky tu tong diem

	addi $s1, $s1, -1
	addi $t0, $t0, 1

#Loc ra so diem cua nguoi choi
_ReadNguoiChoi.process:
	lb $t3, ($t0)
	bne $t3, '-', _ReadNguoiChoi.process.con
	li $s0, 0
	addi $t1, $t1, 1
	addi $t0, $t0, 1 
	lb $t3, ($t0)
	#Neu la dau '-' truoc tong diem thi luu vao mang, khong thi bo qua
_ReadNguoiChoi.process.score:	
	subi $t3, $t3, '0'
	mult $s0, $t5
	mflo $s0
	add $s0, $s0, $t3
	addi $t1, $t1, 1
	addi $t0, $t0, 1 
	lb $t3, ($t0)
	bne $t3, '-', _ReadNguoiChoi.process.score
	#khi da duyet het ky tu cua tong diem, ta luu vao mang
	#tang so luong ky tu '-'
	addi $t4, $t4, 1
	sw $s0, ($t2)
	addi $t2, $t2, 4
_ReadNguoiChoi.process.con:
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	blt $t1, $s1, _ReadNguoiChoi.process

	sw $t4, ($s2) #Do dai mang diem so

#Cuoi thu tuc
	#restore thanh ghi
	lw $t5, 44($sp)
	lw $t4, 40($sp)
	lw $s2, 24($sp)
	lw $s3, 28($sp)
	lw $s4, 32($sp)
	lw $t3, 36($sp)
	lw $t2, 20($sp)
	lw $s1, 16($sp)
	lw $t1, 12($sp)
	lw $t0, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	#Xoa stack
	addi $sp, $sp, 44
	#quay ve
	jr $ra

# ===== Ham sap xep mang (Selection sort)====
_SortDiem:
#Dau Thu Tuc
	addi $sp, $sp, -52	#khai bao kich thuoc
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $s1, 16($sp)
	sw $t2, 20($sp)
	sw $t3, 24($sp)
	sw $s2, 28($sp)
	sw $t4, 32($sp)
	sw $s3, 36($sp)
	sw $s4, 40($sp)
	sw $s5, 44($sp)
	sw $t5, 48($sp)
	sw $t6, 52($sp)
	
#Tao mang index thu tu
	li $t0, 0
	lw $s0, ($a0)
	la $t1, ($a2)
_SortDiem.CreateIdLoop:
	sw $t0, ($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	blt $t0, $s0, _SortDiem.CreateIdLoop

#Than thu tuc
	#khoi tao
	lw $s0, ($a0) # Luu n - 1
	move $s4, $s0 # Luu n
	subi $s0, $s0, 1
	li $t0, 0 # i = 0
	la $s1, ($a1) #Luu dia chi a[i]
	la $s5, ($a2) #Luu dia chi stt a[i]
_SortDiem.Lapi:

	#j = i + 1	
	la $t1, ($t0)
	addi $t1, $t1, 1
	# $s2 la dia chi cua a[j]
	move $s2, $s1
	addi $s2, $s2, 4
	move $s3, $s2
	#Lay gia tri a[i] va a[j] ra
	lw $t2, ($s1)
	
	#Bien max trong j -> n
	lw $t3, ($s2)
	#Tim trong khoang tu j den n gia tri lon nhat va luu vao s2
	j _SortDiem.Lapj

_SortDiem.Conj:
	
	#Neu max lon hon a[i] thi doi cho
	bgt $t2, $t3, _SortDiem.Coni
	#doi gia tri a[i] a[j]
	move $t4, $t2
	move $t2, $t3
	move $t3, $t4
	#gan lai vao dia chi
	sw $t2, ($s1)
	sw $t3, ($s3)
	#doi stt a[i] va a[j]
	sub $t6, $s3, $s1
	add $t6, $t6, $s5
	lw $t2, ($s5)
	lw $t3, ($t6)
	#doi cho gia tri stt
	move $t4, $t2
	move $t2, $t3
	move $t3, $t4
	#gan lai vao dia chi stt
	sw $t2, ($s5)
	sw $t3, ($t6)
	

_SortDiem.Coni:
	#Tang dem i, tang dia chi va kiem tra vong lap
	addi $t0, $t0, 1
	addi $s1, $s1, 4
	addi $s5, $s5, 4
	blt $t0, $s0, _SortDiem.Lapi
	j _SortDiem.Fin

_SortDiem.Lapj:
	lw $t4, ($s2)

	#Neu gap phan tu lon hon thi cap nhat $t3 va dia chi luu $s3, neu khong thi tiep tuc
	bgt $t3, $t4, _SortDiem.Lapj.Con
	move $t3, $t4
	move $s3, $s2
_SortDiem.Lapj.Con:
	#Tang dia chi va bien dem
	addi $s2, $s2, 4
	addi $t1, $t1, 1
	blt $t1, $s4, _SortDiem.Lapj
	j _SortDiem.Conj

_SortDiem.Fin:
#Cuoi thu tuc
	#restore thanh ghi
	lw $t6, 52($sp)
	lw $t5, 48($sp)
	lw $s5, 44($sp)
	lw $s4, 40($sp)
	lw $s3, 36($sp)
	lw $t4, 32($sp)
	lw $s2, 28($sp)
	lw $t3, 24($sp)
	lw $t2, 20($sp)
	lw $s1, 16($sp)
	lw $t1, 12($sp)
	lw $t0, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	#Xoa stack
	addi $sp, $sp, 52
	#quay ve
	jr $ra

# ===== Ham tra ve thong tin nguoi choi o vi tri i  =====
_NguoiChoiInfo:
#Dau Thu Tuc
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $s1, 16($sp)
	sw $t2, 20($sp)
	sw $s2, 24($sp)
	sw $t3, 28($sp)

	la $s0, ($a0) #vi tri can lay thong tin
	la $s1, ($a1) #dia chi str
	la $s2, ($a2) #dia chi luu thong tin

#Than Thu Tuc
	li $t0, 0 #vi tri hien tai
	la $t1, ($s1) #dia chi hien tai
	la $t3, ($s2)
	lb $t2, ($t1)
_NguoiChoiInfo.Loop:
	#Neu vi tri hien tai khong phai vi tri can tim thi tiep tuc vong lap
	bne $t0, $s0, _NguoiChoiInfo.Con
	sb $t2, ($t3)
	addi $t3, $t3, 1
	addi $t1, $t1, 1
	lb $t2, ($t1)
	bne $t2, '*', _NguoiChoiInfo.Loop
	j _NguoiChoiInfo.Fin
_NguoiChoiInfo.Con:
	addi $t1, $t1, 1
	lb $t2, ($t1)
	#Neu la dau * thi tang bien dem vi tri len 1
	beq $t2, '*', _NguoiChoiInfo.Inc
	bne $t2, '\0', _NguoiChoiInfo.Loop	

_NguoiChoiInfo.Inc:
	addi $t0, $t0, 1
	j _NguoiChoiInfo.Con

_NguoiChoiInfo.Fin:
#Cuoi thu tuc
	#restore thanh ghi
	
	lw $s2, 24($sp)
	lw $t3, 28($sp)
	lw $t2, 20($sp)
	lw $s1, 16($sp)
	lw $t1, 12($sp)
	lw $t0, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	#Xoa stack
	addi $sp, $sp, 32
	#quay ve
	jr $ra

