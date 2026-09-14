create or replace PACKAGE PKG_WALLET_TRANSACTIONS AS
    PROCEDURE ADD_TRANSACTION(
        p_user_id VARCHAR2,
        p_wallet_id NUMBER,
        p_category_id NUMBER,
        p_amount NUMBER,
        p_description VARCHAR2,
        p_transaction_type VARCHAR2,
        p_tran_date              DATE,
        pErrorflag OUT VARCHAR2,
        pErrorMessage OUT VARCHAR2
    );
    
    PROCEDURE ADD_TRANSFER(
        p_user_id VARCHAR2,
        p_from_wallet_id NUMBER,
        p_to_wallet_id NUMBER,
        p_amount NUMBER,
        pErrorflag OUT VARCHAR2,
        pErrorMessage OUT VARCHAR2
    );
END PKG_WALLET_TRANSACTIONS;
/