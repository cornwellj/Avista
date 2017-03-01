library(openxlsx)
library(dplyr)
library(plyr)

###DATA IMPORT
#import Avista usage, disconnection, fees data (all in one workbook)
usage_1 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP  Rate Discount for June Pre Report.xlsx', sheet = 1, startRow = 13)
usage_2 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP  Rate Discount for June Pre Report.xlsx', sheet = 2, startRow = 13)
fees <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP  Rate Discount for June Pre Report.xlsx', sheet = 3, startRow = 13)
project_share_info <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP  Rate Discount for June Pre Report.xlsx', sheet = 4, startRow = 13)
disconnections <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP  Rate Discount for June Pre Report.xlsx', sheet = 5, startRow = 13)

##remove extraneous variables
fees <- select(fees, -X4)
disconnections <- select(disconnections, -X3)

#import Rural Ressources demographic information
lirap_rr_demog <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/Sen-Dis Pilot Program Demographics 10-1-15 to 3-31-16.xlsx', sheet = 1)

seop_rr_demog_1 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP Final 10-1-14 to 9-30-15.xlsx', sheet = 1)
seop_rr_demog_2 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SEOP Client Demographics  10-1-15 TO 4-22-16.xlsx', sheet = 1)
seop_rr_demog_2$CDATE <- as.numeric(seop_rr_demog_2$CDATE)
seop_rr_demog_2$CMTHRENT <- as.character(seop_rr_demog_2$CMTHRENT)
seop_rr_demog_2$IID <- as.character(seop_rr_demog_2$IID)
seop_rr_demog_2$SERVDATE <- as.numeric(seop_rr_demog_2$SERVDATE)
seop_rr_demog <- bind_rows(seop_rr_demog_1, seop_rr_demog_2)

#import SNAP LRDP demographic info
lirap_snap_demog <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/LRDP_EVAL_Final.xlsx', sheet = 1)
lirap_snap_demog$CUSTOMER_NAME <- paste(lirap_snap_demog$CLAST1, lirap_snap_demog$CFIRST1, sep = ";")

