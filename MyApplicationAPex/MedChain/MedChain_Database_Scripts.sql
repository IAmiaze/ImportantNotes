/*******************************************************************************
 * MedChain - Healthcare Supply Chain & Patient Safety Platform
 * 
 * Oracle APEX Advanced Project
 * Database Schema and Implementation Scripts
 * 
 * Author: Advanced Oracle APEX Developer
 * Version: 1.0.0
 * Last Updated: January 2026
 * 
 * This script contains:
 * - Complete database schema
 * - Core PL/SQL packages
 * - Triggers and automation
 * - Sample data generation
 * - Performance optimization
 * 
 *******************************************************************************/

-------------------------------------------------------------------------------
-- SECTION 1: SEQUENCES
-------------------------------------------------------------------------------

CREATE SEQUENCE org_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE medicine_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE batch_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE location_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE inventory_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE event_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE patient_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE prescription_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE alert_seq START WITH 1 INCREMENT BY 1;

-------------------------------------------------------------------------------
-- SECTION 2: CORE TABLES
-------------------------------------------------------------------------------

-- Organizations Table (প্রতিষ্ঠান)
CREATE TABLE organizations (
    org_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    org_code            VARCHAR2(20) UNIQUE NOT NULL,
    org_name            VARCHAR2(200) NOT NULL,
    org_type            VARCHAR2(50) NOT NULL, 
    -- Types: MANUFACTURER, DISTRIBUTOR, HOSPITAL, PHARMACY, REGULATOR
    license_number      VARCHAR2(100),
    license_expiry      DATE,
    address_line1       VARCHAR2(200),
    address_line2       VARCHAR2(200),
    city                VARCHAR2(100),
    state               VARCHAR2(100),
    postal_code         VARCHAR2(20),
    country             VARCHAR2(100) DEFAULT 'Bangladesh',
    phone               VARCHAR2(20),
    email               VARCHAR2(200),
    website             VARCHAR2(200),
    status              VARCHAR2(20) DEFAULT 'ACTIVE',
    parent_org_id       NUMBER,
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR2(100),
    updated_date        TIMESTAMP,
    
    CONSTRAINT org_type_chk CHECK (org_type IN ('MANUFACTURER', 'DISTRIBUTOR', 'HOSPITAL', 'PHARMACY', 'REGULATOR')),
    CONSTRAINT org_status_chk CHECK (status IN ('ACTIVE', 'SUSPENDED', 'INACTIVE')),
    CONSTRAINT fk_parent_org FOREIGN KEY (parent_org_id) REFERENCES organizations(org_id)
);

CREATE INDEX idx_org_type ON organizations(org_type);
CREATE INDEX idx_org_status ON organizations(status);
CREATE INDEX idx_org_code ON organizations(org_code);

COMMENT ON TABLE organizations IS 'প্রতিষ্ঠানের মাস্টার টেবিল - হাসপাতাল, ফার্মেসি, ম্যানুফ্যাকচারার';
COMMENT ON COLUMN organizations.org_type IS 'প্রতিষ্ঠানের ধরন';

-- Users Table (ব্যবহারকারী)
CREATE TABLE users (
    user_id             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username            VARCHAR2(100) UNIQUE NOT NULL,
    email               VARCHAR2(200) UNIQUE NOT NULL,
    full_name           VARCHAR2(200) NOT NULL,
    phone               VARCHAR2(20),
    org_id              NUMBER NOT NULL,
    role_code           VARCHAR2(50) NOT NULL,
    employee_id         VARCHAR2(50),
    designation         VARCHAR2(100),
    department          VARCHAR2(100),
    is_active           VARCHAR2(1) DEFAULT 'Y',
    last_login          TIMESTAMP,
    password_hash       VARCHAR2(500),
    mfa_enabled         VARCHAR2(1) DEFAULT 'N',
    mfa_secret          VARCHAR2(200),
    failed_login_count  NUMBER DEFAULT 0,
    account_locked      VARCHAR2(1) DEFAULT 'N',
    password_expiry     DATE,
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR2(100),
    updated_date        TIMESTAMP,
    
    CONSTRAINT fk_user_org FOREIGN KEY (org_id) REFERENCES organizations(org_id),
    CONSTRAINT user_active_chk CHECK (is_active IN ('Y', 'N')),
    CONSTRAINT mfa_enabled_chk CHECK (mfa_enabled IN ('Y', 'N')),
    CONSTRAINT account_locked_chk CHECK (account_locked IN ('Y', 'N'))
);

CREATE INDEX idx_user_org ON users(org_id);
CREATE INDEX idx_user_role ON users(role_code);

