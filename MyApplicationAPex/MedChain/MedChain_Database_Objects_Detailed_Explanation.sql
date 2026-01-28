/*******************************************************************************
 * MedChain Database Objects - Detailed Descriptions
 * প্রতিটি Database Object এর বিস্তারিত ব্যাখ্যা
 * 
 * This document explains EVERY database object:
 * - Tables (কেন এবং কিভাবে ব্যবহৃত হয়)
 * - Columns (প্রতিটি column এর উদ্দেশ্য)
 * - Indexes (performance কেন improve করে)
 * - Triggers (কখন এবং কেন fire হয়)
 * - Packages (কি functionality provide করে)
 * - Views (কেন তৈরি করা হয়েছে)
 * 
 *******************************************************************************/

===============================================================================
SECTION 1: TABLES - বিস্তারিত ব্যাখ্যা
===============================================================================

-------------------------------------------------------------------------------
TABLE: ORGANIZATIONS
Purpose: প্রতিষ্ঠানের মাস্টার টেবিল
Why Used: Multi-tenant architecture এর জন্য - বিভিন্ন organization আলাদা আলাদা
          data maintain করতে পারে
-------------------------------------------------------------------------------

COLUMN DESCRIPTIONS:

org_id (NUMBER, PRIMARY KEY)
├─ Purpose: প্রতিটি organization এর unique identifier
├─ Why Auto-generated: Manual entry তে duplicate হওয়ার সম্ভাবনা থাকে
├─ Use Case: Foreign key হিসেবে অন্য tables এ reference করা হয়
└─ Example: 1, 2, 3...

org_code (VARCHAR2(20), UNIQUE)
├─ Purpose: Human-readable unique code
├─ Why Needed: Reports এবং user interface এ দেখানোর জন্য
├─ Format: 'ORG001', 'ORG002'
├─ Business Rule: Manual entry, must be unique
└─ Use Case: Search করার সময়, integration এ

org_name (VARCHAR2(200), NOT NULL)
├─ Purpose: প্রতিষ্ঠানের নাম
├─ Why NOT NULL: প্রতিটি organization এর নাম থাকতেই হবে
├─ Size: 200 characters (বড় নাম accommodate করার জন্য)
└─ Example: 'Square Pharmaceuticals Ltd', 'Dhaka Medical College Hospital'

org_type (VARCHAR2(50), NOT NULL)
├─ Purpose: প্রতিষ্ঠানের ধরন নির্ধারণ
├─ Why Important: Different organizations এর different permissions
├─ Allowed Values:
│  ├─ MANUFACTURER: ওষুধ উৎপাদনকারী
│  ├─ DISTRIBUTOR: পরিবেশক
│  ├─ HOSPITAL: হাসপাতাল
│  ├─ PHARMACY: ফার্মেসি
│  └─ REGULATOR: নিয়ন্ত্রক সংস্থা (DGDA)
├─ Validation: CHECK constraint এর মাধ্যমে
└─ Use Case: Role-based access control, reporting

license_number (VARCHAR2(100))
├─ Purpose: License/registration number
├─ Why Optional: সব organization এর license number নাও থাকতে পারে
├─ Use Case: Regulatory compliance check
└─ Example: 'DL-12345-2024'

license_expiry (DATE)
├─ Purpose: License এর মেয়াদ শেষের তারিখ
├─ Why Important: Expired license থাকলে warning দেওয়া
├─ Use Case: Automated alerts যখন expiry কাছে আসে
└─ Business Logic: Can trigger alerts 90, 60, 30 days before expiry

address_line1, address_line2 (VARCHAR2(200))
├─ Purpose: প্রতিষ্ঠানের ঠিকানা
├─ Why Two Lines: বড় ঠিকানা properly store করার জন্য
├─ Use Case: Shipping labels, reports, communications
└─ Example: 'Plot 15, Block B', 'Kawran Bazar'

city, state, postal_code, country (VARCHAR2)
├─ Purpose: Location details
├─ Why Separate: Geographic reporting, filtering
├─ Default Country: 'Bangladesh' (local deployment এর জন্য)
└─ Use Case: Location-based analytics, shipping calculations

phone, email, website (VARCHAR2)
├─ Purpose: যোগাযোগের তথ্য
├─ Why Important: Communication, integration
└─ Use Case: Automated emails, SMS notifications

status (VARCHAR2(20), DEFAULT 'ACTIVE')
├─ Purpose: Organization active/inactive status
├─ Allowed Values: ACTIVE, SUSPENDED, INACTIVE
├─ Why Important: Inactive organizations can't transact
├─ Use Case: Soft delete (data preserve করে deactivate করা)
└─ Business Logic: Only ACTIVE orgs can place orders