###DATA MANIPULATION
#need to massage the data to concatenate
lirap_rr_demog <- as.data.frame(lapply(lirap_rr_demog, function(x) (gsub("[,$]", "", x))))
lirap_snap_demog$CIDNUM <- as.character(lirap_snap_demog$CIDNUM)
lirap_snap_demog$CDATE <- as.character(lirap_snap_demog$CDATE)
lirap_rr_demog$CNUM0_2 <- as.numeric(lirap_rr_demog$CNUM0_2)
lirap_rr_demog$CNUM3_5 <- as.numeric(lirap_rr_demog$CNUM3_5)
lirap_rr_demog$CNUM6_17 <- as.numeric(lirap_rr_demog$CNUM6_17)
lirap_rr_demog$CNUM18_59 <- as.numeric(lirap_rr_demog$CNUM18_59)
lirap_rr_demog$CNUM60_ <- as.numeric(lirap_rr_demog$CNUM60_)
lirap_rr_demog$CNUM75_ <- as.numeric(lirap_rr_demog$CNUM75_)
lirap_rr_demog$CNUMHC <- as.numeric(lirap_rr_demog$CNUMHC)
lirap_rr_demog$CHOUSSTAT <- as.numeric(lirap_rr_demog$CHOUSSTAT)
lirap_rr_demog$CHEATINRNT <- as.character(lirap_rr_demog$CHEATINRNT)
lirap_snap_demog$CHOUSTYP <- as.character(lirap_snap_demog$CHOUSTYP)
lirap_snap_demog$CHEAT <- as.character(lirap_snap_demog$CHEAT)
lirap_snap_demog$CHEAT2 <- as.character(lirap_snap_demog$CHEAT2)
lirap_rr_demog$CDATEINRES <- as.character(lirap_rr_demog$CDATEINRES)
lirap_rr_demog$CMTHINCOME <- as.numeric(lirap_rr_demog$CMTHINCOME)
lirap_rr_demog$CMTHINCEAP <- as.numeric(lirap_rr_demog$CMTHINCEAP)
lirap_rr_demog$CMTHINCPA <- as.numeric(lirap_rr_demog$CMTHINCPA)
lirap_rr_demog$CMTHINCGRO <- as.numeric(lirap_rr_demog$CMTHINCGRO)
lirap_rr_demog$CMTHINCERN <- as.numeric(lirap_rr_demog$CMTHINCERN)
lirap_rr_demog$CMTHINCFS <- as.numeric(lirap_rr_demog$CMTHINCFS)
lirap_rr_demog$CMTHINCOTH <- as.numeric(lirap_rr_demog$CMTHINCOTH)
lirap_rr_demog$CPOVLEV <- as.numeric(lirap_rr_demog$CPOVLEV)
lirap_rr_demog$CM_POVLEV <- as.numeric(lirap_rr_demog$CM_POVLEV)
lirap_rr_demog$C_EARN <- as.character(lirap_rr_demog$C_EARN)
lirap_rr_demog$C_SELF <- as.character(lirap_rr_demog$C_SELF)
lirap_rr_demog$C_MIL <- as.character(lirap_rr_demog$C_MIL)
lirap_rr_demog$C_TANF <- as.character(lirap_rr_demog$C_TANF)
lirap_rr_demog$C_GAU <- as.character(lirap_rr_demog$C_GAU)
lirap_rr_demog$C_NOINC <- as.character(lirap_rr_demog$C_NOINC)
lirap_rr_demog$C_PEN <- as.character(lirap_rr_demog$C_PEN)
lirap_rr_demog$C_SSA <- as.character(lirap_rr_demog$C_SSA)
lirap_rr_demog$C_SSI <- as.character(lirap_rr_demog$C_SSI)
lirap_rr_demog$C_SSD <- as.character(lirap_rr_demog$C_SSD)
lirap_rr_demog$C_CHLD <- as.character(lirap_rr_demog$C_CHLD)
lirap_rr_demog$C_UNEMP <- as.character(lirap_rr_demog$C_UNEMP)
lirap_rr_demog$C_VA <- as.character(lirap_rr_demog$C_VA)
lirap_rr_demog$C_OTHER <- as.character(lirap_rr_demog$C_OTHER)
lirap_snap_demog$CRESZIP <- as.character(lirap_snap_demog$CRESZIP)
lirap_rr_demog$CMTHRENT <- as.numeric(lirap_rr_demog$CMTHRENT)
lirap_rr_demog$CMTHUTIL <- as.numeric(lirap_rr_demog$CMTHUTIL)
lirap_rr_demog$CUNITS <- as.numeric(lirap_rr_demog$CUNITS)
lirap_rr_demog$CBEDROOMS <- as.numeric(lirap_rr_demog$CBEDROOMS)
lirap_rr_demog$CMTHRENT <- as.numeric(lirap_rr_demog$CMTHRENT)
lirap_rr_demog$CMTHRENT <- as.numeric(lirap_rr_demog$CMTHRENT)

lirap_rr_demog$'Agency' <- 'Rural Resources'
lirap_snap_demog$'Agency' <- 'SNAP'

lirap_demog <- bind_rows(lirap_rr_demog, lirap_snap_demog)
lirap_demog$Program <- 'LIRAP'

