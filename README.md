# The cost of energy in the UK and its impact on households

:warning: **Please note:** the analysis in this repository constitutes my own independent exploration of public data sources as part of a personal skill development project. These are *not* be associated with the Office for National Statistics as official output or official statistics.

 This mini personal project aims to explore the cost of living situation in the UK during the summer of 2022.
 This involves exploring data related to rising energy prices, inflation and household income.

The project draws inspiration from an ONS report on "[Energy prices and their effect on households](https://www.ons.gov.uk/economy/inflationandpriceindices/articles/energypricesandtheireffectonhouseholds/2022-02-01)" from February 2022.

The aim of the project was to explore the impact of rising energy prices (particularly gas) on households.

A [report](https://github.com/TSGreen/uk-cost-of-living/blob/main/outputs/report.html) has been created which explores:
- the rising price of gas on the wholesale market
- the effect of the Ofgem price cap on household energy prices
- the price increase of energy and its contribution to overall price inflation
- the direct family expenditure on household energy and what the new price cap pricing could mean for household spending, and
- the public perception on the cost of living and what concerns them most.
The report concludes with some policy recommendations.

## Data sources:
The data used in this work is all publicly available statistical publications from the ONS. No data is provided in this repository, but for reproducing this analysis links and the relevant data release are available below:
- [System Average Price (SAP) of gas](https://www.ons.gov.uk/economy/economicoutputandproductivity/output/datasets/systemaveragepricesapofgas) - data released 01 September 2022
- [Consumer price inflation tables](https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceinflation) - data released 17 August 2022
- [Family spending workbook 1](https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/expenditure/datasets/familyspendingworkbook1detailedexpenditureandtrends) - "FYE 2021" edition, released July 2022
- [Public opinions and social trends, Great Britain: household finances](https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/datasets/publicopinionsandsocialtrendsgreatbritainhouseholdfinances) - data covering 17 to 29 August 2022

## Repo structure
The scripts in this project assume the following structure. If reproducing this analysis, the above data sources should be stored as shown below.
```
📦uk-cost-of-living
 ┣ 📂data
 ┃ ┣ 📜consumerpriceinflationdetailedreferencetables.xls
 ┃ ┣ 📜householdfinances17to29august2022.xlsx
 ┃ ┣ 📜systemaveragepriceofgasdataset010922.xlsx
 ┃ ┗ 📜workbook1detailedexpenditureandtrends1.xlsx
 ┣ 📂outputs
 ┃ ┣ 📜gas_prices_2018.png
 ┃ ┣ 📜gas_prices_2021.png
 ┃ ┣ 📜indices_change.png
 ┃ ┣ 📜report.html
 ┃ ┗ 📜report.qmd
 ┣ 📂src
 ┃ ┣ 📜exploration_cpi.R
 ┃ ┣ 📜exploration_gas_prices.R
 ┃ ┗ 📜household_expenses.R
 ┣ 📜.gitignore
 ┣ 📜LICENSE
 ┗ 📜README.md
 ```