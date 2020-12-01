library(tidyverse)
library(echarts4r)

dt <- haven::read_dta("/Users/malshe/Dropbox/Work/R/dataviz-blog/data/mutual-fund-returns-dta.zip") %>% 
  mutate(year = lubridate::year(caldt)) %>% 
  filter(!is.na(mret))

head(dt)


dt2 <- dt %>% 
  count(year, crsp_fundno) %>% 
  filter(n == 12)


dt3 <- dt %>% 
  inner_join(dt2, by = c("year", "crsp_fundno")) %>% 
  arrange(year, crsp_fundno) %>% 
  group_by(year, crsp_fundno) %>% 
  summarize(logmret = sum(log(1 + mret)),
            .groups = "drop") %>%
  group_by(year) %>% 
  mutate(mret = exp(logmret) - 1,
         rev_rank = ntile(mret, 10)) %>%
  ungroup() %>% 
  arrange(crsp_fundno, year) %>% 
  group_by(crsp_fundno) %>% 
  mutate(ld_rev_rank = lead(rev_rank)) %>% 
  ungroup() %>% 
  filter(!is.na(ld_rev_rank)) %>% 
  count(rev_rank, ld_rev_rank) %>% 
  group_by(rev_rank) %>% 
  mutate(prob = n / sum(n))

head(dt3, 10)


saveRDS(dt3, here::here("data", "mf-cleaned.rds"))


