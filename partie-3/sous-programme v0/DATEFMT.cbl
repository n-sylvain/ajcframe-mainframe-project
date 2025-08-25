000100  IDENTIFICATION DIVISION. 
000200  PROGRAM-ID. DATEFMT. 
000300                                                         
000400 ********************************************************
000500  ENVIRONMENT DIVISION. 
000600                                                         
000700 ********************************************************
000800  DATA DIVISION. 
000900  WORKING-STORAGE SECTION. 
000910  77 WS-CURR-DATE-21  PIC X(21). 
001000                                                         
001100  LINKAGE SECTION. 
001110  77 LS-DATE-IN       PIC X(8). 
001200  77 LS-DATE-OUT      PIC X(10). 
001300                                                         
001400 ********************************************************
001500  PROCEDURE DIVISION USING LS-DATE-IN LS-DATE-OUT. 
001510      MOVE SPACES TO LS-DATE-OUT 
001600                                                         
001610      IF LS-DATE-IN = SPACES OR LS-DATE-IN = '00000000' 
001620         MOVE FUNCTION CURRENT-DATE TO WS-CURR-DATE-21 
001630         MOVE WS-CURR-DATE-21(1:8) TO LS-DATE-OUT(1:8) 
001640      ELSE 
001650         MOVE LS-DATE-IN            TO LS-DATE-OUT(1:8) 
001651      END-IF 
001660                                                         
001900                                                         
002000      GOBACK. 