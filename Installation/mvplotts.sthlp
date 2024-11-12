{smcl}
{* 12nov2024}{...}
{cmd:help mvplotts}
{hline}

{title:Title}
    {pstd}  {hi:mvplotts} — Time series visualization of missing data for specified variables

{title: Synopsis}
    {pstd}  {cmd:mvplotts} [{varlist}] [{cmd:if}] [{cmd:in}], [{opt wv(string) title(string) GRoups(string)}]

{title: Description}
    {pstd} {cmd:mvplotts} generates time series plots to visualize the share of missing values over time for each variable in {varlist}. This command works in conjunction with {cmd:mvdesc} to facilitate insights into missing data trends and supports weighted series for deeper analysis.

{title: Syntax}
    {p 8 15 2} {cmd:mvplotts} [{cmd:[varlist]}] [{cmd:if}] [{cmd:in}], [{opt wv(string) title(string) GRoups(string)}]

{synoptset 20 tabbed}{...}

{opt wv(string)} Specifies up to three weighting variables to calculate weighted shares of missing values.

{opt title(string)} Adds a custom title to the graph. Defaults to "Share of Missing Values Over Time" if unspecified.

{opt GRoups(string)} Specifies the group values to include in the plot, typically derived from {cmd:mvdesc} output.

{title: Options}

{synoptset 20 tabbed}{...}

{opt wv(string)} — Specifies one or more weighting variables to create weighted time series of missing values. A maximum of three weighting variables is supported.

{opt title(string)} — Sets a custom title for the time series plot. If omitted, the title defaults to "Share of Missing Values Over Time".

{opt GRoups(string)} — Defines group values to be plotted, generally created by the {cmd:mvdesc} command.

{title: Examples}

{synoptset 20 tabbed}{...}

Example without weighting:
    {phang2}{cmd:. mvplotts var1 var2, groups(time_var)}

    {pstd} Example with a weighting variable:

    {phang2}{cmd:. mvplotts var1 var2, wv(weight_var) title("Time Series of Missing Values")}
