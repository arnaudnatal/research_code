* Dofile - regressions réseaux debt / big 5* - 21/01/25

global main_path "C:\Users\Damien Girollet\Desktop\Post doc\Recherche post-thèse\Papier Arnaud Inde\Data NEEMSIS - INDE\Files from Arnaud\BIG FIVE\Basespourlesanalyses"
use "$main_path\Main_analyses_DG.dta", replace

tab mainocc_occupation_indiv 
gen occup_ego_type=1 if mainocc_occupation_indiv==. 
replace occup_ego_type=2 if mainocc_occupation_indiv==1 
replace occup_ego_type=3 if mainocc_occupation_indiv==6 
replace occup_ego_type=4 if inlist(mainocc_occupation_indiv,2,3,4,5,7)
label define occup_ego_type 1"No job" 2"Self-employed - Agri" 3"Self-employed - Non-Agri" 4"Wage worker", replace
label value occup_ego_type occup_ego_type
tab occup_ego_type


*Netsize
foreach var in  netsize_talk netsize_relative  netsize_debt {
poisson `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , clust(ID_HH) robust
}
foreach var in  netsize_talk netsize_relative  netsize_debt {
bys sex : poisson `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , clust(ID_HH) robust
}

*Composition - family 
foreach var in talk_family_pct relative_family_pct debt_family_pct {
poisson `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , clust(ID_HH) robust
}


*Homophily

	*Gender 
foreach var in talk_samegender_pct relative_samegender_pct debt_samegender_pct {
poisson `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , clust(ID_HH) robust
}

	*Caste
foreach var in talk_samecaste_pct relative_samecaste_pct debt_samecaste_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH) 
}

	*Jatis
foreach var in talk_samejatis_pct relative_samejatis_pct debt_samejatis_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	*Age
foreach var in talk_sameage_pct relative_sameage_pct debt_sameage_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	*Job statut
foreach var in talk_samejobstatut_pct relative_samejobstatut_pct debt_samejobstatut_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	*Occupation
foreach var in talk_sameoccup_pct relative_sameoccup_pct debt_sameoccup_pc {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

		*Educ
foreach var in talk_sameeduc_pct relative_sameeduc_pct debt_sameeduc_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

		*Location
foreach var in talk_samelocation_pct relative_samelocation_pct debt_samelocation_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

			*Wealth
foreach var in  talk_samewealth_pct relative_samewealth_pct debt_samewealth_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

* Strenght 
	*Indicator
foreach var in  strength_talk strength_relative strength_debt {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	*Sub-indicator - freq meet
foreach var in  talk_meetweekly_pct relative_meetweekly_pct debt_meetweekly_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}
		
	*Sub-indicator - intimacy
foreach var in talk_veryintimate_pct relative_veryintimate_pct debt_veryintimate_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	*Sub-indicator - reciprocity
foreach var in talk_reciprocity_pct relative_reciprocity_pct debt_reciprocity_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}
	
	*Sub-indicator - money
foreach var in talk_money_pct relative_money_pct debt_money_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

*Multiplexity
	*Fonction for debt network alters (overlap entre network interperso et network debt)
fracreg probit debt_multiplex_pct i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)

	*Type de relation
foreach var in  talk_multiplexR_pct relative_multiplexR_pct debt_multiplexR_pct {
fracreg probit `var' i.villageid i.religion sex age i.caste i.edulevel i.occup_ego_type  ///
locus fES fOPEX fCO , vce(cluster ID_HH)
}

	 
	
		 
		 
		 
		 
		 
		     
		
		

