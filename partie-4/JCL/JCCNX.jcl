//API4MAP JOB (ACCT#),'DENIS',MSGLEVEL=(1,1),
//         NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,TIME=(0,15),COND=(4,LT)
//********COMPIL COBOL CICS*************************************
//* Pour compiler le programme de l'IHM CICS de connexion
//         JCLLIB  ORDER=SDJ.FORM.PROCLIB
//********
//COMPCIC  EXEC COMPCICS,NOMPGM=A5CNX
//STEPCIC.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPCOB.SYSLIB   DD
//                 DD
//                 DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR
/*
