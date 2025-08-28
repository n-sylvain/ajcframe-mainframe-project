//API8T02B JOB (ACCT#),'SYLVAIN',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1), 
//            NOTIFY=&SYSUID,REGION=4M,TIME=(,30) 
//**************************************************************** 
//* EXECUTION DU PROGRAMME API8.SOURCE.COBOL(TP02B) 
//**************************************************************** 
//STEP01   EXEC PGM=TP02B 
//STEPLIB  DD DSN=API8.COBOL.LOAD,DISP=SHR 
//FEMPLOYE DD DSN=API8.AJC.EMPLOYE.KSDS,DISP=SHR 
//SYSOUT   DD SYSOUT=* 
//SYSIN    DD *
10058
/*