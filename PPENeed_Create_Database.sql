/* ******************************************************************************
	FILE: PPENeed_Create_Database.sql
    DATE: 2020-05-15
    AUTHOR: Melissa Isaacson
    DESCRIPTION:
		Database creation script for the PPENeed site.
****************************************************************************** */
DROP DATABASE IF EXISTS PPENeedDB;
CREATE DATABASE PPENeedDB;
USE PPENeedDB;


/* ******************************************************************************
	CREATE TABLE PersonRole
****************************************************************************** */
DROP TABLE IF EXISTS PersonRole;
CREATE TABLE PersonRole (
	RoleId int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate key for the role table.'
    , RoleType varchar(50) NOT NULL DEFAULT 'Guest' COMMENT 'Type of role for a user. Defaults to ''Guest''.'
) COMMENT 'The role table.'
;

/* ******************************************************************************
	CREATE TABLE Person
****************************************************************************** */
DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
	PersonId int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'The surrogate id for the person table.'
    , Username varchar(256) NOT NULL UNIQUE COMMENT 'This person''s username.'
    , PersonPassword varchar(1000) NOT NULL COMMENT 'This person''s password (hashed).'
    , FirstName varchar(256) NULL COMMENT 'This person''s first name.'
    , LastName varchar(256) NULL COMMENT 'This person''s last name.'
    , Email varchar(256) NULL COMMENT 'This person''s e-mail.'
    , Occupation varchar(256) NULL COMMENT 'This person''s occupation.'
    , RoleId int unsigned NOT NULL COMMENT 'This person''s role on the site. Refers to the Role table.'
    , DateDeactivated date NULL COMMENT 'Date this person was deactivated. If null, means not deactivated.'
    , CONSTRAINT fk_PersonRoleId_PersonRoleRoleId
		FOREIGN KEY (RoleId) REFERENCES PersonRole(RoleId)
) COMMENT 'Table for a person.'
;

/* ******************************************************************************
	CREATE TABLE State
****************************************************************************** */
DROP TABLE IF EXISTS State;
CREATE TABLE State (
	StateAbbreviation char(2) NOT NULL PRIMARY KEY COMMENT 'Full name of state.'
    , State varchar(60) NOT NULL UNIQUE COMMENT 'State abbreviation.'
) COMMENT 'Table for states.'
;

/* ******************************************************************************
	CREATE TABLE ZipCode
****************************************************************************** */
DROP TABLE IF EXISTS ZipCode;
CREATE TABLE ZipCode (
	ZipCode char(5) NOT NULL PRIMARY KEY COMMENT 'A zipcode for an address.'
    , City varchar(256) NOT NULL COMMENT 'A city belonging to a zipcode.'
    , StateAbbreviation char(2) NOT NULL COMMENT 'A state belonging to a zipcode. Refers to the State table.'
    , CONSTRAINT fk_StateAbbreviation_StateStateAbbreviation
		FOREIGN KEY (StateAbbreviation) REFERENCES State(StateAbbreviation)
) COMMENT 'Table for zipcode.'
;

/* ******************************************************************************
	CREATE TABLE Address
****************************************************************************** */
DROP TABLE IF EXISTS Address;
CREATE TABLE Address (
	AddressId int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate key for an address.'
    , AddressLine1 varchar(256) NOT NULL COMMENT 'First line of an address.'
    , AddressLine2 varchar(256) NULL DEFAULT NULL COMMENT 'Second line of an address.'
    , ZipCode char(5) NOT NULL COMMENT 'Zipcode for an address. Refers to the Zipcode table.'
    , DateStarted date NOT NULL COMMENT 'Date this address was listed.'
    , DateEnded date NULL COMMENT 'Date this address was unlisted. If not null, means the address is no longer active.'
    , CONSTRAINT fk_ZipCodeAddress_ZipCodeZipCode
		FOREIGN KEY (ZipCode) REFERENCES ZipCode(ZipCode)
) COMMENT 'Table for addresses.'
;

/* ******************************************************************************
	CREATE TABLE Phone
****************************************************************************** */
DROP TABLE IF EXISTS Phone;
CREATE TABLE Phone (
	PhoneNumber varchar(10) NOT NULL PRIMARY KEY COMMENT 'A phone number.'
    , CountryCode char(1) NOT NULL DEFAULT '1' COMMENT 'Country code for a phone number.'
    , PhoneType varchar(256) NOT NULL COMMENT 'The type of phone.'
    , StartDate date NOT NULL COMMENT 'The date the phone started.'
    , EndDate date NULL COMMENT 'The date this number was deactivated. If not null, means the number is no longer active.'
) COMMENT 'Phone number table.'
;

/* ******************************************************************************
	CREATE TABLE Provider
****************************************************************************** */
DROP TABLE IF EXISTS Provider;
CREATE TABLE Provider (
	ProviderId int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate key for a healthcare provider.'
    , ProviderName varchar(256) NOT NULL COMMENT 'Name of a healthcare provider.'
    , AddressId int unsigned NOT NULL COMMENT 'AddressId for a healthcare provider. Refers to the Address table.'
    , PhoneNumber varchar(10) NOT NULL COMMENT 'Phone number for a healthcare provider. Refers to the Phone table.'
    , Email varchar(256) NOT NULL COMMENT 'E-mail address for a healthcare providers.'
    , DateStarted date NOT NULL COMMENT 'Date this healthcare provider was listed.'
    , UserStarted varchar(256) NOT NULL COMMENT 'User who added this entry.'
    , DateDeactivated date NULL COMMENT 'Date this healthcare provider was unlisted. If not null, means this listing is no longer active.'
    , LastEdited datetime NULL COMMENT 'Date this listing was last edited. If not null, means this listing has been edited.'
    , EditedBy varchar(256) NULL COMMENT 'The user who made the edit. If not null, means this listing has been edited. Refers to the person table.'
    , CONSTRAINT fk_ProviderAddressId_AddressAddressId
		FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
	, CONSTRAINT fk_ProviderPhoneNumber_PhonePhoneNumber
		FOREIGN KEY (PhoneNumber) REFERENCES Phone(PhoneNumber)
	, CONSTRAINT fk_ProviderUserStarted_PersonUsername
		FOREIGN KEY (UserStarted) REFERENCES Person(Username)
	, CONSTRAINT fk_ProviderEditedBy_PersonUsername
		FOREIGN KEY (EditedBy) REFERENCES Person(Username)
) COMMENT 'A table for a healthcare provider.'
;

