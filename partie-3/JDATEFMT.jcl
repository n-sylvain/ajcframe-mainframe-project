//API6DATE JOB (ACCT#),'SYLVAIN',CLASS=A,MSGCLASS=H, 
//             NOTIFY=&SYSUID,REGION=4M,COND=(4,LT) 
//************************************************************
//*      COMPILATION + BIND + EXECUTION DE DATEFMT (DB2)     *
//************************************************************
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API6,
//             NOMPGM=DATEFMT
//*
//APPROC   EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//*                DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.DB2(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//*TEPCOB.SYSLIB   DD DSN=&SYSUID..DB2FILES.COPY,DISP=SHR
//*
//*--- BIND DU PROGRAMME DATEFMT ----------------------------
//*
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (DATEFMT) -
       QUALIFIER (&SYSUID) -
       ACTION    (REPLACE) -
       MEMBER    (DATEFMT) -
       VALIDATE  (BIND)    -
       ISOLATION (CS)      -
       ACQUIRE   (USE)     -
       RELEASE   (COMMIT)  -
       EXPLAIN   (NO)
/*
//**************************************************************
//*                EXECUTION                                   *
//**************************************************************
//STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB  DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//SYSTSPRT DD SYSOUT=*,OUTLIM=2500
//SYSOUT   DD SYSOUT=*,OUTLIM=1000
//SYSIN    DD *
2025-08-08
/*
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(DATEFMT) PLAN(DATEFMT)
/*
