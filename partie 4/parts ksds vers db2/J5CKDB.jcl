//API4KD   JOB (ACCT#),'COMPDB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//       TIME=(0,30),MSGLEVEL=(1,1)
//***********************************************************
//*  ====> JCL D'APPEL DE LA PROCEDURE COMPDB2  BATCH       *
//*                                                         *
//*  ====> COMPIL COBOL/DB2 + BIND   (BATCH)                *
//*        =======================   *******                *
//*        REMPLACER API? PAR VOTRE USER TSO                *
//*           ? : Nì DU GROUPE,  $ : N¢ DU PROGRAMME        *
//*                  API?DB$ PAR LE NOM DU PROGRAMME        *
//*                                                         *
//***********************************************************
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API4,
//             NOMPGM=K5DB2
//*
//APPROC   EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//*                DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.DB2(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//*TEPCOB.SYSLIB   DD DSN=&SYSUID..DB2FILES.COPY,DISP=SHR
//*
//*--- ETAPE DE BIND --------------------------------------
//*
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (K5DB2) -
       QUALIFIER (API4)    -
       ACTION    (REPLACE) -
       MEMBER    (K5DB2) -
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
//STEPLIB  DD DSN=&SYSUID..SOURCE.LOAD,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=2500
//SYSOUT   DD  SYSOUT=*,OUTLIM=1000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(K5DB2) PLAN(K5DB2)
/*
//FPARTK   DD DSN=&SYSUID..PROJET.NEWPARTS.KSDS,DISP=SHR