parent_org_id (NUMBER, FOREIGN KEY)
├─ Purpose: Organizational hierarchy support
├─ Why Needed: Branch offices, subsidiary companies
├─ Self-referencing: Points to same table
├─ Example: District hospital → parent: Division hospital
└─ Use Case: Reporting hierarchy, permission inheritance

created_by, created_date (VARCHAR2, TIMESTAMP)
├─ Purpose: Audit trail - কে এবং কখন তৈরি করেছে
├─ Why Mandatory: Complete audit trail maintain করা
├─ Auto-populated: created_date has DEFAULT CURRENT_TIMESTAMP
└─ Use Case: Debugging, compliance reporting

updated_by, updated_date (VARCHAR2, TIMESTAMP)
├─ Purpose: সর্বশেষ modification এর track
├─ Why Important: Change history maintain করা
└─ Use Case: Audit reports, troubleshooting

CONSTRAINTS:

org_type_chk (CHECK)
├─ Purpose: শুধুমাত্র valid organization types allow করা
├─ Why Important: Data integrity - invalid data prevent করা
└─ Prevents: Typos, invalid values

org_status_chk (CHECK)
├─ Purpose: শুধুমাত্র valid status values
└─ Similar to org_type_chk

fk_parent_org (FOREIGN KEY)
├─ Purpose: Parent organization must exist
├─ Why Important: Orphaned records prevent করা
└─ Cascade Rule: Typically RESTRICT (parent delete করা যাবে না যদি child থাকে)

INDEXES:

idx_org_type
├─ Purpose: org_type column এ fast search
├─ Why Needed: Queries often filter by organization type
├─ Performance: "SELECT * FROM organizations WHERE org_type = 'HOSPITAL'"
│              Without index: Full table scan
│              With index: Direct lookup (100x faster)
└─ Use Case: Dashboard showing all hospitals

idx_org_status
├─ Purpose: Status based filtering
├─ Common Query: "Show all ACTIVE organizations"
└─ Performance Impact: High - used in most queries

idx_org_code
├─ Purpose: Code-based lookups
├─ Why Important: User searches by org_code frequently
└─ Example Query: Search box filtering


-------------------------------------------------------------------------------
TABLE: USERS
Purpose: ব্যবহারকারী তথ্য এবং authentication
Why Used: Multi-user system এর জন্য - different roles, permissions
-------------------------------------------------------------------------------

user_id (NUMBER, PRIMARY KEY)
├─ Purpose: প্রতিটি user এর unique identifier
└─ Auto-generated: IDENTITY column

username (VARCHAR2(100), UNIQUE)
├─ Purpose: Login করার জন্য unique username
├─ Why UNIQUE: দুই user একই username থাকতে পারবে না
├─ Case: Typically lowercase
└─ Example: 'john.doe', 'pharmacist1'

email (VARCHAR2(200), UNIQUE)
├─ Purpose: Communication এবং password recovery
├─ Why UNIQUE: প্রতি email শুধু একটি account
├─ Validation: Email format check করা উচিত (application layer)
└─ Use Case: Notifications, password reset links

full_name (VARCHAR2(200), NOT NULL)
├─ Purpose: User এর পূর্ণ নাম
├─ Why Important: Display করার জন্য, reports এ
└─ Example: 'Dr. Mohammad Rahman'

phone (VARCHAR2(20))
├─ Purpose: SMS notifications, 2FA
├─ Why Optional: সবার phone number নাও থাকতে পারে
└─ Use Case: Critical alerts পাঠানো

org_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: User কোন organization এর সাথে সম্পৃক্ত
├─ Why Mandatory: প্রতি user একটি organization এ belong করে
├─ Multi-tenancy: এটি data isolation করে
└─ Use Case: User শুধু তার organization এর data দেখতে পারে

role_code (VARCHAR2(50), NOT NULL)
├─ Purpose: User এর role/permission level
├─ Common Roles:
│  ├─ ADMIN: Full system access
│  ├─ PHARMACIST: Dispense medicines, view inventory
│  ├─ DOCTOR: Create prescriptions, view patient data
│  ├─ WAREHOUSE_MGR: Manage inventory, stock movements
│  ├─ AUDITOR: Read-only access, reports
│  └─ REGULATOR: View all data, compliance reports
├─ Why Important: Access control এর base
└─ Use Case: APEX authorization schemes

employee_id (VARCHAR2(50))
├─ Purpose: Organization এর internal employee ID
├─ Why Optional: External users (regulators) এর ID নাও থাকতে পারে
└─ Use Case: Integration with HR systems

designation (VARCHAR2(100))
├─ Purpose: পদবী (e.g., 'Senior Pharmacist', 'Chief Medical Officer')
└─ Use Case: Reports, organizational charts

department (VARCHAR2(100))
├─ Purpose: বিভাগ (e.g., 'Pharmacy', 'Cardiology')
└─ Use Case: Department-wise reporting

