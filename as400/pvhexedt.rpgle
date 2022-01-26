      *============================================================================================*
      *                                                                            SyazwanH/040218 *
      * PVHEXEDT                                                                                   *
      * Database File Hex Editor                                                                   *
      *                                                                                            *
      * Version 1 Release 1 Modification 0                                                         *
      *                                                                                            *
      *  Compile as module. Then bind with file interface procedures APIs (PVHEXEDTU). This        *
      *   program contains unused routines for expansion in future version.                        *
      *                                                                                            *
      *  Required parameters:                                                                      *
      *     File name "pFil" (Char 10) - Valid file name.                                          *
      *     Library name "pLib" (Char 10) - Valid library name.                                    *
      *     Member name "pMbr" (Char 10) - Valid member name OR '*FIRST'.                          *
      *     Mode "pMod" (Char 1) - '1' or '2'.                                                     *
      *                                                                                            *
      *  Parameters description:                                                                   *
      *     pFil - Origin file to read as input.                                                   *
      *     pLib - Library name of origin file.                                                    *
      *     pMbr - Member name of origin file.                                                     *
      *     pMod - Language mode.                                                                  *
      *                                                                                            *
      *============================================================================================*
      * Maintenance Log                                                                            *
      * ---------------                                                                            *
      * Trace  Date      Pgmr.     Notes                                                           *
      * ------------------------------------------------------------------------------------------ *
      *        20040218  SyazwanH  New.                                                            *
      *============================================================================================*
      *---------------------------------------------------------------------------------------------
      * Compiler options
      *---------------------------------------------------------------------------------------------
      *
     HAltSeq(*None)
      *
      *---------------------------------------------------------------------------------------------
      * Files declaration
      *---------------------------------------------------------------------------------------------
      *
     FPvhexedtd CF   E             WorkStn UsrOpn
     F                                     InfDs(Keys)
      *
      *---------------------------------------------------------------------------------------------
      * External procedures
      *---------------------------------------------------------------------------------------------
      *
     D OpenFile        Pr                  ExtProc('pvOpenFile')
     D  FilNamPtr                      *   Const
     D  LibNamPtr                      *   Const
     D  MbrNamPtr                      *   Const
     D  NRec                         10I 0
     D  RecSz                        10I 0
     D  RsnCode                      10I 0
      *
     D ReadFirst       Pr                  ExtProc('pvReadFirst')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadSame        Pr                  ExtProc('pvReadSame')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadNext        Pr                  ExtProc('pvReadNext')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadPrev        Pr                  ExtProc('pvReadPrev')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadLast        Pr                  ExtProc('pvReadLast')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadRrn         Pr                  ExtProc('pvReadRrn')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D UpdateRec       Pr                  ExtProc('pvUpdate')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D CloseFile       Pr                  ExtProc('pvCloseFile')
     D  RsnCode                      10I 0
      *
     D RetrMbrDesc     Pr                  ExtPgm('QUSRMBRD')
     D  MbrDetl                            Like(Qusm0100)
     D  MbrDetlLen                   10I 0
     D  FmtName_2                     8A
     D  FilePath                     20A
     D  FileMbr                      10A
     D  OvrProc                       1A
     D  ErrorCode                          Like(Qusec)
      *
     D CrtUsrSpc       Pr                  ExtPgm('QUSCRTUS')
     D  UserSpace                    20A
     D  ExtendedAtr                  10A
     D  InitSize                     10I 0
     D  InitValue                     1A
     D  PubAuth                      10A
     D  Text                         50A
     D  Replace                      10A
     D  ErrorCode                          Like(Qusec)
      *
     D RtvUsrSpc       Pr                  ExtPgm('QUSRTVUS')
     D  UserSpace                    20A
     D  StrPos                       10I 0
     D  LenDta                       10I 0
     D  Receiver                   4096A
      *
     D DltUsrSpc       Pr                  ExtPgm('QUSDLTUS')
     D  UserSpace                    20A
     D  ErrorCode                          Like(Qusec)
      *
     D LstRcdFmt       Pr                  ExtPgm('QUSLRCD')
     D  FmtUsrSpc                    20A
     D  FmtFormat                    10A
     D  FmtPath                      20A
     D  FmtOverride                   1A
      *
     D LstFld          Pr                  ExtPgm('QUSLFLD')
     D  FldUsrSpc                    20A
     D  FldFormat                    10A
     D  FmtPath                      20A
     D  FmtRecord                    10A
     D  FmtOverride                   1A
      *
     D WriteToScreen   Pr            10I 0 ExtProc('QsnWrtDta')
     D  Dta                           1A
     D  DtaLen                       10I 0
     D  FldId                        10I 0
     D  Row                          10I 0
     D  Column                       10I 0
     D  StrMonoAtr                    1A
     D  EndMonoAtr                    1A
     D  StrColrAtr                    1A
     D  EndColrAtr                    1A
     D  CmdBuffHdl                   10I 0
     D  LowLEnvHdl                   10I 0
     D  ErrorCode                          Like(Qusec)
      *
     D System          Pr                  ExtPgm('QCMDEXC')
     D  ExtCmd                      512A   Options(*Varsize) Const
     D  ExtCmdLen                    15P 5 Const
      *
      *---------------------------------------------------------------------------------------------
      * Copybooks
      *---------------------------------------------------------------------------------------------
      *
      * Retrieve member description
     D/Copy Qsysinc/Qrpglesrc,Qusrmbrd
      * List record formats
     D/Copy Qsysinc/Qrpglesrc,Quslrcd
      * List fields
     D/Copy Qsysinc/Qrpglesrc,Quslfld
      * Error information
     D/Copy Qsysinc/Qrpglesrc,Qusec
      *
      *---------------------------------------------------------------------------------------------
      * Data structures
      *---------------------------------------------------------------------------------------------
      *
     D OffSets         Ds
     D  WOffs00                            Inz(*All'0')
     D  WOffs01                            Inz(*All'0')
     D  WOffs02                            Inz(*All'0')
     D  WOffs03                            Inz(*All'0')
     D  WOffs04                            Inz(*All'0')
     D  WOffs05                            Inz(*All'0')
     D  WOffs06                            Inz(*All'0')
     D  WOffs07                            Inz(*All'0')
     D  WOffs08                            Inz(*All'0')
     D  WOffs09                            Inz(*All'0')
     D  WOffs0A                            Inz(*All'0')
     D  WOffs0B                            Inz(*All'0')
     D  WOffs0C                            Inz(*All'0')
     D  WOffs0D                            Inz(*All'0')
     D  WOffs0E                            Inz(*All'0')
     D  OffSet                        5A   Overlay(OffSets:1) Dim(15)
      *
     D Hexes           Ds
     D  WHex0000                           Inz(*All'0')
     D  WHex0001                           Inz(*All'0')
     D  WHex0002                           Inz(*All'0')
     D  WHex0003                           Inz(*All'0')
     D  WHex0004                           Inz(*All'0')
     D  WHex0005                           Inz(*All'0')
     D  WHex0006                           Inz(*All'0')
     D  WHex0007                           Inz(*All'0')
     D  WHex0008                           Inz(*All'0')
     D  WHex0009                           Inz(*All'0')
     D  WHex000A                           Inz(*All'0')
     D  WHex000B                           Inz(*All'0')
     D  WHex000C                           Inz(*All'0')
     D  WHex000D                           Inz(*All'0')
     D  WHex000E                           Inz(*All'0')
     D  WHex000F                           Inz(*All'0')
     D  WHex0100                           Inz(*All'0')
     D  WHex0101                           Inz(*All'0')
     D  WHex0102                           Inz(*All'0')
     D  WHex0103                           Inz(*All'0')
     D  WHex0104                           Inz(*All'0')
     D  WHex0105                           Inz(*All'0')
     D  WHex0106                           Inz(*All'0')
     D  WHex0107                           Inz(*All'0')
     D  WHex0108                           Inz(*All'0')
     D  WHex0109                           Inz(*All'0')
     D  WHex010A                           Inz(*All'0')
     D  WHex010B                           Inz(*All'0')
     D  WHex010C                           Inz(*All'0')
     D  WHex010D                           Inz(*All'0')
     D  WHex010E                           Inz(*All'0')
     D  WHex010F                           Inz(*All'0')
     D  WHex0200                           Inz(*All'0')
     D  WHex0201                           Inz(*All'0')
     D  WHex0202                           Inz(*All'0')
     D  WHex0203                           Inz(*All'0')
     D  WHex0204                           Inz(*All'0')
     D  WHex0205                           Inz(*All'0')
     D  WHex0206                           Inz(*All'0')
     D  WHex0207                           Inz(*All'0')
     D  WHex0208                           Inz(*All'0')
     D  WHex0209                           Inz(*All'0')
     D  WHex020A                           Inz(*All'0')
     D  WHex020B                           Inz(*All'0')
     D  WHex020C                           Inz(*All'0')
     D  WHex020D                           Inz(*All'0')
     D  WHex020E                           Inz(*All'0')
     D  WHex020F                           Inz(*All'0')
     D  WHex0300                           Inz(*All'0')
     D  WHex0301                           Inz(*All'0')
     D  WHex0302                           Inz(*All'0')
     D  WHex0303                           Inz(*All'0')
     D  WHex0304                           Inz(*All'0')
     D  WHex0305                           Inz(*All'0')
     D  WHex0306                           Inz(*All'0')
     D  WHex0307                           Inz(*All'0')
     D  WHex0308                           Inz(*All'0')
     D  WHex0309                           Inz(*All'0')
     D  WHex030A                           Inz(*All'0')
     D  WHex030B                           Inz(*All'0')
     D  WHex030C                           Inz(*All'0')
     D  WHex030D                           Inz(*All'0')
     D  WHex030E                           Inz(*All'0')
     D  WHex030F                           Inz(*All'0')
     D  WHex0400                           Inz(*All'0')
     D  WHex0401                           Inz(*All'0')
     D  WHex0402                           Inz(*All'0')
     D  WHex0403                           Inz(*All'0')
     D  WHex0404                           Inz(*All'0')
     D  WHex0405                           Inz(*All'0')
     D  WHex0406                           Inz(*All'0')
     D  WHex0407                           Inz(*All'0')
     D  WHex0408                           Inz(*All'0')
     D  WHex0409                           Inz(*All'0')
     D  WHex040A                           Inz(*All'0')
     D  WHex040B                           Inz(*All'0')
     D  WHex040C                           Inz(*All'0')
     D  WHex040D                           Inz(*All'0')
     D  WHex040E                           Inz(*All'0')
     D  WHex040F                           Inz(*All'0')
     D  WHex0500                           Inz(*All'0')
     D  WHex0501                           Inz(*All'0')
     D  WHex0502                           Inz(*All'0')
     D  WHex0503                           Inz(*All'0')
     D  WHex0504                           Inz(*All'0')
     D  WHex0505                           Inz(*All'0')
     D  WHex0506                           Inz(*All'0')
     D  WHex0507                           Inz(*All'0')
     D  WHex0508                           Inz(*All'0')
     D  WHex0509                           Inz(*All'0')
     D  WHex050A                           Inz(*All'0')
     D  WHex050B                           Inz(*All'0')
     D  WHex050C                           Inz(*All'0')
     D  WHex050D                           Inz(*All'0')
     D  WHex050E                           Inz(*All'0')
     D  WHex050F                           Inz(*All'0')
     D  WHex0600                           Inz(*All'0')
     D  WHex0601                           Inz(*All'0')
     D  WHex0602                           Inz(*All'0')
     D  WHex0603                           Inz(*All'0')
     D  WHex0604                           Inz(*All'0')
     D  WHex0605                           Inz(*All'0')
     D  WHex0606                           Inz(*All'0')
     D  WHex0607                           Inz(*All'0')
     D  WHex0608                           Inz(*All'0')
     D  WHex0609                           Inz(*All'0')
     D  WHex060A                           Inz(*All'0')
     D  WHex060B                           Inz(*All'0')
     D  WHex060C                           Inz(*All'0')
     D  WHex060D                           Inz(*All'0')
     D  WHex060E                           Inz(*All'0')
     D  WHex060F                           Inz(*All'0')
     D  WHex0700                           Inz(*All'0')
     D  WHex0701                           Inz(*All'0')
     D  WHex0702                           Inz(*All'0')
     D  WHex0703                           Inz(*All'0')
     D  WHex0704                           Inz(*All'0')
     D  WHex0705                           Inz(*All'0')
     D  WHex0706                           Inz(*All'0')
     D  WHex0707                           Inz(*All'0')
     D  WHex0708                           Inz(*All'0')
     D  WHex0709                           Inz(*All'0')
     D  WHex070A                           Inz(*All'0')
     D  WHex070B                           Inz(*All'0')
     D  WHex070C                           Inz(*All'0')
     D  WHex070D                           Inz(*All'0')
     D  WHex070E                           Inz(*All'0')
     D  WHex070F                           Inz(*All'0')
     D  WHex0800                           Inz(*All'0')
     D  WHex0801                           Inz(*All'0')
     D  WHex0802                           Inz(*All'0')
     D  WHex0803                           Inz(*All'0')
     D  WHex0804                           Inz(*All'0')
     D  WHex0805                           Inz(*All'0')
     D  WHex0806                           Inz(*All'0')
     D  WHex0807                           Inz(*All'0')
     D  WHex0808                           Inz(*All'0')
     D  WHex0809                           Inz(*All'0')
     D  WHex080A                           Inz(*All'0')
     D  WHex080B                           Inz(*All'0')
     D  WHex080C                           Inz(*All'0')
     D  WHex080D                           Inz(*All'0')
     D  WHex080E                           Inz(*All'0')
     D  WHex080F                           Inz(*All'0')
     D  WHex0900                           Inz(*All'0')
     D  WHex0901                           Inz(*All'0')
     D  WHex0902                           Inz(*All'0')
     D  WHex0903                           Inz(*All'0')
     D  WHex0904                           Inz(*All'0')
     D  WHex0905                           Inz(*All'0')
     D  WHex0906                           Inz(*All'0')
     D  WHex0907                           Inz(*All'0')
     D  WHex0908                           Inz(*All'0')
     D  WHex0909                           Inz(*All'0')
     D  WHex090A                           Inz(*All'0')
     D  WHex090B                           Inz(*All'0')
     D  WHex090C                           Inz(*All'0')
     D  WHex090D                           Inz(*All'0')
     D  WHex090E                           Inz(*All'0')
     D  WHex090F                           Inz(*All'0')
     D  WHex0A00                           Inz(*All'0')
     D  WHex0A01                           Inz(*All'0')
     D  WHex0A02                           Inz(*All'0')
     D  WHex0A03                           Inz(*All'0')
     D  WHex0A04                           Inz(*All'0')
     D  WHex0A05                           Inz(*All'0')
     D  WHex0A06                           Inz(*All'0')
     D  WHex0A07                           Inz(*All'0')
     D  WHex0A08                           Inz(*All'0')
     D  WHex0A09                           Inz(*All'0')
     D  WHex0A0A                           Inz(*All'0')
     D  WHex0A0B                           Inz(*All'0')
     D  WHex0A0C                           Inz(*All'0')
     D  WHex0A0D                           Inz(*All'0')
     D  WHex0A0E                           Inz(*All'0')
     D  WHex0A0F                           Inz(*All'0')
     D  WHex0B00                           Inz(*All'0')
     D  WHex0B01                           Inz(*All'0')
     D  WHex0B02                           Inz(*All'0')
     D  WHex0B03                           Inz(*All'0')
     D  WHex0B04                           Inz(*All'0')
     D  WHex0B05                           Inz(*All'0')
     D  WHex0B06                           Inz(*All'0')
     D  WHex0B07                           Inz(*All'0')
     D  WHex0B08                           Inz(*All'0')
     D  WHex0B09                           Inz(*All'0')
     D  WHex0B0A                           Inz(*All'0')
     D  WHex0B0B                           Inz(*All'0')
     D  WHex0B0C                           Inz(*All'0')
     D  WHex0B0D                           Inz(*All'0')
     D  WHex0B0E                           Inz(*All'0')
     D  WHex0B0F                           Inz(*All'0')
     D  WHex0C00                           Inz(*All'0')
     D  WHex0C01                           Inz(*All'0')
     D  WHex0C02                           Inz(*All'0')
     D  WHex0C03                           Inz(*All'0')
     D  WHex0C04                           Inz(*All'0')
     D  WHex0C05                           Inz(*All'0')
     D  WHex0C06                           Inz(*All'0')
     D  WHex0C07                           Inz(*All'0')
     D  WHex0C08                           Inz(*All'0')
     D  WHex0C09                           Inz(*All'0')
     D  WHex0C0A                           Inz(*All'0')
     D  WHex0C0B                           Inz(*All'0')
     D  WHex0C0C                           Inz(*All'0')
     D  WHex0C0D                           Inz(*All'0')
     D  WHex0C0E                           Inz(*All'0')
     D  WHex0C0F                           Inz(*All'0')
     D  WHex0D00                           Inz(*All'0')
     D  WHex0D01                           Inz(*All'0')
     D  WHex0D02                           Inz(*All'0')
     D  WHex0D03                           Inz(*All'0')
     D  WHex0D04                           Inz(*All'0')
     D  WHex0D05                           Inz(*All'0')
     D  WHex0D06                           Inz(*All'0')
     D  WHex0D07                           Inz(*All'0')
     D  WHex0D08                           Inz(*All'0')
     D  WHex0D09                           Inz(*All'0')
     D  WHex0D0A                           Inz(*All'0')
     D  WHex0D0B                           Inz(*All'0')
     D  WHex0D0C                           Inz(*All'0')
     D  WHex0D0D                           Inz(*All'0')
     D  WHex0D0E                           Inz(*All'0')
     D  WHex0D0F                           Inz(*All'0')
     D  WHex0E00                           Inz(*All'0')
     D  WHex0E01                           Inz(*All'0')
     D  WHex0E02                           Inz(*All'0')
     D  WHex0E03                           Inz(*All'0')
     D  WHex0E04                           Inz(*All'0')
     D  WHex0E05                           Inz(*All'0')
     D  WHex0E06                           Inz(*All'0')
     D  WHex0E07                           Inz(*All'0')
     D  WHex0E08                           Inz(*All'0')
     D  WHex0E09                           Inz(*All'0')
     D  WHex0E0A                           Inz(*All'0')
     D  WHex0E0B                           Inz(*All'0')
     D  WHex0E0C                           Inz(*All'0')
     D  WHex0E0D                           Inz(*All'0')
     D  WHex0E0E                           Inz(*All'0')
     D  WHex0E0F                           Inz(*All'0')
     D  Hex                           2A   Overlay(Hexes:1) Dim(240)
      *
     D Buffers         Ds
     D  WStr00                             Inz(*AllX'40')
     D  WStr01                             Inz(*AllX'40')
     D  WStr02                             Inz(*AllX'40')
     D  WStr03                             Inz(*AllX'40')
     D  WStr04                             Inz(*AllX'40')
     D  WStr05                             Inz(*AllX'40')
     D  WStr06                             Inz(*AllX'40')
     D  WStr07                             Inz(*AllX'40')
     D  WStr08                             Inz(*AllX'40')
     D  WStr09                             Inz(*AllX'40')
     D  WStr0A                             Inz(*AllX'40')
     D  WStr0B                             Inz(*AllX'40')
     D  WStr0C                             Inz(*AllX'40')
     D  WStr0D                             Inz(*AllX'40')
     D  WStr0E                             Inz(*AllX'40')
     D  Buffer                       16A   Overlay(Buffers:1) Dim(15)
      *
     D Keys            Ds
     D  FncKey               369    369A
      *
     D FmtUsrSpc       Ds            20    Qualified
     D  Name                   1     10A   Inz('PVRCDFMT')
     D  Library               11     20A   Inz('QTEMP')
      *
     D FldUsrSpc       Ds            20    Qualified
     D  Name                   1     10A   Inz('PVFLD')
     D  Library               11     20A   Inz('QTEMP')
      *
     D FilePath        Ds            20    Qualified
     D  Name                   1     10A   Inz(*Blanks)
     D  Library               11     20A   Inz(*Blanks)
      *
     D FmtPath         Ds            20    Qualified
     D  Name                   1     10A
     D  Library               11     20A
      *
     D Rcv             Ds            16    Qualified
     D  OffSet                 1      4B 0
     D  NoEntr                 9     12B 0
     D  LstSiz                13     16B 0
      *
     D FldInf          Ds            10    Qualified Occurs(512)
     D  Typ                    1      1A
     D  Len                    2      5B 0
     D  Pos                    6      9B 0
     D  Rsv                   10     10A
      *
     D ValueHex        Ds
     D  ValueChar1                    1A   Inz(*Blanks)
     D  ValueChar2                    1A   Inz(*Blanks)
      *
     D IntDs           Ds
     D  IntNum                        5I 0 Inz(*Zeros)
     D  IntChar                       1A   Overlay(IntNum:2)
     D  IntNum2                      10I 0 Inz(*Zeros)
     D  IntChar2                      3A   Overlay(IntNum2:2)
      *
      *---------------------------------------------------------------------------------------------
      * Variables and standalone fields
      *---------------------------------------------------------------------------------------------
      *
     D pFil            S             10A
     D pLib            S             10A
     D pMbr            S             10A
     D pMod            S             10A
      *
     D MsgBuffPtr      S               *   Inz(%Addr(MsgBuff))
     D MsgBuff         S          32767A   Inz(*Blanks)
     D MsgBuffSz       S             10I 0 Inz(%Size(MsgBuff))
     D RtnSz           S             10I 0 Inz(*Zeros)
     D Rrn             S             10I 0 Inz(*Zeros)
     D NRec            S             10I 0 Inz(*Zeros)
     D RecSz           S             10I 0 Inz(*Zeros)
     D RsnCode         S             10I 0 Inz(*Zeros)
     D ErrorCode       S                   Like(Qusec) Inz(*Blanks)
     D MbrDetl         S                   Like(Qusm0100)
     D MbrDetlLen      S             10I 0 Inz(%Size(MbrDetl))
     D FormatName      S              8A   Inz('MBRD0100')
     D FileMbr         S             10A   Inz(*Blanks)
     D OvrProc         S              1A   Inz('0')
     D ExtCmd          S            512A   Inz(*Blanks)
     D ExtCmdLen       S             15P 5 Inz(%Size(ExtCmd))
     D ExtendedAtr     S             10A   Inz('USRSPC')
     D InitSize        S             10I 0 Inz(10000)
     D InitValue       S              1A   Inz(X'00')
     D PubAuth         S             10A   Inz('*ALL')
     D Text            S             50A   Inz('Parser User Space')
     D StrPos          S             10I 0 Inz(*Zeros)
     D LenDta          S             10I 0 Inz(*Zeros)
     D Receiver        S           4096A   Inz(*Blanks)
     D Replace         S             10A   Inz('*YES')
     D FmtFormat       S             10A   Inz('RCDL0200')
     D FldFormat       S             10A   Inz('FLDL0100')
     D FmtOverride     S              1A   Inz('1')
     D FmtRecord       S             10A   Inz(*Blanks)
     D UserSpace       S             20A   Inz(*Blanks)
     D Dta             S              1A   Inz(X'0E')
     D DtaLen          S             10I 0 Inz(%Size(Dta))
     D FldId           S             10I 0 Inz(*Zeros)
     D Row             S             10I 0 Inz(*Zeros)
     D Column          S             10I 0 Inz(*Zeros)
     D StrMonoAtr      S              1A   Inz(X'00')
     D EndMonoAtr      S              1A   Inz(X'00')
     D StrColrAtr      S              1A   Inz(X'00')
     D EndColrAtr      S              1A   Inz(X'00')
     D CmdBuffHdl      S             10I 0 Inz(*Zeros)
     D LowLEnvHdl      S             10I 0 Inz(*Zeros)
     D RtnCode         S             10I 0 Inz(*Zeros)
      *
     D WrkBuff         S          32767A   Inz(*Blanks)
     D HexImage        S                   Like(Hexes) Inz(*Blanks)
     D BufferImage     S                   Like(Buffers) Inz(*Blanks)
      *
     D QEndOfFile      S              1N   Inz(*Off)
     D QEndOfPgm       S              1N   Inz(*Off)
     D QError          S              1N   Inz(*Off)
      *
     D Nn              S             10I 0 Inz(*Zeros)
     D Yy              S             10I 0 Inz(*Zeros)
     D FldInfN         S             10I 0 Inz(*Zeros)
      *
     D Remainder       S             10I 0 Inz(*Zeros)
     D MaxLine         S             10I 0 Inz(*Zeros)
     D MaxPage         S             10I 0 Inz(*Zeros)
     D MaxPos          S             10I 0 Inz(*Zeros)
     D CurrentLine     S             10I 0 Inz(1)
     D CurrentPage     S             10I 0 Inz(1)
     D CurrentRecord   S             10I 0 Inz(1)
      *
     D HexInt          S             10I 0 Inz(*Zeros)
     D HexChar         S              1A   Inz(*Blanks)
     D HexCode         S              2A   Inz(*Blanks)
     D Hex1Byte        S              1A   Inz(*Blanks)
     D Hex2Byte        S              1A   Inz(*Blanks)
     D OffSetA         S             10I 0 Inz(*Zeros)
     D OffSetB         S             10I 0 Inz(*Zeros)
     D XByte           S              1A   Inz(*Blanks)
     D XNumber         S             10I 0 Inz(*Zeros)
     D XNumber1        S             10I 0 Inz(*Zeros)
     D XNumber2        S             10I 0 Inz(*Zeros)
     D HexOne          S              1A   Inz(*Blanks)
     D HexTwo          S              1A   Inz(*Blanks)
      *
      *---------------------------------------------------------------------------------------------
      * Constants
      *---------------------------------------------------------------------------------------------
      *
     D HexDigits       C                   Const('0123456789ABCDEF')
      *
      *---------------------------------------------------------------------------------------------
      * Parameters and keys list
      *---------------------------------------------------------------------------------------------
      *
     C     *Entry        Plist
     C                   Parm                    pFil
     C                   Parm                    pLib
     C                   Parm                    pMbr
     C                   Parm                    pMod
      *
      *---------------------------------------------------------------------------------------------
      * Main logic
      *---------------------------------------------------------------------------------------------
      *
      /Free

       ExSr SrOpenFile;
       If (QError = *Off);

         MaxLine = %Div(RecSz:16);
         Remainder = %Rem(RecSz:16);
         If (Remainder > *Zeros);
            MaxLine += 1;
         EndIf;

         MaxPage = %Div(MaxLine:15);
         Remainder = %Rem(MaxLine:15);
         If (Remainder > *Zeros);
            MaxPage += 1;
         EndIf;

         MaxPos = RecSz;

         WPath = %Trim(FilePath.Library) + '/' +
                 %Trim(FilePath.Name) + '(' +
                 %Trim(FileMbr) + ')';
         WRecAll = NRec;

          ExSr SrReadFirst;
          If (QEndOfFile = *Off);
             DoW (QEndOfPgm = *Off);

                ExSr SrConstruct;

                If (CurrentLine = MaxLine);
                   WRmk = ' Bottom';
                Else;
                   WRmk ='More...';
                EndIf;
                WRecCur = CurrentRecord;
                Exfmt D01;

                Select;
                   When (*In03 = *On);
                      ExSr SrSync;
                      If (WrkBuff <> MsgBuff);
                         ExSr SrUpdate;
                      EndIf;
                      QEndOfPgm = *On;
                   When (*In12 = *On);
                      QEndOfPgm = *On;
                   When (*In07 = *On);
                      ExSr SrSync;
                      If (WrkBuff <> MsgBuff);
                         ExSr SrUpdate;
                      EndIf;
                      If ((CurrentRecord - 1) > *Zeros);
                         ExSr SrReadPrev;
                         CurrentRecord -= 1;
                      Else;
                         ExSr SrReadLast;
                         CurrentRecord = NRec;
                      EndIf;
                   When (*In08 = *On);
                      ExSr SrSync;
                      If (WrkBuff <> MsgBuff);
                         ExSr SrUpdate;
                      EndIf;
                      If ((CurrentRecord + 1) <= NRec);
                         ExSr SrReadNext;
                         CurrentRecord += 1;
                      Else;
                         ExSr SrReadFirst;
                         CurrentRecord = 1;
                      EndIf;
                   When (*In05 = *On);
                      ExSr SrReadSame;
                   When (*In10 = *On) Or (FncKey = X'F1');
                      If (WRecCur <> CurrentRecord) And
                         (WRecCur > *Zeros) And (WRecCur <= NRec);
                         Rrn = WRecCur;
                         ExSr SrReadRrn;
                         If (QEndOfFile = *On);
                            Rrn = CurrentRecord;
                            ExSr SrReadRrn;
                         Else;
                            CurrentRecord = Rrn;
                         EndIf;
                      Else;
                         ExSr SrSync;
                      EndIf;
                   When (*In21 = *On);
                      *In21 = *Off;
                      If ((CurrentLine - 1) > *Zeros);
                         CurrentLine -= 1;
                      Else;
                         CurrentLine = 1;
                      EndIf;
                   When (*In22 = *On);
                      *In22 = *Off;
                      If ((CurrentLine + 1) < MaxLine);
                         CurrentLine += 1;
                      Else;
                         CurrentLine = MaxLine;
                      EndIf;
                EndSl;

             EndDo;
          EndIf;

       EndIf;
       ExSr SrCloseFile;

       *Inlr = *On;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrConstruct
       //   Construct display
       //-------------------------------------------------------------------------------------------

         BegSr SrConstruct;

            For Nn = 1 By 1 To 15;
               IntNum2 = ((Nn + (CurrentLine - 1)) * 16) - 15;
               HexChar = %Subst(IntChar2:2:1);
               ExSr SrStringToHex;
               %Subst(OffSet(Nn):2:2) = HexCode;
               HexChar = %Subst(IntChar2:3:1);
               ExSr SrStringToHex;
               %Subst(OffSet(Nn):4:2) = HexCode;

               For Yy = 1 By 1 To 16;
                  HexChar = %Subst(WrkBuff:(((Nn + (CurrentLine - 1)) * 16 -
                            15) + (Yy - 1)):1);
                  ExSr SrStringToHex;
                  Hex(((Nn * 16) - 15) + (Yy - 1)) = HexCode;
               EndFor;

               Buffer(Nn) = %Subst(WrkBuff:((Nn + (CurrentLine - 1)) * 16 -
                            15):16);

               For Yy = 1 By 1 To 16;
                  HexChar = %Subst(Buffer(Nn):Yy:1);
                  ExSr SrStringToHex;
                  If (HexInt < 64);
                     %Subst(Buffer(Nn):Yy:1) = X'3F';
                  EndIf;
               EndFor;

               HexImage = Hexes;
               BufferImage = Buffers;
            EndFor;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrSync
       //   Synchronize values on hex column and string column
       //-------------------------------------------------------------------------------------------

         BegSr SrSync;

            Select;

               When (Hexes <> HexImage);
                  For Nn = 1 By 1 To %Elem(Hex);
                     If Hex(Nn) <> %Subst(HexImage:((Nn * 2) - 1):2);
                        HexCode = Hex(Nn);
                        ExSr SrHexToString;
                        %Subst(WrkBuff:((((CurrentLine * 16) - 15) - 1) + Nn)
                        :1) = HexChar;
                     EndIf;
                  EndFor;

               When (Buffers <> BufferImage);
                  For Nn = 1 By 1 To %Size(Buffers);
                     If (%Subst(Buffers:Nn:1) <> %Subst(BufferImage:Nn:1));
                        %Subst(WrkBuff:((((CurrentLine * 16) - 15) - 1) + Nn)
                        :1) = %Subst(Buffers:Nn:1);
                     EndIf;
                  EndFor;

            EndSl;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrLstFlds
       //   List fields
       //-------------------------------------------------------------------------------------------

         BegSr SrLstFlds;

            FmtPath.Name = pFil;
            FmtPath.Library = pLib;

            // Generate record format information
            CallP(E) LstRcdFmt (FmtUsrSpc : FmtFormat :
                                FmtPath : FmtOverride);

            UserSpace = FmtUsrSpc;

            LenDta = 16;
            StrPos = 125;
            ExSr SrRtvUsrSpc;
            Rcv = Receiver;
            StrPos = Rcv.OffSet + 1;
            LenDta = Rcv.LstSiz;
            ExSr SrRtvUsrSpc;
            QUsl020000 = Receiver;
            FmtRecord = Qusfn06;

            // Generate fields information
            CallP(E) LstFld (FldUsrSpc : FldFormat : FmtPath :
                             FmtRecord : FmtOverride);

            UserSpace = FldUsrSpc;

            LenDta = 16;
            StrPos = 125;
            ExSr SrRtvUsrSpc;
            Rcv = Receiver;
            StrPos = Rcv.OffSet + 1;
            LenDta = Rcv.LstSiz;

            Nn = 1;
            For FldInfN = 1 By 1 To Rcv.NoEntr;
               %Occur(FldInf) = FldInfn;

               ExSr SrRtvUsrSpc;
               Qusl0100 = Receiver;
               FldInf.Typ = Qusdt;
               FldInf.Len = Qusflb;
               FldInf.Pos = Nn;

               Nn += FldInf.Len;
               StrPos += Rcv.LstSiz;
            EndFor;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrCrtUsrSpc
       //   Create user space
       //-------------------------------------------------------------------------------------------

         BegSr SrCrtUsrSpc;

            // Create record format user space
            Reset Qusec;
            Qusbprv = %Size(Qusec);
            Qusbavl = *Zeros;
            ErrorCode = Qusec;

            CallP(E) CrtUsrSpc (FmtUsrSpc : ExtendedAtr : InitSize :
                                InitValue : PubAuth : Text :
                                Replace : ErrorCode);

            // Create field specifications user space
            Reset Qusec;
            Qusbprv = %Size(Qusec);
            Qusbavl = *Zeros;
            ErrorCode = Qusec;

            CallP(E) CrtUsrSpc (FldUsrSpc : ExtendedAtr : InitSize :
                                InitValue : PubAuth : Text :
                                Replace : ErrorCode);

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrRtvUsrSpc
       //   Retrieve user space
       //-------------------------------------------------------------------------------------------

         BegSr SrRtvUsrSpc;

            Receiver = *Blanks;
            CallP(E) RtvUsrSpc (UserSpace : StrPos : LenDta : Receiver);

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrDltUsrSpc
       //   Delete user space
       //-------------------------------------------------------------------------------------------

         BegSr SrDltUsrSpc;

            // Delete record format user space
            Reset Qusec;
            Qusbprv = %Size(Qusec);
            Qusbavl = *Zeros;
            ErrorCode = Qusec;

            CallP(E) DltUsrSpc (FmtUsrSpc : ErrorCode);

            // Delete field specifications user space
            Reset Qusec;
            Qusbprv = %Size(Qusec);
            Qusbavl = *Zeros;
            ErrorCode = Qusec;

            CallP(E) DltUsrSpc (FldUsrSpc : ErrorCode);

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrOpenFile
       //   Open files
       //-------------------------------------------------------------------------------------------

         BegSr SrOpenFile;

            // Open input file.
            FilePath.Name = pFil;
            FilePath.Library = pLib;
            FileMbr = pMbr;

            CallP(E) RetrMbrDesc (MbrDetl : MbrDetlLen : FormatName :
                                  FilePath : FileMbr : OvrProc :
                                  ErrorCode);

            Qusm0100 = MbrDetl;
            FilePath.Library = Qusdfill;
            FileMbr = Qusmn02;

            OpenFile (%Addr(FilePath.Name) : %Addr(FilePath.Library) :
                      %Addr(FileMbr) : NRec : RecSz : RsnCode);

            If (RsnCode > *Zeros);
               QError = *On;
            Else;
               ExSr SrCrtUsrSpc;
               ExSr SrLstFlds;
               ExSr SrDltUsrSpc;
            EndIf;

            // Open display file.
            Open Pvhexedtd;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadFirst
       //   Read first record
       //-------------------------------------------------------------------------------------------

         BegSr SrReadFirst;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                       RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadSame
       //   Read same record
       //-------------------------------------------------------------------------------------------

         BegSr SrReadSame;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadSame (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                      RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadNext
       //   Read next record
       //-------------------------------------------------------------------------------------------

         BegSr SrReadNext;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                      RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadPrev
       //   Read previous record
       //-------------------------------------------------------------------------------------------

         BegSr SrReadPrev;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                      RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadLast
       //   Read last record
       //-------------------------------------------------------------------------------------------

         BegSr SrReadLast;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadLast (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                      RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReadRrn
       //   Read record based on RRN
       //-------------------------------------------------------------------------------------------

         BegSr SrReadRrn;

            MsgBuff = *Blanks;
            MsgBuffSz = RecSz;
            ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                     RsnCode);

            If (RtnSz <= *Zeros);
               QEndOfFile = *On;
            Else;
               WrkBuff = MsgBuff;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrUpdate
       //   Update current record
       //-------------------------------------------------------------------------------------------

         BegSr SrUpdate;

            MsgBuff = WrkBuff;
            MsgBuffSz = RecSz;
            UpdateRec (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                       RsnCode);

            If (RtnSz <= *Zeros);
               QError = *On;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrCloseFile
       //   Close files
       //-------------------------------------------------------------------------------------------

         BegSr SrCloseFile;

            // Close input file.
            CloseFile(RsnCode);

            // Close display file.
            Close Pvhexedtd;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrInsSO
       //   Insert shift out to the field's control byte
       //-------------------------------------------------------------------------------------------

         BegSr SrInsSO;

            RtnCode = WriteToScreen (Dta : DtaLen : FldId : Row : Column :
                                     StrMonoAtr : EndMonoAtr : StrColrAtr :
                                     EndColrAtr : CmdBuffHdl : LowLEnvHdl :
                                     ErrorCode);

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrStringToHex
       //   Convert string to hex to integer
       //-------------------------------------------------------------------------------------------

         BegSr SrStringToHex;

            IntChar = (HexChar);
            OffSetA = (%Div(IntNum:16));
            OffSetB = (%Rem(IntNum:16));
            ValueChar1 = (%Subst(HexDigits:OffSetA+1:1));
            ValueChar2 = (%Subst(HexDigits:OffSetB+1:1));

            XByte = ValueChar1;
            ExSr SrGetNumber;
            XNumber1 = XNumber;

            XByte = ValueChar2;
            ExSr SrGetNumber;
            XNumber2 = XNumber;

            XNumber1 = (XNumber1 * 16);
            XNumber = (XNumber1 + XNumber2);

            HexInt = XNumber;
            HexCode = ValueChar1 + ValueChar2;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrGetNumber
       //   Convert number from hex values
       //-------------------------------------------------------------------------------------------

         BegSr SrGetNumber;

            Select;

               When XByte = '0';
                  XNumber = 0;

               When XByte = '1';
                  XNumber = 1;

               When XByte = '2';
                  XNumber = 2;

               When XByte = '3';
                  XNumber = 3;

               When XByte = '4';
                  XNumber = 4;

               When XByte = '5';
                  XNumber = 5;

               When XByte = '6';
                  XNumber = 6;

               When XByte = '7';
                  XNumber = 7;

               When XByte = '8';
                  XNumber = 8;

               When XByte = '9';
                  XNumber = 9;

               When XByte = 'A';
                  XNumber = 10;

               When XByte = 'B';
                  XNumber = 11;

               When XByte = 'C';
                  XNumber = 12;

               When XByte = 'D';
                  XNumber = 13;

               When XByte = 'E';
                  XNumber = 14;

               When XByte = 'F';
                  XNumber = 15;

            EndSl;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrHexToString
       //   Convert hex to string
       //-------------------------------------------------------------------------------------------

         BegSr SrHexToString;

            HexOne = %Subst(HexCode:1:1);
            HexTwo = %Subst(HexCode:2:1);

            If (HexTwo >= '0' And HexTwo <= '9' Or HexTwo = ' ');
               HexChar = HexTwo;
            Else;
      /End-Free
     C                   BitOff    '4567'        HexChar
     C                   Select
     C                   When      (HexTwo = 'A')
     C                   BitOn     '46'          HexChar
     C                   When      (HexTwo = 'B')
     C                   BitOn     '467'         HexChar
     C                   When      (HexTwo = 'C')
     C                   BitOn     '45'          HexChar
     C                   When      (HexTwo = 'D')
     C                   BitOn     '457'         HexChar
     C                   When      (HexTwo = 'E')
     C                   BitOn     '456'         HexChar
     C                   When      (HexTwo = 'F')
     C                   BitOn     '4567'        HexChar
     C                   EndSl
      /Free
            EndIf;

            If (HexOne = ' ');
               HexChar = *Blanks;
            Else;
      /End-Free
     C                   BitOff    '0123'        HexChar
     C                   Select
     C                   When      (HexOne = '1')
     C                   BitOn     '3'           HexChar
     C                   When      (HexOne = '2')
     C                   BitOn     '2'           HexChar
     C                   When      (HexOne = '3')
     C                   BitOn     '23'          HexChar
     C                   When      (HexOne = '4')
     C                   BitOn     '1'           HexChar
     C                   When      (HexOne = '5')
     C                   BitOn     '13'          HexChar
     C                   When      (HexOne = '6')
     C                   BitOn     '12'          HexChar
     C                   When      (HexOne = '7')
     C                   BitOn     '123'         HexChar
     C                   When      (HexOne = '8')
     C                   BitOn     '0'           HexChar
     C                   When      (HexOne = '9')
     C                   BitOn     '03'          HexChar
     C                   When      (HexOne = 'A')
     C                   BitOn     '02'          HexChar
     C                   When      (HexOne = 'B')
     C                   BitOn     '023'         HexChar
     C                   When      (HexOne = 'C')
     C                   BitOn     '01'          HexChar
     C                   When      (HexOne = 'D')
     C                   BitOn     '013'         HexChar
     C                   When      (HexOne = 'E')
     C                   BitOn     '012'         HexChar
     C                   When      (HexOne = 'F')
     C                   BitOn     '0123'        HexChar
     C                   EndSl
      /Free
            EndIf;

         EndSr;

      /End-Free
      *
