
# RECODING OF VARIABLES 
# creates a grouping variable for BMI
n <- length(sample_data(curat.pseq)$BMI)
data1 <- data.frame(id=1:n)
data1$bmi <- sample_data(curat.pseq)$BMI # creates a new variable with BMI in it
# Classification based upon the ATlas data
data1$bmi[data1$bmi <18.5] <- "underweight"
data1$bmi[data1$bmi >=45] <- "super obese"
data1$bmi[data1$bmi >= 18.5 & data1$bmi <25] <- "lean"
data1$bmi[data1$bmi >= 25 & data1$bmi <30] <- "overweight"
data1$bmi[data1$bmi >= 30 & data1$bmi <35] <- "obese"
data1$bmi[data1$bmi >= 35 & data1$bmi <40] <- "severe obese"
data1$bmi[data1$bmi >= 40 & data1$bmi <45] <- "morbid obese"
data1$bmi <- factor(data1$bmi)    

# creates a new variable in the phyloseq called BMI
sample_data(curat.pseq)$bmi_group = data1$bmi
# Check that it works
#get_variable(curat.pseq, "bmi_group")


# same with gender -> sex
# creates a grouping varaible for BMI
#n <- length(sample_data(curat.pseq)$gender)
#data <- data.frame(id=1:n)
#data$sex <- sample_data(curat.pseq)$gender # creates a new variable with gender in it
# Classification based upon the ATlas data
#data$sex[data$sex == "female"] <- "female"
#data$sex[data$sex == "male"] <- "male"
#data$sex <- factor(data$sex)

# creates a new variable in the phyloseq called sex
#sample_data(curat.pseq)$sex = data$sex

#n <- length(sample_data(curat.pseq)$subject)
#data <- data.frame(id=1:n)


# creates a new variable in the phyloseq called age_category
#sample_data(curat.pseq)$age_category = data$age_c


#mypseq[["curat.recode.pseq"]] <- curat.pseq


# Common variables to keep:  "age", "sex", "nationality", "bmi_group", "covid"
# sample_variables(pseq)
# sample_data(pseq)[c(2:16,18:96)] = NULL
# 