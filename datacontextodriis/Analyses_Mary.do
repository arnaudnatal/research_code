**************
** NEEMSIS-2 **
***************

** 1. Création de la base de travail **
*-------------------------------------*
use "${plocation}\OneDrive - Université Paris-Dauphine\Thèse\RUME-NEEMSIS\Données modifiées\AppariementPanel.dta", clear 

	* 1.1 Garder uniquement les individus dont on une information pour 2020 * 
	drop if HHID2020=="" & INDID2020=="" 
	count 
	* Il reste 3647 observations * 
	
	* 1.2 Suppression des membres ayant quitté leur ménage : migration ou décès * 
	codebook livinghome2020
	drop if livinghome2020=="No, left permanently (new household/got married/ left more than 1 year)" | livinghome2020=="No died" | livinghome2020==""
	count 
	* Il reste 3005 observations *
	
	* 1.3 Garder uniquement les variables d'intérêt * 
	drop agecorr2010 livinghome2010 lefthomereason2010 member_left2010 relationshiptohead2010 relationshiptoheadother2010 villageid2010 villagearea2010 reasonlefthome2010 reasonlefthomeother2010 submissiondate2010 agecorr2016 livinghome2016 lefthomereason2016 member_left2016 relationshiptohead2016 relationshiptoheadother2016 villageid2016 villagearea2016 reasonlefthome2016 reasonlefthomeother2016 HHID2016 INDID2016 HHID2010 INDID2010 submissiondate2016 only2010 only2016 in20102016 m_agepanel2010_r m_agepanel2016_r m_agepanel2010_n m_agepanel2016_n diffagepanel2010 diffagepanel2016
	
save "${mod_dta}\NEEMSIS2.dta", replace

	
	* 1.4 Ajout d'infos manquantes *
		* a- Questionnaire ménage *
		sort HHID2020 INDID2020
		destring INDID2020, replace 
		merge 1:1 HHID2020 INDID2020 using "${raw_n2}\NEEMSIS2-HH.dta"
		keep if _merge==3 
		drop _merge 
		* 3005 observations (O.K) * 
		
		* b- Questionnaire individuel *
		sort HHID2020 INDID2020
		merge 1:1 HHID2020 INDID2020 using "${raw_n2}\NEEMSIS2-ego.dta"
		* Pour 8 ego, on n'a pas les infos au niveau ménage car ce sont des individus qui sont morts - changement d'égo pris en compte sûrement *
		drop if _merge==2
		drop _merge 
		count
		* Il reste 3005 observations (O.K) * 
		
		* c- Base des occupations *
		sort HHID2020 INDID2020
		merge 1:1 HHID2020 INDID2020 using "C:\Users\disantolo\Dropbox (IRD)\NEEMSIS\2. Data\Constructed_data\NEEMSIS2-occup_indiv.dta"
		keep if _merge==3
		drop _merge
		count 
		* Il reste 3005 observations (O.K) * 
		
	* 1.5 Suppression des 6 ménages pour lesquels on n'a pas d'info au niveau ménage * 
	drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
	drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
	drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef" 
	drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4" 
	drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7" 
	drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409" 
		

save "${mod_dta}\NEEMSIS2_2.dta", replace