-- Medicine Master Table (ওষুধের মাস্টার)
CREATE TABLE medicine_master (
    medicine_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_code       VARCHAR2(50) UNIQUE NOT NULL,
    generic_name        VARCHAR2(200) NOT NULL,
    brand_name          VARCHAR2(200),
    manufacturer_id     NUMBER NOT NULL,
    dosage_form         VARCHAR2(50) NOT NULL,
    strength            VARCHAR2(100) NOT NULL,
    unit_of_measure     VARCHAR2(20) NOT NULL,
    therapeutic_class   VARCHAR2(100),
    drug_category       VARCHAR2(50),
    storage_condition   VARCHAR2(200),
    is_controlled       VARCHAR2(1) DEFAULT 'N',
    is_refrigerated     VARCHAR2(1) DEFAULT 'N',
    shelf_life_months   NUMBER,
    barcode             VARCHAR2(100) UNIQUE,
    description         CLOB,
    side_effects        CLOB,
    contraindications   CLOB,
    status              VARCHAR2(20) DEFAULT 'ACTIVE',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR2(100),
    updated_date        TIMESTAMP,
    
    CONSTRAINT fk_med_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES organizations(org_id),
    CONSTRAINT med_controlled_chk CHECK (is_controlled IN ('Y', 'N')),
    CONSTRAINT med_refrigerated_chk CHECK (is_refrigerated IN ('Y', 'N')),
    CONSTRAINT med_status_chk CHECK (status IN ('ACTIVE', 'DISCONTINUED', 'RECALLED'))
);

CREATE INDEX idx_med_generic ON medicine_master(generic_name);
CREATE INDEX idx_med_brand ON medicine_master(brand_name);
CREATE INDEX idx_med_manufacturer ON medicine_master(manufacturer_id);

-- Medicine Batches Table (ব্যাচ ট্র্যাকিং)
CREATE TABLE medicine_batches (
    batch_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id         NUMBER NOT NULL,
    batch_number        VARCHAR2(100) NOT NULL,
    lot_number          VARCHAR2(100),
    manufacture_date    DATE NOT NULL,
    expiry_date         DATE NOT NULL,
    manufacturer_id     NUMBER NOT NULL,
    initial_quantity    NUMBER NOT NULL,
    current_quantity    NUMBER NOT NULL,
    unit_price          NUMBER(10,2),
    mrp                 NUMBER(10,2),
    gtin                VARCHAR2(50),
    verification_hash   VARCHAR2(500),
    qr_code             BLOB,
    batch_status        VARCHAR2(20) DEFAULT 'ACTIVE',
    recall_flag         VARCHAR2(1) DEFAULT 'N',
    recall_reason       VARCHAR2(500),
    recall_date         DATE,
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_batch_medicine FOREIGN KEY (medicine_id) REFERENCES medicine_master(medicine_id),
    CONSTRAINT fk_batch_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES organizations(org_id),
    CONSTRAINT batch_status_chk CHECK (batch_status IN ('ACTIVE', 'EXPIRED', 'RECALLED', 'DISPOSED')),
    CONSTRAINT recall_flag_chk CHECK (recall_flag IN ('Y', 'N')),
    CONSTRAINT batch_unique UNIQUE (medicine_id, batch_number, manufacturer_id)
);

CREATE INDEX idx_batch_medicine ON medicine_batches(medicine_id);
CREATE INDEX idx_batch_expiry ON medicine_batches(expiry_date);
CREATE INDEX idx_batch_status ON medicine_batches(batch_status);

-- Locations Table (স্টোরেজ লোকেশন)
CREATE TABLE locations (
    location_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    org_id              NUMBER NOT NULL,
    location_code       VARCHAR2(50) NOT NULL,
    location_name       VARCHAR2(200) NOT NULL,
    location_type       VARCHAR2(50) NOT NULL,
    parent_location_id  NUMBER,
    capacity            NUMBER,
    has_temperature_control VARCHAR2(1) DEFAULT 'N',
    min_temperature     NUMBER,
    max_temperature     NUMBER,
    sensor_id           VARCHAR2(50),
    is_active           VARCHAR2(1) DEFAULT 'Y',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_location_org FOREIGN KEY (org_id) REFERENCES organizations(org_id),
    CONSTRAINT fk_parent_location FOREIGN KEY (parent_location_id) REFERENCES locations(location_id),
    CONSTRAINT location_unique UNIQUE (org_id, location_code),
    CONSTRAINT temp_control_chk CHECK (has_temperature_control IN ('Y', 'N'))
);

