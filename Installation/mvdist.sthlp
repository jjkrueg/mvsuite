{smcl}
{* 12nov2024}{...}
{cmd:help mvdist}
{hline}

{title:Title}
    {pstd}  {hi:mvdist} — Distributional comparison of a weighting variable with respect to missingness in specified variables

{title: Synopsis}
    {pstd}  {cmd:mvdist} {varlist} [{cmd:if}] [{cmd:in}], {opt wv(string)} [ {opt GRaph} {opt yaxis(string)} ]

{title: Description}
    {pstd} {cmd:mvdist} analyzes the distribution of a specified weighting variable in relation to missing values in one or more variables from {varlist}. It provides a distributional comparison of the weighting variable where each specified variable is either missing or not, allowing for a visual and statistical evaluation of these distributions.

{pstd} The command checks for consistency in input values, reports relevant test statistics (Kolmogorov-Smirnov D-statistic and p-values), and optionally generates distribution comparison graphs.

{title: Options}

   {pstd}  {opt wv(string)} Specifies the weighting variable. Must be numeric. Only one weighting variable is allowed.

   {pstd}  {opt GRaph} Generates comparison histograms showing the distributions of the weighting variable by missing and non-missing groups in {varlist}.

   {pstd}  {opt yaxis(string)} Specifies the y-axis type for histograms if {opt GRaph} is specified. Accepted values are {cmd:percent}, {cmd:den}, {cmd:density}, {cmd:fraction}, {cmd:frac}, {cmd:frequency}, and {cmd:freq}. Default is frequency.

{title: Examples}

    {pstd}  {cmd: mvdist var1 var2, wv(weightvar)}

    {pstd}  {cmd: mvdist var1 var2, wv(weightvar) GRaph yaxis(density)}

{title: Notes}

This program outputs the Kolmogorov-Smirnov D-statistic and the associated p-value for each variable in {varlist} compared to the weighting variable. If the {opt GRaph} option is specified, histograms comparing the distributions of the weighting variable for missing and non-missing observations are generated.

Input consistency checks are included to ensure only numeric variables are used in {opt wv} and {varlist}, and that {opt yaxis} types are valid if specified.

{title: Errors}

    {pstd} 
The following errors may be encountered:

    {pmore} * "Too many weight variables specified": Only one weighting variable can be specified.

    {pmore} * "`wv' contains missing values": Weighting variable should not contain missing values.

    {pmore} * "`wv' should be in numeric format": Weighting variable must be numeric.

    {pmore} * "`var' should be in numeric format": All variables in {varlist} must be numeric.

    {pmore} * "unknown y-axis type": Invalid y-axis type specified for histograms.

{title: Author}
    Developed by [Your Name/Organization].