/* ******************************************************************************
	CREATE TABLE Item
****************************************************************************** */
DROP TABLE IF EXISTS Item;
CREATE TABLE Item (
	ItemId int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate key for the item table.'
    , ProviderId int unsigned NOT NULL COMMENT 'Provider Id for the healthcare provider. Refers to the Provider table.'
    , ItemName varchar(256) NOT NULL COMMENT 'This item''s name.'
    , Amount int unsigned NOT NULL COMMENT 'Amount of this item.'
    , StartDate date NOT NULL COMMENT 'Date this item was added to a listing.'
    , UserStarted varchar(256) NOT NULL COMMENT 'User who added this listing. References the Person table.'
    , DateDeactivated date NULL COMMENT 'Date this item was deactivated.'
    , LastEdited datetime NULL COMMENT 'Date this item was edited. If not null, means it has been edited.'
    , EditedBy varchar(256) NULL COMMENT 'The user who made the edit. If not null, means this listing has been edited. Refers to the person table.'
    , CONSTRAINT fk_ItemProviderId_ProviderProviderId
		FOREIGN KEY (ProviderId) REFERENCES Provider(ProviderId)
	, CONSTRAINT fk_ItemUserStarted_PersonUsername
		FOREIGN KEY (UserStarted) REFERENCES Person(Username)
	, CONSTRAINT fk_ItemEditedBy_PersonUsername
		FOREIGN KEY (EditedBy) REFERENCES Person(Username)
) COMMENT 'A table for list items.'
;
/* ***************************************************************************
Insert PersonRole Records
*************************************************************************** */
INSERT INTO PersonRole(
    RoleType
) VALUES
	('Guest')
    , ('Member')
    , ('Moderator')
    , ('Admin')
;

-- Test
-- SELECT *
-- FROM PersonRole
-- ;
/* ***************************************************************************
Insert State Records
*************************************************************************** */
INSERT INTO State(
    StateAbbreviation
    , State
) VALUES
	('AL', 'Alabama')
    , ('AK', 'Alaska')
    , ('AZ', 'Arizona')
    , ('AR', 'Arkansas')
    , ('CA', 'California')
    , ('CO', 'Colorado')
    , ('CT', 'Connecticut')
    , ('DE', 'Delaware')
    , ('DC', 'District of Columbia')
    , ('FL', 'Florida')
    , ('GA', 'Georgia')
    , ('HI', 'Hawaii')
    , ('ID', 'Idaho')
    , ('IL', 'Illinois')
    , ('IN', 'Indiana')
    , ('IA', 'Iowa')
    , ('KS', 'Kansas')
    , ('KY', 'Kentucky')
    , ('LA', 'Louisiana')
    , ('ME', 'Maine')
    , ('MD', 'Maryland')
    , ('MA', 'Massachusetts')
    , ('MI', 'Michigan')
    , ('MN', 'Minnesota')
    , ('MS', 'Mississippi')
    , ('MO', 'Missouri')
    , ('MT', 'Montana')
    , ('NE', 'Nebraska')
    , ('NV', 'Nevada')
    , ('NH', 'New Hampshire')
    , ('NJ', 'New Jersey')
    , ('NM', 'New Mexico')
    , ('NY', 'New York')
    , ('NC', 'North Carolina')
    , ('ND', 'North Dakota')
    , ('OH', 'Ohio')
    , ('OK', 'Oklahoma')
    , ('OR', 'Oregon')
    , ('PA', 'Pennsylvania')
    , ('RI', 'Rhode Island')
    , ('SC', 'South Carolina')
    , ('SD', 'South Dakota')
    , ('TN', 'Tennessee')
    , ('TX', 'Texas')
    , ('UT', 'Utah')
    , ('VT', 'Vermont')
    , ('VA', 'Virginia')
    , ('WA', 'Washington')
    , ('WV', 'West Virginia')
    , ('WI', 'Wisconsin')
    , ('WY', 'Wyoming')
    , ('AS', 'American Samoa')
    , ('GU', 'Guam')
    , ('MP', 'Northern Mariana Islands')
    , ('PR', 'Puerto Rico')
    , ('VI', 'U.S. Virgin Islands')
    , ('UM', 'U.S. Minor Outlying Islands')
;

-- Test
-- SELECT *
-- FROM State
-- ;

/* ******************************************************************************
	CREATE FUNCTIONS
****************************************************************************** */

/* ******************************************************************************
	FIND A ROLE ID BY ROLE TYPE
****************************************************************************** */
DELIMITER $$
DROP FUNCTION IF EXISTS get_roleid_by_type$$
CREATE FUNCTION get_roleid_by_type(
    p_role VARCHAR(50)
)
RETURNS INT
DETERMINISTIC READS SQL DATA
COMMENT 'Finds a RoleId by it''s type.'
BEGIN
	DECLARE p_role_id INT UNSIGNED;
    
    SELECT
		RoleId
	INTO p_role_id
	FROM PersonRole
    WHERE RoleType = p_role
    ;
    
    RETURN (p_role_id);
    
END$$
DELIMITER ;

-- Test
-- SELECT get_roleid_by_type('Moderator');

