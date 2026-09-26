/****** Object:  View [dbo].[SOL_ALERTB1_LAYOUT_PAGO_EFECTUADOB1SLQuery]    Script Date: 26/09/2026 06:21:54 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SOL_ALERTB1_LAYOUT_PAGO_EFECTUADOB1SLQuery] AS
/* ============================================================================== */
/* TITULO 1: SELECT PRINCIPAL Y AGRUPACIÓN DE TOTALES (CON ALIAS DESCRIPTIVOS)    */
/* Objetivo: Sumarizar retenciones, traer datos de cheques, bancos y proveedores  */
/* ============================================================================== */
SELECT 
    TA."EntryPag" AS "DocEntry", 
    TA."DocDate" AS "FechaPago", 
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."DocTotal" ELSE TA."DocTotalFC" END, 2) AS "TotalPago", 
    TA."CardName" AS "Proveedor", 
    TA."DocNum" AS "DocNum", 
    TA."DocCurr" AS "Moneda",
    T4."LicTradNum" AS "NITProveedor", 
    TA."Comments" AS "Comentarios", 
    TA."TrsfrAcct" AS "CuentaTransferencia", 
    TA."CUENTA" AS "NombreCuentaTransf", 
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."TrsfrSum" ELSE TA."TrsfrSumFC" END, 2) AS "ValorTransferencia", 
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."BaseICA" ELSE TA."BaseICA" END, 2)) AS "BaseRetencionICA", 
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."RetICA" ELSE TA."RetICAFC"  END, 2)) AS "ValorRetencionICA",
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."BaseIVA" ELSE TA."BaseIVA" END, 2)) AS "BaseRetencionIVA", 
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."RetIVA" ELSE TA."RetIVAFC"  END, 2)) AS "ValorRetencionIVA",
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."BaseFTE" ELSE TA."BaseFTE" END, 2)) AS "BaseRetencionFTE", 
    SUM(ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."RetFTE" ELSE TA."RetFTEFC"  END, 2)) AS "ValorRetencionFTE",
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."BfNetDcnt" ELSE TA."BfNetDcntF"  END, 2) AS "TotalAntesDcto", 
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."BfDcntSum" ELSE TA."BfDcntSumF"  END, 2) AS "DescuentoBase", 
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."SumApplied" ELSE  TA."AppliedFC"  END, 2) AS "ValorAplicado", 
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."DcntSum" ELSE TA."DcntSumFC" END, 2) AS "SumaDescuento", 
    T5."U_NAME" AS "UsuarioCreador", 
    TA."TransId" AS "TransID", 
    TA."DocEntry" AS "EntryDocumentoBase", 
    T11."TransRef" AS "ReferenciaCheque",  
    T11."BankNum" AS "CodigoBancoCheque", 
    T13."BankName" AS "NombreBancoCheque", 
    T11."AcctNum" AS "NumCuentaCheque", 
    T11."Branch" AS "SucursalCheque", 
    T11."CheckNum" AS "NumeroCheque", 
    T11."VendorName" AS "ProveedorCheque", 
    T14."PrintHeadr" AS "NombreSociedad", 
    T14."RevOffice" AS "OficinaImpuestos", 
    T11."CheckDate" AS "FechaCheque", 
    T11."TotalWords" AS "TotalenLetras", 
    TA."DocPag" AS "DocNumPagado",
    ROUND(CASE WHEN ISNULL(TA."DocRate", 0) = 0 THEN TA."VatSum" ELSE TA."VatSum" / TA."DocRate" END, 2) AS "TotalIVA", 
    TA."ObjType" AS "TipoObjetoBase",  
    TA."DocCur" AS "MonedaBase",
    T14."CompnyAddr" AS "DireccionEmpresa", 
    T14."Phone1" AS "TelefonoEmpresa1",
    '1' AS "ID"