seop_rr_demog <- as.data.frame(lapply(seop_rr_demog, function(x) (gsub("[,$]", "", x))))
seop_rr_demog$CDATE <- as.character(seop_rr_demog$CDATE)
lirap_demog$CMTHUTIL <- as.numeric(lirap_demog$CMTHUTIL)
seop_rr_demog$CHEATINRNT <- as.character(seop_rr_demog$CHEATINRNT)
lirap_demog$CBEDROOMS <- as.numeric(lirap_demog$CBEDROOMS)
seop_rr_demog$C_EARN <- as.character(seop_rr_demog$C_EARN)
seop_rr_demog$C_SELF <- as.character(seop_rr_demog$C_SELF)
seop_rr_demog$C_MIL <- as.character(seop_rr_demog$C_MIL)
seop_rr_demog$C_TANF <- as.character(seop_rr_demog$C_TANF)
seop_rr_demog$C_GAU <- as.character(seop_rr_demog$C_GAU)
seop_rr_demog$C_NOINC <- as.character(seop_rr_demog$C_NOINC)
seop_rr_demog$C_PEN <- as.character(seop_rr_demog$C_PEN)
seop_rr_demog$C_SSA <- as.character(seop_rr_demog$C_SSA)
seop_rr_demog$C_SSI <- as.character(seop_rr_demog$C_SSI)
seop_rr_demog$C_SSD <- as.character(seop_rr_demog$C_SSD)
seop_rr_demog$C_CHLD <- as.character(seop_rr_demog$C_CHLD)
seop_rr_demog$C_UNEMP <- as.character(seop_rr_demog$C_UNEMP)
seop_rr_demog$C_VA <- as.character(seop_rr_demog$C_VA)
seop_rr_demog$C_OTHER <- as.character(seop_rr_demog$C_OTHER)
lirap_demog$SERVDATE <- as.numeric(lirap_demog$SERVDATE)
seop_rr_demog$CNUM0_2 <- as.numeric(seop_rr_demog$CNUM0_2)
seop_rr_demog$CNUM3_5 <- as.numeric(seop_rr_demog$CNUM3_5)
seop_rr_demog$CNUM6_17 <- as.numeric(seop_rr_demog$CNUM6_17)
seop_rr_demog$CNUM18_59 <- as.numeric(seop_rr_demog$CNUM18_59)
seop_rr_demog$CNUM60_ <- as.numeric(seop_rr_demog$CNUM60_)
seop_rr_demog$CNUM75_ <- as.numeric(seop_rr_demog$CNUM75_)
seop_rr_demog$CNUMHC <- as.numeric(seop_rr_demog$CNUMHC)
lirap_demog$CHOUSSTAT <- as.character(lirap_demog$CHOUSSTAT)
seop_rr_demog$CMTHRENT <- as.numeric(seop_rr_demog$CMTHRENT)
seop_rr_demog$CMTHINCOME <- as.numeric(seop_rr_demog$CMTHINCOME)
seop_rr_demog$CMTHINCEAP <- as.numeric(seop_rr_demog$CMTHINCEAP)
seop_rr_demog$CMTHINCPA <- as.numeric(seop_rr_demog$CMTHINCPA)
seop_rr_demog$CMTHINCGRO <- as.numeric(seop_rr_demog$CMTHINCGRO)
seop_rr_demog$CMTHINCERN <- as.numeric(seop_rr_demog$CMTHINCERN)
seop_rr_demog$CMTHINCFS <- as.numeric(seop_rr_demog$CMTHINCFS)
seop_rr_demog$CMTHINCOTH <- as.numeric(seop_rr_demog$CMTHINCOTH)
seop_rr_demog$CPOVLEV <- as.numeric(seop_rr_demog$CPOVLEV)
seop_rr_demog$CM_POVLEV <- as.numeric(seop_rr_demog$CM_POVLEV)
seop_rr_demog$IID <- as.character(seop_rr_demog$IID)
seop_rr_demog$CMTHUTIL <- as.numeric(seop_rr_demog$CMTHUTIL)
seop_rr_demog$CBEDROOMS <- as.numeric(seop_rr_demog$CBEDROOMS)
seop_rr_demog$SERVDATE <- as.numeric(seop_rr_demog$SERVDATE)
seop_rr_demog$enrollmentdate <- as.Date('1900-01-01')+seop_rr_demog$SERVDATE-2

seop_rr_demog$Program <- 'SEOP'
seop_rr_demog$Agency <- 'Rural Resources'
#demog <- lirap_demog
demog <- bind_rows(lirap_demog, seop_rr_demog)

#make demographic data more consistent
demog <- as.data.frame(apply(demog, 2, function(x) {x[x == 'N'] <- 'FALSE'; x}))
demog <- as.data.frame(apply(demog, 2, function(x) {x[x == 'Y'] <- 'TRUE'; x}))
demog$CHOUSTYP[demog$CHOUSTYP == '1'] <- '1-3 unit'
demog$CHOUSTYP[demog$CHOUSTYP == '2'] <- '4+ units'
demog$CHOUSTYP[demog$CHOUSTYP == '3'] <- '1-2 floors'
demog$CHOUSTYP[demog$CHOUSTYP == '4'] <- 'mobile'
demog$CHOUSTYP[demog$CHOUSTYP == '5'] <- '4+ units'
demog$CHOUSTYP[demog$CHOUSTYP == '6'] <- '3+ floors'
demog$CHOUSTYP[demog$CHOUSTYP == '7'] <- 'homeless'
demog$CHOUSTYP[demog$CHOUSTYP == '8'] <- 'rv trailer'

demog$CHEAT[demog$CHEAT == '1'] <- 'Elec'
demog$CHEAT[demog$CHEAT == '2'] <- 'Gas'
demog$CHEAT[demog$CHEAT == '3'] <- 'Prop'
demog$CHEAT[demog$CHEAT == '4'] <- 'Oil'
demog$CHEAT[demog$CHEAT == '5'] <- 'Wood'
demog$CHEAT[demog$CHEAT == '6'] <- 'Coal'

