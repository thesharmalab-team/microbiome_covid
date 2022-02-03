my_cur_table <- function(mypseq){
  
  curat.pseq <- subset_samples(mypseq[["curat.recode.pseq"]], curat.covid.class == "HIGH" | curat.covid.class == "LOW")
    
  # defines the length of the new frame
  n <- length(sample_data(curat.pseq)$curat.covid.class)
  message(paste(c("The total number of microbiome samples:", n), collapse = " "))
  data <- data.frame(id=1:n)
  
  # get the disease classification. 
  data$curat.covid.class <- sample_data(curat.pseq)$curat.covid.class
  # brings in the co-variates
  data$bmi <- sample_data(curat.pseq)$bmi_group
  # replace the NA with unknown
  data$bmi <- fct_explicit_na(data$bmi, na_level = "Unknown")

  data$bmi <- factor(data$bmi, levels = c("lean",
                                          "overweight",
                                          "obese",
                                          "morbid obese",
                                          "severe obese",
                                          "super obese",
                                          "Unknown"))
  
  data$bmi <- mapvalues(data$bmi, 
                        from = c("lean", 
                                 "overweight",
                                 "obese", 
                                 "morbid obese", 
                                 "severe obese",
                                 "super obese",
                                 "Unknown"),
                        to = c("Lean (BMI 18.5+ to 25)",
                               "Overweight (BMI 25+ to 30)",
                               "Obese (BMI 30+ to 35)", 
                               "Morbid obese (BMI 35+ to 40)",
                               "Severe Obese (BMI 40+ to 45)", 
                               "Super Obese (BMI 45+)",
                               "Unknown"))
  # Age
  data$age <- sample_data(curat.pseq)$age
  #data$age <- data$age  %>% replace_na("Unknown")
  
  # Gender
  data$gender <- sample_data(curat.pseq)$gender
  # replace the NA with unknown
  data$gender <- fct_explicit_na(data$gender, na_level = "Unknown")
  
  #table1(~ age  +  bmi | curat.mnd.class, data=data)   
  #table_one <- tableby(curat.mnd.class ~ bmi + age, data = data)
  t1 <- data %>%  set_labels(list(bmi = "BMI", age = "Age", gender = "Gender")) %>% 
    tableby(curat.covid.class ~ gender + age + bmi, data = .,
            test=FALSE,
            numeric.stats=c( "mean","sd"),
            cat.stats=c("count"), 
            digits=2 ) %>%
    as.data.frame() %>% dplyr::select(.,
                               -group.term,
                               -group.label,
                               -strata.term,
                               -term,
                               -variable.type,
                               -variable) %>%
    dplyr::rename(., "Variable" = label, "Low Disease Group" = LOW, "High Disease group" = HIGH)
#  t1[c(1,8),2] <- ""
#  t1 <- as_grouped_data(t1, groups = c("variable"))
  t1 <- flextable(t1) %>% 
    add_header_lines(values = c("Demographic Data: Curat Dataset") ) %>% 
    bold(part = "header") %>%
    bold(i = c(1,5,8)) %>%
    theme_booktabs() %>% 
    autofit() %>% 
    fix_border_issues()
  return(t1)
}
# 

