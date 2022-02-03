
# RECODING OF VARIABLES 
# creates a grouping variable for BMI
n <- length(sample_data(curat.pseq)$BMI)
data <- data.frame(id=1:n)
data$bmi <- sample_data(curat.pseq)$BMI # creates a new variable with BMI in it
# Classification based upon the ATlas data
data$bmi[data$bmi <18.5] <- "underweight"
data$bmi[data$bmi >=45] <- "super obese"
data$bmi[data$bmi >= 18.5 & data$bmi <25] <- "lean"
data$bmi[data$bmi >= 25 & data$bmi <30] <- "overweight"
data$bmi[data$bmi >= 30 & data$bmi <35] <- "obese"
data$bmi[data$bmi >= 35 & data$bmi <40] <- "severe obese"
data$bmi[data$bmi >= 40 & data$bmi <45] <- "morbid obese"
data$bmi <- factor(data$bmi)    

# creates a new variable in the phyloseq called BMI
sample_data(curat.pseq)$bmi_group = data$bmi
# Check that it works
#get_variable(curat.pseq, "bmi_group")


# same with gender -> sex
# creates a grouping varaible for BMI
n <- length(sample_data(curat.pseq)$gender)
data <- data.frame(id=1:n)
data$sex <- sample_data(curat.pseq)$gender # creates a new variable with gender in it
# Classification based upon the ATlas data
data$sex[data$sex == "female"] <- "female"
data$sex[data$sex == "male"] <- "male"
data$sex <- factor(data$sex)

# creates a new variable in the phyloseq called sex
sample_data(curat.pseq)$sex = data$sex

n <- length(sample_data(curat.pseq)$subject)
data <- data.frame(id=1:n)

# Regroup age category in atlas
n <- length(sample_data(curat.pseq)$age)
data <- data.frame(id=1:n)
data$age_c <- sample_data(curat.pseq)$age # creates a new variable with age in it
# Classification based upon the Atlas data
# data$age_c[data$age_c >= 18 & data$age_c <70] <- "adult"
data$age_c[data$age_c >=70] <- "senior"
data$age_c[data$age_c <70] <- "adult"
data$age_c <- factor(data$age_c)

# creates a new variable in the phyloseq called bmi_group
sample_data(curat.pseq)$age_category = data$age_c


mypseq[["curat.recode.pseq"]] <- curat.pseq


# Common variables to keep:  "age", "sex", "nationality", "bmi_group", "covid"
# sample_variables(pseq)
# sample_data(pseq)[c(2:16,18:96)] = NULL
# 