demog$CHEAT2[demog$CHEAT2 == '1'] <- 'Elec'
demog$CHEAT2[demog$CHEAT2 == '2'] <- 'Gas'
demog$CHEAT2[demog$CHEAT2 == '3'] <- 'Prop'
demog$CHEAT2[demog$CHEAT2 == '4'] <- 'Oil'
demog$CHEAT2[demog$CHEAT2 == '5'] <- 'Wood'
demog$CHEAT2[demog$CHEAT2 == '6'] <- 'Coal'

demog$CHEAT <- tolower(demog$CHEAT)
demog$CHEAT2 <- tolower(demog$CHEAT2)
demog$CHOUSTYP <- tolower(demog$CHOUSTYP)

demog$CHOUSSTAT <- tolower(demog$CHOUSSTAT)
demog$CHOUSSTAT[demog$CHOUSSTAT == '1'] <- 'own/buy'
demog$CHOUSSTAT[demog$CHOUSSTAT == '2'] <- 'subsidized'
demog$CHOUSSTAT[demog$CHOUSSTAT == '3'] <- 'rental'
demog$CHOUSSTAT[demog$CHOUSSTAT == '0'] <- NA

###import basecamp information
##Rural Resources uploads a spreadsheet with a new tab for each upload date that contains new participant info
basecamp_rr_1 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 1)
basecamp_rr_2 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 2)
basecamp_rr_3 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 3)
basecamp_rr_4 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 4)
basecamp_rr_5 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 5)
basecamp_rr_6 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 6)
basecamp_rr_7 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 7)
basecamp_rr_8 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 8)
basecamp_rr_9 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 9)
basecamp_rr_10 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 10)
basecamp_rr_11 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 11)
basecamp_rr_12 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 12)
basecamp_rr_13 <- read.xlsx('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/PILOT PROG WORKSHEETS.xlsx', sheet = 13)

basecamp_rr_7$strAccountNumber <- as.character(basecamp_rr_7$strAccountNumber)
basecamp_rr_8$strAccountNumber <- as.character(basecamp_rr_8$strAccountNumber)
basecamp_rr_9$strAccountNumber <- as.character(basecamp_rr_9$strAccountNumber)
basecamp_rr_10$strAccountNumber <- as.character(basecamp_rr_10$strAccountNumber)
basecamp_rr_11$strAccountNumber <- as.character(basecamp_rr_11$strAccountNumber)
basecamp_rr_12$strAccountNumber <- as.character(basecamp_rr_12$strAccountNumber)
basecamp_rr_13$strAccountNumber <- as.character(basecamp_rr_13$strAccountNumber)

basecamp_rr <- bind_rows(basecamp_rr_1, basecamp_rr_2, basecamp_rr_3, basecamp_rr_4,
                         basecamp_rr_5, basecamp_rr_6, basecamp_rr_7, basecamp_rr_8,
                         basecamp_rr_9, basecamp_rr_10, basecamp_rr_11, basecamp_rr_12,
                         basecamp_rr_13)

basecamp_rr$strAccountNumber[nchar(basecamp_rr$strAccountNumber)==9] <- paste('0', basecamp_rr$strAccountNumber, sep = '')[nchar(basecamp_rr$strAccountNumber)==9]
basecamp_rr$mergeindicator <- 1 #96 participants (seems valid)

#import SNAP LRPD enrollment Basecamp info
setwd('/Volumes/Projects/444001 - Avista LI Pilot/Analysis/Billing and Disconnect Analysis/June 2016 Initial Report/MK Files/SNAP/Basecamp/')
options(stringsAsFactors = FALSE)

temp = list.files(pattern="*.CSV")
list2env(
  lapply(setNames(temp, make.names(gsub("*.CSV$", "", temp))), 
         read.csv), envir = .GlobalEnv)

LRPD_ENROLL_042916 <- select(LRPD_ENROLL_042916, -DATCOMP)
LRPD_ENROLL_051716 <- select(LRPD_ENROLL_051716, -DATCOMP)
LRPD_ENROLL_051816 <- select(LRPD_ENROLL_051816, -DATCOMP)
LRPD_ENROLL_052516 <- select(LRPD_ENROLL_052516, -DATCOMP)