FROM (

    /* ============================================================================== */
    /* TITULO 2: PAGOS APLICADOS A FACTURAS DE PROVEEDORES (OPCH / ObjType 18)        */
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", T7."DocEntry" AS "Entry_Fact", T0."DocCurr",
        T7."NumAtCard" AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", T0."UserSign",
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        T2."DocEntry" AS "FAC", T2."BfNetDcnt", T2."BfNetDcntF", T2."BfDcntSum", T2."BfDcntSumF",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."U_HBT_BaseRet" ELSE 0.00 END AS "BaseICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmnt" ELSE 0.00 END AS "RetICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetICAFC",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmnt" ELSE 0.00 END AS "RetIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetIVAFC",        
        CASE T10."U_HBT_TipRet" WHEN '4' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmnt" ELSE 0.00 END AS "RetFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetFTEFC",
        T0."TransId", T0."DocEntry", T2."SumApplied", T2."AppliedFC", T2."DcntSum", T2."DcntSumFC", T7."VatSum", T7."ObjType", T7."DocCur", T0."DocRate", T0."SysRate", T2."WtInvCatS"
    FROM OVPM T0  
    INNER JOIN VPM2 T2 ON T0."DocEntry" = T2."DocNum" 
    INNER JOIN OPCH T7 ON T2."DocEntry" = T7."DocEntry" AND T2."InvType" = T7."ObjType" AND T7."ObjType"=18
    LEFT JOIN PCH1 T8 ON T7."DocEntry" = T8."DocEntry" 
    LEFT JOIN PCH5 T9 ON T8."DocEntry" = T9."AbsEntry" 
    LEFT JOIN OWHT T10 ON T9."WTCode" = T10."WTCode"

    UNION ALL

    /* ============================================================================== */
    /* TITULO 3: PAGOS APLICADOS A NOTAS DE CRÉDITO DE PROVEEDORES (ORPC / ObjType 19)*/
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", T7."DocEntry" AS "Entry_Fact", T0."DocCurr",
        T7."NumAtCard" AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", T0."UserSign",
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        T2."DocEntry" AS "FAC", T2."BfNetDcnt", T2."BfNetDcntF", T2."BfDcntSum", T2."BfDcntSumF", 
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."U_HBT_BaseRet" ELSE 0.00 END AS "BaseICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmnt" ELSE 0.00 END AS "RetICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetICAFC",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmnt" ELSE 0.00 END AS "RetIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetIVAFC",        
        CASE T10."U_HBT_TipRet" WHEN '4' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmnt" ELSE 0.00 END AS "RetFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetFTEFC",
        T0."TransId", T0."DocEntry", T2."SumApplied", T2."AppliedFC", T2."DcntSum", T2."DcntSum", T7."VatSum", T7."ObjType", T7."DocCur", T0."DocRate", T0."SysRate", T2."WtInvCatS"
    FROM OVPM T0  
    INNER JOIN VPM2 T2 ON T0."DocEntry" = T2."DocNum" 
    INNER JOIN ORPC T7 ON T2."DocEntry" = T7."DocEntry" AND T2."InvType" = T7."ObjType" AND T7."ObjType"=19
    LEFT JOIN RPC1 T8 ON T7."DocEntry" = T8."DocEntry" 
    LEFT JOIN RPC5 T9 ON T8."DocEntry" = T9."AbsEntry" 
    LEFT JOIN OWHT T10 ON T9."WTCode" = T10."WTCode"

    UNION ALL

    /* ============================================================================== */
    /* TITULO 4: PAGOS APLICADOS A ANTICIPOS DE PROVEEDORES (ODPO / ObjType 204)      */
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", T7."DocEntry" AS "Entry_Fact", T0."DocCurr",
        T7."NumAtCard" AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", T0."UserSign",
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        T2."DocEntry" AS "FAC", T2."BfNetDcnt", T2."BfNetDcntF", T2."BfDcntSum", T2."BfDcntSumF",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."U_HBT_BaseRet" ELSE 0.00 END AS "BaseICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmnt" ELSE 0.00 END AS "RetICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetICAFC",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmnt" ELSE 0.00 END AS "RetIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetIVAFC",        
        CASE T10."U_HBT_TipRet" WHEN '4' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmnt" ELSE 0.00 END AS "RetFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetFTEFC",
        T0."TransId", T0."DocEntry", T2."SumApplied", T2."AppliedFC", T2."DcntSum", T2."DcntSum", T7."VatSum", T7."ObjType", T7."DocCur", T0."DocRate", T0."SysRate", T2."WtInvCatS"
    FROM OVPM T0  
    INNER JOIN VPM2 T2 ON T0."DocEntry" = T2."DocNum" 
    INNER JOIN ODPO T7 ON T7."DocEntry" = T2."DocEntry" AND T2."InvType" = T7."ObjType" AND T7."ObjType"=204
    LEFT JOIN DPO1 T8 ON T7."DocEntry" = T8."DocEntry" 
    LEFT JOIN DPO5 T9 ON T7."DocEntry" = T9."AbsEntry" 
    LEFT JOIN OWHT T10 ON T9."WTCode" = T10."WTCode"

    UNION ALL

    /* ============================================================================== */
    /* TITULO 5: PAGOS APLICADOS A NOTAS DE CRÉDITO DE CLIENTES (ORIN / ObjType 14)   */
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", T7."DocEntry" AS "Entry_Fact", T0."DocCurr",
        T7."NumAtCard" AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", T0."UserSign",
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        T2."DocEntry" AS "FAC", T2."BfNetDcnt", T2."BfNetDcntF", T2."BfDcntSum", T2."BfDcntSumF",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."U_HBT_BaseRet" ELSE 0.00 END AS "BaseICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmnt" ELSE 0.00 END AS "RetICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetICAFC",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmnt" ELSE 0.00 END AS "RetIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetIVAFC",        
        CASE T10."U_HBT_TipRet" WHEN '4' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmnt" ELSE 0.00 END AS "RetFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetFTEFC",
        T0."TransId", T0."DocEntry", T2."SumApplied", T2."AppliedFC", T2."DcntSum", T2."DcntSum", T7."VatSum", T7."ObjType", T7."DocCur", T0."DocRate", T0."SysRate", T2."WtInvCatS"
    FROM OVPM T0  
    INNER JOIN VPM2 T2 ON T0."DocEntry" = T2."DocNum" 
    INNER JOIN ORIN T7 ON T2."DocEntry" = T7."DocEntry" AND T2."InvType" = T7."ObjType" AND T7."ObjType"=14
    LEFT JOIN RIN1 T8 ON T7."DocEntry" = T8."DocEntry" 
    LEFT JOIN RIN5 T9 ON T8."DocEntry" = T9."AbsEntry" 
    LEFT JOIN OWHT T10 ON T9."WTCode" = T10."WTCode"

    UNION ALL

    /* ============================================================================== */
    /* TITULO 6: PAGOS APLICADOS A ASIENTOS MANUALES / DIARIO (OJDT / ObjType 30)     */
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", T7."TransId" AS "Entry_Fact", T0."DocCurr",
        CAST(T7."TransId" AS VARCHAR(50)) AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", T0."UserSign", 
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        T2."DocEntry" AS "FAC", T2."BfNetDcnt", T2."BfNetDcntF", T2."BfDcntSum", T2."BfDcntSumF",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."U_HBT_BaseRet" ELSE 0.00 END AS "BaseICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmnt" ELSE 0.00 END AS "RetICA",
        CASE T10."U_HBT_TipRet" WHEN '1' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetICAFC",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmnt" ELSE 0.00 END AS "RetIVA",
        CASE T10."U_HBT_TipRet" WHEN '2' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetIVAFC",        
        CASE T10."U_HBT_TipRet" WHEN '4' THEN "U_HBT_BaseRet" ELSE 0.00 END AS "BaseFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmnt" ELSE 0.00 END AS "RetFTE",
        CASE T10."U_HBT_TipRet" WHEN '4' THEN T9."WTAmntFC" ELSE 0.00 END AS "RetFTEFC",
        T0."TransId", T0."DocEntry", T2."SumApplied", T2."AppliedFC", T2."DcntSum", T2."DcntSum", 0.00, T7."ObjType", '', T0."DocRate", T0."SysRate", T2."WtInvCatS"
    FROM OVPM T0  
    INNER JOIN VPM2 T2 ON T0."DocEntry" = T2."DocNum" 
    INNER JOIN OJDT T7 ON T7."TransId" = T2."DocEntry" AND T2."InvType" = T7."ObjType" AND T7."ObjType"=30
    LEFT JOIN JDT1 T8 ON T7."TransId" = T8."TransId" 
    LEFT JOIN JDT2 T9 ON T8."TransId" = T9."AbsEntry" 
    LEFT JOIN OWHT T10 ON T9."WTCode" = T10."WTCode"

    UNION ALL

    /* ============================================================================== */
    /* TITULO 7: PAGOS A CUENTA (SIN DOCUMENTO BASE ASOCIADO)                         */
    /* ============================================================================== */
    SELECT DISTINCT 
        T0."DocEntry" AS "EntryPag", T0."DocDate", T0."DocTotal", T0."DocTotalFC", T0."CardName", T0."DocNum", 
        0 AS "Entry_Fact", T0."DocCurr", '' AS "DocPag", T0."Comments", T0."TrsfrAcct", T0."TrsfrSum", T0."TrsfrSumFC", T0."CardCode", 
        T0."UserSign", 
        (SELECT "AcctName" FROM OACT WHERE "AcctCode" = CASE WHEN ISNULL(T0."TrsfrAcct",'')='' THEN T0."CashAcct" ELSE T0."TrsfrAcct" END) AS "CUENTA", 
        0 AS "FAC", 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, T0."TransId", T0."DocEntry", 0.00, 0.00, 0.00, 0, 'COP', T0."DocRate", T0."SysRate", 0
    FROM OVPM T0  
    WHERE T0."NoDocSum" > 0

) TA