CREATE INDEX idx_location_org ON locations(org_id);
CREATE INDEX idx_location_type ON locations(location_type);

-- Inventory Table (ইনভেন্টরি)
CREATE TABLE inventory (
    inventory_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    batch_id            NUMBER NOT NULL,
    location_id         NUMBER NOT NULL,
    quantity            NUMBER NOT NULL,
    reserved_quantity   NUMBER DEFAULT 0,
    available_quantity  NUMBER GENERATED ALWAYS AS (quantity - reserved_quantity) VIRTUAL,
    reorder_level       NUMBER,
    max_stock_level     NUMBER,
    last_stock_date     DATE,
    last_counted_by     VARCHAR2(100),
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR2(100),
    updated_date        TIMESTAMP,
    
    CONSTRAINT fk_inv_batch FOREIGN KEY (batch_id) REFERENCES medicine_batches(batch_id),
    CONSTRAINT fk_inv_location FOREIGN KEY (location_id) REFERENCES locations(location_id),
    CONSTRAINT inv_unique UNIQUE (batch_id, location_id),
    CONSTRAINT inv_quantity_chk CHECK (quantity >= 0),
    CONSTRAINT inv_reserved_chk CHECK (reserved_quantity >= 0)
);

CREATE INDEX idx_inv_batch ON inventory(batch_id);
CREATE INDEX idx_inv_location ON inventory(location_id);

-- Supply Chain Events Table (সাপ্লাই চেইন ইভেন্ট)
CREATE TABLE supply_chain_events (
    event_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    batch_id            NUMBER NOT NULL,
    event_type          VARCHAR2(50) NOT NULL,
    from_org_id         NUMBER,
    to_org_id           NUMBER,
    from_location_id    NUMBER,
    to_location_id      NUMBER,
    quantity            NUMBER NOT NULL,
    event_date          TIMESTAMP NOT NULL,
    shipment_ref        VARCHAR2(100),
    temperature_min     NUMBER,
    temperature_max     NUMBER,
    gps_coordinates     VARCHAR2(100),
    notes               VARCHAR2(500),
    verified_by         VARCHAR2(100),
    verification_hash   VARCHAR2(500),
    previous_event_hash VARCHAR2(500),
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_event_batch FOREIGN KEY (batch_id) REFERENCES medicine_batches(batch_id),
    CONSTRAINT fk_event_from_org FOREIGN KEY (from_org_id) REFERENCES organizations(org_id),
    CONSTRAINT fk_event_to_org FOREIGN KEY (to_org_id) REFERENCES organizations(org_id),
    CONSTRAINT event_type_chk CHECK (event_type IN (
        'MANUFACTURED', 'SHIPPED', 'RECEIVED', 'TRANSFERRED', 
        'DISPENSED', 'RETURNED', 'DISPOSED', 'RECALLED'
    ))
);

CREATE INDEX idx_event_batch ON supply_chain_events(batch_id);
CREATE INDEX idx_event_type ON supply_chain_events(event_type);
CREATE INDEX idx_event_date ON supply_chain_events(event_date);

-- Patients Table (রোগী)
CREATE TABLE patients (
    patient_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_code        VARCHAR2(50) UNIQUE NOT NULL,
    national_id         VARCHAR2(50),
    first_name          VARCHAR2(100) NOT NULL,
    last_name           VARCHAR2(100),
    date_of_birth       DATE NOT NULL,
    gender              VARCHAR2(10) NOT NULL,
    blood_group         VARCHAR2(5),
    phone               VARCHAR2(20),
    email               VARCHAR2(200),
    address             VARCHAR2(500),
    emergency_contact   VARCHAR2(200),
    emergency_phone     VARCHAR2(20),
    registered_org_id   NUMBER,
    is_active           VARCHAR2(1) DEFAULT 'Y',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR2(100),
    updated_date        TIMESTAMP,
    
    CONSTRAINT fk_patient_org FOREIGN KEY (registered_org_id) REFERENCES organizations(org_id),
    CONSTRAINT patient_gender_chk CHECK (gender IN ('MALE', 'FEMALE', 'OTHER'))
);

CREATE INDEX idx_patient_code ON patients(patient_code);
CREATE INDEX idx_patient_nid ON patients(national_id);

