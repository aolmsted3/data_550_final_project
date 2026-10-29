#! Build Report
efgh_report.html: code/03_render_report.R raw_data/sim_data.rds \
  output/table_one.rds output/predicted_diarrhea_probability.png
	Rscript code/03_render_report.R

#! Make Table 1
output/table_one.rds: code/01_make_table1.R raw_data/sim_data.rds
	Rscript code/01_make_table1.R

#! Make Figure
output/predicted_diarrhea_probability.png: code/02_make_figure.R \
  raw_data/sim_data.rds
	Rscript code/02_make_figure.R

#! Clean rule
.PHONY: clean
clean:
	rm output/*