/* ============================================================================== */
/* TITULO 8: JOINS FINALES PARA DATOS MAESTROS (Bancos, Cheques, SN y Usuarios)   */
/* ============================================================================== */
LEFT JOIN OCRD T4 ON T4."CardCode" = TA."CardCode"
LEFT JOIN OUSR T5 ON T5."USERID" = TA."UserSign"
LEFT JOIN OCHO T11 ON T11."TransRef" = TA."DocNum"
LEFT JOIN ODSC T13 ON T13."BankCode" = T11."BankNum"
LEFT JOIN OADM T14 ON 1=1

/* ============================================================================== */
/* AGRUPACIÓN                                                                     */
/* ============================================================================== */
GROUP BY  
    TA."EntryPag", TA."DocDate", TA."DocTotal", TA."DocTotalFC", TA."CardName", TA."DocNum",  TA."TrsfrAcct", TA."TrsfrSum", TA."TrsfrSumFC", TA."DocCurr",
    TA."CUENTA", T4."LicTradNum", TA."Comments", T5."U_NAME", TA."TransId", TA."DocEntry", T4."U_HBT_RegTrib", TA."FAC",
    T11."BankNum", T13."BankName", T11."AcctNum", T11."Branch", T11."CheckNum", T11."VendorName", T14."PrintHeadr", T14."RevOffice", 
    T11."CheckDate", T11."TransRef", T11."TotalWords", TA."DocPag", TA."BfNetDcnt", TA."BfDcntSum", TA."BfNetDcntF", TA."BfDcntSumF",
    TA."SumApplied", TA."AppliedFC", TA."DcntSum", TA."DcntSumFC", TA."VatSum",
    TA."ObjType", TA."WtInvCatS", TA."DocCur", T14."CompnyAddr", T14."Phone1", TA."DocRate";
GO