-- Allergies Table (এলার্জি)
CREATE TABLE allergies (
    allergy_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id          NUMBER NOT NULL,
    allergen_type       VARCHAR2(50) NOT NULL,
    allergen_name       VARCHAR2(200) NOT NULL,
    medicine_id         NUMBER,
    severity            VARCHAR2(20) NOT NULL,
    reaction            VARCHAR2(500),
    onset_date          DATE,
    reported_by         VARCHAR2(100),
    verified_by         VARCHAR2(100),
    is_active           VARCHAR2(1) DEFAULT 'Y',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_allergy_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_allergy_medicine FOREIGN KEY (medicine_id) REFERENCES medicine_master(medicine_id),
    CONSTRAINT allergy_severity_chk CHECK (severity IN ('MILD', 'MODERATE', 'SEVERE', 'LIFE_THREATENING'))
);

CREATE INDEX idx_allergy_patient ON allergies(patient_id);

-- Prescriptions Table (প্রেসক্রিপশন)
CREATE TABLE prescriptions (
    prescription_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prescription_number VARCHAR2(50) UNIQUE NOT NULL,
    patient_id          NUMBER NOT NULL,
    doctor_id           NUMBER NOT NULL,
    org_id              NUMBER NOT NULL,
    prescription_date   DATE NOT NULL,
    diagnosis           VARCHAR2(1000),
    notes               CLOB,
    status              VARCHAR2(20) DEFAULT 'ACTIVE',
    valid_until         DATE,
    dispensed_by        NUMBER,
    dispensed_date      TIMESTAMP,
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_rx_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_rx_doctor FOREIGN KEY (doctor_id) REFERENCES users(user_id),
    CONSTRAINT fk_rx_org FOREIGN KEY (org_id) REFERENCES organizations(org_id),
    CONSTRAINT fk_rx_pharmacist FOREIGN KEY (dispensed_by) REFERENCES users(user_id),
    CONSTRAINT rx_status_chk CHECK (status IN ('ACTIVE', 'DISPENSED', 'CANCELLED', 'EXPIRED'))
);

CREATE INDEX idx_rx_patient ON prescriptions(patient_id);
CREATE INDEX idx_rx_doctor ON prescriptions(doctor_id);

-- Prescription Items Table
CREATE TABLE prescription_items (
    item_id             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prescription_id     NUMBER NOT NULL,
    medicine_id         NUMBER NOT NULL,
    dosage              VARCHAR2(100) NOT NULL,
    frequency           VARCHAR2(100) NOT NULL,
    duration_days       NUMBER NOT NULL,
    quantity            NUMBER NOT NULL,
    instructions        VARCHAR2(500),
    batch_id            NUMBER,
    dispensed_quantity  NUMBER DEFAULT 0,
    status              VARCHAR2(20) DEFAULT 'PENDING',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_rx_item_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id),
    CONSTRAINT fk_rx_item_medicine FOREIGN KEY (medicine_id) REFERENCES medicine_master(medicine_id),
    CONSTRAINT fk_rx_item_batch FOREIGN KEY (batch_id) REFERENCES medicine_batches(batch_id),
    CONSTRAINT rx_item_status_chk CHECK (status IN ('PENDING', 'DISPENSED', 'CANCELLED'))
);

CREATE INDEX idx_rx_item_prescription ON prescription_items(prescription_id);

-- ADR Reports Table (পার্শ্বপ্রতিক্রিয়া)
CREATE TABLE adr_reports (
    adr_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    report_number       VARCHAR2(50) UNIQUE NOT NULL,
    patient_id          NUMBER NOT NULL,
    medicine_id         NUMBER NOT NULL,
    batch_id            NUMBER,
    reaction_type       VARCHAR2(100) NOT NULL,
    severity            VARCHAR2(20) NOT NULL,
    onset_date          DATE NOT NULL,
    description         CLOB NOT NULL,
    outcome             VARCHAR2(50),
    reported_by         NUMBER NOT NULL,
    reported_date       DATE NOT NULL,
    verified_by         NUMBER,
    verified_date       DATE,
    sent_to_regulator   VARCHAR2(1) DEFAULT 'N',
    regulator_ref       VARCHAR2(100),
    status              VARCHAR2(20) DEFAULT 'PENDING',
    created_by          VARCHAR2(100) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_adr_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_adr_medicine FOREIGN KEY (medicine_id) REFERENCES medicine_master(medicine_id),
    CONSTRAINT fk_adr_batch FOREIGN KEY (batch_id) REFERENCES medicine_batches(batch_id),
    CONSTRAINT fk_adr_reporter FOREIGN KEY (reported_by) REFERENCES users(user_id),
    CONSTRAINT fk_adr_verifier FOREIGN KEY (verified_by) REFERENCES users(user_id),
    CONSTRAINT adr_severity_chk CHECK (severity IN ('MILD', 'MODERATE', 'SEVERE', 'LIFE_THREATENING')),
    CONSTRAINT adr_status_chk CHECK (status IN ('PENDING', 'VERIFIED', 'UNDER_INVESTIGATION', 'CLOSED'))
);

