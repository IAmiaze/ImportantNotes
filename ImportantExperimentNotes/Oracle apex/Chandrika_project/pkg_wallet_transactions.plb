create or replace PACKAGE BODY PKG_WALLET_TRANSACTIONS
AS
    PROCEDURE UPDATE_WALLET_BALANCE (p_wallet_id          NUMBER,
                                     p_category_id        NUMBER,
                                     p_user_id            VARCHAR2,
                                     p_amount             NUMBER,
                                     p_is_increment       VARCHAR2,
                                     pErrorflag       OUT VARCHAR2,
                                     pErrorMessage    OUT VARCHAR2)
    AS
        v_balance   NUMBER;
    BEGIN
        BEGIN
            SELECT balance
              INTO v_balance
              FROM wallets_balance
             WHERE wallet_id = p_wallet_id AND user_id = p_user_id
            FOR UPDATE;

            IF p_is_increment = 'Y'
            THEN
                v_balance := v_balance + p_amount;
            ELSE
                v_balance := v_balance - p_amount;
            END IF;

            UPDATE wallets_balance
               SET balance = v_balance
             WHERE     wallet_id = p_wallet_id
                   AND category_id = p_category_id
                   AND user_id = p_user_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                INSERT INTO wallets_balance (wallet_id,
                                             category_id,
                                             user_id,
                                             balance)
                         VALUES (
                                    p_wallet_id,
                                    p_category_id,
                                    p_user_id,
                                    CASE
                                        WHEN p_is_increment = 'Y'
                                        THEN
                                            p_amount
                                        ELSE
                                            -p_amount
                                    END);
            WHEN OTHERS
            THEN
                pErrorflag := 'Y';
                pErrorMessage := SQLERRM;
                RETURN;
        END;

        pErrorflag := 'N';
        pErrorMessage := 'Success';
    END UPDATE_WALLET_BALANCE;

    PROCEDURE ADD_TRANSACTION (p_user_id                VARCHAR2,
                               p_wallet_id              NUMBER,
                               p_category_id            NUMBER,
                               p_amount                 NUMBER,
                               p_description            VARCHAR2,
                               p_transaction_type       VARCHAR2,
                               p_tran_date              DATE,
                               pErrorflag           OUT VARCHAR2,
                               pErrorMessage        OUT VARCHAR2)
    AS
        vCountExWallet   NUMBER;
        vErrorflag       VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
    BEGIN
        IF p_transaction_type IS NULL
        THEN
            pErrorMessage := 'Transaction Type Required.';
            pErrorflag := 'Y';
            RETURN;
        ELSIF p_category_id IS NULL
        THEN
            pErrorMessage := 'Category Required Value.';
            pErrorflag := 'Y';

            RETURN;
        ELSIF p_wallet_id IS NULL
        THEN
            pErrorMessage := 'Wallet Required Value.';
            pErrorflag := 'Y';

            RETURN;
        ELSIF p_amount IS NULL
        THEN
            pErrorMessage := 'Amount Not Found.';
            pErrorflag := 'Y';

            RETURN;
        ELSIF p_tran_date IS NULL
        THEN
            pErrorMessage := 'Transaction Date Missing';
            pErrorflag := 'Y';

            RETURN;
        END IF;

        BEGIN
            INSERT INTO transactions (user_id,
                                      wallet_id,
                                      category_id,
                                      amount,
                                      description,
                                      transaction_type,
                                      transaction_date)
                 VALUES (p_user_id,
                         p_wallet_id,
                         p_category_id,
                         p_amount,
                         p_description,
                         p_transaction_type,
                         p_tran_date);

            IF p_transaction_type = 'INC'
            THEN
                SELECT COUNT (*)
                  INTO vCountExWallet
                  FROM wallets_balance
                 WHERE user_id = p_user_id AND wallet_id = p_wallet_id;

                IF vCountExWallet > 0
                THEN
                    UPDATE wallets_balance
                       SET balance = balance + p_amount
                     WHERE wallet_id = p_wallet_id AND user_id = p_user_id;
                ELSE
                    INSERT INTO wallets_balance (wallet_id,
                                                 category_id,
                                                 user_id,
                                                 balance)
                         VALUES (p_wallet_id,
                                 p_category_id,
                                 p_user_id,
                                 p_amount);
                END IF;
            END IF;

            IF p_transaction_type = 'EXP'
            THEN
                SELECT COUNT (*)
                  INTO vCountExWallet
                  FROM wallets_balance
                 WHERE user_id = p_user_id AND wallet_id = p_wallet_id;

                IF vCountExWallet > 0
                THEN
                    UPDATE wallets_balance
                       SET balance = balance - p_amount
                     WHERE wallet_id = p_wallet_id AND user_id = p_user_id;
                ELSE
                    INSERT INTO wallets_balance (wallet_id,
                                                 category_id,
                                                 user_id,
                                                 balance)
                         VALUES (p_wallet_id,
                                 p_category_id,
                                 p_user_id,
                                 -p_amount);
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorflag := 'Y';
                pErrorMessage := SQLERRM;
                RETURN;
        END;

        pErrorflag := vErrorflag;
        pErrorMessage := vErrorMessage;
    END ADD_TRANSACTION;

    PROCEDURE ADD_TRANSFER (p_user_id              VARCHAR2,
                            p_from_wallet_id       NUMBER,
                            p_to_wallet_id         NUMBER,
                            p_amount               NUMBER,
                            pErrorflag         OUT VARCHAR2,
                            pErrorMessage      OUT VARCHAR2)
    AS
        vErrorflag       VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vAvailBal        NUMBER;
        vCountExWallet   NUMBER;
        vMyException     EXCEPTION;
    BEGIN
        IF p_from_wallet_id IS NULL
        THEN
            vErrorMessage := 'Source wallet Not Found.';
            RAISE vMyException;
        END IF;

        IF p_to_wallet_id IS NULL
        THEN
            vErrorMessage := 'Destoination wallet Not Found.';
            RAISE vMyException;
        END IF;

        IF p_amount = 0
        THEN
            vErrorMessage := 'Amount Should be Greater than 0';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT balance
              INTO vAvailBal
              FROM WALLETS_BALANCE
             WHERE wallet_id = p_from_wallet_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                vAvailBal := 0;
        END;

        IF vAvailBal <= 0
        THEN
            vErrorMessage := 'Insufficient Balance in your source wallet';
            RAISE vMyException;
        END IF;

        BEGIN
            INSERT INTO transfers (user_id,
                                   from_wallet_id,
                                   to_wallet_id,
                                   amount)
                 VALUES (p_user_id,
                         p_from_wallet_id,
                         p_to_wallet_id,
                         p_amount);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorflag := 'Y';
                pErrorMessage := 'Transfer Execution Error: ' || SQLERRM;
                RETURN;
        END;

        BEGIN
            SELECT COUNT (*)
              INTO vCountExWallet
              FROM wallets_balance
             WHERE user_id = p_user_id AND wallet_id = p_to_wallet_id;

            IF vCountExWallet > 0
            THEN
                UPDATE wallets_balance
                   SET balance = balance + p_amount
                 WHERE wallet_id = p_to_wallet_id AND user_id = p_user_id;
            ELSE
                INSERT INTO wallets_balance (wallet_id,
                                             category_id,
                                             user_id,
                                             balance)
                     VALUES (p_to_wallet_id,
                             0,
                             p_user_id,
                             p_amount);
            END IF;

            UPDATE wallets_balance
               SET balance = balance - p_amount
             WHERE wallet_id = p_from_wallet_id AND user_id = p_user_id;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorflag := 'Y';
            pErrorMessage := vErrorMessage;
    END ADD_TRANSFER;
END PKG_WALLET_TRANSACTIONS;
/