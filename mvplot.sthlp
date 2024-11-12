{smcl}
{* 12nov2024}{...}
{cmd:help mvplot}
{hline}

{title:Title}
    {pstd}  {hi:mvplot} — Visual representation of missing data shares for specified variables

{title: Synopsis}
    {pstd}  {cmd:mvplot} [{varlist}] [{cmd:if}] [{cmd:in}], [{opt wv(string) type(string) LABels title(string)}]

{title: Description}
    {pstd} {cmd:mvplot} generates graphical representations of missing data for each variable in {varlist}. This command can produce pie or bar charts showing the proportion of missing values and optionally incorporate weighting variables if specified. 

{title: Syntax}
    {p 8 15 2} {cmd:mvplot} [{cmd:[varlist]}] [{cmd:if}] [{cmd:in}], [{opt wv(string) type(string) LABels title(string)}]

   {pstd}  {opt wv(string)} Specifies up to three weighting variables to weight the share of missing values.

   {pstd}  {opt type(string)} Sets the chart type. Options are {cmd:pie} or {cmd:bar} (default).

   {pstd}  {opt LABels} Adds value labels to the bars in the bar chart for better interpretability.

   {pstd}  {opt title(string)} Custom title for the plot; if omitted, a default title will be used.
{p_end}

{title: Options}

    {pstd}  {opt wv(string)} — Specifies one or more weighting variables to calculate weighted shares of missing values. A maximum of three weighting variables is allowed.

    {pstd}  {opt type(string)} — Selects the chart type: {cmd:pie} for pie charts or {cmd:bar} for bar charts. The default is {cmd:bar}.

    {pstd}  {opt LABels} — Adds data labels to each bar in the bar chart.

    {pstd}  {opt title(string)} — Allows a custom title to be added to the plot.

{title: Examples}
    {pstd} Example without weighting:

    {pstd}{cmd:mvplot var1 var2 var3, type(bar)}

    {pstd} Example with a weighting variable:
    {pstd} {cmd:mvplot var1 var2 var3, wv(weight_var) type(pie) title("Missing Values Distribution")}