CREATE INDEX idx_adr_patient ON adr_reports(patient_id);
CREATE INDEX idx_adr_medicine ON adr_reports(medicine_id);

-- Alerts Table (সতর্কতা)
CREATE TABLE alerts (
    alert_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alert_type          VARCHAR2(50) NOT NULL,
    entity_type         VARCHAR2(50),
    entity_id           NUMBER,
    severity            VARCHAR2(20) NOT NULL,
    message             VARCHAR2(1000) NOT NULL,
    assigned_to         NUMBER,
    status              VARCHAR2(20) DEFAULT 'OPEN',
    resolved_by         NUMBER,
    resolved_date       TIMESTAMP,
    resolution_notes    VARCHAR2(1000),
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_alert_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    CONSTRAINT fk_alert_resolved_by FOREIGN KEY (resolved_by) REFERENCES users(user_id),
    CONSTRAINT alert_severity_chk CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CONSTRAINT alert_status_chk CHECK (status IN ('OPEN', 'ACKNOWLEDGED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'))
);

CREATE INDEX idx_alert_type ON alerts(alert_type);
CREATE INDEX idx_alert_severity ON alerts(severity);
CREATE INDEX idx_alert_status ON alerts(status);

-- Notifications Table
CREATE TABLE notifications (
    notification_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id             NUMBER NOT NULL,
    notification_type   VARCHAR2(50) NOT NULL,
    title               VARCHAR2(200) NOT NULL,
    message             VARCHAR2(1000) NOT NULL,
    link_url            VARCHAR2(500),
    is_read             VARCHAR2(1) DEFAULT 'N',
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_date           TIMESTAMP,
    
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_notif_user ON notifications(user_id);
CREATE INDEX idx_notif_read ON notifications(is_read);

-- Audit Log Table (অডিট লগ)
CREATE TABLE audit_log (
    audit_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name          VARCHAR2(100) NOT NULL,
    operation           VARCHAR2(20) NOT NULL,
    record_id           NUMBER,
    old_values          CLOB,
    new_values          CLOB,
    changed_by          VARCHAR2(100) NOT NULL,
    changed_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address          VARCHAR2(50),
    session_id          VARCHAR2(100)
);

CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_date ON audit_log(changed_date);

-- Temperature Logs (IoT)
CREATE TABLE temperature_logs (
    log_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id         NUMBER NOT NULL,
    sensor_id           VARCHAR2(50),
    temperature         NUMBER NOT NULL,
    humidity            NUMBER,
    recorded_at         TIMESTAMP NOT NULL,
    alert_triggered     VARCHAR2(1) DEFAULT 'N',
    
    CONSTRAINT fk_temp_location FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE INDEX idx_temp_location ON temperature_logs(location_id);
CREATE INDEX idx_temp_date ON temperature_logs(recorded_at);

-- Drug Interactions
CREATE TABLE drug_interactions (
    interaction_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id_1       NUMBER NOT NULL,
    medicine_id_2       NUMBER NOT NULL,
    interaction_type    VARCHAR2(50) NOT NULL,
    description         VARCHAR2(1000),
    recommendation      VARCHAR2(500),
    
    CONSTRAINT fk_interaction_med1 FOREIGN KEY (medicine_id_1) REFERENCES medicine_master(medicine_id),
    CONSTRAINT fk_interaction_med2 FOREIGN KEY (medicine_id_2) REFERENCES medicine_master(medicine_id),
    CONSTRAINT interaction_unique UNIQUE (medicine_id_1, medicine_id_2)
);

-------------------------------------------------------------------------------
-- SECTION 3: TRIGGERS
-------------------------------------------------------------------------------

-- Batch Verification Hash Trigger
CREATE OR REPLACE TRIGGER trg_batch_verification_hash
BEFORE INSERT ON medicine_batches
FOR EACH ROW
BEGIN
    :NEW.verification_hash := RAWTOHEX(DBMS_CRYPTO.HASH(
        UTL_RAW.CAST_TO_RAW(
            :NEW.medicine_id || :NEW.batch_number || 
            TO_CHAR(:NEW.manufacture_date, 'YYYYMMDD') || 
            TO_CHAR(:NEW.expiry_date, 'YYYYMMDD') ||
            :NEW.manufacturer_id || 'GENESIS'
        ),
        DBMS_CRYPTO.HASH_SH256
    ));
END;
/

-- Supply Chain Hash Chain Trigger
CREATE OR REPLACE TRIGGER trg_supply_chain_hash
BEFORE INSERT ON supply_chain_events
FOR EACH ROW
DECLARE
    v_prev_hash VARCHAR2(500);
BEGIN
    -- Get previous event hash
    BEGIN
        SELECT verification_hash INTO v_prev_hash
        FROM (
            SELECT verification_hash 
            FROM supply_chain_events 
            WHERE batch_id = :NEW.batch_id
            ORDER BY event_date DESC
            FETCH FIRST 1 ROW ONLY
        );
        
        :NEW.previous_event_hash := v_prev_hash;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            :NEW.previous_event_hash := NULL;
            v_prev_hash := 'GENESIS';
    END;
    
    -- Generate new hash
    :NEW.verification_hash := RAWTOHEX(DBMS_CRYPTO.HASH(
        UTL_RAW.CAST_TO_RAW(
            :NEW.batch_id || :NEW.event_type || 
            TO_CHAR(:NEW.event_date, 'YYYYMMDDHH24MISS') ||
            NVL(v_prev_hash, 'GENESIS')
        ),
        DBMS_CRYPTO.HASH_SH256
    ));
END;
/

-- Inventory Reorder Alert Trigger
CREATE OR REPLACE TRIGGER trg_inventory_reorder_alert
AFTER UPDATE OF quantity ON inventory
FOR EACH ROW
WHEN (NEW.quantity <= NEW.reorder_level AND OLD.quantity > OLD.reorder_level)
BEGIN
    INSERT INTO alerts (
        alert_type, entity_type, entity_id, severity, message, created_date
    ) VALUES (
        'REORDER', 'INVENTORY', :NEW.inventory_id, 
        'MEDIUM',
        'Stock below reorder level for inventory ID: ' || :NEW.inventory_id,
        CURRENT_TIMESTAMP
    );
END;
/

-------------------------------------------------------------------------------
-- SECTION 4: CORE PACKAGES
-------------------------------------------------------------------------------

-- Security Package
CREATE OR REPLACE PACKAGE security_pkg AS
    FUNCTION encrypt_data(p_data IN VARCHAR2) RETURN RAW;
    FUNCTION decrypt_data(p_encrypted IN RAW) RETURN VARCHAR2;
    PROCEDURE log_access(
        p_user_id IN NUMBER,
        p_action IN VARCHAR2,
        p_details IN VARCHAR2 DEFAULT NULL
    );
END security_pkg;
/

CREATE OR REPLACE PACKAGE BODY security_pkg AS
    c_key RAW(32) := UTL_RAW.CAST_TO_RAW('MedChainSecure2024Key@@');
    
    FUNCTION encrypt_data(p_data IN VARCHAR2) RETURN RAW IS
    BEGIN
        RETURN DBMS_CRYPTO.ENCRYPT(
            src => UTL_RAW.CAST_TO_RAW(p_data),
            typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
            key => c_key
        );
    END encrypt_data;
    
    FUNCTION decrypt_data(p_encrypted IN RAW) RETURN VARCHAR2 IS
    BEGIN
        RETURN UTL_RAW.CAST_TO_VARCHAR2(
            DBMS_CRYPTO.DECRYPT(
                src => p_encrypted,
                typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
                key => c_key
            )
        );
    END decrypt_data;
    
    PROCEDURE log_access(
        p_user_id IN NUMBER,
        p_action IN VARCHAR2,
        p_details IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO audit_log (
            table_name, operation, record_id, new_values, changed_by
        ) VALUES (
            'ACCESS_LOG', p_action, p_user_id, p_details, USER
        );
        COMMIT;
    END log_access;
END security_pkg;
/

-- Verification Package
CREATE OR REPLACE PACKAGE verification_pkg AS
    FUNCTION verify_supply_chain(p_batch_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION generate_qr_code(p_batch_id IN NUMBER) RETURN BLOB;
END verification_pkg;
/

CREATE OR REPLACE PACKAGE BODY verification_pkg AS
    FUNCTION verify_supply_chain(p_batch_id IN NUMBER) RETURN VARCHAR2 IS
        v_is_valid BOOLEAN := TRUE;
        v_prev_hash VARCHAR2(500);
        v_calc_hash VARCHAR2(500);
        
        CURSOR c_events IS
            SELECT event_id, batch_id, event_type, event_date,
                   verification_hash, previous_event_hash
            FROM supply_chain_events
            WHERE batch_id = p_batch_id
            ORDER BY event_date;
    BEGIN
        FOR rec IN c_events LOOP
            v_calc_hash := RAWTOHEX(DBMS_CRYPTO.HASH(
                UTL_RAW.CAST_TO_RAW(
                    rec.batch_id || rec.event_type || 
                    TO_CHAR(rec.event_date, 'YYYYMMDDHH24MISS') ||
                    NVL(v_prev_hash, 'GENESIS')
                ),
                DBMS_CRYPTO.HASH_SH256
            ));
            
            IF v_calc_hash != rec.verification_hash THEN
                v_is_valid := FALSE;
                EXIT;
            END IF;
            
            IF v_prev_hash IS NOT NULL AND v_prev_hash != rec.previous_event_hash THEN
                v_is_valid := FALSE;
                EXIT;
            END IF;
            
            v_prev_hash := rec.verification_hash;
        END LOOP;
        
        RETURN CASE WHEN v_is_valid THEN 'VERIFIED' ELSE 'TAMPERED' END;
    END verify_supply_chain;
    
    FUNCTION generate_qr_code(p_batch_id IN NUMBER) RETURN BLOB IS
        -- This would integrate with a QR code generation library
        v_qr BLOB;
    BEGIN
        -- Placeholder for QR code generation
        RETURN v_qr;
    END generate_qr_code;
END verification_pkg;
/

-- Alert Management Package
CREATE OR REPLACE PACKAGE alert_pkg AS
    PROCEDURE generate_expiry_alerts;
    PROCEDURE notify_alert(p_alert_id IN NUMBER);
END alert_pkg;
/

CREATE OR REPLACE PACKAGE BODY alert_pkg AS
    PROCEDURE generate_expiry_alerts IS
        CURSOR c_expiring IS
            SELECT 
                mb.batch_id,
                mb.batch_number,
                mm.brand_name,
                mb.expiry_date,
                TRUNC(mb.expiry_date - SYSDATE) as days_remaining,
                i.inventory_id,
                i.quantity,
                l.org_id,
                CASE 
                    WHEN TRUNC(mb.expiry_date - SYSDATE) <= 7 THEN 'CRITICAL'
                    WHEN TRUNC(mb.expiry_date - SYSDATE) <= 30 THEN 'HIGH'
                    WHEN TRUNC(mb.expiry_date - SYSDATE) <= 60 THEN 'MEDIUM'
                    ELSE 'LOW'
                END as severity
            FROM medicine_batches mb
            JOIN medicine_master mm ON mb.medicine_id = mm.medicine_id
            JOIN inventory i ON mb.batch_id = i.batch_id
            JOIN locations l ON i.location_id = l.location_id
            WHERE mb.batch_status = 'ACTIVE'
            AND mb.expiry_date BETWEEN SYSDATE AND SYSDATE + 90
            AND i.quantity > 0;
    BEGIN
        FOR rec IN c_expiring LOOP
            -- Check if alert already exists
            DECLARE
                v_exists NUMBER;
            BEGIN
                SELECT COUNT(*) INTO v_exists
                FROM alerts
                WHERE entity_type = 'BATCH'
                AND entity_id = rec.batch_id
                AND alert_type = 'EXPIRY'
                AND status IN ('OPEN', 'ACKNOWLEDGED');
                
                IF v_exists = 0 THEN
                    INSERT INTO alerts (
                        alert_type, entity_type, entity_id, severity, message,
                        created_date
                    ) VALUES (
                        'EXPIRY', 'BATCH', rec.batch_id, rec.severity,
                        rec.brand_name || ' (Batch: ' || rec.batch_number || 
                        ') expires in ' || rec.days_remaining || ' days. Quantity: ' || rec.quantity,
                        SYSTIMESTAMP
                    );
                END IF;
            END;
        END LOOP;
        
        COMMIT;
    END generate_expiry_alerts;
    
    PROCEDURE notify_alert(p_alert_id IN NUMBER) IS
        v_alert alerts%ROWTYPE;
    BEGIN
        SELECT * INTO v_alert FROM alerts WHERE alert_id = p_alert_id;
        
        -- Create notifications for relevant users
        INSERT INTO notifications (user_id, notification_type, title, message, created_date)
        SELECT 
            u.user_id,
            v_alert.alert_type,
            v_alert.severity || ' Alert',
            v_alert.message,
            SYSTIMESTAMP
        FROM users u
        WHERE u.is_active = 'Y'
        AND u.role_code IN ('ADMIN', 'PHARMACIST', 'MANAGER');
        
        COMMIT;
    END notify_alert;
END alert_pkg;
/

-------------------------------------------------------------------------------
-- SECTION 5: SAMPLE DATA GENERATION
-------------------------------------------------------------------------------

-- Sample Organizations
INSERT INTO organizations (org_code, org_name, org_type, city, country, created_by)
VALUES ('ORG001', 'Square Pharmaceuticals Ltd', 'MANUFACTURER', 'Dhaka', 'Bangladesh', 'SYSTEM');

INSERT INTO organizations (org_code, org_name, org_type, city, country, created_by)
VALUES ('ORG002', 'Dhaka Medical College Hospital', 'HOSPITAL', 'Dhaka', 'Bangladesh', 'SYSTEM');

INSERT INTO organizations (org_code, org_name, org_type, city, country, created_by)
VALUES ('ORG003', 'Lazz Pharma', 'PHARMACY', 'Dhaka', 'Bangladesh', 'SYSTEM');

-- Sample Users
INSERT INTO users (username, email, full_name, org_id, role_code, created_by)
VALUES ('admin', 'admin@medchain.com', 'System Administrator', 1, 'ADMIN', 'SYSTEM');

INSERT INTO users (username, email, full_name, org_id, role_code, created_by)
VALUES ('pharmacist1', 'pharmacist@hospital.com', 'John Pharmacist', 2, 'PHARMACIST', 'SYSTEM');

-- Sample Medicines
INSERT INTO medicine_master (
    medicine_code, generic_name, brand_name, manufacturer_id,
    dosage_form, strength, unit_of_measure, therapeutic_class, created_by
) VALUES (
    'MED0000001', 'Paracetamol', 'Napa', 1,
    'TABLET', '500', 'MG', 'Analgesic', 'SYSTEM'
);

INSERT INTO medicine_master (
    medicine_code, generic_name, brand_name, manufacturer_id,
    dosage_form, strength, unit_of_measure, therapeutic_class, created_by
) VALUES (
    'MED0000002', 'Amoxicillin', 'Amoxil', 1,
    'CAPSULE', '250', 'MG', 'Antibiotic', 'SYSTEM'
);

COMMIT;

-------------------------------------------------------------------------------
-- SECTION 6: SCHEDULED JOBS
-------------------------------------------------------------------------------

-- Daily Expiry Alert Job
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'EXPIRY_ALERT_JOB',
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN alert_pkg.generate_expiry_alerts; END;',
        start_date => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=9',
        enabled => TRUE,
        comments => 'Daily job to generate expiry alerts'
    );
END;
/

-------------------------------------------------------------------------------
-- SECTION 7: VIEWS
-------------------------------------------------------------------------------

-- Active Inventory View
CREATE OR REPLACE VIEW v_active_inventory AS
SELECT 
    i.inventory_id,
    mm.brand_name,
    mm.generic_name,
    mb.batch_number,
    mb.expiry_date,
    TRUNC(mb.expiry_date - SYSDATE) as days_to_expiry,
    l.location_name,
    i.quantity,
    i.available_quantity,
    mb.mrp,
    i.quantity * mb.mrp as total_value
FROM inventory i
JOIN medicine_batches mb ON i.batch_id = mb.batch_id
JOIN medicine_master mm ON mb.medicine_id = mm.medicine_id
JOIN locations l ON i.location_id = l.location_id
WHERE i.quantity > 0
AND mb.batch_status = 'ACTIVE';

-- System Health View
CREATE OR REPLACE VIEW v_system_health AS
SELECT 
    'Total Medicines' as metric,
    TO_CHAR(COUNT(*)) as value
FROM medicine_master
WHERE status = 'ACTIVE'
UNION ALL
SELECT 
    'Active Batches' as metric,
    TO_CHAR(COUNT(*)) as value
FROM medicine_batches
WHERE batch_status = 'ACTIVE'
UNION ALL
SELECT 
    'Total Inventory Value' as metric,
    TO_CHAR(SUM(i.quantity * mb.mrp), '999,999,999.99') as value
FROM inventory i
JOIN medicine_batches mb ON i.batch_id = mb.batch_id
WHERE i.quantity > 0
UNION ALL
SELECT 
    'Active Alerts' as metric,
    TO_CHAR(COUNT(*)) as value
FROM alerts
WHERE status IN ('OPEN', 'ACKNOWLEDGED');

-------------------------------------------------------------------------------
-- SCRIPT COMPLETE
-- 
-- Next Steps:
-- 1. Review and customize organization data
-- 2. Set up APEX application
-- 3. Configure ORDS endpoints
-- 4. Test all triggers and packages
-- 5. Load production data
-- 
-- For support: support@medchain.com
-------------------------------------------------------------------------------
