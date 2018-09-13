CREATE DATABASE [SQLDB]
GO

USE [SQLDB]
GO

/****** Object:  Table [dbo].[user] ******/
CREATE TABLE [dbo].[user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[age] [int] NULL
) ON [PRIMARY];
/****************************************/

/****** Object:  ColumnMasterKey [CMK_AE] ******/
CREATE COLUMN MASTER KEY [CMK_AE]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'CurrentUser/my/355FC9B92CB033D32F93235FDF5F5CC3A67608BE'
)
GO

/****** Object:  ColumnEncryptionKey [CEK_AE] ******/
CREATE COLUMN ENCRYPTION KEY [CEK_AE]
WITH VALUES
(
	COLUMN_MASTER_KEY = [CMK_AE],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x016E000001630075007200720065006E00740075007300650072002F006D0079002F0033003500350066006300390062003900320063006200300033003300640033003200660039003300320033003500660064006600350066003500630063003300610036003700360030003800620065005A77830BA0E01B52279F9C8CE3FD6405100911ED221591D983833A787FEB29C805F06C1F3E5328909E8EA063E60BCBD1C9616F20FB8F5EB049460BE7797B03C9F5ED933D3CC67B78BA56F24B99D7D4FC35BD5411A9D703413CD8A3673131CB59A338363554636816E0B88BB573DD856435C86F73F75DAF61D6C0EA44D9BFE5892BAAB3CDBD53B1629D7078A8652687845D794624FEC9B3BD29E9A46D59358F2A7E69D6CC01580272E2F981D9E20BA8BEEBF3012F47F456DDE79CF14C8E5FF8086F7396EA7F4C1A191BB73E125A5213AC672F670BCA5122A1CA6EC33647080CA795A0ADB7EB43FF5B06BFE7DE4B0E65E31FA69355BD944FE735DAEA8BE01CA4787A735CFD257F3610CC9EB7965F7F35BA26CA51E8E26B19DCBF4F8B62EA41090C38F23D34E36786B7EB2A67A6B71E6363D79B1C12C96A45D2DA1A183F608FFC3393394997C59CBC1CE79DF8B477015E72ED096C8432C90EDA901033A9B3FE5DA47F167AFB1920B4E238A6CDD30A47B258EAF5AFB7470D52493C5C62DAFBE25950D6D22E47D39EDF3F13991B3F961EA3AB15EF4D8485D3DD64BB12FAC386C6C16D4566C1739C604A92A3E7D87D302089F21CD68ECEEF1B525795B84AFEBAE62D36853525212CBF42B3E0F9AAAB3AB827E090431A82C7CC12FB7816C6F6D4EF82B990F7FDE8C317375D4B39901F9213500548215CF91EEB8EA708CEFE7E3DE34DEB
)
GO

/****** Object:  Table [dbo].[userAE] ******/
CREATE TABLE [dbo].[userAE](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_AE], ENCRYPTION_TYPE = Deterministic, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,
	[age] [int] ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_AE], ENCRYPTION_TYPE = Randomized, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL
) ON [PRIMARY]
GO

/****** Object:  ColumnMasterKey [CMK_AEAKV] ******/
CREATE COLUMN MASTER KEY [CMK_AEAKV]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'AZURE_KEY_VAULT',
	KEY_PATH = N'<Provide KEY Path URL>'
)
GO

/****** Object:  ColumnEncryptionKey [CEK_AEAKV] ******/
CREATE COLUMN ENCRYPTION KEY [CEK_AEAKV]
WITH VALUES
(
	COLUMN_MASTER_KEY = [CMK_AEAKV],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x01A8000001680074007400700073003A002F002F0063006800650065006E00610061006B0076002E007600610075006C0074002E0061007A007500720065002E006E00650074003A003400340033002F006B006500790073002F0063006D006B006100750074006F0031002F00640030003300310033003600630065006500610035003300340037006200300038006600640037006200640038003200320034003800380063006600390066003447DD75896B7054DABE04DE5F4F62B4DE695CD655260ED0FE68F5DF13DDF97FA03354C166EE02EFC488EA0F94EEFEB51D0762E149815F72C4E519FF12C5EE9CED7DE161403D003C6C52A6107A904B8E53F408DA113DE97882602EBD9C9B5729A8FF4F10396C1439971C3211DDEBB2859E1F434305B31DEF53EC60A562F3F7E4DA4689533C52408EFC9EA652EBFCB739ED15445C52649A46582B1723C3846A6325710E404FE44FA012EFE41B6D99A835827C66D1325E4B7E43B705643EC2F56366CCBFBED44B5230EA3537A376F48DDA2F90952D38110D16E7254E8B38B94C028476336E7B14F310A47902C0C24C0D0B3FFAE97356D5BF21681AA3E65EF255387C78A111EA3CC958ACBA2807C8F564667B0DBC3B79C386E2DAEBD85362110F9F5B7F3ED44F8AEA3EAA5D1B888AA687E1E2462BA951647085B801E18C852F57A988068D7366707E97D711BE2B99B9A47295CC3CED8006B276813FB7B5EEB7BE93CF4DF3EB19FC6ACF69233916055471E3042D34B1FA294BA1E23635EAF56700B760BB9F8A09F80A868E2733379284634D5AB8D5A8C2AF2D99C2A1365ED69C5ABB9DE86887526EBFA46F4AEA63FB6523213A94464ABF11DC9FFA6BCF3BDF16DA01FE80E88AB0F0CC3A82DB095EE6D9AC3405358F379F65F91F16F1E5E86E01702B39340582E3C5CA20174BBA5E17420EE39F7805D409B7EACE65AAD0828BFBA94F
)
GO