/* ******************************************************************************
	FIND A PROVIDER ID BY NAME
****************************************************************************** */
DELIMITER $$
DROP FUNCTION IF EXISTS get_provider_by_name$$
CREATE FUNCTION get_provider_by_name(
    p_provider_name VARCHAR(256)
)
RETURNS INT
DETERMINISTIC READS SQL DATA
COMMENT 'Finds a Provider Id by it''s name.'
BEGIN
	DECLARE p_provider_id INT UNSIGNED;
    
    SELECT
		ProviderId
	INTO p_provider_id
	FROM Provider
    WHERE ProviderName = p_provider_name
    ;
    
    RETURN (p_provider_id);
    
END$$
DELIMITER ;

-- Test
-- SELECT get_provider_by_name('MercyCare');

/* ******************************************************************************
	CREATE STORED PROCEDURES
****************************************************************************** */

/* ******************************************************************************
	USER CRUD
****************************************************************************** */

/* ******************************************************************************
	CREATE A NEW USER
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_new_user$$
CREATE PROCEDURE sp_create_new_user(
	IN p_username VARCHAR(256)
    , IN p_password VARCHAR(1000)
    , IN p_first_name VARCHAR(256)
    , IN p_last_name VARCHAR(256)
    , IN p_email VARCHAR(256)
    , IN p_occupation VARCHAR(256)
    , IN p_roletype VARCHAR(50)
)
COMMENT 'A procedure to insert a new user into the database.'
BEGIN
	DECLARE var_duplicate_entry TINYINT DEFAULT FALSE;
    DECLARE var_wrong_number_args TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 1062
		SET var_duplicate_entry = TRUE;
	DECLARE CONTINUE HANDLER FOR 1318
		SET var_wrong_number_args = TRUE;

    INSERT INTO Person(
		Username
        , PersonPassword
        , FirstName
        , LastName
        , Email
        , Occupation
        , RoleId
    ) VALUES (
		p_username
        , p_password
        , p_first_name
        , p_last_name
        , p_email
        , p_occupation
        , get_roleid_by_type(p_roletype)
    )
    ;
    
    SELECT ROW_COUNT();
    
    IF var_duplicate_entry = TRUE THEN
		SELECT 'Username was already taken.' AS message;
	END IF;
    
    IF var_wrong_number_args = TRUE THEN
		SELECT 'Wrong number of arguments.' AS message;
	END IF;

END$$
DELIMITER ;

-- SELECT *
-- FROM Person
-- ;

-- Test
-- CALL sp_create_new_user('Jack', 'password', 'Member');

-- SELECT *
-- FROM Person
-- ;

/* ******************************************************************************
	GET A USER BY NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_user_by_name$$
CREATE PROCEDURE sp_get_user_by_name(
	IN p_username VARCHAR(256)
)
COMMENT 'A procedure to get a user by username.'
BEGIN
    SELECT
		Person.PersonId
        , Person.Username
        , Person.FirstName
        , Person.LastName
        , Person.Email
        , Person.Occupation
        , PersonRole.RoleType
	FROM Person
    INNER JOIN PersonRole
    ON Person.RoleId = PersonRole.RoleId
    WHERE Person.Username = p_username
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_get_user_by_name('Jack');

-- SELECT *
-- FROM Person
-- ;

/* ******************************************************************************
	GET A USERNAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_user$$
CREATE PROCEDURE sp_get_user(
	IN p_username VARCHAR(256)
)
COMMENT 'A procedure to get a username.'
BEGIN
    SELECT
        Username
	FROM Person
    WHERE Username = p_username
    ;

END$$
DELIMITER ;

/* ******************************************************************************
	GET A PASSWORD
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_password$$
CREATE PROCEDURE sp_get_password(
	IN p_password VARCHAR(1000)
)
COMMENT 'A procedure to get a password.'
BEGIN
    SELECT
        PersonPassword
	FROM Person
    WHERE PersonPassword = p_password
    ;

END$$
DELIMITER ;

/* ******************************************************************************
	GET A PASSWORD WITH USERNAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_password_with_username$$
CREATE PROCEDURE sp_get_password_with_username(
	IN p_username VARCHAR(256)
)
COMMENT 'A procedure to get a password via the username.'
BEGIN
    SELECT
        PersonPassword
	FROM Person
    WHERE Username = p_username
    ;

END$$
DELIMITER ;


-- CALL sp_get_password_with_username('jack');
-- CALL sp_get_password_with_username('thane');

/* ******************************************************************************
	GET A USERNAME AND PASSWORD
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_userpassword$$
CREATE PROCEDURE sp_get_userpassword(
	IN p_username VARCHAR(256)
    , IN p_password VARCHAR(1000)
)
COMMENT 'A procedure to get a username and password.'
BEGIN
    SELECT
        Person.Username
        , Person.PersonPassword
	FROM Person
    WHERE Username = p_username AND PersonPassword = p_password
    ;

END$$
DELIMITER ;

/* ******************************************************************************
	EDIT A USER BY ID
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_user$$
CREATE PROCEDURE sp_edit_user(
	IN p_personid INT UNSIGNED
	, IN p_username VARCHAR(256)
    , IN p_firstname VARCHAR(256)
    , IN p_lastname VARCHAR(256)
    , IN p_email VARCHAR(256)
    , IN p_occupation VARCHAR(256)
)
COMMENT 'A procedure to update a user by username.'
BEGIN
	UPDATE Person
	SET
		Username = p_username
		, FirstName = p_firstname
        , LastName = p_lastname
        , Email = p_email
        , Occupation = p_occupation
	WHERE PersonId = p_personid
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_user_by_name('micky', 'Micky', 'Mouse', 'Actor');

-- SELECT *
-- FROM Person;

/* ******************************************************************************
	EDIT A USER BY NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_user_by_name$$
CREATE PROCEDURE sp_edit_user_by_name(
	IN p_username VARCHAR(256)
    , IN p_firstname VARCHAR(256)
    , IN p_lastname VARCHAR(256)
    , IN p_email VARCHAR(256)
    , IN p_occupation VARCHAR(256)
)
COMMENT 'A procedure to update a user by username.'
BEGIN
	UPDATE Person
	SET
		FirstName = p_firstname
        , LastName = p_lastname
        , Email = p_email
        , Occupation = p_occupation
	WHERE Username = p_username
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_user_by_name('micky', 'Micky', 'Mouse', 'Actor');

-- SELECT *
-- FROM Person;

/* ******************************************************************************
	EDIT A USER'S PASSWORD BY USERNAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_user_password_by_name$$
CREATE PROCEDURE sp_edit_user_password_by_name(
	IN p_username VARCHAR(256)
    , IN p_oldpassword VARCHAR(1000)
    , IN p_newpassword VARCHAR(1000)
)
COMMENT 'A procedure to update a user''s password by username.'
BEGIN
	UPDATE Person
	SET
		PersonPassword = p_newpassword
	WHERE Username = p_username AND PersonPassword = p_oldpassword
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_user_password_by_name('micky', 'password', 'newpassword');

-- SELECT *
-- FROM Person;

/* ******************************************************************************
	DEACTIVATE A USER BY USERNAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_deactivate_user_by_name$$
CREATE PROCEDURE sp_deactivate_user_by_name(
	IN p_username VARCHAR(256)
)
COMMENT 'A procedure to deactivate a user by username.'
BEGIN
	UPDATE Person
    SET DateDeactivated = CURDATE()
    WHERE Username = p_username
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_deactivate_user_by_name('micky');

-- SELECT *
-- FROM Person;

/* ******************************************************************************
	LISTINGS CRUD
****************************************************************************** */

