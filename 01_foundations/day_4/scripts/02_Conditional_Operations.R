# **10.Create data frame**

df <- data.frame(
  Name= c("Naznin", "Sumaiya", "Mamun"),
  Age= c(25, 20, 24),
  City= c("Bangladesh", "Bangladesh", "Bangladesh"),
  Lonliness= c("low", "medium", "high"))
df
#Check data structure
str(df)
#check data summary
summary(df)


# **11. Convert/change data structure**

#character to Factor
is_smoker <- c("yes", "no", "no", "yes")
class(is_smoker)
factor(is_smoker)

#change data structure from dataset
df$Lonliness <- as.factor(df$Lonliness)
df
#check data structure
str(df)


# **12.Date and Times**

date <- as.Date("2024-06-30")

formatted_date <- format(date, 
                         format='%y/%m/%d')
formatted_date

#check structure
class(date)


# **13.Conditional Operation/ if_else statement**

#type1:single condition
if(condition){
  do_something
}
#example
a <- 10
if (a>0){ 
  print("positive")
}


#type2:double condition
if (condition){
  do_something} else {
    do_something
  }
#example
b <- 33
if (b<0) {
  print("negative")
}else {
  print("positive")
}

#type3:multiple condition
if(condition){
  do_something} else if (condition){
    do_something} else if (condition){
      do_something} else{
        do_something
      }
#example
x <- 0
if (x >0 ){
  print("x is positive")
}else if (x<0){
  print("x is negative")
}else {
  print("x is zero")
}


#if else function
#example1
x <- 22
ifelse(x>0, "positive", "negative")

#example2
ages <- c(12,17,18, 26,66,45,54,53,23,13,52,76)
ifelse(ages <= 18, "under 18", "adults")


# **14.Loop operation**

print("Bangladesh")
print("Bangladesh")
print("Bangladesh")
print("Bangladesh")
print("Bangladesh")
print("Bangladesh")

#for loop
for(variable in seq){
  do_something
}

#example1
for (i in 1:7){
  print("Bangladesh")
}

#example2
for (i in 1:20){
  if (i == 7){
    break
  }
  print(i)
}

#example3
for (i in 1:10){
  if (i == 5){
    next
  }
  print(i)
}

#while loop
while(condition){
  do_something
}

#example
i <- 3
while(i <= 10){
  print(i)
  i= i+1
}


# **15.Function**

#type1. Built in function
#example1
ages <- c(12,17,18, 26,66,45,54,53,23,13,52,76)
sum(ages)
summary(ages)
mean(ages)
median(ages)
min(ages)
max(ages)
quantile(ages, .25)
quantile(ages, .50)
quantile(ages, .75)

#example2
ages1 <- c(12,17,18, 26,66,45,54,53,23,13,52,76, NA, NaN)
ages1
mean(ages1, na.rm = T)
median(ages1, na.rm = T)
min(ages1, na.rm = T)
quantile(ages1, .50, na.rm = T)
summary(ages1, na.rm = T)

#type2:User defined function
add <- function(num1, num2) {
  #do something
}

#example1
add <- function(num1, num2) {
  total <- num1 + num2
  return(total)
}
add(5, 12)

#example2
calculateSum <- function(...){
  numbers <- c(...)
  total <- sum(numbers) 
  return(total)
}
calculateSum(2, 4, 54, 35, 23, 5)


# **16.simulation-generating random numbers**

#generate 5 random numbers between 0 to 1
random_numbers <- runif(50)
random_numbers
#generate random integer numbers 
random_integer <- sample(1:10, 3)
random_integer

random_integer <- sample(1:100, 50)
random_integer
#generate random numbers from a normal distribution mean 0 sd 1
random_numbers <- rnorm(50, mean=0, sd=1)
random_numbers

random_numbers <- rnorm(20, mean=0, sd=1)
random_numbers