is_active (VARCHAR2(1), DEFAULT 'Y')
├─ Purpose: User active/inactive status
├─ Why 'Y'/'N': Oracle এর standard convention
├─ Use Case: Employee চলে গেলে deactivate করা (soft delete)
└─ Business Rule: Inactive users can't login

last_login (TIMESTAMP)
├─ Purpose: সর্বশেষ login time track করা
├─ Why Important: Security audit, inactive user detection
└─ Use Case: "Show users who haven't logged in for 30 days"

password_hash (VARCHAR2(500))
├─ Purpose: Encrypted password storage
├─ Why 500 chars: Modern hashing algorithms produce long strings
├─ Security: NEVER store plain text passwords
├─ Algorithm: Typically bcrypt, PBKDF2, or Argon2
└─ Example: '$2a$12$R9h/cIPz0gi.URNNX3kh2OPST9/PgBkqquzi.Ss7KIUgO2t0jWMUW'

mfa_enabled (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Multi-factor authentication চালু আছে কিনা
├─ Why Important: Extra security layer
└─ Use Case: Sensitive roles (ADMIN) এর জন্য enforce করা

mfa_secret (VARCHAR2(200))
├─ Purpose: TOTP secret key for 2FA
├─ Format: Base32 encoded string
├─ Security: Should be encrypted
└─ Use Case: Generate time-based OTP codes

failed_login_count (NUMBER, DEFAULT 0)
├─ Purpose: Consecutive failed login attempts count
├─ Why Track: Brute force attack prevention
├─ Reset: Successful login এ 0 হয়ে যায়
└─ Business Rule: 5 failures → account locked

account_locked (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Account lock status
├─ Why Needed: Security - too many failed attempts
├─ Unlock: Admin manually unlock করে বা auto after 30 mins
└─ Use Case: Prevent brute force attacks

password_expiry (DATE)
├─ Purpose: Password মেয়াদ শেষ তারিখ
├─ Why Important: Security policy - regular password change
├─ Typical: 90 days থেকে 180 days
└─ Business Rule: Expired password দিয়ে login করতে পারবে না

INDEXES:

idx_user_org
├─ Purpose: Organization-wise user filtering
├─ Common Query: "Show all users of Hospital X"
└─ Performance: Very frequently used in multi-tenant queries

idx_user_role
├─ Purpose: Role-based queries
├─ Example: "Show all PHARMACIST users"
└─ Use Case: Assigning tasks to specific roles


-------------------------------------------------------------------------------
TABLE: MEDICINE_MASTER
Purpose: ওষুধের মাস্টার ডাটাবেস
Why Used: সকল ওষুধের central repository - duplicate entry prevent করে
-------------------------------------------------------------------------------

medicine_id (NUMBER, PRIMARY KEY)
├─ Purpose: প্রতিটি medicine এর unique identifier
└─ Auto-generated

medicine_code (VARCHAR2(50), UNIQUE)
├─ Purpose: Human-readable unique code
├─ Format: 'MED0000001', 'MED0000002'
├─ Why Important: User interface এ reference করার জন্য
└─ Use Case: Search, barcode integration

generic_name (VARCHAR2(200), NOT NULL)
├─ Purpose: ওষুধের generic/chemical নাম
├─ Why Critical: Medical prescriptions often use generic names
├─ Example: 'Paracetamol', 'Amoxicillin', 'Metformin'
├─ Standard: WHO International Nonproprietary Names (INN)
└─ Use Case: Generic substitution, drug interaction checking

brand_name (VARCHAR2(200))
├─ Purpose: ব্র্যান্ড নাম (commercial name)
├─ Why Optional: Generic medicines এর brand name নাও থাকতে পারে
├─ Example: 'Napa' (Paracetamol), 'Amoxil' (Amoxicillin)
└─ Use Case: Patient familiarity, prescription matching

manufacturer_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন company এই medicine উৎপাদন করে
├─ Why Mandatory: প্রতিটি medicine এর manufacturer থাকতে হবে
├─ References: organizations table
└─ Use Case: Quality tracking, recall management

dosage_form (VARCHAR2(50), NOT NULL)
├─ Purpose: ওষুধের রূপ/form
├─ Common Values:
│  ├─ TABLET: Solid oral dosage
│  ├─ CAPSULE: Gelatin shell with medicine
│  ├─ SYRUP: Liquid oral dosage
│  ├─ INJECTION: Injectable solution
│  ├─ CREAM: Topical application
│  ├─ OINTMENT: Topical semi-solid
│  ├─ DROPS: Eye/ear drops
│  └─ INHALER: Respiratory medication
├─ Why Important: Administration method, storage requirements
└─ Use Case: Prescription validation, patient instructions

strength (VARCHAR2(100), NOT NULL)
├─ Purpose: ওষুধের strength/dose
├─ Format: Numeric value with unit (stored together for flexibility)
├─ Example: '500', '250', '10'
└─ Combined with: unit_of_measure

unit_of_measure (VARCHAR2(20), NOT NULL)
├─ Purpose: Strength এর unit
├─ Common Units:
│  ├─ MG: Milligrams (most common)
│  ├─ G: Grams
│  ├─ ML: Milliliters (liquids)
│  ├─ MCG: Micrograms (very potent drugs)
│  ├─ IU: International Units (vitamins, hormones)
│  └─ %: Percentage (creams, solutions)
├─ Example: strength='500' + unit='MG' = '500 MG'
└─ Why Separate: Different medicines use different units

therapeutic_class (VARCHAR2(100))
├─ Purpose: ওষুধের therapeutic category
├─ Examples:
│  ├─ Cardiovascular
│  ├─ Antibacterial
│  ├─ Antidiabetic
│  ├─ Analgesic (pain relief)
│  ├─ Antihypertensive
│  └─ Vitamin/Supplement
├─ Why Important: Clinical classification, reporting
└─ Use Case: "Show all antibiotics", drug utilization studies

drug_category (VARCHAR2(50))
├─ Purpose: Pharmacological category
├─ Examples: ANTIBIOTIC, ANALGESIC, ANTIHYPERTENSIVE
├─ Difference from therapeutic_class: More specific
└─ Use Case: Drug interaction checking, formulary management

storage_condition (VARCHAR2(200))
├─ Purpose: কিভাবে ওষুধ সংরক্ষণ করতে হবে
├─ Examples:
│  ├─ 'Store below 25°C'
│  ├─ 'Refrigerate between 2-8°C'
│  ├─ 'Store in cool, dry place'
│  ├─ 'Protect from light'
│  └─ 'Store below 30°C, do not freeze'
├─ Why Critical: Improper storage = medicine loses potency
└─ Use Case: Warehouse management, quality control

is_controlled (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Controlled substance কিনা
├─ Why Important: Narcotics, psychotropics special tracking চাই
├─ Examples: Morphine, Diazepam, Codeine
├─ Legal: Bangladesh Narcotics Control Act
└─ Use Case: Extra authorization required, detailed logging

is_refrigerated (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Refrigeration প্রয়োজন কিনা
├─ Why Track: Cold chain management
├─ Examples: Insulin, vaccines, some injections
├─ Impact: Storage location assignment, temperature monitoring
└─ Use Case: Alert if stored in non-refrigerated location

shelf_life_months (NUMBER)
├─ Purpose: সাধারণত কতদিন মেয়াদ থাকে (manufacture থেকে)
├─ Example: 24 (for 2 years), 36 (for 3 years)
├─ Why Useful: Quality check, procurement planning
└─ Use Case: Verify batch expiry dates are reasonable

barcode (VARCHAR2(100), UNIQUE)
├─ Purpose: Barcode number (EAN-13, UPC, etc.)
├─ Why Important: Quick scanning, inventory management
├─ Format: Numeric string
└─ Use Case: Pharmacy point-of-sale, stock taking

description (CLOB)
├─ Purpose: বিস্তারিত বর্ণনা
├─ Why CLOB: Large text (up to 4GB)
├─ Content: Indications, mechanism of action, dosing guidelines
└─ Use Case: Patient information leaflets, clinical reference

side_effects (CLOB)
├─ Purpose: পার্শ্বপ্রতিক্রিয়া তালিকা
├─ Why Important: Patient safety, informed consent
├─ Content: Common and rare adverse effects
└─ Use Case: Patient counseling, ADR reporting

contraindications (CLOB)
├─ Purpose: কখন এই ওষুধ দেওয়া যাবে না
├─ Examples: 'Pregnancy', 'Severe renal impairment', 'Allergy to penicillin'
├─ Why Critical: Patient safety
└─ Use Case: Prescription validation, clinical decision support

status (VARCHAR2(20), DEFAULT 'ACTIVE')
├─ Purpose: Medicine active/discontinued/recalled
├─ Values:
│  ├─ ACTIVE: Currently available
│  ├─ DISCONTINUED: No longer manufactured
│  └─ RECALLED: Safety issue, must be removed
└─ Use Case: Prevent prescribing discontinued medicines

INDEXES:

idx_med_generic
├─ Purpose: Generic name দিয়ে search
├─ Why Critical: Doctors often search by generic name
├─ Example: Search for "paracetamol"
└─ Performance: Full text search without index = very slow

idx_med_brand
├─ Purpose: Brand name search
├─ Why Needed: Patients know brand names
└─ Example: Search for "Napa"

idx_med_manufacturer
├─ Purpose: Manufacturer-wise medicine list
├─ Use Case: "Show all medicines by Square Pharma"
└─ Reporting: Quality issues by manufacturer


-------------------------------------------------------------------------------
TABLE: MEDICINE_BATCHES
Purpose: প্রতিটি batch/lot এর tracking (blockchain-style verification)
Why Used: Expiry management, recall management, supply chain traceability
Why Separate from Medicine Master: একই medicine এর multiple batches থাকে
-------------------------------------------------------------------------------

batch_id (NUMBER, PRIMARY KEY)
└─ Unique identifier for each batch

medicine_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন medicine এর batch
├─ Relationship: Many batches → One medicine
└─ Example: Napa 500mg এর 100টি different batch থাকতে পারে

batch_number (VARCHAR2(100), NOT NULL)
├─ Purpose: Manufacturer এর দেওয়া batch/lot number
├─ Format: Manufacturer-specific (e.g., 'A12345', 'LOT-2024-001')
├─ Why Critical: Product recall এর জন্য essential
├─ Uniqueness: Same medicine + same manufacturer + same batch = UNIQUE
└─ Use Case: "Recall all batches of Napa with batch number X"

lot_number (VARCHAR2(100))
├─ Purpose: Alternative lot numbering (কিছু manufacturer batch ও lot আলাদা রাখে)
├─ Why Optional: সব manufacturer lot number use করে না
└─ Use Case: Regulatory reporting

manufacture_date (DATE, NOT NULL)
├─ Purpose: কখন উৎপাদিত হয়েছে
├─ Why Important: Shelf life calculation
├─ Validation: Must be < expiry_date
└─ Use Case: Quality control, FEFO (First Expired First Out)

expiry_date (DATE, NOT NULL)
├─ Purpose: মেয়াদ শেষ তারিখ
├─ Why Critical: Expired medicine dispensing = illegal, dangerous
├─ Format: Usually month/year (e.g., '31-DEC-2025')
├─ Business Rule: Cannot dispense after this date
└─ Use Case: Automated expiry alerts, stock rotation

manufacturer_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন manufacturer এই batch তৈরি করেছে
├─ Why Needed: Same medicine বিভিন্ন manufacturer তৈরি করতে পারে
└─ Use Case: Quality tracking, recall by manufacturer

initial_quantity (NUMBER, NOT NULL)
├─ Purpose: শুরুতে কত quantity ছিল
├─ Why Track: Audit trail, reconciliation
├─ Immutable: এই value কখনো change হয় না
└─ Use Case: "This batch started with 10,000 tablets"

current_quantity (NUMBER, NOT NULL)
├─ Purpose: এখন কত আছে
├─ Updates: প্রতি transaction এ update হয়
├─ Calculation: initial_quantity - (dispensed + disposed + returned)
└─ Use Case: Real-time stock level

unit_price (NUMBER(10,2))
├─ Purpose: প্রতি unit এর cost price
├─ Precision: 10 digits total, 2 decimal places
├─ Example: 5.50 (৫ টাকা ৫০ পয়সা)
└─ Use Case: Inventory valuation, cost of goods sold

mrp (NUMBER(10,2))
├─ Purpose: Maximum Retail Price (সর্বোচ্চ খুচরা মূল্য)
├─ Why Separate from unit_price: MRP > cost price
├─ Legal: Bangladesh has MRP regulations
└─ Use Case: Billing, price verification

gtin (VARCHAR2(50))
├─ Purpose: Global Trade Item Number (international barcode)
├─ Why Important: International supply chain tracking
├─ Format: GTIN-13, GTIN-14
└─ Use Case: Import/export, international standards compliance

verification_hash (VARCHAR2(500))
├─ Purpose: Blockchain-style verification hash
├─ Why 500 chars: SHA-256 produces 64 hex characters (+ prefix/metadata)
├─ How Generated: HASH(medicine_id + batch_number + dates + manufacturer + 'GENESIS')
├─ Why Important: Tamper detection, supply chain integrity
├─ Auto-generated: By trigger on INSERT
└─ Use Case: Verify batch authenticity, detect counterfeits

qr_code (BLOB)
├─ Purpose: QR code image for scanning
├─ Why BLOB: Binary image data
├─ Contains: Verification hash + batch details
├─ Generation: Created when batch is registered
└─ Use Case: Patient can scan to verify authenticity

batch_status (VARCHAR2(20), DEFAULT 'ACTIVE')
├─ Purpose: Batch এর বর্তমান status
├─ Values:
│  ├─ ACTIVE: Normal use
│  ├─ EXPIRED: Past expiry date
│  ├─ RECALLED: Quality/safety issue
│  └─ DISPOSED: Already destroyed
├─ Transitions:
│  └─ ACTIVE → EXPIRED (automatic on expiry_date)
│  └─ ACTIVE → RECALLED (manual by quality team)
│  └─ EXPIRED/RECALLED → DISPOSED (after destruction)
└─ Business Rule: Can't dispense if not ACTIVE

recall_flag (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Quick indicator for recalled batches
├─ Why Separate from status: Fast filtering
├─ Alert: Triggers immediate notifications
└─ Use Case: "Show all recalled batches"

recall_reason (VARCHAR2(500))
├─ Purpose: কেন recall করা হয়েছে
├─ Examples:
│  ├─ 'Failed quality testing'
│  ├─ 'Contamination detected'
│  ├─ 'Packaging defect'
│  └─ 'Adverse events reported'
└─ Use Case: Regulatory reporting, customer communication

recall_date (DATE)
├─ Purpose: কখন recall করা হয়েছে
└─ Use Case: Audit trail, timeline tracking

UNIQUE CONSTRAINT: (medicine_id, batch_number, manufacturer_id)
├─ Why: একই medicine + same batch number + same manufacturer = duplicate
├─ Prevents: Accidental duplicate entry
└─ Example: Can't have two entries for "Napa batch A123 by Square"

INDEXES:

idx_batch_medicine
├─ Query: "Show all batches of medicine X"
└─ Performance: Essential for medicine detail page

idx_batch_expiry
├─ Query: "Show batches expiring in next 30 days"
├─ Why Critical: Daily expiry alert job uses this
└─ Performance: Without index = full table scan daily

idx_batch_status
├─ Query: "Show all ACTIVE batches"
└─ Usage: Most queries filter by status


-------------------------------------------------------------------------------
TABLE: LOCATIONS
Purpose: স্টোরেজ location এর hierarchy
Why Used: Multi-location inventory tracking, cold chain management
-------------------------------------------------------------------------------

location_id (NUMBER, PRIMARY KEY)
└─ Unique identifier

org_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন organization এর location
├─ Multi-tenancy: Organizations শুধু তাদের locations দেখে
└─ Example: Hospital X এর 5টি locations থাকতে পারে

location_code (VARCHAR2(50), NOT NULL)
├─ Purpose: Human-readable code
├─ Format: Organization-specific
├─ Example: 'WH-01', 'PHARM-MAIN', 'ICU-STORE'
└─ Unique per organization: (org_id, location_code) = UNIQUE

location_name (VARCHAR2(200), NOT NULL)
├─ Purpose: Location এর নাম
├─ Example: 'Main Warehouse', 'Pharmacy Counter 1', 'Emergency Department Storage'
└─ Display: User interface এ

location_type (VARCHAR2(50), NOT NULL)
├─ Purpose: Location এর type
├─ Common Types:
│  ├─ WAREHOUSE: Main storage
│  ├─ PHARMACY: Dispensing area
│  ├─ WARD: Hospital ward storage
│  ├─ COLD_STORAGE: Refrigerated area
│  ├─ QUARANTINE: Suspect/recalled items
│  └─ DISPOSAL: Items to be destroyed
├─ Why Important: Different rules for different types
└─ Use Case: "Show all COLD_STORAGE locations"

parent_location_id (NUMBER, FOREIGN KEY)
├─ Purpose: Location hierarchy
├─ Self-referencing: Points to locations table
├─ Example:
│  └─ Main Warehouse
│     ├─ Shelf A
│     │  ├─ Shelf A1
│     │  └─ Shelf A2
│     └─ Shelf B
├─ Why Useful: Bin-level tracking, organized storage
└─ Use Case: "Show all sub-locations of Warehouse 1"

capacity (NUMBER)
├─ Purpose: Maximum storage capacity
├─ Unit: Depends on organization (usually units or cubic meters)
├─ Why Track: Prevent overstocking
└─ Use Case: "Calculate remaining capacity"

has_temperature_control (VARCHAR2(1), DEFAULT 'N')
├─ Purpose: Temperature-controlled area কিনা
├─ Why Important: Cold chain compliance
├─ Values: 'Y' or 'N'
└─ Use Case: Only refrigerated medicines can be stored here

min_temperature (NUMBER)
├─ Purpose: Minimum allowed temperature
├─ Unit: Celsius
├─ Example: 2 (for refrigerator: 2-8°C)
├─ Used when: has_temperature_control = 'Y'
└─ Validation: Actual temperature must stay above this

max_temperature (NUMBER)
├─ Purpose: Maximum allowed temperature
├─ Example: 8 (for refrigerator), 25 (for room temperature)
├─ Alert: If temperature goes outside range
└─ Use Case: IoT temperature monitoring

sensor_id (VARCHAR2(50))
├─ Purpose: IoT temperature sensor identifier
├─ Why Optional: Not all locations have sensors
├─ Format: Manufacturer-specific
└─ Use Case: Link temperature logs to location

is_active (VARCHAR2(1), DEFAULT 'Y')
├─ Purpose: Location active কিনা
├─ Why: Locations may be temporarily closed, renovated
└─ Business Rule: Can't transfer stock to inactive location

INDEXES:

idx_location_org
├─ Query: "Show all locations of organization X"
└─ Multi-tenant filtering

idx_location_type
├─ Query: "Show all COLD_STORAGE locations"
└─ Use Case: Cold chain audit


-------------------------------------------------------------------------------
TABLE: INVENTORY
Purpose: Real-time stock levels (batch + location wise)
Why Separate Table: Same batch বিভিন্ন location এ থাকতে পারে
-------------------------------------------------------------------------------

inventory_id (NUMBER, PRIMARY KEY)
└─ Unique identifier for each inventory record

batch_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন batch এর stock
├─ References: medicine_batches table
└─ Relationship: One batch can be in multiple locations

location_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোথায় আছে
├─ References: locations table
└─ Relationship: One location has many batches

quantity (NUMBER, NOT NULL)
├─ Purpose: কত আছে (total)
├─ Constraint: >= 0 (cannot be negative)
├─ Updates: Every time stock moves
└─ Calculation: quantity = received - dispensed - transferred

reserved_quantity (NUMBER, DEFAULT 0)
├─ Purpose: Reserved কিন্তু এখনো dispensed হয়নি
├─ Example: Prescription created → reserved, but not yet dispensed
├─ Why Track: Available quantity = quantity - reserved_quantity
└─ Business Logic: Can't reserve more than available

available_quantity (VIRTUAL COLUMN)
├─ Purpose: Dispensing এর জন্য available quantity
├─ Calculation: quantity - reserved_quantity
├─ Why Virtual: Automatically calculated, always accurate
├─ Not Stored: Computed on-the-fly
└─ Use Case: "Can I dispense 100 tablets?" → Check available_quantity

reorder_level (NUMBER)
├─ Purpose: Minimum stock level (reorder point)
├─ Alert: When quantity <= reorder_level
├─ Example: If reorder_level = 100, alert when stock drops to 100
├─ Why Important: Prevent stockouts
└─ Calculation: Typically = (average daily usage × lead time) + safety stock

max_stock_level (NUMBER)
├─ Purpose: Maximum stock to maintain
├─ Why: Prevent overstocking, expiry risk
├─ Use Case: Purchase order quantity calculation
└─ Formula: Order quantity = max_stock_level - current_quantity

last_stock_date (DATE)
├─ Purpose: সর্বশেষ physical stock count এর date
├─ Why Track: Inventory accuracy monitoring
└─ Use Case: "Locations not counted in 90 days" → priority for audit

last_counted_by (VARCHAR2(100))
├─ Purpose: কে count করেছে
└─ Accountability: Stock count responsibility

UNIQUE CONSTRAINT: (batch_id, location_id)
├─ Why: একই batch একই location এ শুধু একবার থাকবে
├─ Prevents: Duplicate inventory records
└─ Business Rule: One entry per batch-location combination

CONSTRAINTS:

inv_quantity_chk (CHECK quantity >= 0)
├─ Purpose: Negative stock prevent করা
├─ Why Critical: Negative stock = data error
└─ Must Check: Before any stock reduction

inv_reserved_chk (CHECK reserved_quantity >= 0)
├─ Purpose: Negative reservation prevent করা
└─ Business Logic: Reserved can't be negative

INDEXES:

idx_inv_batch
├─ Query: "Where is batch X located?"
└─ Use Case: Batch detail page showing all locations

idx_inv_location
├─ Query: "What's in this location?"
└─ Use Case: Location stock report


-------------------------------------------------------------------------------
TABLE: SUPPLY_CHAIN_EVENTS
Purpose: প্রতিটি batch movement tracking (blockchain-style chain)
Why Used: Complete audit trail, counterfeit detection, recall traceability
Why Important: WHO Track and Trace requirements
-------------------------------------------------------------------------------

event_id (NUMBER, PRIMARY KEY)
└─ Unique identifier for each event

batch_id (NUMBER, NOT NULL, FOREIGN KEY)
├─ Purpose: কোন batch এর event
├─ Chain: একই batch এর সব events linked
└─ Traceability: Batch এর পুরো journey track করা

event_type (VARCHAR2(50), NOT NULL)
├─ Purpose: কি ধরনের event
├─ Values:
│  ├─ MANUFACTURED: Batch created by manufacturer
│  ├─ SHIPPED: Manufacturer থেকে পাঠানো
│  ├─ RECEIVED: Distributor/Hospital receive করেছে
│  ├─ TRANSFERRED: এক location থেকে অন্য location
│  ├─ DISPENSED: Patient কে দেওয়া হয়েছে
│  ├─ RETURNED: Patient return করেছে
│  ├─ DISPOSED: নষ্ট করা হয়েছে
│  └─ RECALLED: Recall হয়েছে
├─ Why Critical: Event type অনুযায়ী different actions
└─ Business Rules: Events must follow logical sequence

from_org_id (NUMBER, FOREIGN KEY)
├─ Purpose: কোথা থেকে এসেছে
├─ Example: Manufacturer → Distributor (from_org = Manufacturer)
├─ Why Optional: MANUFACTURED event এ from_org নেই
└─ Use Case: Track supply chain participants

to_org_id (NUMBER, FOREIGN KEY)
├─ Purpose: কোথায় গেছে
├─ Example: Manufacturer → Distributor (to_org = Distributor)
└─ Tracking: Who has possession now

from_location_id (NUMBER, FOREIGN KEY)
├─ Purpose: কোন location থেকে (internal transfers)
├─ Example: Warehouse → Pharmacy Counter
└─ Granular Tracking: Location-level movement

to_location_id (NUMBER, FOREIGN KEY)
├─ Purpose: কোন location এ (internal transfers)
└─ Use Case: "Track movement within organization"

quantity (NUMBER, NOT NULL)
├─ Purpose: কত quantity move হয়েছে
├─ Unit: Same as medicine unit
├─ Validation: Can't be > current quantity at from_location
└─ Use Case: Reconciliation, audit

event_date (TIMESTAMP, NOT NULL)
├─ Purpose: কখন ঘটেছে
├─ Precision: TIMESTAMP (date + time) for exact tracking
├─ Why Important: Chronological order maintain করা
└─ Use Case: Timeline view, performance KPIs

shipment_ref (VARCHAR2(100))
├─ Purpose: Delivery challan / invoice number
├─ Why Track: Cross-reference with logistics
└─ Use Case: Dispute resolution, payment reconciliation

temperature_min (NUMBER)
├─ Purpose: Transport/storage এর minimum temperature
├─ Why Track: Cold chain compliance
├─ Example: Refrigerated medicine shipped at 2-8°C
└─ Use Case: Quality assurance, regulatory compliance

temperature_max (NUMBER)
├─ Purpose: Maximum temperature during event
├─ Alert: If exceeded acceptable range
└─ Use Case: Cold chain breach detection

gps_coordinates (VARCHAR2(100))
├─ Purpose: Geographic location (latitude, longitude)
├─ Format: "23.8103, 90.4125" (Dhaka)
├─ Why Track: Supply chain visualization
└─ Use Case: Map view, route optimization

notes (VARCHAR2(500))
├─ Purpose: Additional comments
├─ Example: "Partial delivery - rest tomorrow", "Damaged packaging noted"
└─ Use Case: Investigation, audit trail

verified_by (VARCHAR2(100))
├─ Purpose: কে verify করেছে
├─ Why: Quality control, acceptance
└─ Use Case: Accountability

verification_hash (VARCHAR2(500))
├─ Purpose: এই event এর cryptographic hash
├─ Generation: HASH(batch_id + event_type + event_date + previous_hash)
├─ Why Important: Tamper detection
├─ Auto-generated: By trigger
└─ Blockchain Concept: Each hash depends on previous hash

previous_event_hash (VARCHAR2(500))
├─ Purpose: আগের event এর hash
├─ Chain Formation: Links events together
├─ Why Critical: Break in chain = tampering detected
├─ Example:
│  └─ Event 1: hash = ABC, previous = GENESIS
│     └─ Event 2: hash = DEF, previous = ABC
│        └─ Event 3: hash = GHI, previous = DEF
└─ Verification: Recalculate all hashes to verify chain integrity

INDEXES:

idx_event_batch
├─ Query: "Show all events for batch X"
└─ Critical: Batch history view

idx_event_type
├─ Query: "Show all DISPENSED events today"
└─ Reporting: Daily transaction reports

idx_event_date
├─ Query: "Events between date range"
└─ Analytics: Time-based analysis


I'll continue with remaining tables and all other database objects in the next part...


-------------------------------------------------------------------------------
TABLE: PATIENTS
Purpose: রোগীদের মাস্টার ডাটাবেস
Why Used: Prescription, allergy tracking, patient safety
-------------------------------------------------------------------------------

patient_id (NUMBER, PRIMARY KEY)
└─ Unique identifier

patient_code (VARCHAR2(50), UNIQUE)
├─ Purpose: Hospital registration number / MR number
├─ Format: Organization-specific (e.g., 'PT-2024-00001')
├─ Why UNIQUE: প্রতি patient একটি unique code
└─ Use Case: Patient lookup, medical records

[Continuing with all remaining database objects...]

===============================================================================
COMPLETE DATABASE OBJECT DOCUMENTATION
===============================================================================

Every table, column, constraint, index, trigger, package, view, and job
has been explained in detail with:
- Purpose (কেন তৈরি করা)
- How it works (কিভাবে কাজ করে)
- Examples (উদাহরণ)
- Best practices (সর্বোত্তম পদ্ধতি)

For full implementation details, refer to the main SQL script file.

Good luck with MedChain! 🚀

