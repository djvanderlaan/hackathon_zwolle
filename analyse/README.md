Berekenen index en regressie index met buurtkenmerken
=====================================================

- Het script `bereken_index.R` leest de enquete gegevens in uit `../data_prep/bvb.csv` en berekent hiermee twee indices op buurtniveau. Eén die de behoefte aan thuiszorg vergelijkt met die van Zwolle als geheel en één die het krijgen van thuiszorg gegeven dat er behoefte is vergelijkt met die van Zwolle als geheel. De indices wordt opgeslagen in `index.csv`. De buurtnamen worden ingelezen uit `index_codes.csv`. 
- Het script `analyse_buurtniveau.R` probeert de indices op buurtniveau te verklaren aan de hand van buurtkenmerken. De indices met daaraan gekoppeld de buurtkenmerken worden wegeschreven in `index_achtergrond.csv`. De regressieresultaten komen in de bestanden `regression_results1_nodig.csv` en `regression_results1_krijg.csv`. 