/* ******************************************************************************
	CREATE A NEW LISTING
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_new_listing$$
CREATE PROCEDURE sp_create_new_listing(
	IN p_provider_name VARCHAR(256)
    , IN p_username VARCHAR(256)
    , IN p_address_line_1 VARCHAR(256)
    , IN p_address_line_2 VARCHAR(256)
    , IN p_zipcode CHAR(5)
    , IN p_city VARCHAR(256)
    , IN p_state CHAR(2)
    , IN p_countrycode CHAR(1)
	, IN p_phonenumber VARCHAR(10)
    , IN p_phonetype VARCHAR(256)
    , IN p_email VARCHAR(256)
)
COMMENT 'A procedure to insert a new listing into the database.'
BEGIN
	DECLARE duplicate_entry TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 1062
		SET duplicate_entry = TRUE;
	
    INSERT INTO Zipcode(
		ZipCode
        , City
        , StateAbbreviation
    ) VALUES (
		p_zipcode
        , p_city
        , p_state
    )
    ;
    
    IF duplicate_entry = TRUE THEN
		SELECT 'Zipcode was not inserted - duplicate encountered.' AS message;
        SET duplicate_entry = FALSE;
	ELSE
		SELECT 'Zipcode was inserted.' AS message;
	END IF;
    
    INSERT INTO Address(
		AddressLine1
        , AddressLine2
        , ZipCode
        , DateStarted
    ) VALUES (
		p_address_line_1
        , p_address_line_2
        , p_zipcode
        , CURDATE()
    )
    ;
    
    INSERT INTO Phone(
		PhoneNumber
        , CountryCode
        , PhoneType
        , StartDate
    ) VALUES (
		p_phonenumber
        , p_countrycode
        , p_phonetype
        , CURDATE()
    )
    ;
    
    INSERT INTO Provider (
		ProviderName
        , AddressId
        , PhoneNumber
        , Email
        , DateStarted
        , UserStarted
    ) VALUES (
		p_provider_name
        , (SELECT AddressId
			FROM Address
            WHERE AddressLine1 = p_address_line_1 AND ZipCode = p_zipcode)
		, p_phonenumber
        , p_email
        , CURDATE()
        , p_username
    )
    ;

END$$
DELIMITER ;

-- DELETE FROM Provider
-- WHERE ProviderId = 6
-- ;

-- SELECT *
-- FROM PROVIDER
-- ;

-- Test
-- CALL sp_create_new_listing('MercyCare', 'micky', '1790 Blairs Ferry Rd', NULL, '52233', 'Hiawatha', 'IA', '1', '3193788362', 'Office');

-- CALL sp_create_new_listing('Mercy Medical Center', 'brandy', '701 10th St SE', NULL, '52403', 'Cedar Rapids', 'IA', '1', '3193986011', 'Office');

-- SELECT
-- 	Provider.ProviderName
--     , Provider.PhoneNumber
--     , Provider.DateStarted
--     , Provider.UserStarted
--     , Provider.DateDeactivated
--     , Address.AddressLine1
--     , ZipCode.City
--     , ZipCode.StateAbbreviation
--     , ZipCode.ZipCode
-- FROM Provider
-- INNER JOIN Address
-- ON Address.AddressId = Provider.AddressId
-- INNER JOIN ZipCode
-- ON ZipCode.ZipCode = Address.ZipCode
-- ;

-- UPDATE Provider
-- SET DateDeactivated = NULL
-- WHERE ProviderId = 1
-- ;

/* ******************************************************************************
	EDIT A LISTING
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_provider$$
CREATE PROCEDURE sp_edit_provider(
	IN p_provider_id INT UNSIGNED
	, IN p_provider_name VARCHAR(256)
    , IN p_address_line_1 VARCHAR(256)
    , IN p_address_line_2 VARCHAR(256)
    , IN p_zipcode CHAR(5)
    , IN p_city VARCHAR(256)
    , IN p_state_abbreviation CHAR(2)
    , IN p_country_code CHAR(1)
    , IN p_phonenumber VARCHAR(10)
    , IN p_phone_type VARCHAR(256)
    , IN p_email VARCHAR(256)
)
COMMENT 'A procedure to update a Provider.'
BEGIN

	DECLARE var_provider_name VARCHAR(256);
    DECLARE var_address_id INT UNSIGNED;
    DECLARE var_address_line_1 VARCHAR(256);
	DECLARE var_zipcode CHAR(5);
    DECLARE var_city VARCHAR(256);
    DECLARE var_state_abbreviation CHAR(2);
    DECLARE var_country_code CHAR(1);
    DECLARE var_phonenumber VARCHAR(10);
    DECLARE var_phone_type VARCHAR(256);
    DECLARE var_new_address_id INT UNSIGNED;
    DECLARE var_email VARCHAR(256);
    
    SELECT ProviderName, AddressId, PhoneNumber, Email
    INTO var_provider_name, var_address_id, var_phonenumber, var_email
    FROM Provider
    WHERE ProviderId = p_provider_id
    ;
    
    SELECT AddressLine1, ZipCode
    INTO var_address_line_1, var_zipcode
    FROM Address
    WHERE AddressId = var_address_id
    ;
    
    SELECT City, StateAbbreviation
    INTO var_city, var_state_abbreviation
    FROM Zipcode
    WHERE ZipCode = var_zipcode
    ;
    
    SELECT CountryCode, PhoneType
    INTO var_country_code, var_phone_type
    FROM Phone
    WHERE PhoneNumber = var_phonenumber
    ;
    
    IF p_provider_name != var_provider_name THEN
		UPDATE Provider
        SET
			ProviderName = p_provider_name
		WHERE ProviderId = p_provider_id
        ;
	ELSEIF p_address_line_1 != var_address_line_1 THEN
		UPDATE Address
		SET DateEnded = CURDATE()
        WHERE AddressLine1 = var_address_line_1
        ;
        
        INSERT INTO Address(
			AddressLine1
            , AddressLine2
            , ZipCode
            , DateStarted
		) VALUES (
			p_address_line_1
            , p_address_line_2
            , p_zipcode
            , CURDATE()
		)
        ;
        
        SELECT AddressId
        INTO var_new_address_id
        FROM Address
        WHERE AddressLine1 = p_address_line_1
        ;        
        
        UPDATE Provider
        SET AddressId = var_new_address_id
        WHERE ProviderId = p_provider_id
        ;
	ELSEIF p_zipcode != var_zipcode THEN
		IF EXISTS(SELECT ZipCode FROM Zipcode WHERE ZipCode = p_zipcode) THEN
            UPDATE Address
            SET ZipCode = p_zipcode
            WHERE AddressId = var_address_id
            ;
		ELSE
			INSERT INTO Zipcode(
				ZipCode
                , City
                , StateAbbreviation
            ) VALUES (
				p_zipcode
                , p_city
                , p_state_abbreviation
            )
			;
            UPDATE Address
            SET ZipCode = p_zipcode
            WHERE AddressId = var_address_id
            ;
		END IF
		;
	ELSEIF p_phonenumber != var_phonenumber THEN
		UPDATE Phone
        SET EndDate = CURDATE()
        WHERE PhoneNumber = var_phonenumber
        ;
        
        INSERT INTO Phone(
			PhoneNumber
            , CountryCode
            , PhoneType
			, StartDate
        ) VALUES (
			p_phonenumber
            , p_country_code
            , p_phone_type
            , CURDATE()
        )
        ;
        
        UPDATE Provider
        SET PhoneNumber = p_phonenumber
        WHERE ProviderId = p_provider_id
        ;
	ELSEIF p_email != var_email THEN
		UPDATE Provider
        SET
			Email = p_email
		WHERE ProviderId = p_provider_id
        ;
    END IF
    ;

END$$
DELIMITER ;

-- TEST
-- CALL sp_edit_provider(4, 'Health Clinic', '572 Luna Dr', '', '61103', 'Rockford', 'IL', '1', '8153585555', 'Office');
-- CALL sp_edit_provider(3, 'Mercy Medical Center', '701 10th St SE', NULL, '52403', 'Cedar Rapids', 'IA', '1', '3193986011', 'Office');
-- CALL sp_view_providers_multi_info('Health Clinic', '572 Luna Dr', '8153585555');

-- SELECT *
-- From Provider
-- ;

-- SELECT *
-- FROM Zipcode
-- ;

-- SELECT *
-- FROM Person
-- WHERE Username = 'jack'
-- ;

/* ******************************************************************************
	EDIT A LISTING'S NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_provider_name$$
CREATE PROCEDURE sp_edit_provider_name(
	IN p_username VARCHAR(256)
    , IN p_old_provider_name VARCHAR(256)
    , IN p_new_provider_name VARCHAR(256)
)
COMMENT 'A procedure to update a provider''s name.'
BEGIN
	UPDATE Provider
	SET
		ProviderName = p_new_provider_name
        , LastEdited = NOW()
        , EditedBy = p_username
	WHERE ProviderName = p_old_provider_name
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_provider_name();

-- SELECT *
-- FROM Provider;

/* ******************************************************************************
	EDIT A LISTING'S PHONE NUMBER
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_provider_phone_number$$
CREATE PROCEDURE sp_edit_provider_phone_number(
	IN p_username VARCHAR(256)
    , IN p_old_phone_number VARCHAR(256)
    , IN p_new_phone_number VARCHAR(256)
)
COMMENT 'A procedure to update a Provider''s phonenumber.'
BEGIN
	UPDATE Phone
	SET
		EndDate = CURDATE()
	WHERE PhoneNumber = p_old_phone_number
    ;
    
    INSERT INTO Phone(
		PhoneNumber
        , CountryCode
        , PhoneType
        , StartDate
    ) VALUES (
		p_new_phone_number
        , (SELECT CountryCode
			FROM Phone
            WHERE PhoneNumber = p_old_phone_number)
        , (SELECT PhoneType
			FROM Phone
            WHERE PhoneNumber = p_old_phone_number)
		, CURDATE()
    )
    ;
    
    UPDATE Provider
    SET
		PhoneNumber = p_new_phone_number
        , LastEdited = NOW()
        , EditedBy = p_username
	WHERE PhoneNumber = p_old_phone_number
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_provider_phone_number();

-- SELECT *
-- FROM zipcode;

/* ******************************************************************************
	EDIT A LISTING'S ADDRESS
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_edit_provider_address$$
CREATE PROCEDURE sp_edit_provider_address(
    IN p_new_address_line_1 VARCHAR(256)
    , IN p_old_address_line_1 VARCHAR(256)
    , IN p_new_address_line_2 VARCHAR(256)
    , IN p_old_address_line_2 VARCHAR(256)
    , IN p_zipcode CHAR(5)
    , IN p_city VARCHAR(256)
    , IN p_state_abbreviation CHAR(2)
)
COMMENT 'A procedure to update a Provider''s address.'
BEGIN
	DECLARE var_zipcode CHAR(5);
    DECLARE var_address_id INT UNSIGNED;
    
    SELECT ZipCode
    INTO var_zipcode
	FROM ZipCode
    WHERE ZipCode = p_zipcode
    ;
    
    SELECT
		AddressId
	INTO var_address_id
    FROM Address
    WHERE AddressLine1 = p_old_address_line_1 AND AddressLine2 = p_old_address_line_2
    ;
    
    IF var_zipcode != p_zipcode THEN
		INSERT INTO ZipCode(
			ZipCode
            , City
            , StateAbbreviation
        ) VALUES (
			p_zipcode
            , p_city
            , p_state_abbreviation
        )
        ;
	END IF
    ;
    
    UPDATE Address
    SET
		DateEnded = CURDATE()
	WHERE AddressId = var_address_id
    ;
    
    INSERT INTO Address(
		AddressLine1
        , AddressLine2
        , ZipCode
        , DateStarted
    ) VALUES (
		p_new_address_line_1
        , p_new_address_line_2
        , p_zip_code
        , CURDATE()
    )
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_edit_provider_address();

-- SELECT *
-- FROM Provider;

/* ******************************************************************************
	VIEW PROVIDER (INCLUDING ID) BY ID
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_provider_by_id$$
CREATE PROCEDURE sp_view_provider_by_id(
	IN p_provider_id INT UNSIGNED
)
COMMENT 'A procedure to select a provider based on multiple information.'
BEGIN    
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Phone.PhoneType
        , Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE Provider.ProviderId = p_provider_id
        AND Provider.DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_provider_by_id(1);

-- SELECT *
-- FROM Provider
-- ;

-- UPDATE Provider
-- SET Email = 'Fousteme43@dayrep.com'
-- WHERE ProviderId = 3
;
/* ******************************************************************************
	VIEW PROVIDERS (INCLUDING ID) BY MULTI-INFO
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_multi_info$$
CREATE PROCEDURE sp_view_providers_multi_info(
	IN p_provider_name VARCHAR(256)
    , IN p_address_line_1 VARCHAR(256)
    , IN p_phone_number VARCHAR(10)
)
COMMENT 'A procedure to select a provider based on multiple information.'
BEGIN    
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Phone.PhoneType
        , Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE Provider.ProviderName = p_provider_name
		AND Address.AddressLine1 = p_address_line_1
        AND Provider.PhoneNumber = p_phone_number
        AND Provider.DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_multi_info('Health Clinic', '582 Luna Dr', '8153585555');

/* ******************************************************************************
	VIEW PROVIDER BY NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_provider_by_name$$
CREATE PROCEDURE sp_view_provider_by_name(
	IN p_provider_name VARCHAR(256)
)
COMMENT 'A procedure to view providers by name.'
BEGIN    
    SELECT
		Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
	WHERE Provider.ProviderName = p_provider_name
		AND DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_provider_by_name('MercyCare');

/* ******************************************************************************
	PROVIDERS COUNT
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_providers_count$$
CREATE PROCEDURE sp_providers_count()
COMMENT 'A procedure to count the amount of providers.'
BEGIN    
    SELECT COUNT(*) AS 'Count'
	FROM Provider
    WHERE DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_providers_count();

/* ******************************************************************************
	VIEW PROVIDERS
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers$$
CREATE PROCEDURE sp_view_providers()
COMMENT 'A procedure to view a list of providers.'
BEGIN    
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE Provider.DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers();

/* ******************************************************************************
	SEARCH PROVIDERS BY NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_search_providers_name$$
CREATE PROCEDURE sp_search_providers_name(
    IN p_provider_name VARCHAR(256)
)
COMMENT 'A procedure to search a list of providers by provider name.'
BEGIN
	DECLARE var_illegal_argument TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 3685
		SET var_illegal_argument = TRUE;
	
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE LOWER(Provider.ProviderName) REGEXP TRIM(LOWER(p_provider_name))
    AND DateDeactivated IS NULL
    ;
    
    IF var_illegal_argument = TRUE THEN
		SELECT 'Search was not completed - invalid search term was used.' AS message;
	ELSE
		SELECT 'Search was completed.' AS message;
	END IF;

END$$
DELIMITER ;

-- Test
-- CALL sp_search_providers_name('clinic');

/* ******************************************************************************
	SEARCH PROVIDERS BY CITY
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_search_providers_city$$
CREATE PROCEDURE sp_search_providers_city(
    IN p_city VARCHAR(256)
)
COMMENT 'A procedure to search a list of providers by city.'
BEGIN    
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE LOWER(ZipCode.City) REGEXP TRIM(LOWER(p_city))
    AND DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_search_providers_city('Cedar Rapids');

/* ******************************************************************************
	VIEW PROVIDERS BY LIMIT
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_limited_providers$$
CREATE PROCEDURE sp_view_limited_providers(
    IN p_limit_start INT UNSIGNED
    , IN p_limit_amount INT UNSIGNED
)
COMMENT 'A procedure to view a limited number of providers.'
BEGIN    
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE DateDeactivated IS NULL
    LIMIT p_limit_start, p_limit_amount
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_limited_providers(0, 1);

/* ******************************************************************************
	VIEW PROVIDERS BY STATE
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_state$$
CREATE PROCEDURE sp_view_providers_state(
    IN p_state VARCHAR(60)
)
COMMENT 'A procedure to view providers by state.'
BEGIN
	DECLARE var_illegal_argument TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 3685
		SET var_illegal_argument = TRUE;
	
    SELECT
		Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , State.State
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN State
    ON State.StateAbbreviation = ZipCode.StateAbbreviation
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE UPPER(State.State) = UPPER(p_state)
		OR LOWER(State.StateAbbreviation) = LOWER(p_state)
		AND Provider.DateDeactivated IS NULL
    ;
    
    IF var_illegal_argument = TRUE THEN
		SELECT 'Search was not completed - invalid search term was used.' AS message;
	ELSE
		SELECT 'Search was completed.' AS message;
	END IF;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_state('Iowa');

/* ******************************************************************************
	VIEW PROVIDERS BY STATE - LIMIT
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_state_limit$$
CREATE PROCEDURE sp_view_providers_state_limit(
    IN p_state VARCHAR(60)
    , IN p_limit_start INT UNSIGNED
    , IN p_limit_amount INT UNSIGNED
)
COMMENT 'A procedure to view a limited number of providers.'
BEGIN    
    SELECT
		Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , State.State
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN State
    ON State.StateAbbreviation = ZipCode.StateAbbreviation
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE State.State = p_state
		AND Provider.DateDeactivated IS NULL
    LIMIT p_limit_start, p_limit_amount
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_state_limit('Iowa', 0, 10);

/* ******************************************************************************
	VIEW PROVIDERS BY CITY
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_city$$
CREATE PROCEDURE sp_view_providers_city(
    IN p_city VARCHAR(256)
)
COMMENT 'A procedure to view providers based on the city.'
BEGIN
	DECLARE var_illegal_argument TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 3685
		SET var_illegal_argument = TRUE;
	
    SELECT
		Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
		, Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE ZipCode.City = p_city
		AND Provider.DateDeactivated IS NULL
    ;
    
    IF var_illegal_argument = TRUE THEN
		SELECT 'Search was not completed - invalid search term was used.' AS message;
	ELSE
		SELECT 'Search was completed.' AS message;
	END IF;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_city('Cedar Rapids');

/* ******************************************************************************
	VIEW PROVIDERS BY CITY - LIMIT
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_city_limit$$
CREATE PROCEDURE sp_view_providers_city_limit(
    IN p_city VARCHAR(256)
    , IN p_limit_start INT UNSIGNED
    , IN p_limit_amount INT UNSIGNED
)
COMMENT 'A procedure to view a limited number of providers based on the city.'
BEGIN    
    SELECT
		Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    WHERE ZipCode.City = p_city
		AND Provider.DateDeactivated IS NULL
    LIMIT p_limit_start, p_limit_amount
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_city_limit('Cedar Rapids', 0, 10);

/* ******************************************************************************
	VIEW PROVIDERS BY Item
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_providers_item$$
CREATE PROCEDURE sp_view_providers_item(
    IN p_item_name VARCHAR(256)
)
COMMENT 'A procedure to view providers based on the item.'
BEGIN
	DECLARE var_illegal_argument TINYINT DEFAULT FALSE;
    
	DECLARE CONTINUE HANDLER FOR 3685
		SET var_illegal_argument = TRUE;
	
    SELECT
		Provider.ProviderId
		, Provider.ProviderName
        , Address.AddressLine1
        , Address.AddressLine2
        , ZipCode.City
        , ZipCode.StateAbbreviation
        , Address.ZipCode
        , Phone.CountryCode
        , Provider.PhoneNumber
        , Provider.Email
        , Provider.UserStarted
	FROM Provider
    INNER JOIN Address
    ON Address.AddressId = Provider.AddressId
    INNER JOIN ZipCode
    ON ZipCode.ZipCode = Address.ZipCode
    INNER JOIN Phone
    ON Phone.PhoneNumber = Provider.PhoneNumber
    INNER JOIN Item
    ON Item.ProviderId = Provider.ProviderId
    WHERE LOWER(Item.ItemName) REGEXP TRIM(LOWER(p_item_name))
		AND Provider.DateDeactivated IS NULL
        AND Item.DateDeactivated IS NULL
    ;
    
    IF var_illegal_argument = TRUE THEN
		SELECT 'Search was not completed - invalid search term was used.' AS message;
	ELSE
		SELECT 'Search was completed.' AS message;
	END IF;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_providers_item('mask');

-- SELECT *
-- FROM Item
-- ;

/* ******************************************************************************
	'SOFT DELETE' PROVIDER
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_soft_delete_provider$$
CREATE PROCEDURE sp_soft_delete_provider(
    IN p_provider_id VARCHAR(256)
)
COMMENT 'A procedure to put a date into DateDeactivated for a provider.'
BEGIN    
    UPDATE Provider
    SET DateDeactivated = CURDATE()
    WHERE ProviderId = p_provider_id
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_soft_delete_provider(1);

/* ******************************************************************************
	ITEMS CRUD
****************************************************************************** */

