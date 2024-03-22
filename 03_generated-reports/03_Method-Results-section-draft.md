# Analysis and Results


- [Method](#method)
  - [Measures](#measures)
    - [Post Category](#post-category)
    - [Total Interaction](#total-interaction)
    - [Positive Sentiment](#positive-sentiment)
    - [Negative Sentiment](#negative-sentiment)
  - [Analysis](#analysis)
- [Results](#results)
  - [Descriptives](#descriptives)
  - [Inferential analysis](#inferential-analysis)
- [References](#references)

# Method

Data was collected from 9 leading Israeli universities’ public Facebook
pages, using CrowdTangle software (*About Us \| CrowdTangle Help
Center*, n.d.) to extract and mine data. This enabled us to export all
data and information from the universities official Facebook pages,
including user responses, engagement rates, and reactions.

Each page’s data was converted into a CSV file, with each sheet
representing a different page. The timeframe of this sample was
initially started on Oct 7th in response to the massacre and terminated
within the \_\_ months post the starting of the war. TO ADD: HOW WERE
THE FILES ADDED TOGETHER TO CREATE THE FINAL CSV?

## Measures

We were interested in how the number and kind (positive / negative) of
interactions to posts were related to the university and the category of
post, and therefore created the following measures:

### Post Category

Posts were manually categorized into one of 5 categories: “Community
Support”, “Updates and Instructions”, “Academic Adjustments”,
“Supporting Our Troops and Hostages”, and “Marketing of Academic
Programs”.

### Total Interaction

Total interaction was measured using the sum of interactions, such as
likes, shares, reactions, and comments, on a page, which is consistent
with previous studies (Eberl et al., 2020).

### Positive Sentiment

Positive sentiment was calculated for each post by adding the number of
positive reactions, namely “Likes”, “Love”, and “Care” reactions.

### Negative Sentiment

Negative sentiment was calculated for each post by adding the number of
negative reactions, namely the “Sad” and “Angry” reactions.

## Analysis

All statistical analyses were conducted with R (R Core Team, 2024)
version 4.3.3 and RStudio (*RStudio*, 2024) version 2023.12.1.402. All
data and code are available at XXX.

Our inferential analysis relies on a series of generalized linear
models. To account for potential overdispersion in each of our count
outcomes (total interactions, positive sentiment, negative sentiment),
we used quasi-poisson models with robust standard errors. For ease of
interpretation, we then used the models to create predictions on the
response scale (e.g., the number of interactions) for our different
groups of interest and plotted means and uncertainty of those
predictions.

TO DO: Cite all the packages used in the analysis.

# Results

## Descriptives

We collected 1010 posts from the 9 Universities included in the sample.
<a href="#tbl-n_posts" class="quarto-xref">Table 1</a> shows the total
number of posts in each category created within each University’s
Facebook page, as well as the total number of posts for each University.
We can see that all universities had over 70 posts in this period, with
Bar-Ilan University topping the chart with 128 post.

<div class="cell-output-display">

![](03_Method-Results-section-draft_files/figure-commonmark/tbl-n_posts-1.png)

</div>

Examining the descriptive statistics by University, as presented in
<a href="#tbl-uni" class="quarto-xref">Table 2</a>, we see clear signs
of overdispersion (the standard deviation of each count is clearly
higher than the mean).

<div class="cell-output-display">

![](03_Method-Results-section-draft_files/figure-commonmark/tbl-uni-1.png)

</div>

The same can be observed when we calculate descriptive statistics for
each category instead, as in
<a href="#tbl-cat" class="quarto-xref">Table 3</a>. More descriptive
analyses, including simple visualizations of the raw data itself, are
available at (ADD LINK OR EXPLAIN GITHUB REPOSITORY).

<div class="cell-output-display">

![](03_Method-Results-section-draft_files/figure-commonmark/tbl-cat-1.png)

</div>

## Inferential analysis

# References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0" line-spacing="2">

<div id="ref-aboutus" class="csl-entry">

*About Us \| CrowdTangle Help Center*. (n.d.).
<http://help.crowdtangle.com/en/articles/4201940-about-us>

</div>

<div id="ref-eberl2020" class="csl-entry">

Eberl, J.-M., Tolochko, P., Jost, P., Heidenreich, T., & Boomgaarden, H.
G. (2020). What’s in a post? How sentiment and issue salience affect
users’ emotional reactions on Facebook. *Journal of Information
Technology & Politics*, *17*(1), 48–65.
<https://doi.org/10.1080/19331681.2019.1710318>

</div>

<div id="ref-rcoreteam2024" class="csl-entry">

R Core Team. (2024). *R: A language and environment for statistical
computing*. R Foundation for Statistical Computing.
<https://www.R-project.org/>

</div>

<div id="ref-rstudio2024" class="csl-entry">

*RStudio: Integrated development environment for r*. (2024). Posit
Software, PBC. <http://www.posit.co/>

</div>

</div>