/****** Object:  Table [dbo].[userAEAKV] ******/
CREATE TABLE [dbo].[userAEAKV](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_AEAKV], ENCRYPTION_TYPE = Deterministic, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,
	[age] [int] ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_AEAKV], ENCRYPTION_TYPE = Randomized, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL
) ON [PRIMARY]
GO

/****** Object:  ColumnMasterKey [CMK_AEJKS] ******/
CREATE COLUMN MASTER KEY CMK_AEJKS
WITH 
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_JAVA_KEYSTORE', 
	KEY_PATH = N'lp-e796bdea-c1df-4a27-b657-2bb71e2837d1'
)
GO

/****** Object:  ColumnEncryptionKey [CEK_AEJKS] ******/
CREATE COLUMN ENCRYPTION KEY CEK_AEJKS 
WITH VALUES 
(
	COLUMN_MASTER_KEY = CMK_AEJKS, 
	ALGORITHM = 'RSA_OAEP', 
	ENCRYPTED_VALUE = 0x014E0000016C0070002D00650037003900360062006400650061002D0063003100640066002D0034006100320037002D0062003600350037002D003200620062003700310065003200380033003700640031002C296A9269070A6533BD87303EDE75AAA5A3FFD47EA7A9120A045E2CD58A1DBC063B807D1B923FA89A88B94E4D7F386E20B6E1CFF0C5455037B142F883A49EC2D6043DAA3D313690D69851EA4A4894F57EDA2B36EDCC8B06FE06F6F9F0A2F1D6F47CBB58BA918354A0F194E941074C7514D028DE9441496B6901CA560127911BF5FDB908014C5BDE5F9CA094D0D18B5EDC1D8F9C53FAC2EE849C0883057574E22FCEA5EFC85A086937467BBBF610C18E98733F63E7AFFD46FB780325BD24E8071F2AC22F80F0D9DD817F86FE9B54EC721D55BAC7764A696268E17C17D13C9D3F8A41954A3AFA5DE07E23B80698D9BE343A1A5E41D5B0CD5894A54464DDD929D6907A0E942FAA007D51D722075E138D730E2A4B88DC36C6523A6D583C855D08EC15155421E6D8E48DA961092406AF7B1D9F43BDFB1E3C9D0773FBD940B339F16ECB22B4A57BA18F1C53E6D8F317ADFD2010C63265535AD54EAF87FFE7E66CF185483E05CD2A8EC588CFE059C9F562411A3B61A88F5E1F6845D7161F1054DFA1EEAE1B49AD804E71EB9F4C35A2AF2953BB624F108D7A677A9859C90C0F458B1901FCC5D9643EE481976F1A21A2EF33F283F7F46727DD99AB617147222F2CAA71DB9CB5F459F7E0371F68673C7FB04AD4C9B60871FA792F0C6C7577069A52BF71BC9CEB80355B89B9228A941FEA20066A0BB6BD0E5AFB453E655B123EB3244D2DD4
)
GO

/****** Object:  Table [dbo].[userAEJKS] ******/
CREATE TABLE [dbo].[userAEJKS] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (ENCRYPTION_TYPE = DETERMINISTIC, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', COLUMN_ENCRYPTION_KEY = CEK_AEJKS) NULL,
	[age] [int] ENCRYPTED WITH (ENCRYPTION_TYPE = RANDOMIZED, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', COLUMN_ENCRYPTION_KEY = CEK_AEJKS) NULL
)
GO