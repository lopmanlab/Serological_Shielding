source('CYZ_reorg/R/input_default.R')
test = seir_model_shields_rcfc_nolatent(0, Get_Inits(Pars = pars_default), pars_default)