** 2. Variables **
*----------------* 
	* 2.1 Questionnaire ménage * 
		* a- Education (discrimination positive) * 
		keep if agecorr2020>=25
		count 
		* 1862 observations *
		
		** RQ : conditionnalité au fait d'avoir déjà été à l'école **
		codebook everattendedschool 
		* Echantillon de 1315 individus * 
		
		ta reservation everattendedschool, miss
		* Pour deux individus qui, normalement, n'auraient jamais été scolarisés, on a une réponse positive à la question en lien avec le fait d'avoir bénéficié de dispositifs de discrimination positive à l'école *
			// Qui sont ces individus ? 
			ta HHID_panel INDID_panel if reservation==1 & everattendedschool==0
			// Ind_2 dans les ménages NAT30 et SEM23 *
			// Quel est leur niveau d'éducation ? 
			ta classcompleted if INDID_panel=="Ind_2" & HHID_panel=="NAT30"
			* 12th class * 
			ta classcompleted if INDID_panel=="Ind_2" & HHID_panel=="SEM23"
			* 10th class *
			// Il faut donc remplacer la valeur de la variable "everattendedschool" pour ces deux individus 
			replace everattendedschool=1 if INDID_panel=="Ind_2" & HHID_panel=="NAT30" | INDID_panel=="Ind_2" & HHID_panel=="SEM23"
			// Echantillon de 1317 individus * 
			
		codebook reservation if everattendedschool==1
		* On a donc 277 individus (/1317) qui ont bénéficié/bénéficient de dispositifs de discrimination positive à l'école - soit 21% *
		// Mais de quels dispositifs exactement ? 
		** RQ : 1 - Quotas in higher education institutions ; 2 - Free secondary schooling ; 3 - Scholarships ; 4 - Specific schools ; 5 - Hostels and free mid day meals ** 
		ta reservationkind if reservation==1, miss
		* Aucune valeur manquante *
		g quotas=0 if reservation==1
		replace quotas=1 if (reservationkind=="1" & reservation==1) | (reservationkind=="1 2 3 5" & reservation==1) | (reservationkind=="1 2 5" & reservation==1) | (reservationkind=="1 3" & reservation==1) | (reservationkind=="1 3 4" & reservation==1) | (reservationkind=="1 3 5" & reservation==1) | (reservationkind=="1 4 5" & reservation==1) | (reservationkind=="1 5" & reservation==1)
		
		g freescndschl=0 if reservation==1
		replace freescndschl=1 if (reservationkind=="2" & reservation==1) | (reservationkind=="1 2 3 5" & reservation==1) | (reservationkind=="1 2 5" & reservation==1) | (reservationkind=="2 3" & reservation==1) | (reservationkind=="2 3 5" & reservation==1) | (reservationkind=="2 3 5 77" & reservation==1) | (reservationkind=="2 4" & reservation==1) | (reservationkind=="2 4 5" & reservation==1) | (reservationkind=="2 5" & reservation==1) 
		
		g scholarships=0 if reservation==1
		replace scholarships=1 if (reservationkind=="3" & reservation==1) | (reservationkind=="1 2 3 5" & reservation==1) | (reservationkind=="1 3" & reservation==1) | (reservationkind=="1 3 4" & reservation==1) | (reservationkind=="1 3 5" & reservation==1) | (reservationkind=="2 3" & reservation==1) | (reservationkind=="2 3 5" & reservation==1) | (reservationkind=="2 3 5 77" & reservation==1) | (reservationkind=="3 4" & reservation==1) | (reservationkind=="3 5" & reservation==1) |  (reservationkind=="3 77" & reservation==1) 
		
		g speschools=0 if reservation==1
		replace speschools=1 if (reservationkind=="4" & reservation==1) | (reservationkind=="1 3 4" & reservation==1) | (reservationkind=="1 4 5" & reservation==1) | (reservationkind=="2 4" & reservation==1) | (reservationkind=="2 4 5" & reservation==1) | (reservationkind=="3 4" & reservation==1) | (reservationkind=="4 5" & reservation==1) 
		
		g hostmiddmeals=0 if reservation==1
		replace hostmiddmeals=1 if (reservationkind=="5" & reservation==1) | (reservationkind=="1 2 3 5" & reservation==1) | (reservationkind=="1 2 5" & reservation==1) | (reservationkind=="1 3 5" & reservation==1) | (reservationkind=="1 4 5" & reservation==1) | (reservationkind=="1 5" & reservation==1) | (reservationkind=="2 3 5" & reservation==1) | (reservationkind=="2 3 5 77" & reservation==1) |  (reservationkind=="2 4 5" & reservation==1) | (reservationkind=="2 5" & reservation==1) | (reservationkind=="3 5" & reservation==1) | (reservationkind=="4 5" & reservation==1) 
		
		foreach var of varlist quotas freescndschl scholarships speschools hostmiddmeals {
		ta `var' if reservation==1
		}
		
		* Parmi les 277 bénéficiaires de dispositifs de discrimination positive, 31% ont disposé/disposent de quotas, 50% ont bénéficié/bénéficient de la gratuité des frais d'inscription en école secondaire, 30% ont bénéficié/bénéficient d'une bourse, 16% ont bénéficié/bénéficient d'une scolarisation dans un établissement spécialisé, et 65% ont bénéficié/bénéficient d'un logement et de repas du midi gratuit(s) - gratuité du logement/repas du midi et gratuité de l'enseignement secondaire sont les plus répandus >50% * 
			** RQ : somme des pourcentages > 100% car possibilité de bénéficier de plusieurs dispositifs durant la scolarité ** 
		
			** Analyse selon la caste **
			ta reservation caste_panel,row
			* Parmi les 277 bénéficiaires, 124 sont de basse caste - 45%, 116 de caste moyenne - 42% et 37 de haute caste - 13% *
				** RQ : bizarre pour les hautes castes et potentiellement pour les castes moyennes - vérification avec le sexe ** 
				ta reservation sex_panel if caste_panel=="Middle" 
				* 47 femmes et 69 hommes *
				ta reservation sex_panel if caste_panel=="Upper" 
				* 17 femmes et 20 hommes *
				
			foreach var of varlist quotas freescndschl scholarships speschools hostmiddmeals {
			ta `var' caste_panel,row
			}
			* Faits notables : les bénéficiaires de caste moyenne sont relativement plus inscrits au sein des dispositifs d'institutions scolaires spécifiques (54%) et de quotas au sein de l'enseignement supérieur (49%), tandis que pour les basses castes, ce sont au sein des dispositifs de bourse qu'ils sont le plus représentés (58%) *
				
			** Analyse selon le genre ** 
			ta reservation sex_panel, row 
			* Parmi les 277 bénéficiaires de dispositifs de discrimination positive, 53% sont des hommes et 47% sont des femmes * 
			
		* b- Marché du travail (discrimination positive) *
		codebook reservationemployment if agecorr2020>10
		* 101 valeurs manquantes 
		// 961 (/2552) qui ont dit avoir bénéficié de ce type de discrimination positive - près de 38% *
		
			** Analyse selon la caste ** 
			ta reservationemployment caste_panel if agecorr2020>10, row
			* Parmi les individus bénéficiaires, près de 50% sont de basse caste, 42% de caste moyenne et 8% de haute caste *
			
			** Analyse selon le genre **
			ta reservationemployment sex_panel if agecorr2020>10, row
			* Parmi les individus bénéficiaires, près de 52% sont des hommes et 48% sont des femmes *
			
			** Analyse inter-secteurs **
			ta reservationemployment mainocc_occupation_indiv if agecorr2020>10, row 
			* Principalement pour des emplois occasionnels (48%), notamment agricoles (26%) * 
			
			
		* c- Pouvoir de décision (dépenses consommation et de santé) * 
		codebook decisionconsumption decisionhealth
		* Pas de valeur manquante * 
		destring decisionconsumption decisionhealth, replace 
		label define decisionconsumptionlbl 1 "Yourself" 2 "Spouse" 3 "Your spouse and yourself jointly" 4 "Someone else" 5 "Yourself and someone else jointly" 77 "Other"
		label values decisionconsumption decisionconsumptionlbl
		 
		label define decisionhealthlbl 1 "Yourself" 2 "Spouse" 3 "Your spouse and yourself jointly" 4 "Someone else" 5 "Yourself and someone else jointly" 77 "Other"
		label values decisionhealth decisionhealthlbl
		
			** Dépenses de consommation ** 
			ta decisionconsumption, miss 
			* 8 obs. "Someone Else" + 51 obs. "Yourself and someone else jointly" * 
				ta HHID_panel if decisionconsumption==4
				* Ménages concernés : KAR3 et ORA15 
				// Quelle est la composition de ces ménages ? * 
					ta relationshiptohead2020 if HHID_panel=="KAR3" 
					* Ménage composé de 2 individus : chef de ménage et sa femme * 
						ta decisionhealth if HHID_panel=="KAR3"
						* Pour les dépenses de santé, c'est la femme qui prend les décisions 
						// Formulation de l'hypothèse que c'est la même chose pour les dépenses de consommation * 
					ta relationshiptohead2020 if HHID_panel=="ORA15" 
					* Ménage composé de 6 individus : chef de ménage, la belle-fille, le fils et trois petits enfants 
					// Formulation de l'hypothèse que ce soit le fils qui prend les décisions * 
			
				ta HHID_panel if decisionconsumption==5 
				* Ménages concernés : KAR56, KOR21, KOR39, KOR47, MAN1, MANAM60, NAT6, et SEM45 * 
				// Quelle est la composition de ces ménages ? * 
					ta relationshiptohead2020 if HHID_panel=="KAR56" 
					* Ménage composé de 5 individus : chef de ménage, sa femme, ses deux fils et sa fille 
					// Formulation de l'hypothèse que ce soit le chef de ménage et le fils AÎNE qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="KOR21" 
					* Ménage composé de 8 individus : chef de ménage, ses deux fils, ses deux belles-filles et trois de ses petits enfants
						ta relationshiptohead2020 sex_panel if HHID_panel=="KOR21" 
						* Chef de ménage est une femme *
					// Formulation de l'hypothèse que ce soit le chef et le fils AÎNE qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="KOR39" 
					* Ménage composé de 3 individus : chef de ménage et ses deux fils
					// Formulation de l'hypothèse que ce soit le chef et le fils AÎNE qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="KOR47" 
					* Ménage composé de 8 individus : chef de ménage, beaux parents et 5 autres personnes 
						ta relationshiptohead2020 sex_panel if HHID_panel=="KOR47" 
						* Chef de ménage est un homme * 
					// Formulation de l'hypothèse que ce soit le chef de ménage et son beau-père qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="MAN1" 
					* Ménage composé de 5 individus : chef de ménage, son fils, sa belle-fille et deux petit-enfants 
						ta relationshiptohead2020 sex_panel if HHID_panel=="MAN1" 
						* Chef de ménage est une femme * 
					// Formulation de l'hypothèse que ce soit le chef et le fils qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="MANAM60" 
					* Ménage composé de 7 individus : chef de ménage, deux fils, deux belles-filles et deux petits enfants * 
						ta relationshiptohead2020 sex_panel if HHID_panel=="MANAM60" 
						* Chef de ménage est un homme * 
					// Formulation de l'hypothèse que ce soit le chef et le fils AÎNE qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="NAT6" 
					* Ménage composé de 4 individus : chef de ménage et ses trois filles
						ta relationshiptohead2020 sex_panel if HHID_panel=="NAT6" 
						* Chef de ménage est une femme * 
					// Formulation de l'hypothèse que ce soit le chef et la fille AÎNEE qui prennent conjointement les décisions * 
					ta relationshiptohead2020 if HHID_panel=="SEM45" 
					* Ménage composé de 11 individus : chef de ménage, ses trois fils, ses trois belles-filles et ses quatre petits enfants
						ta relationshiptohead2020 sex_panel if HHID_panel=="SEM45" 
						* Chef de ménage est une femme * 
					// Formulation de l'hypothèse que ce soit le chef et la fils AÎNE qui prennent conjointement les décisions * 
					
					
			g agechld=agecorr2020 if relationshiptohead2020=="Son" | relationshiptohead2020=="Daughter"
			bysort HHID_panel : egen ageoldchld=max(agechld)
			g olderchild=1 if (agecorr2020==ageoldchld & relationshiptohead2020=="Son") | (agecorr2020==ageoldchld & relationshiptohead2020=="Daughter")
			replace olderchild=0 if (agecorr2020!=ageoldchld & relationshiptohead2020=="Son") | (agecorr2020!=ageoldchld & relationshiptohead2020=="Daughter")
			label var olderchild "Older child"
			drop agechld ageoldchld
				
			g decmakcons=0
			replace decmakcons=1 if (decisionconsumption==1 & relationshiptohead2020=="Head")
			replace decmakcons=1 if (decisionconsumption==2 & relationshiptohead2020=="Husband") | (decisionconsumption==2 & relationshiptohead2020=="Wife")
			replace decmakcons=1 if (decisionconsumption==3 & relationshiptohead2020=="Head") | (decisionconsumption==3 & relationshiptohead2020=="Husband") | (decisionconsumption==3 & relationshiptohead2020=="Wife")
			replace decmakcons=1 if (decisionconsumption==4 & relationshiptohead2020=="Son" & HHID_panel=="ORA15") | (decisionconsumption==4 & relationshiptohead2020=="Wife" & HHID_panel=="KAR3")
			replace decmakcons=1 if (decisionconsumption==5 & relationshiptohead2020=="Head") | (decisionconsumption==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="KAR56") | (decisionconsumption==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="KOR21") | (decisionconsumption==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="KOR39") | (decisionconsumption==5 & relationshiptohead2020=="Father-in-law" & HHID_panel=="KOR47") | (decisionconsumption==5 & relationshiptohead2020=="Son" & HHID_panel=="MAN1") | (decisionconsumption==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="MANAM60") | (decisionconsumption==5 & relationshiptohead2020=="Daughter" & olderchild==1 & HHID_panel=="NAT6") | (decisionconsumption==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="SEM45")
			label var decmakcons "Decision-making on consumption-related expenses"
			
					** Analyse inter-sexe ** 
					ta decmakcons sex_panel, row
					* Parmi les 590 individus qui ont un pouvoir de décision en lien avec les dépenses de consommation, 60% sont des femmes *
				
				** Dépenses de santé ** 
				ta decisionhealth, miss 
				* 10 obs. "Someone Else" + 46 obs. "Yourself and someone else jointly" * 
					ta HHID_panel if decisionhealth==4
					* Ménages concernés : SEM62 et ORA15 
					// Quelle est la composition de ces ménages ? * 
						ta relationshiptohead2020 if HHID_panel=="SEM62" 
						* Ménage composé de 4 individus : chef de ménage, sa femme et ses deux fils
						// Formulation de l'hypothèse que ce soit le fils AÎNE qui prend les décisions *  
						ta relationshiptohead2020 if HHID_panel=="ORA15" 
						* Ménage composé de 6 individus : chef de ménage, la belle-fille, le fils et les trois petits enfants 
						// Formulation de l'hypothèse que ce soit le fils qui prend les décisions * 
					ta HHID_panel if decisionhealth==5 
					* Ménages concernés : KOR28, KOR39, KOR9, KUV18, MAN54, MANAM59, NAT6, ORA46, et SEM56 * 
					// Quelle est la composition de ces ménages ? * 
						ta relationshiptohead2020 if HHID_panel=="KOR28" 
						* Ménage composé de 10 individus : chef de ménage, sa femme, sa fille, ses deux fils, ses deux belles-filles et ses trois petits enfants
						// Formulation de l'hypothèse que ce soit le chef de ménage et le fils AÎNE qui prennent conjointement les décisions *  
						ta relationshiptohead2020 if HHID_panel=="KOR39" 
						* Ménage composé de 3 individus : chef de ménage et ses deux fils 
						// Formulation de l'hypothèse que ce soit le chef de ménage et le fils AÎNE qui prennent conjointement les décisions *  
						ta relationshiptohead2020 if HHID_panel=="KOR9" 
						* Ménage composé de 5 individus : chef de ménage, sa femme, son fils et ses deux filles *
							ta decisionconsumption if HHID_panel=="KOR9"
							* Pour les dépenses de consommation, c'est la femme du chef de ménage qui prend les decisions *
						// Formulation de l'hypothèse que ce soit le chef de ménage et sa femme qui prennent conjointement les décisions *  
						ta relationshiptohead2020 if HHID_panel=="KUV18" 
						* Ménage composé de 2 individus : chef de ménage et son fils 
						// Formulation de l'hypothèse que ce soit le chef de ménage et son fils qui prennent conjointement les décisions *  
						ta relationshiptohead2020 if HHID_panel=="MAN54" 
						* Ménage composé de 5 individus : chef de ménage, sa femme, son père, sa mère et son fils 
						// Formulation de l'hypothèse que ce soit le chef de ménage et son père qui prennent conjointement les décisions * 
						ta relationshiptohead2020 if HHID_panel=="MANAM59" 
						* Ménage composé de 5 individus : chef de ménage, sa femme, son fils, sa fille et sa belle-fille 
						// Formulation de l'hypothèse que ce soit le chef de ménage et son fils qui prennent conjointement les décisions * 
						ta relationshiptohead2020 if HHID_panel=="NAT6" 
						* Ménage composé de 4 individus : chef de ménage et ses trois filles
						// Formulation de l'hypothèse que ce soit le chef de ménage et sa fille AÎNEE qui prennent conjointement les décisions * 
						ta relationshiptohead2020 if HHID_panel=="ORA46" 
						* Ménage composé de 4 individus : chef de ménage, sa femme et ses deux fils
						// Formulation de l'hypothèse que ce soit le chef de ménage et son fils AÎNE qui prennent conjointement les décisions * 
						ta relationshiptohead2020 if HHID_panel=="SEM56" 
						* Ménage composé de 8 individus : chef de ménage, ses trois fils, ses deux belles-filles et ses deux petits enfants
						// Formulation de l'hypothèse que ce soit le chef de ménage et son fils AÎNE qui prennent conjointement les décisions * 
					
					
				g decmakhealth=0
				replace decmakhealth=1 if (decisionhealth==1 & relationshiptohead2020=="Head")
				replace decmakhealth=1 if (decisionhealth==2 & relationshiptohead2020=="Husband") | (decisionhealth==2 & relationshiptohead2020=="Wife")
				replace decmakhealth=1 if (decisionhealth==3 & relationshiptohead2020=="Head") | (decisionhealth==3 & relationshiptohead2020=="Husband") | (decisionhealth==3 & relationshiptohead2020=="Wife")
				replace decmakhealth=1 if (decisionhealth==4 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="SEM62") | (decisionhealth==4 & relationshiptohead2020=="Son" & HHID_panel=="ORA15")
				replace decmakhealth=1 if (decisionhealth==5 & relationshiptohead2020=="Head") | (decisionhealth==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="KOR28") | (decisionhealth==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="KOR39") | (decisionhealth==5 & relationshiptohead2020=="Wife" & HHID_panel=="KOR9") | (decisionhealth==5 & relationshiptohead2020=="Son" & HHID_panel=="KUV18") | (decisionhealth==5 & relationshiptohead2020=="Father" & HHID_panel=="MAN54") | (decisionhealth==5 & relationshiptohead2020=="Son" & HHID_panel=="MANAM59") | (decisionhealth==5 & relationshiptohead2020=="Daughter" & olderchild==1 & HHID_panel=="NAT6") | (decisionhealth==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="ORA46") | (decisionhealth==5 & relationshiptohead2020=="Son" & olderchild==1 & HHID_panel=="SEM56")
				label var decmakhealth "Decision-making on health-related expenses"
					
				g decmakexp=0
				replace decmakexp=1 if decmakcons==1 & decmakhealth==1
				label var decmakexp "Decision-making on all expenses"
			
					** Analyse inter-sexe ** 
					ta decmakexp sex_panel, row
					* Parmi les 590 individus qui ont un pouvoir de décision en lien avec les dépenses de santé, environ 64% sont des femmes *
			
				g decmakind=0
				replace decmakind=(decmakcons + decmakhealth)
				label var decmakind "Decision-making indicator"
				g decmakind2=decmakind/2
			
					** Analyse inter-sexe ** 
					tabstat decmakind2, stat(mean) by(sex_panel)
					* Femmes qui ont un pouvoir de décision plus important en matière de dépenses (consommation et santé) *
					
					
	* 2.2 Questionnaire individuel * 
		* a- Marché du travail (satisfaction) * 
		global motiv useknowledgeatwork satisfyingpurpose schedule takeholiday 
		* The more is best 
		recode useknowledgeatwork (4=1) (3=2) (2=3) (1=4) 
		recode schedule (4=1) (3=2) (2=3) (1=4) 
		recode takeholiday (4=1) (3=2) (2=3) (1=4) 
		egen motiv=rowtotal($motiv)
		replace motiv=motiv/16 
			
			** Analyse inter-secteurs ** 
			tabstat motiv, stat(mean) by(mainocc_occupation_indiv)
			* Plus bas niveau de facteurs motivants (mobilisation de ses compétences/connaissances, objectif satisfant, motivations à donner le meilleur de soi-même, autonomie) au travail pour les emplois publics de type NREGA et le plus haut pour les emplois réguliers et qualifiés dans le secteur non-agri * 
			
			
		global oblig agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4
		* The more is worst 
		recode agreementatwork4 (4=1) (3=2) (2=3) (1=4) 
		egen oblig=rowtotal($oblig)
		replace oblig=oblig/16  
			
			** Analyse inter-secteurs ** 
			tabstat oblig, stat(mean) by(mainocc_occupation_indiv)
			* Plus haut niveau d'obligations (financière, sociale - obligation et recherche d'approbation sous peine de sanction sociale, pas d'importance à effectuer ce travail) pour les emplois publics réservés de type NREGA et plus bas niveau pour le fait d'être indép dans le secteur agri. 
			
			
		global satisf happywork satisfactionsalary
		* The more is best 
		recode happywork (4=1) (3=2) (2=3) (1=4) 
		recode satisfactionsalary (4=1) (3=2) (2=3) (1=4) 
		recode changework (1=0) (0=1)
		egen satisf=rowtotal($satisf) 
		g satisf2=(satisf+changework)/9
			
			** Analyse inter-secteurs ** 
			tabstat satisf2, stat(mean) by(mainocc_occupation_indiv)
			* Plus haut niveau de satisfaction pour les travailleurs réguliers qualifiés dans le secteur non-agricole et plus faible niveau de satisfaction pour les travailleurs indép dans le secteur agri. * 
			
		* b- Marché du travail (discrimination) *
		g anyformdiscri=0 if dummyworkedpastyear==1 
		foreach var of varlist discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 {
		codebook `var' if dummyworkedpastyear==1
		replace anyformdiscri=1 if dummyworkedpastyear==1 & `var'==1
		replace anyformdiscri=. if dummyworkedpastyear==1 & `var'==.
		}
		* 1 valeur manquante pour chaque variable *
		codebook anyformdiscri if dummyworkedpastyear==1 
		* 1 valeur manquante (O.K) * 
		* Sur 1264 individus qui ont travaillé l'année précédant l'enquête, 138 ont connu au moins une forme (sexe, religion, orientation sexuelle, handicap, caste, localité, parti politique) de discrimination dans leur travail - soit environ 11% *
				
			** Analyse inter-secteurs ** 
			ta mainocc_occupation_indiv anyformdiscri, col 
			* Majoritairement au sein des emplois occasionnels (61%), et notamment du secteur non-agricole (32%) 
			// Comparativement les emplois publics de type NREGA et les emplois réguliers non-qualifiés dans le secteur non-agricole sont très peu touches (3% resp.) * 
				
		g anyformresdiscri=0 if dummyworkedpastyear==1 
		foreach var of varlist resdiscrimination1 resdiscrimination2 resdiscrimination3 {
		codebook `var' if dummyworkedpastyear==1
		replace anyformresdiscri=1 if dummyworkedpastyear==1 & `var'==1
		replace anyformresdiscri=. if dummyworkedpastyear==1 & `var'==.
		}
		* 1 valeur manquante pour chaque variable *
		codebook anyformresdiscri if dummyworkedpastyear==1 
		* 1 valeur manquante (O.K) * 
		* Sur 1264 individus qui ont travaillé l'année précédant l'enquête, seuls 46 ont connu au moins une forme (sexe, religion, caste) de discrimination dans leur recherche de travail - soit environ 4% * 
			
			** Analyse inter-secteurs ** 
			ta mainocc_occupation_indiv anyformresdiscri, col 
			* Majoritairement au sein des emplois occasionnels (56%), et notamment du secteur agricole (40%) 
			// Comparativement les emplois publics de type NREGA et les emplois réguliers non-qualifiés dans le secteur non-agricole sont très peu voire peu touchés (7% et 3% resp.) * 
			
		g anyformresdiscri2=0 if dummyworkedpastyear==1 
		foreach var of varlist resdiscrimination4 resdiscrimination5 {
		codebook `var' if dummyworkedpastyear==1
		replace anyformresdiscri2=1 if dummyworkedpastyear==1 & `var'==1
		replace anyformresdiscri2=. if dummyworkedpastyear==1 & `var'==.
		}
		* 1 valeur manquante pour chaque variable *
		codebook anyformresdiscri2 if dummyworkedpastyear==1 
		* 1 valeur manquante (O.K) * 
		* Sur 1264 individus qui ont travaillé l'année précédant l'enquête, seuls 33 ont connu au moins une forme (religion, caste) de discrimination dans leur recherche de travail dans le cadre d'emplois réservés (quotas) - soit environ 3% * 
** RQ : pourquoi avoir supprimé la dimension de sexe pour cette question ? ** 

			** Analyse inter-secteurs ** 
			ta mainocc_occupation_indiv anyformresdiscri2, col 
			* Majoritairement au sein des emplois occasionnels (56%), et notamment du secteur agricole (28%) 
			// Comparativement les emplois publics de type NREGA et les emplois réguliers non-qualifiés dans le secteur non-agricole sont très peu voire peu touchés (3% resp.) * 
		
		
		* c- Marché du travail (pouvoir de décision) * 
		codebook decisionwork if dummyworkedpastyear==1
		* 4 valeurs manquantes *
		* Sur 1264 individus qui ont travaillé l'année précédant l'enquête, 456 ont pris eux-mêmes la décision de travailler - soit 37% *
			
			** Analyse inter-sexe ** 
			ta sex_panel if decisionwork==1
			* Parmi eux, seuls 34% sont des femmes *
			
			** Analyse inter-sexe en interaction avec la caste ** 
			ta caste_panel sex_panel if decisionwork==1, col 
			* Parmi ces 34% de femmes, 60% sont des dalits * 
		
		codebook decisionearnwork if dummyworkedpastyear==1 & mainoccuptype<5 // Agriculteurs, travailleurs indép., salariés
** RQ : pourquoi considérer les travailleurs non-rémunérés dans la ferme familiale et pas les autres travailleurs rémunérés ? (=5) ** 
		* 1 valeur manquante * 
		* Sur les 1197 individus qui ont travaillé l'année précédant l'enquête et qui ont été rémunérés, 491 ont été seuls à décider de l'utilisation de leur rémunération- soit environ 42% - et 430 ont pu décider de l'utilisation de leur rémunération avec une tierce personne (conjoint(e), parents/beaux-parents, enfant(s)) - soit environ 36% * 
		
			** Analyse inter-sexe ** 
			ta sex_panel if decisionearnwork==1
			* Parmi eux, seuls 33% sont des femmes *
			ta sex_panel if decisionearnwork==1 | decisionearnwork==3 | decisionearnwork==4 | decisionearnwork==7 
			* Parmi eux, seuls 39% sont des femmes *
			
			** Analyse inter-sexe en interaction avec la caste ** 
			ta caste_panel sex_panel if decisionearnwork==1 | decisionearnwork==3 | decisionearnwork==4 | decisionearnwork==7, col 
			* Parmi ces 39% de femmes, 56% sont des dalits * 
		
		* d- Normes sociales *
		codebook opinionworkingwoman
		* 1 valeur manquante * 
		* Sur 1668 individus (egos), 1545 (1047+498) individus sont au moins d'accords (si ce n'est fortement en accord) avec le fait qu'une femme prenne la décision de travailler * 
			** Analyse inter-sexes **
			ta sex_panel if opinionworkingwoman==1 | opinionworkingwoman==2
			* Parmi ces 1545 individus, 51% sont des hommes et 49% sont des femmes *
			
			ta sex_panel if opinionworkingwoman==3 | opinionworkingwoman==4
			* Parmi les 122 individus en désaccord (voire fortement), 40% sont des femmes et 60% sont des hommes * 
				ta relationshiptohead2020 sex_panel if opinionworkingwoman==3 | opinionworkingwoman==4, col
				* Parmi les hommes, ce sont les chefs de ménage et les fils majoritairement qui sont contre (49% et 41%), et pour les femmes, ce sont principalement les femmes de chef de ménage, les filles et les belles-filles (35%, 25%, 21 * %)
			
		codebook opinionactivewoman 
		* 1 valeur manquante * 
		* * Sur 1668 individus (egos), 1555 (996+559) individus sont au moins d'accords (si ce n'est fortement en accord) avec le fait qu'une femme prenne les principales décisions en lien avec la consommation * 
			** Analyse inter-sexes **
			ta sex_panel if opinionactivewoman==1 | opinionactivewoman==2
			* Parmi ces 1555 individus, 51% sont des hommes et 49% sont des femmes * 
			ta sex_panel if opinionactivewoman==3 | opinionactivewoman==4
			* Parmi les 112 individus en désaccord (voire fortement), 38% sont des femmes et 62% sont des hommes * 
			
			