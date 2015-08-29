
columns <- "name index2014 index2012
#42
zelfstandigheid_boodsch 163 NA
zelfstandigheid_koken   164 NA 
zelfstandigheid_wassen  165  NA
zelfstandigheid_verpl   166  NA
#41
gezondheid              162 169
#43
langdurig_ziek          167 170
#45
belemmer_thuis      175 171
belemmer_vrijetijd  176 172
belemmer_werk       177 173
belemmer_sociaal    178  NA
#46
onderst_fam       179 177
onderst_beroep    180 178
onderst_vrijw     181 179
onderst_part      182 180
onderst_geen      183 181
onderst_nietnodig 184 182
#52
inzet_01 212 207
inzet_02 213 208
inzet_03 214 209
inzet_04 215 210
inzet_05 216 211
inzet_06 217 212
inzet_07 218 213
inzet_08 219 214
inzet_09 220 215
inzet_10 221 216
#54
geholpen 235 230
#77
geslacht 317 302
#78
leeft 318 303
#79
landgeb 303 288
landgeb_vader 304 290
landgeb_moeder 305 292
#80
hh 309 294
#81
nhh 311 296
#82
oplniv 312 297
#83
werk 313 298
#84
postcode 316 300
#buurt
buurt 315 301"
columns <- read.table(textConnection(columns), stringsAsFactors = FALSE, 
  header=TRUE)


orig_2014 <- read.csv("../../_zwolle/BvB/BvB/BvB 2014.csv", stringsAsFactors=FALSE,
  na = "#NULL!")
orig_2012 <- read.csv("../../_zwolle/BvB/BvB/BvB 2012.csv", stringsAsFactors=FALSE,
  na = "#NULL!")


library(dplyr)
data <- rbind_all(list(data_2012, data_2014))

oplniv <- 'orig,new
"Geen opgave",onbekend
"Hoger algemeen en voortgezet onderwijs (havo, vwo, hbs, mms, atheneum, gymnasium)",middelbaar
"Hoger beroepsonderwijs (hbo, heao, hts, lerarenopleiding, sociale academie e.d.)",hoger
"Ik heb geen schoolopleiding afgerond",lager
"Lager beroepsonderwijs (lbo, lts, leao, lhno, huishoudschool, ambachtsschool)",lager
"Lager beroepsonderwijs (lbo, lts, leao, lhno, huishoudschool, ambachtsschool, speciaal onderwijs, praktijkonderwijs)",lager
"Lager onderwijs / basisonderwijs / speciaal basisonderwijs",lager
"Middelbaar algemeen en voortgezet onderwijs (mavo, mulo)",middelbaar
"Middelbaar beroepsonderwijs (mbo, mts, meao, leerlingwezen)",middelbaar
"Speciaal onderwijs / praktijkonderwijs",lager
"Voorbereidend middelbaar beroepsonderwijs (vmbo)",lager
"Wetenschappelijk onderwijs (universiteit)",hoger'
oplniv <- read.csv(textConnection(oplniv))
m <- match(data$oplniv, oplniv$orig)
data$oplniv <- oplniv$new[m]



werk <- 'orig;new
-99;onbekend
Anders, namelijk ;onbekend
Anders, namelijk:;onbekend
Geen opgave;onbekend
Ik ben met pensioen / ik ben met vervroegd pensioen;pensioen
Ik ben student / ga naar school;student
Ik heb betaald werk bij een baas;werk
Ik heb betaald werk bij een werkgever;werk
Ik heb een bijstandsuitkering;uitkering
Ik heb een eigen bedrijf met personeel;eigenbedrijf
Ik heb een eigen bedrijf zonder personeel (freelancer, zelfstandige zonder personeel);eigenbedrijf
Ik heb een uitkering voor arbeidsongeschiktheid;uitkering
Ik heb een werkloosheidsuitkering;uitkering
Ik heb geen eigen inkomen (bijv. omdat iemand anders in het huishouden kostwinner is);geeninkomen'
werk <- read.csv2(textConnection(werk))
m <- match(data$werk, werk$orig)
data$werk <- werk$new[m]

hh <- 'orig;new
Alleenstaand;alleenstaand
Echt)paar, met thuiswonend(e) kind(eren);samenw_kinderen
(Echt)paar, zonder thuiswonend(e) kind(eren);samenw_zonder_kinderen
Een andere samenstelling, namelijk:;overig
Eenoudergezin;eenouder
Eén ouder, met (thuiswonende) kinderen;eenouder_kinderen
Geen opgave;overig
Ik woon alleen;alleenstaand
Samenwonend / gehuwd met thuiswonende kind(eren);samenw_kinderen
Samenwonend/ gehuwd zonder thuiswonende kind(eren);samenw_zonder_kinderen
Studentenhuis;alleenstaand'
hh <- read.csv2(textConnection(hh))
m <- match(data$hh, hh$orig)
data$hh <- hh$new[m]

onderst <- 'orig;new
0;0
1;1
Answered;1
Geen opgave;
Not Answered;0'
onderst <- read.csv2(textConnection(onderst))
m <- match(data$onderst_fam, onderst$orig)
data$onderst_fam <- onderst$new[m]
m <- match(data$onderst_beroep, onderst$orig)
data$onderst_beroep <- onderst$new[m]
m <- match(data$onderst_vrijw, onderst$orig)
data$onderst_vrijw <- onderst$new[m]
m <- match(data$onderst_part, onderst$orig)
data$onderst_part <- onderst$new[m]
m <- match(data$onderst_geen, onderst$orig)
data$onderst_geen <- onderst$new[m]
m <- match(data$onderst_nietnodig, onderst$orig)
data$onderst_nietnodig <- onderst$new[m]

landgeb <- 'orig;new
-99;onbekend
Ander land, namelijk:;westers
Geen opgave;onbekend
In een ander land, namelijk:;westers
Marokko;nietwesters
Nederland;nederland
Nederlandse Antillen Nederlandse Antillen of Aruba;nietwesters
Suriname;nietwesters
Turkije;nietwesters'
landgeb <- read.csv2(textConnection(landgeb))
m <- match(data$landgeb, landgeb$orig)
data$landgeb <- landgeb$new[m]

m <- match(data$landgeb_moeder, landgeb$orig)
data$landgeb_moeder <- landgeb$new[m]

m <- match(data$landgeb_vader, landgeb$orig)
data$landgeb_vader <- landgeb$new[m]




write.csv(data, "bvb.csv", row.names=FALSE)


