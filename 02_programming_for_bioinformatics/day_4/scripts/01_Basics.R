# Install pak package 
install.packages("pak")

# CRAN Packages (data management + visualization)
cran_pkgs <- c("tidyverse", "ggsci", "ggthemes", "ggpubr", "tidyplots")
pak::pkg_install(cran_pkgs)

# Bioconductor for Bioinformatics 
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.23")

# Install bioconductor packages 
bio_pkgs <- c("DESeq2", "TCGAbiolinks")
pak::pkg_install(bio_pkgs)

# Load packages 
library(pak)
library(DESeq2)

# Creating variables 
a <- 10 

# Naming convention 
age <- 30
my_age <- 30

# Getting help 
help(print)
?print

# Reserved keywords 
?Reserved
if <- is_weekday

# Data types 
class(2)
class(2.2)
class("Bioinformatics")
class(TRUE)

# Create variables 
x <- 2 
class(x)

y <- 2.2
class(y)

z <- "Bioinformatics"
class(z)

w <- TRUE
class(w)

# **1.Printing something**

#type1
print("hello world")
#type2
cat("hello world")
#type3
message <- "hello world"
print(message)


# **2.Call variables**

#type1
a <- 10
a
#type2
age <- 10
age
#type3
ages <- c(10,20,25,23,28,29,30)
ages


# **3.R as a mathematical operator**
a <- 10
b <- 20

#type1.Arithmetic operator(+,-,*,/)
a+b #addition
a-b #subtraction
a*b #Multiplication
a/b #Division
a%%b #Modulus (remainder after division)

#type2.Relational operator(>, <, >=, <=)
a>b #Greater than
a<b #Less than
a<=b #Less than or equal to
a>=b #Greater than or equal to

#type3.Logical operator(|, &, !=)
a==b #Equal to
a>b | a==b #Logical OR
a<b & a==b #Logical AND
a!=b #Not equal to


# **4.Check data type**

#type1.Numerical (discrete~ count, continuous~measured) 
#discrete
stu_age <- 29
class(stu_age)
#continuous
stu_weight <- 67.5
class(stu_weight)

#type2.Categorical (nominal ~ no order, ordinal ~ have order)
#nominal
is_smoker <- c("yes", "no", "yes")
class(is_smoker)
#ordinal
BMI <- c("underweight", "normal", "overweight", "obese")
class(BMI)

#type3.Logical (TRUE, FALSE~ T, F)
is_holiday <- c(TRUE, FALSE, FALSE, TRUE)
class(is_holiday)


# **5.Working on string/character data type**

message1 <- "CHIRAL BANGLADESH"
#to find total length
nchar(message1)
#join two strings
message2 <- "Naznin"
message3 <- "Suktara"
paste(message2, message3)
#change upper-lower case
toupper("naznin")
tolower("NAZNIN")


# **6.Vector creation using c, :, seq functions**

#using c function
#1.Numerical vector
ages <- c(22,33,34,23, 24, 84)
ages
class(ages)
#2.character vector
is_smoker <- c("yes", "no", "no", "yes")
is_smoker
class(is_smoker)
#3. Logical vector
is_weekend <- c(TRUE, FALSE, TRUE, TRUE)
class(is_weekend)
#4. Complex vector
V1 <- c(7+2i, 4+8i)
V1
class(V1)

#using : operator
chrome_seq <- 1:70
chrome_seq

#using seq function
intervals <- seq(from=1, to=100,by=2)
intervals
class(intervals)

#Special one:mixed vector
mixed <- c(TRUE, "Naznin", 16)
mixed
class(mixed)


# **7.sub-setting object**

ages <- c(23, 23,32, 13, 31, 39)
ages[3]  #specific element
ages[1:4] #series of element
ages[c(1,3,4)] #specific multiple element

#vectorized operations
stu_hight <- c(4.9, 5.1, 5.3, 5.5, 5.8)
stu_hight * 100


# **8.Crete List ~ contain different elements**

dummy <- list(ages= c(22,14,21,32),
              gender= c("male", "female", "male", "male"),
              location= c("Magura", "Jessore", "Dhaka", "Khulna"),
              smoking_habit= c(T, F, F, T),
              education= c("graduation", "secondary", "graduation", "graduation"))
dummy

# **9.Matrix creation**

#type1
mat1 <- matrix(1:9, ncol=3, nrow=3)
mat1
#check dimension
dim(mat1)

#type2
mat2 <- matrix(1:9, ncol=3, nrow=3, byrow = T)
mat2

#type3
mat3 <- matrix(1:9, ncol=3, 
               dimnames = list(c("X", "Y", "Z"),
                               c("A", "B", "C")))
mat3

#check dimension
dim(mat3)
#check row and column names
dimnames(mat3)

#matrix sub-setting
mat3[1, ] #entire rows
mat3[, 1] #entire col
mat3[1, 3] #specific element

