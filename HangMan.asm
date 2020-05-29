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
	remind:.asciiz "\n Chua chinh xac. Can than hon nhe!"
	printmark:.asciiz "\n| Diem vong choi nay cua ban la: "
	printtotal:.asciiz "\nTong diem cua ban la: "
	newgame:.asciiz "\nNEW GAME\n"
	gameover:.asciiz "\n================\n|   THUA CUOC   |\n================\n"
	wingame:.asciiz "\n================\n|  CHIEN THANG  |\n================\n"
	endgame:.asciiz "\n1.Choi lai\n2. Dung lai.\n"
	menu1:.asciiz "\n=================\n| Tiep tuc doan |\n=================\n| 1. Mot ky tu. |\n| 2. Ca tu.     |\n| 0. Exit.      |\n=================\nChon: "
	fin: .asciiz "input.txt"

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

	str_compare:.space 50
	markarr :.space 10
	guess_arr:.space 2

	str: .space 2000
	CauHoi: .space 50
.text
	
Begin:
	li $v0,4
	la $a0,newgame
	syscall 

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
	
MainLoop:

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
	lb $a2,check
	bne $a2,0,Wingame
	lw $a2,doansai 
	bge $a2,7,LoseGame
	j Continue
LoseGame:
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
	j EndGame
Wingame:
	li $v0,4
	la $a0,wingame
	syscall

	lw $a0,nword 
	addi $a0,$a0,1
	sw $a0,nword 
	lw $a0,score
	lw $a1,doansai
	jal PrintResult
	j Begin
Continue:
	#Xuat thong bao lua chon
	li $v0,4
	la $a0,menu1
	syscall 
	
	li $v0,5
	syscall 
	move $s0,$v0
	beq $s0,1, AChar
	beq $s0,2,WholeWord
	beq $s0,0, End

	#lay random tu 0 - 10
	#li $v0,42
	#li $a1,10
	#syscall 
	#addi $a0,$a0,1

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
	
	lw $t3,doansai
	la $a0,CauHoi
	
	la $a2,markarr
	la $a3,doansai  
	jal _CheckExistChar

	lw $t4,doansai
	sub $t3,$t4,$t3
	bgt $t3,0, PrintNotifError 
	j MainLoop
	PrintNotifError:
		move $a0,$t4
		jal _Thongbao
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
	jal _StringCompare
	lw $a0, check
	beq $a0,1,Wingame
	j LoseGame 
EndGame:
	li $v0,4
	la $a0,endgame
	syscall
	li $v0,5
	syscall
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
		lb $s2,($s0)
		addi $t0,$t0,1
		addi $s0,$s0,1
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
	#Xia stack
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
	li $t0,1
#than thu tuc:
_S.Copy.Loop:
	lb $s4,($s0)
	sb $s4,($a1)
	
	addi $s0,$s0,1
	addi $a1,$a1,1
	lb $s4,($s0)
	
	addi $t0,$t0,1
	bne $t0,$s3,_S.Copy.Check
	j _Scopy.End
_S.Copy.Check:
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
	#Xia stack
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
	#Tinh toan diem cua nguoi choi
	li $t4,100
	mul $t2,$s1,$t4
	sub $s0,$s0,$t2
	ble $s1,$t3,BonusMark
	j PrintResult.Continue
	BonusMark:
		li $t4,2
		mul $s0,$s0,$t4
	PrintResult.Continue:
	#in ra diem cua nguoi choi
	li $v0,4
	la $a0,printmark
	syscall 
	li $v0,1#$a0<--score
	move $a0,$s0
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
	#xoa stack
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
		lb $s3,4($s0)
		beq $s3,0,NotWin
	_CheckWin.Inc:
		addi $s0,$s0,1
		addi $t0,$t0,1
		ble $t0,$s1,_CheckWin.Loop
		j _CheckWin.EndLoop
	NotWin:
		li $t0,0
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
		lb $s2,($s0)
		lb $s3,4($s1)
		beq $s3,1,_printChar
		j _printStar
	_printChar.Continue:
		addi $s0,$s0,1
		addi $s1,$s1,1
		lb $s2,($s0)
		bne $s2,'\0',_printStr.Loop
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
		bne $s2,'\n',_S.length.Loop

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
	lb $s2,($s0) 
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
	li $t1,1
	sw $t1,($t0)
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
	li $t0,0
	li $t2,1
	li $t3,0
#than thu tuc
	#Vong lap so sanh tung ky tu
	_CheckExistChar.Loop:
		lb $t1,($s0)
		beq $s1,$t1,_CheckExistChar.Exist

	_CheckExistChar.Loop.Continue:
		addi $t0,$t0,1
		addi $s0,$s0,1
		bne $t1,'\0',_CheckExistChar.Loop
		j _CheckExistChar.EndLoop
	_CheckExistChar.Exist:
		addi $t3,$t3,1
		add $s2,$s2,$t0
		sb $t2,4($s2) 
		sub $s2,$s2,$t0
		j _CheckExistChar.Loop.Continue
	_CheckExistChar.EndLoop:
		beq $t3,0,NotExist
		j _CheckExistChar.EndFunc
		NotExist:
			lw $t2,($s3)
			addi $t3,$t2,1
			sw $t3,($s3)			
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