/* ******************************************************************************
	CREATE A NEW ITEM
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_new_item$$
CREATE PROCEDURE sp_create_new_item(
	IN p_provider_id INT UNSIGNED
    , IN p_username VARCHAR(256)
    , IN p_item_name VARCHAR(256)
    , IN p_amount INT UNSIGNED
)
COMMENT 'A procedure to insert a new item into the database.'
BEGIN
    INSERT INTO Item(
		ProviderId
        , ItemName
        , Amount
        , StartDate
        , UserStarted
    ) VALUES (
		p_provider_id
        , p_item_name
        , p_amount
        , CURDATE()
        , p_username
    )
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_create_new_item('MercyCare', 'micky', 'Masks', NULL, '100', 'Y', 'Weekly');
-- CALL sp_create_new_item('MercyCare', 'micky', 'Gloves', NULL, '1000', 'Y', 'Daily');

-- SELECT *
-- FROM Item
-- ;

/* ******************************************************************************
	EDIT AN ITEM
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_item_all$$
CREATE PROCEDURE sp_update_item_all(
    p_item_id INT UNSIGNED
    , IN p_username VARCHAR(256)
    , IN p_item_name VARCHAR(256)
    , IN p_amount INT UNSIGNED
)
COMMENT 'A procedure to update an item''s information in the database.'
BEGIN

	DECLARE var_item_name VARCHAR(256);
    DECLARE var_amount INT UNSIGNED;
    
    SELECT ItemName
    INTO var_item_name
    FROM Item
    WHERE ItemId = p_item_id
    ;
    
    SELECT Amount
    INTO var_amount
    FROM Item
    WHERE ItemId = p_item_id
    ;
    
    IF var_item_name != p_item_name THEN
		UPDATE Item
        SET ItemName = p_item_name
        WHERE ItemId = p_item_id
        ;
	ELSEIF var_amount != p_amount THEN
		UPDATE Item
        SET Amount = p_amount
        WHERE ItemId = p_item_id
        ;
	END IF
    ;
	    
    UPDATE Item
    SET
		LastEdited = NOW()
        , EditedBy = p_username
	WHERE ItemId = p_item_id
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_update_item_all();

-- SELECT *
-- FROM Item
-- ;

/* ******************************************************************************
	EDIT AN ITEM AMOUNT
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_item_amount$$
CREATE PROCEDURE sp_update_item_amount(
	IN p_item_id VARCHAR(256)
    , IN p_username VARCHAR(256)
    , IN p_item_name VARCHAR(256)
    , IN p_amount INT UNSIGNED
)
COMMENT 'A procedure to update an item''s amount in the database.'
BEGIN
    
    UPDATE Item
    SET
        Amount = p_amount
        , LastEdited = NOW()
        , EditedBy = p_username
	WHERE ItemId = p_item_id
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_update_item_amount();

-- SELECT *
-- FROM Item
-- ;

/* ******************************************************************************
	VIEW ITEMS WITH LIMITS
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_items$$
CREATE PROCEDURE sp_view_items(
	IN p_provider_id INT UNSIGNED
	, IN p_item_limit_start INT UNSIGNED
    , IN p_item_limit_amount INT UNSIGNED
)
COMMENT 'A procedure to view items.'
BEGIN    
    SELECT
		ItemName
        Amount
	FROM Item
    WHERE ProviderId = p_provider_id
	LIMIT p_item_limit_start, p_item_limit_amount
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_items(0, 10);

/* ******************************************************************************
	VIEW ITEMS BY ID
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_items_by_id$$
CREATE PROCEDURE sp_view_items_by_id(
	IN p_item_id INT UNSIGNED
)
COMMENT 'A procedure to view items by ID.'
BEGIN
    
    SELECT
		ItemId
		, ItemName
        , Amount
        , UserStarted
	FROM Item
	WHERE ItemId = p_item_id AND
		DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_items_by_provider('MercyCare');

/* ******************************************************************************
	VIEW ITEMS BY PROVIDER
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_items_by_provider$$
CREATE PROCEDURE sp_view_items_by_provider(
	IN p_provider_id INT UNSIGNED
)
COMMENT 'A procedure to view items by Provider.'
BEGIN
    
    SELECT
		ItemId
		, ItemName
        , Amount
        , UserStarted
	FROM Item
	WHERE ProviderId = p_provider_id AND
		DateDeactivated IS NULL
    ;

END$$
DELIMITER ;

-- SELECT *
-- FROM ITEM
-- ;

-- SELECT ItemId
-- FROM Item
-- WHERE ProviderId = 2;

-- Test
-- CALL sp_view_items_by_provider('MercyCare');

/* ******************************************************************************
	VIEW ITEMS BY NAME
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_view_items_by_name$$
CREATE PROCEDURE sp_view_items_by_name(
	IN p_item_name VARCHAR(256)
)
COMMENT 'A procedure to view items by name.'
BEGIN    
    SELECT
		Provider.ProviderName
		, Item.ItemName
        , Item.Amount
	FROM Item
    INNER JOIN Provider
    ON Provider.ProviderId = Item.ProviderId
	WHERE Item.ItemName = p_item_name
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_view_items_by_name('Masks');

-- SELECT *
-- FROM Item;

/* ******************************************************************************
	DEACTIVATE AN ITEM
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_deactivate_item$$
CREATE PROCEDURE sp_deactivate_item(
	IN p_item_id INT UNSIGNED,
    IN p_user VARCHAR(256)
)
COMMENT 'A procedure to deactivate an item.'
BEGIN
    
    UPDATE Item
    SET
		DateDeactivated = NOW()
        , LastEdited = NOW()
        , EditedBy = p_user
	WHERE ItemId = p_item_id
    ;

END$$
DELIMITER ;

-- Select *
-- From Item
-- ;

/* ******************************************************************************
	DELETE AN ITEM
****************************************************************************** */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_delete_item$$
CREATE PROCEDURE sp_delete_item(
	IN p_item_id INT UNSIGNED
)
COMMENT 'A procedure to delete an item from the database.'
BEGIN
    
    DELETE FROM Item
    WHERE ItemId = p_item_id
    ;

END$$
DELIMITER ;

-- Test
-- CALL sp_delete_item();

-- SELECT *
-- FROM Item
-- ;

-- ALTER TABLE Address
-- MODIFY AddressLine2 varchar(256) NULL DEFAULT NULL COMMENT 'Second line of an address.'
-- ;