/****** Object:  View [dbo].[SOL_ALERTB1_LAYOUT_OCB1SLQuery]    Script Date: 26/09/2026 06:21:49 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[SOL_ALERTB1_LAYOUT_OCB1SLQuery] AS
/* ============================================================================== */
/* TITULO: REPORTE DETALLADO DE PEDIDOS DE COMPRA (ORDENES DE COMPRA)             */
/* Objetivo: Traer cabecera, líneas, datos del proveedor, empresa y autorizadores */
/* ============================================================================== */
SELECT 
    /* --- DATOS DE CABECERA DEL DOCUMENTO --- */
    T0."DocEntry" AS "DocEntry", 
    T0."DocNum" AS "DocNum", 
    T0."DocDate" AS "FechaDocumento", 
    T0."DocDueDate" AS "FechaDespacho", 
    T0."DocCur" AS "Moneda", 
    CASE WHEN T0."DocCur" = T4."MainCurncy" THEN T0."VatSum" ELSE T0."VatSumFC" END AS "TotalIVA", 
    CASE WHEN T0."DocCur" = T4."MainCurncy" THEN T0."DocTotal" ELSE T0."DocTotalFC" END AS "TotalDocumento", 
    
    /* --- DATOS DEL PROVEEDOR --- */
    T0."CardCode" AS "CodigoProveedor", 
    T0."CardName" AS "NombreProveedor", 
    T0."Address" AS "DireccionProveedor", 
    T0."NumAtCard" AS "ReferenciaProveedor", 
    T2."LicTradNum" AS "NITProveedor", 
    T2."City" AS "CiudadProveedor", 
    (SELECT UPPER("Name") FROM OCRY WHERE "Code"=T2."Country") AS "PaisProveedor",
    T2."Phone1" AS "TelefonoProveedor1", 
    T2."Phone2" AS "TelefonoProveedor2", 
    (SELECT J0."Name" FROM OCPR J0 WHERE J0."CntctCode"=T0."CntctCode") AS "NombreContacto",
    
    /* --- CONDICIONES Y LOGISTICA --- */
    T0."GroupNum" AS "CodCondicionPago", 
    (SELECT J0."PymntGroup" FROM OCTG J0 WHERE J0."GroupNum"=T0."GroupNum") AS "CondicionPago",
    (SELECT "TrnspName" FROM OSHP WHERE "TrnspCode"=T0."TrnspCode") AS "Incoterm",  
    
    /* --- DETALLE DE LÍNEAS (ARTÍCULOS) --- */
    T1."ItemCode" AS "CodigoArticulo", 
    T1."Dscription" AS "DescripcionArticulo", 
    T8."FrgnName" AS "NombreExtranjeroArticulo", 
    T1."Quantity" AS "Cantidad", 
    T1."Price" AS "PrecioUnitario", 
    CASE WHEN T0."DocCur"= T4."MainCurncy" THEN T1."LineTotal" ELSE T1."TotalFrgn" END AS "TotalLinea", 
    T1."UomCode" AS "CodUnidadMedida", 
    T3."UomName" AS "NombreUnidadMedida",
    T1."WhsCode" AS "CodigoAlmacen", 
    T6."StreetNo" AS "DireccionAlmacen",
    
    /* --- DATOS DE LA EMPRESA (SOCIEDAD) Y USUARIOS --- */
    T4."PrintHeadr" AS "RazonSocialEmpresa", 
    T4."CompnyAddr" AS "DireccionEmpresa", 
    T7."City" AS "CiudadEmpresa", 
    T7."Street" AS "CalleEmpresa", 
    T4."Phone1" AS "TelefonoEmpresa1", 
    T4."Phone2" AS "TelefonoEmpresa2", 
    T4."E_Mail" AS "EmailEmpresa", 
    T4."RevOffice" AS "OficinaImpuestosEmpresa", 
    T5."U_NAME" AS "UsuarioCreador", 
    T0."Comments" AS "Comentarios",
    '1' AS "ID"

FROM OPOR T0  
INNER JOIN POR1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OCRD T2 ON T2."CardCode"=T0."CardCode"
LEFT JOIN OUOM T3 ON T3."UomCode"=T1."UomCode"
LEFT JOIN OADM T4 ON 1=1
INNER JOIN OUSR T5 ON T0."UserSign" = T5."USERID"
LEFT JOIN OWHS T6 ON T6."WhsCode"=T1."WhsCode"
LEFT JOIN ADM1 T7 ON 1=1
LEFT JOIN OITM T8 ON T8."ItemCode" = T1."ItemCode";
GO