LRPD_ENROLL_011116$enrollmentdate <- as.Date('2016-01-11')
LRPD_ENROLL_011916$enrollmentdate <- as.Date('2016-01-19')
LRPD_ENROLL_012716$enrollmentdate <- as.Date('2016-01-27')
LRPD_ENROLL_020516$enrollmentdate <- as.Date('2016-02-05')
LRPD_ENROLL_021016$enrollmentdate <- as.Date('2016-02-10')
LRPD_ENROLL_021916$enrollmentdate <- as.Date('2016-02-19')
LRPD_ENROLL_022616$enrollmentdate <- as.Date('2016-02-26')
LRPD_ENROLL_030416$enrollmentdate <- as.Date('2016-03-04')
LRPD_ENROLL_031116$enrollmentdate <- as.Date('2016-03-11')
LRPD_ENROLL_031816$enrollmentdate <- as.Date('2016-03-18')
LRPD_ENROLL_032416$enrollmentdate <- as.Date('2016-03-11')
LRPD_ENROLL_040116$enrollmentdate <- as.Date('2016-04-01')
LRPD_ENROLL_040716$enrollmentdate <- as.Date('2016-04-07')
LRPD_ENROLL_041816$enrollmentdate <- as.Date('2016-04-18')
LRPD_ENROLL_042116$enrollmentdate <- as.Date('2016-04-21')
LRPD_ENROLL_042916$enrollmentdate <- as.Date('2016-04-29')
LRPD_ENROLL_051716$enrollmentdate <- as.Date('2016-05-17')
LRPD_ENROLL_051816$enrollmentdate <- as.Date('2016-05-18')
LRPD_ENROLL_052516$enrollmentdate <- as.Date('2016-05-25')
LRPD_ENROLL_060116$enrollmentdate <- as.Date('2016-06-01')
LRPD_ENROLL_060316$enrollmentdate <- as.Date('2016-06-03')
LRPD_ENROLL_061016$enrollmentdate <- as.Date('2016-06-10')
LRPD_ENROLL_061616$enrollmentdate <- as.Date('2016-06-16')
LRPD_ENROLL_062016$enrollmentdate <- as.Date('2016-06-20')
LRPD_ENROLL_101215$enrollmentdate <- as.Date('2015-10-12')
LRPD_ENROLL_102015$enrollmentdate <- as.Date('2015-10-20')
LRPD_ENROLL_102615$enrollmentdate <- as.Date('2015-10-26')
LRPD_ENROLL_103015$enrollmentdate <- as.Date('2015-10-30')
LRPD_ENROLL_110615$enrollmentdate <- as.Date('2015-11-06')
LRPD_ENROLL_111315$enrollmentdate <- as.Date('2015-11-13')
LRPD_ENROLL_113015$enrollmentdate <- as.Date('2015-11-30')
LRPD_ENROLL_120915$enrollmentdate <- as.Date('2015-12-09')
LRPD_ENROLL_121815$enrollmentdate <- as.Date('2015-12-18')
LRPD_ENROLL_122315$enrollmentdate <- as.Date('2015-12-23')
LRPD_ENROLL_123115$enrollmentdate <- as.Date('2015-12-31')

basecamp_snap <- rbind(LRPD_ENROLL_011116, LRPD_ENROLL_011916, LRPD_ENROLL_012716, LRPD_ENROLL_020516, LRPD_ENROLL_021016,
                       LRPD_ENROLL_021916, LRPD_ENROLL_022616, LRPD_ENROLL_030416, LRPD_ENROLL_031116, LRPD_ENROLL_031816,
                       LRPD_ENROLL_032416, LRPD_ENROLL_040116, LRPD_ENROLL_040716, LRPD_ENROLL_041816, LRPD_ENROLL_042116,
                       LRPD_ENROLL_042916, LRPD_ENROLL_051716, LRPD_ENROLL_051816, LRPD_ENROLL_052516, LRPD_ENROLL_101215,
                       LRPD_ENROLL_102015, LRPD_ENROLL_102615, LRPD_ENROLL_103015, LRPD_ENROLL_110615, LRPD_ENROLL_111315, 
                       LRPD_ENROLL_113015, LRPD_ENROLL_120915, LRPD_ENROLL_121815, LRPD_ENROLL_122315, LRPD_ENROLL_123115)

basecamp_snap$SA.Account.ID <- as.character(basecamp_snap$X10_DIGIT_ACCT)
basecamp_snap$mergeindicator <- 1 #647 participants (seems valid?)

