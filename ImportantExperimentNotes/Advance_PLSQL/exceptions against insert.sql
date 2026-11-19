    PROCEDURE dpr_insert_fetran (i_brancd     IN     VARCHAR2,
                                 i_doctyp     IN     VARCHAR2,
                                 i_docnum     IN     VARCHAR2,
                                 i_sernum     IN     NUMBER,
                                 i_docdat     IN     DATE,
                                 i_valdat     IN     DATE,
                                 i_oprcod     IN     VARCHAR2,
                                 i_actype     IN     VARCHAR2,
                                 i_actnum     IN     VARCHAR2,
                                 i_curcde     IN     VARCHAR2,
                                 i_exrate     IN     VARCHAR2,
                                 i_debcre     IN     VARCHAR2,
                                 i_dbamfc     IN     NUMBER,
                                 i_dbamlc     IN     NUMBER,
                                 i_cramfc     IN     NUMBER,
                                 i_cramlc     IN     NUMBER,
                                 i_curbal     IN     NUMBER,
                                 i_balflg     IN     VARCHAR2,
                                 i_chgflg     IN     VARCHAR2,
                                 i_chqser     IN     VARCHAR2,
                                 i_chqnum     IN     VARCHAR2,
                                 i_chqdat     IN     DATE,
                                 i_trbrancd   IN     VARCHAR2,
                                 i_tractype   IN     VARCHAR2,
                                 i_tractnum   IN     VARCHAR2,
                                 i_trchqser   IN     VARCHAR2,
                                 i_trchqnum   IN     VARCHAR2,
                                 i_trchqdat   IN     DATE,
                                 i_clrzon     IN     NUMBER,
                                 i_clrday     IN     NUMBER,
                                 i_prtflg     IN     VARCHAR2,
                                 i_glcode     IN     VARCHAR2,
                                 i_opbrancd   IN     VARCHAR2,
                                 i_remark     IN     VARCHAR2,
                                 i_yrprfx     IN     VARCHAR2,
                                 i_chgcde     IN     VARCHAR2,
                                 i_modcde     IN     VARCHAR2,
                                 i_supid2     IN     VARCHAR2,
                                 i_drcode     IN     VARCHAR2,
                                 i_crcode     IN     VARCHAR2,
                                 i_oprstamp   IN     VARCHAR2,
                                 i_timstamp   IN     DATE,
                                 i_glflag     IN     VARCHAR2,
                                 i_refno5     IN     VARCHAR2,
                                 errflg          OUT VARCHAR2,
                                 errmsg          OUT VARCHAR2)
    IS
        e_null_col     EXCEPTION;
        e_fk_missing   EXCEPTION;
        e_too_large    EXCEPTION;
        e_check_viol   EXCEPTION;

        PRAGMA EXCEPTION_INIT (e_null_col, -1400);
        PRAGMA EXCEPTION_INIT (e_fk_missing, -2291);
        PRAGMA EXCEPTION_INIT (e_too_large, -12899);
        PRAGMA EXCEPTION_INIT (e_check_viol, -2290);

        v_err_detail   VARCHAR2 (4000);
    BEGIN
        INSERT INTO stfetrand (brancd,
                               doctyp,
                               docnum,
                               sernum,
                               docdat,
                               valdat,
                               oprcod,
                               actype,
                               actnum,
                               curcde,
                               exrate,
                               debcre,
                               dbamfc,
                               dbamlc,
                               cramfc,
                               cramlc,
                               curbal,
                               balflg,
                               chgflg,
                               chqser,
                               chqnum,
                               chqdat,
                               trbrancd,
                               tractype,
                               tractnum,
                               trchqser,
                               trchqnum,
                               trchqdat,
                               clrzon,
                               clrday,
                               prtflg,
                               glcode,
                               opbrancd,
                               remark,
                               yrprfx,
                               chgcde,
                               modcde,
                               supid2,
                               drcode,
                               crcode,
                               oprstamp,
                               timstamp,
                               glflag,
                               refno5)
             VALUES (i_brancd,
                     i_doctyp,
                     i_docnum,
                     i_sernum,
                     i_docdat,
                     i_valdat,
                     i_oprcod,
                     i_actype,
                     i_actnum,
                     i_curcde,
                     i_exrate,
                     i_debcre,
                     i_dbamfc,
                     i_dbamlc,
                     i_cramfc,
                     i_cramlc,
                     i_curbal,
                     i_balflg,
                     i_chgflg,
                     i_chqser,
                     i_chqnum,
                     i_chqdat,
                     i_trbrancd,
                     i_tractype,
                     i_tractnum,
                     i_trchqser,
                     i_trchqnum,
                     i_trchqdat,
                     i_clrzon,
                     i_clrday,
                     i_prtflg,
                     i_glcode,
                     i_opbrancd,
                     i_remark,
                     i_yrprfx,
                     i_chgcde,
                     i_modcde,
                     i_supid2,
                     i_drcode,
                     i_crcode,
                     i_oprstamp,
                     i_timstamp,
                     i_glflag,
                     i_refno5);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            errflg := 'E';
            v_err_detail :=
                REGEXP_SUBSTR (SQLERRM,
                               '\(([^\)]+)\)',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Duplicate Record Found in stfetrand for Account: '
                || i_actnum
                || ' (Constraint/Index: '
                || v_err_detail
                || ')';
        WHEN e_null_col
        THEN
            errflg := 'E';
            -- ORA-01400 embeds "OWNER"."TABLE"."COLUMN" inside double quotes
            v_err_detail :=
                REGEXP_SUBSTR (SQLERRM,
                               '"[^"]+"\."[^"]+"\."([^"]+)"',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Mandatory column NULL violation on column: '
                || NVL (v_err_detail, 'UNKNOWN');
        WHEN e_too_large
        THEN
            errflg := 'E';
            -- ORA-12899 embeds "OWNER"."TABLE"."COLUMN" inside double quotes
            v_err_detail :=
                REGEXP_SUBSTR (SQLERRM,
                               '"[^"]+"\."[^"]+"\."([^"]+)"',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Value too long for column: '
                || NVL (v_err_detail, 'UNKNOWN');
        WHEN e_fk_missing
        THEN
            errflg := 'E';
            -- ORA-02291 embeds constraint name inside parentheses: (OWNER.FK_NAME)
            v_err_detail :=
                REGEXP_SUBSTR (SQLERRM,
                               '\(([^\)]+)\)',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Parent FK missing for constraint: '
                || NVL (v_err_detail, 'UNKNOWN');
        WHEN e_check_viol
        THEN
            errflg := 'E';
            -- ORA-2290 embeds constraint name inside parentheses: (OWNER.CHECK_NAME)
            v_err_detail :=
                REGEXP_SUBSTR (SQLERRM,
                               '\(([^\)]+)\)',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Check constraint violated: '
                || NVL (v_err_detail, 'UNKNOWN');
        WHEN VALUE_ERROR OR INVALID_NUMBER
        THEN
            errflg := 'E';
            v_err_detail :=
                REGEXP_SUBSTR (DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                               'line ([0-9]+)',
                               1,
                               1,
                               NULL,
                               1);
            errmsg :=
                   'Data conversion error during insert at line '
                || NVL (v_err_detail, 'N/A')
                || ': '
                || SQLERRM;
        WHEN OTHERS
        THEN
            errflg := 'E';
            errmsg :=
                   'Error while inserting stfetran in dpr_insert_fetran '
                || SQLERRM;
    END;