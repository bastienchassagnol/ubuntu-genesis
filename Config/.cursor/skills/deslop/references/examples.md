# Before and after examples

Prose from manuscripts and package vignettes. Citations are placeholders; the
numbers are illustrative and must be replaced by the author's own output.

## 1. Methods paragraph

Before:
> In this section, we will delve into the comprehensive methodology that was
> leveraged to robustly estimate treatment effects. A cutting-edge Bayesian
> hierarchical framework was utilised, which serves as a powerful tool for
> navigating the complexities of multi-site data \cite{key}.

After:
> We estimated site-specific treatment effects with a Bayesian hierarchical
> model \cite{key}. Site intercepts and slopes had normal priors with a shared
> mean and half-normal scale. We fitted the model with four chains of 2 000
> iterations and discarded the first 1 000 as warm-up.

Changes: removed announcement, jargon and "serves as"; used "we" for authors'
actions; added procedure details the author must confirm.

## 2. Results with numbers and intervals

Before:
> Interestingly, the results reveal a remarkably significant improvement,
> underscoring the pivotal role of the proposed estimator. Notably, the
> proposed method substantially outperformed the baselines across all settings.

After:
> The proposed estimator had lower root mean squared error than the baseline in
> 11 of 12 settings (median difference -0.8, 95% interval -1.1 to -0.4;
> Table~\ref{tab:rmse}). In the 12th setting, with n = 20, the two estimators
> did not differ.

Changes: dropped adverbs and "underscoring" clause; replaced "substantially" and
"all" with the count, effect and interval; reported the exception.

## 3. Vignette introduction

Before:
> Welcome to the `mixfit` package! Let's dive in and unlock the power of
> flexible mixture modelling. Whether you are a beginner or an expert, this
> seamless, easy-to-use package empowers you to simply fit state-of-the-art
> models in just a few lines.

After:
> `mixfit` estimates Gaussian mixture models by expectation-maximisation. This
> vignette fits a two-component model to the `faithful` data, checks
> convergence and compares it with a one-component fit. You need a numeric data
> frame with no missing values.

Changes: replaced marketing adjectives with the function's job, the vignette's
plan in one sentence and the input requirement. Speaks to the user directly.

## 4. Figure caption

Before:
> Figure 2: A comprehensive overview showcasing the remarkable performance of
> our approach, which clearly demonstrates the importance of calibration.

After:
> Figure 2: Calibration of predicted risk by decile in the validation cohort
> (n = 1 204). Points show observed event rates with 95% Wilson intervals; the
> dashed line is perfect calibration. Predictions above 0.4 are
> overestimated.

Changes: a caption defines panels, axes, intervals and states the finding; no
evaluative adjectives.

## 5. Response to reviewer

Before:
> We sincerely thank the reviewer for this insightful and thought-provoking
> comment, which has greatly helped us improve our manuscript. We completely
> agree that this is an important point. We have carefully addressed it in the
> revised version.

After:
> Reviewer 2, comment 3 (missing-data handling). We agree that complete-case
> analysis can bias the estimate. We added multiple imputation with 20 imputed
> sets (Methods, Section 2.4) and report the complete-case result as a
> sensitivity analysis (Supplementary Table S3). The hazard ratio changed from
> 1.42 to 1.38; the conclusion is unchanged.

Changes: removed praise boilerplate; stated the change, its location and its
effect.

## 6. Function documentation prose

Before:
> This function serves as a powerful and flexible wrapper that allows users to
> easily perform fitting of the model, leveraging a robust optimisation
> routine.

After:
> Fits the model by maximum likelihood with `optim()`. Returns an object of
> class `mixfit` with the estimates, standard errors and convergence code.

Changes: removed "serves as" and adjectives; gave the method and the return
value.