##create Basecamp subsets for merge (strictly interested in enrollment dates)
basecamp_rr$enrollmentdate <- as.Date('1900-01-01')+basecamp_rr$dtRequisitionDate-2
basecamp_rr$SA.Account.ID <- basecamp_rr$strAccountNumber
basecamp_snap$strFirstName <- sapply(strsplit(basecamp_snap$CUSTOMER_NAME, ';'), '[', 2)
basecamp_snap$strLastName <- sapply(strsplit(basecamp_snap$CUSTOMER_NAME, ';'), '[', 1)

basecamp_rr_concat <- select(basecamp_rr, strFirstName, strLastName, enrollmentdate, SA.Account.ID)
basecamp_snap_concat <- select(basecamp_snap, strFirstName, strLastName, enrollmentdate, SA.Account.ID)

###merge demographic information to basecamp enrollment info
demog_enrollment_1 <- left_join(filter(demog, Agency == 'Rural Resources' & Program == 'LIRAP'), basecamp_rr_concat, by = c("CFIRST1"="strFirstName", 'CLAST1'='strLastName'))
demog_enrollment_2 <- left_join(filter(demog, Agency == 'SNAP'), basecamp_snap_concat, by = c("CFIRST1"="strFirstName", 'CLAST1'='strLastName'))
demog_3 <- filter(demog, Agency == 'Rural Resources' & Program == 'SEOP')

demog_enrollment <- bind_rows(demog_enrollment_1, demog_enrollment_2)
demog_enrollment$enrollmentdate <- as.Date(demog_enrollment$enrollmentdate.y)
demog_3$enrollmentdate <- as.Date(demog_3$enrollmentdate)
demog_enrollment <- bind_rows(demog_enrollment, demog_3)

##merge to usage dataset for regressions
demog_enrollment_usage_1 <- left_join(usage_2, demog_enrollment_1, by = "SA.Account.ID")
demog_enrollment_usage_2 <- left_join(usage_2, demog_enrollment_2, by = "SA.Account.ID")
demog_enrollment_usage_3 <- filter(left_join(usage_1, demog_3, by = c("SA.Account.ID" = 'CIDNUM')), !is.na(Program))
demog_enrollment_usage_4 <- filter(left_join(usage_2, demog_3, by = c("SA.Account.ID" = 'CIDNUM')), !is.na(Program))

demog_enrollment_usage <- filter(rbind(demog_enrollment_usage_1, demog_enrollment_usage_2), !is.na(Agency.y))
demog_enrollment_usage <- bind_rows(demog_enrollment_usage, demog_enrollment_usage_3, demog_enrollment_usage_4)

write.csv(demog, '/Volumes/Projects/444001 - Avista LI Pilot/Data/demographics.csv', row.names = FALSE)

######THE REST OF THIS IS OLD UNUSED CODE
#grantcust_snap <- TO BE RECEIVED WEEK OF JUNE 6

basecamp_rr_wbilling_1 <- left_join(usage_1, basecamp_rr, by = c("SA.Account.ID"="strAccountNumber"))
basecamp_rr_wbilling_2 <- left_join(usage_2, basecamp_rr, by = c("SA.Account.ID"="strAccountNumber"))
count(basecamp_rr_wbilling_1, mergeindicator) #0 matches
count(basecamp_rr_wbilling_2, mergeindicator) #1191 matches (out of 10945)

lirap_rr_demog$mergeindicator <- 1 #82 participants (seems valid)
lirap_rr_demog_wbilling_1 <- left_join(usage_1, lirap_rr_demog, by = c("SA.Account.ID"="CIDNUM"))
lirap_rr_demog_wbilling_2 <- left_join(usage_2, lirap_rr_demog, by = c("SA.Account.ID"="CIDNUM"))
count(lirap_rr_demog_wbilling_1, mergeindicator) #0 matches
count(lirap_rr_demog_wbilling_2, mergeindicator) #1209 matches (out of 10945)

#merge demographic and basecamp info
complete_rr_1 <- left_join(basecamp_rr, lirap_rr_demog, by = c('strAccountNumber'='CIDNUM'))
complete_rr_2 <- left_join(usage_2, complete_rr_1, by = c("SA.Account.ID"="strAccountNumber"))
count(complete_rr_2, mergeindicator.y) #1191 matches (out of 10945)
#count(test, mergeindicator.y) == min(nrow(basecamp_rr), nrow(ratediscountcust_rr_demog))


