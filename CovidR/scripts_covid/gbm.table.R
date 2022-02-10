gbm.table <- function(my.table.data,gbm.mean.levels) {
  ft <-arrange(my.table.data, location)
  #ft <-ft %>% dplyr::rename(Country = location) 
  # creates the means
  #ft.mean <-  summaryBy( . ~ Region, data = ft) %>%
  #add_row()
  #ft <- as_grouped_data(ft, groups = c("Region"))
  
  # Tidy's up the data and renames and then inserts a column with Total 
  #ft.mean <-ft.mean %>% 
  #dplyr::rename(DALY = DALY.mean,Prevalence = Prevalence.mean, Incidence = Incidence.mean) %>% 
  # add_column( Country = "Mean", .after = 1)
  # Intersts the rows. The number here are critical 
  #ft<- insertRows(ft, gbm.mean.levels, new = ft.mean, rcurrent = FALSE)
  # this removes the country label for the means
  #ft[gbm.mean.levels,1] <- ""
  ft <- flextable(ft) %>% 
    footnote( i = 1, j = 3:5,
              value = as_paragraph(
                c(gbm_ref)
              ),
              ref_symbols = c("a"),
              part = "header") %>% 
    colformat_num( j = 3:5, digits = 2) %>% 
    valign( valign = "bottom", part = "header") %>% 
    add_header_lines(values = c(tab_title_gbm) ) %>% 
    bold(part = "header") %>%
    #bold(i = gbm.mean.levels) %>%
    theme_booktabs() %>% 
    autofit() %>% 
    fix_border_issues()
  return(ft)
}