/****** Object:  View [dbo].[SOL_ALERTB1_COREB1SLQuery]    Script Date: 26/09/2026 06:21:41 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SOL_ALERTB1_COREB1SLQuery] AS
SELECT 
    T0."DocEntry" AS "DocEntry", 
    T0."DocNum" AS "DocNum", 
    T0."CardCode" AS "CodProveedor", 
    T0."CardName" AS "Proveedor", 
    T3."Name" AS "TipoDoc", 
    T2."U_SOL_Mail" AS "Correos", 
    T3."U_SOL_ViewNameLayout" AS "VistaLayout", 
    T3."U_SOL_BodyHTML" AS "CuerpoCorreoHTML", 
    T3."U_SOL_SubjectHTML" AS "AsuntoCorreoHTML", 
    T4."CompnyName" AS "RazonSocial", 
    T4."U_SOL_LogoPath" AS "Logo", 
    1 AS "ID"
FROM OVPM T0 
INNER JOIN [@SOL_ALERTSB1_H] T1 ON T0."CardCode" = T1."U_SOL_CardCode"
INNER JOIN [@SOL_ALERTSB1_L] T2 ON T1."Code" = T2."Code" AND T2."U_SOL_ObjectType" = T0."ObjType"
INNER JOIN [@SOL_OBJECTMD] T3 ON T3."Code" = T2."U_SOL_ObjectType" 
INNER JOIN OADM T4 ON 1 = 1
WHERE ISNULL(T2."U_SOL_Active", 'N') = 'Y' AND ISNULL(T0."U_SOL_Send", 'N') = 'Y'

UNION ALL 

SELECT 
    T0."DocEntry" AS "DocEntry", 
    T0."DocNum" AS "DocNum", 
    T0."CardCode" AS "CodProveedor", 
    T0."CardName" AS "Proveedor", 
    T3."Name" AS "TipoDoc", 
    T2."U_SOL_Mail" AS "Correos", 
    T3."U_SOL_ViewNameLayout" AS "VistaLayout", 
    T3."U_SOL_BodyHTML" AS "CuerpoCorreoHTML", 
    T3."U_SOL_SubjectHTML" AS "AsuntoCorreoHTML", 
    T4."CompnyName" AS "RazonSocial", 
    T4."U_SOL_LogoPath" AS "Logo", 
    1 AS "ID"
FROM OPOR T0 
INNER JOIN [@SOL_ALERTSB1_H] T1 ON T0."CardCode" = T1."U_SOL_CardCode"
INNER JOIN [@SOL_ALERTSB1_L] T2 ON T1."Code" = T2."Code" AND T2."U_SOL_ObjectType" = T0."ObjType"
INNER JOIN [@SOL_OBJECTMD] T3 ON T3."Code" = T2."U_SOL_ObjectType" 
INNER JOIN OADM T4 ON 1 = 1
WHERE ISNULL(T2."U_SOL_Active", 'N') = 'Y' AND ISNULL(T0."U_SOL_Send", 'N') = 'Y'
AND T0."CANCELED" = 'N'

UNION ALL

SELECT 
    T0."DocEntry" AS "DocEntry", 
    T0."DocNum" AS "DocNum", 
    T0."CardCode" AS "CodProveedor", 
    T0."CardName" AS "Proveedor", 
    T3."Name" AS "TipoDoc", 
    T2."U_SOL_Mail" AS "Correos", 
    T3."U_SOL_ViewNameLayout" AS "VistaLayout", 
    T3."U_SOL_BodyHTML" AS "CuerpoCorreoHTML", 
    T3."U_SOL_SubjectHTML" AS "AsuntoCorreoHTML", 
    T4."CompnyName" AS "RazonSocial", 
    T4."U_SOL_LogoPath" AS "Logo", 
    1 AS "ID"
FROM ORCT T0 
INNER JOIN [@SOL_ALERTSB1_H] T1 ON T0."CardCode" = T1."U_SOL_CardCode"
INNER JOIN [@SOL_ALERTSB1_L] T2 ON T1."Code" = T2."Code" AND T2."U_SOL_ObjectType" = T0."ObjType"
INNER JOIN [@SOL_OBJECTMD] T3 ON T3."Code" = T2."U_SOL_ObjectType" 
INNER JOIN OADM T4 ON 1 = 1
WHERE ISNULL(T2."U_SOL_Active", 'N') = 'Y' AND ISNULL(T0."U_SOL_Send", 'N') = 'Y';
GO