basecamp_snap_wbilling_1 <- left_join(usage_1, basecamp_snap, by = "SA.Account.ID")
basecamp_snap_wbilling_2 <- left_join(usage_2, basecamp_snap, by = "SA.Account.ID")
count(basecamp_snap_wbilling_1, mergeindicator) #0 matches
count(basecamp_snap_wbilling_2, mergeindicator) #6353 matches

#merge LIRAP demographic and basecamp info
complete_snap_1 <- left_join(basecamp_snap, lirap_snap_demog, by = 'CUSTOMER_NAME')
complete_snap_2 <- left_join(usage_2, complete_snap_1, by = 'SA.Account.ID')
count(complete_snap_2, mergeindicator) #6353 matches (out of 10945)



##Descriptives
#Table 1: Pilot and SEOP Participation
lirap_rr_demog_table1 <- select(lirap_rr_demog, CIDNUM, CLAST1, CFIRST1, SERVDATE)
lirap_rr_demog_table1$Program <- 'LIRAP'
lirap_rr_demog_table1$Agency <- 'Rural Resources'
lirap_rr_demog_table1$date <- as.Date(lirap_rr_demog_table1$SERVDATE)

seop_rr_demog_table1 <- select(seop_rr_demog, CIDNUM, CLAST1, CFIRST1, SERVDATE)
seop_rr_demog_table1$Program <- 'SEOP'
seop_rr_demog_table1$Agency <- 'Rural Resources'
seop_rr_demog_table1$date <- as.Date('1900-01-01')+seop_rr_demog_table1$SERVDATE-2

lirap_snap_demog_table1 <- select(complete_snap_1, CIDNUM, CLAST1, CFIRST1, CDATE)
lirap_snap_demog_table1$Program <- 'LIRAP'
lirap_snap_demog_table1$Agency <- 'SNAP'
colnames(lirap_snap_demog_table1)[4] <- "SERVDATE"
lirap_snap_demog_table1$date <- as.Date('1900-01-01')+lirap_snap_demog_table1$SERVDATE-2

table1 <- rbind(lirap_rr_demog_table1, lirap_snap_demog_table1, seop_rr_demog_table1)
table1$lirap_period <- 1
table1$lirap_period[table1$date < as.Date('2015-10-01')] <- 0

table1_aggr <- ddply(table1, c('Agency', 'Program', 'lirap_period'), summarise,
                        'Number of Customers' = length(CIDNUM)
)

#determine how many LIRAP participants also partcipated in SEOP, and when
table1$seop_pre <- 0
table1$lirap_pre <- 0
table1$seop_post <- 0
table1$lirap_post <- 0
table1$seop_pre[table1$Program == 'SEOP' & table1$lirap_period == 0] <- 1
table1$lirap_pre[table1$Program == 'LIRAP' & table1$lirap_period == 0] <- 1
table1$seop_post[table1$Program == 'SEOP' & table1$lirap_period == 1] <- 1
table1$lirap_post[table1$Program == 'LIRAP' & table1$lirap_period == 1] <- 1

table1_previouspart_aggr <- ddply(table1, c('Agency', 'CLAST1', 'CFIRST1'), summarise,
                             'SEOP_pre' = max(seop_pre, na.rm = TRUE),
                             'LIRAP_pre' = max(lirap_pre, na.rm = TRUE),
                             'SEOP_post' = max(seop_post, na.rm = TRUE),
                             'LIRAP_post' = max(lirap_post, na.rm = TRUE)
)  


table1_previouspart <- table(table1_previouspart_aggr$SEOP_pre,table1_previouspart_aggr$LIRAP_post) # A will be rows, B will be columns 
table1_previouspart # print table 

library(pastecs)
test <- as.data.frame(stat.desc(lirap_snap_demog)) 


#energy consumption
lirap_snap_energy <- filter(complete_snap_2, mergeindicator == 1)
lirap_snap_energy$participation_date <- as.Date('1900-01-01')+lirap_snap_energy$CDATE-2
lirap_snap_energy$start_date <- as.Date('1900-01-01')+lirap_snap_energy$Bill.Date-2
lirap_snap_energy$end_date <- as.Date('1900-01-01')+lirap_snap_energy$End.Read.Date-2

lirap_snap_energy$post <- 0
lirap_snap_energy$post[ lirap_snap_energy$participation_date < lirap_snap_energy$end_date] <- 1

