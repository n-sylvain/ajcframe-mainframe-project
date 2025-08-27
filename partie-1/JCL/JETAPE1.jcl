//API6E1   JOB (ACCT#),'SYLVAIN',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//         TIME=(0,30),MSGLEVEL=(1,1)
//***********************************************************
//* TEST LECTURE FICHIER NEWPRODS.DATA - ETAPE 1          *
//***********************************************************
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API6,
//             NOMPGM=ETAPE1
//*
//*--- COMPILATION COBOL ----------------------------------
//*
//COMPILE  EXEC IGYWCLG
//COBOL.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//LKED.SYSLMOD   DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//*
//**************************************************************
//*                EXECUTION                                   *
//**************************************************************
//STEPRUN  EXEC PGM=&NOMPGM,COND=(4,LT)
//STEPLIB  DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//NEWPRODS DD DSN=API6.PROJET.NEWPRODS.DATA,DISP=SHR
//SYSOUT   DD SYSOUT=*