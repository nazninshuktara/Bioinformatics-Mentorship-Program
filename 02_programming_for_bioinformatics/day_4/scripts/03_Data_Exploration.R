#Data exploration
library(gapminder)
#show entire data
gapminder
#check dimension
dim(gapminder)
#examine first few rows
head(gapminder)
#examine last few rows
tail(gapminder)
#num of rows
nrow(gapminder)
#num of col
ncol(gapminder)
#check rows names
names(gapminder)
#sampling
sample(gapminder)
#check data structure
str(gapminder)
#summary of entire data
summary(gapminder)
#summary of specific colums
summary(gapminder$country)
summary(gapminder$lifeExp)
#specific states
mean(gapminder$lifeExp)
sd(gapminder$lifeExp)
#check missing value
airquality
head(airquality)
is.na(airquality)
sum(is.na(airquality))
#check duplicated value
duplicated(airquality)
sum(duplicated(airquality))
#remove missing values
air <- na.omit(airquality)
air
is.na(air)
sum(is.na(air))

#Data manipulation
#packages for data manipulation
library(tidyverse)
library(naniar)
#data formats
#1.CSV
#2.Excel

#1.CSV Data import
CSV_data <- read.csv("data/500_Person_Gender_Height_Weight_Index.csv")
CSV_data
#excel data import
xl_data <- readxl::read_excel("data/Life_Expectancy_Long.xlsx")
xl_data
#2.data exploration
dim(CSV_data) #dimension
ncol(CSV_data) #number of column
nrow(CSV_data) #number of rows
names(CSV_data) #names of column
head(CSV_data) #first 6 rows
tail(CSV_data)# last 6 rows
head(CSV_data, 20) #first 20 rows
sample(CSV_data) #default data(sampling)
sample_n(CSV_data, 100) #100 data
sample_frac(CSV_data, .30) #30% data
str(CSV_data) #check data structure
glimpse(CSV_data) #check data structure
is.na(CSV_data) #check missing valie
sum(is.na(CSV_data)) #sum of missing value
duplicated(CSV_data) #check duplicate value
sum(duplicated(CSV_data)) #sum of duplicate value
vis_miss(CSV_data) #visualize missing value
new_csv <- unique(CSV_data) #remove duplicated value
sum(duplicated(new_csv))
#3.Data manipulation
ncol(new_csv)
nrow(new_csv)
names(new_csv)
#select single column by name
select(new_csv,Gender)
#select multiple column by name
select(new_csv, Gender, Height)
#select single column by number
select(new_csv, 3)
#select multiple column by number
select(new_csv, c(1, 2, 3))
#removing single column
select(new_csv, - Gender)
#subset observation
filter(new_csv, Gender=="Male")
#pipe operator/chaining(ctrl+shift+M)
new_csv |> 
  select(Gender, Height, Weight) |>
  filter(Gender=="Female") |> 
  head()


#working with gapminder
library(gapminder)
gapminder
gapminder |> 
  select(starts_with("c")) |> 
  head()
#filter with %in% operator
gapminder |> 
  filter(country %in% c("Bangladesh", "Pakistan", "India"))
#crete new column-mutate
gapminder |> 
  mutate(gdp = pop * gdpPercap) |> 
  head()
#rename the colume
gapminder |> 
  rename(population= pop) |> 
  head()
#sort/arrange
gapminder |>
  select(country, pop) |> 
  arrange(desc(pop))|> 
  head()
#data grouping
head(gapminder)
gapminder |> 
  group_by(continent) |> 
  summarise(avg_lifeExp = mean(lifeExp),
            avg_gdpPercap = mean(gdpPercap)) |> 
  head()



#data Reshaping
#understanding long and wide data
wide_data <- readxl::read_excel("data/Life_Expectancy_Wide.xlsx")
long_data <- readxl::read_excel("data/Life_Expectancy_Long.xlsx")
#convert wide data into long data
new_long <- pivot_longer(wide_data,
                         cols = 2:75, 
                         names_to = "year", 
                         values_to = "LifeExp" )
#convert long data into wide data
new_wide <- pivot_wider(long_data,
                        names_from = "Year", 
                        values_from = "LifeExp" )

covid_data <- read.csv("data/time_series_covid19_confirmed_global.csv")
new_covid_data <- pivot_longer(covid_data,
                               cols = 5:1147, 
                               names_to = "Date", 
                               values_to = "Confirmed case")
#change data structure
co_data <- new_covid_data |> 
  mutate_at(vars(Province.State,Country.Region), factor) |>
  mutate_if(is.character, as.Date) |> 
  glimpse(co_data)

#join data
demo_data <- readxl::read_excel("data/patient data.xlsx", sheet=1)
clinical_data <- readxl::read_excel("data/patient data.xlsx", sheet=2)
adv_data <- readxl::read_excel("data/patient data.xlsx", sheet =3)
#join two data
patient_data <- left_join(demo_data, clinical_data, by="patient Id")
patient_data
patient_data <- left_join(patient_data, adv_data, by="patient Id")
patient_data
#join multiple data
final_patient_data <- list(demo_data, clinical_data, adv_data)
data <- final_patient_data |> 
  reduce(left_join, by = "patient Id") |> 
  mutate_if(is.character, as.factor)
glimpse(data)   
#data analysis
library(gtsummary)
library(gt)
library(easystats)
#data import
thalassemia_qol_data <- read.csv("data/Thalassemia_QoL.csv") 
#demographic characteristics
thalassemia_qol_data |> 
  select(1:8) |> 
  tbl_summary(statistic = list(all_continuous() ~ "{mean}±{sd}")) |> 
  as_gt() |> 
  gtsave("Table1.docx")
#clinical information
thalassemia_qol_data |> 
  select(9:17) |> 
  tbl_summary(statistic = list(all_continuous() ~ "{mean}±{sd}"),
              type = list(everything() ~ "categorical")) |> 
  as_gt() |>
  gtsave("Table2.docx")
#statistical test
thalassemia_qol_data |> 
  select(Total_SF_Score, Gender) |> 
  tbl_summary(by = Gender, statistic = list(all_continuous() ~ "{mean}±{sd}")) |> 
  add_p() |> 
  bold_p(t = .05)

thalassemia_qol_data |> 
  select(Total_SF_Score, Level_of_Education) |> 
  tbl_summary(by = Level_of_Education, 
              statistic = list(all_continuous() ~ "{mean}±{sd}")) |> 
  add_p() |> 
  bold_p(t = .05)
