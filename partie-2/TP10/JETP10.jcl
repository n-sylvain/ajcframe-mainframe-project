//API8ET10   JOB (ACCT#),'SYLVAIN',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT)
//****************************************************************
//* EXECUTION DU PROGRAMME API8.SOURCE.COBOL(TP10)
//****************************************************************
//STEP01   EXEC PGM=TP10
//STEPLIB  DD DSN=API8.COBOL.LOAD,DISP=SHR
//F1CLIENT DD DSN=API8.AJC.F1.DATA,DISP=SHR
//F2CLIENT DD DSN=API8.AJC.F2.DATA,DISP=SHR
//SYSOUT   DD SYSOUT=*
