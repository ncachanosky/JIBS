# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# ao_at (Other Assets / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0235 | -2.123 | 0.2154 | [-0.0716, 0.0281] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0169 | -2.187 | 0.1749 | [-0.0530, 0.0160] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0021 | -0.377 | 0.8383 | [-0.0146, 0.0104] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0091 |  2.316 | 0.1141 | [-0.0008, 0.0214] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0156 | -1.065 | 0.5992 | [-0.0485, 0.0486] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0097 | -0.981 | 0.6478 | [-0.0346, 0.0275] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0030 |  0.702 | 0.6279 | [-0.0052, 0.0163] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0048 |  2.119 | 0.1386 | [-0.0012, 0.0153] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0067 | -1.272 | 0.4630 | [-0.0188, 0.0049] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0043 | -1.871 | 0.1805 | [-0.0091, 0.0010] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0009 | -0.292 | 0.7931 | [-0.0067, 0.0066] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0057 |  2.421 | 0.0621 ** | [0.0008, 0.0103] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0183 |  2.401 | 0.0803 ** | [0.0028, 0.0508] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  0.742 | 0.4797 | [-0.0046, 0.0166] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.732 | 0.5362 | [-0.0071, 0.0075] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0036 | -0.765 | 0.7696 | [-0.0209, 0.0116] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0137 |  2.414 | 0.0416 ** | [0.0018, 0.0268] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0011 | -0.723 | 0.4978 | [-0.0037, 0.0023] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.486 | 0.5368 | [-0.0120, 0.0219] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0014 | -0.432 | 0.7070 | [-0.0090, 0.0049] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0086 | -1.334 | 0.4574 | [-0.0227, 0.0070] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0040 | -1.541 | 0.2902 | [-0.0086, 0.0023] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.015 | 0.9909 | [-0.0066, 0.0092] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0059 |  2.590 | 0.0490 ** | [0.0011, 0.0100] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.497 | 0.6500 | [-0.0092, 0.0054] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0031 | -1.065 | 0.3712 | [-0.0093, 0.0027] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.207 | 0.8573 | [-0.0087, 0.0084] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0079 |  2.430 | 0.0529 ** | [0.0015, 0.0147] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0054 |  1.675 | 0.1231 | [-0.0003, 0.0124] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.327 | 0.7477 | [-0.0020, 0.0037] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0016 |  0.417 | 0.6008 | [-0.0069, 0.0118] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0026 |  1.099 | 0.3305 | [-0.0021, 0.0072] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0104 |  2.450 | 0.0261 ** | [0.0020, 0.0196] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0017 |  0.860 | 0.4226 | [-0.0018, 0.0057] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0037 |  0.722 | 0.5183 | [-0.0082, 0.0167] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0048 |  1.623 | 0.2064 | [-0.0017, 0.0108] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0011 | -0.149 | 0.9568 | [-0.0173, 0.0121] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0004 | -0.109 | 0.9493 | [-0.0079, 0.0067] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0142 |  5.409 | 0.0000 ** | [0.0081, 0.0209] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  0.693 | 0.6090 | [-0.0062, 0.0127] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0223 | -2.513 | 0.1267 | [-0.0518, 0.0026] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0166 | -2.764 | 0.0708 ** | [-0.0379, -0.0029] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0026 | -0.516 | 0.7794 | [-0.0125, 0.0085] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0097 |  2.454 | 0.0770 ** | [0.0010, 0.0193] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0160 | -1.070 | 0.6149 | [-0.0501, 0.0103] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0111 | -1.092 | 0.5993 | [-0.0356, 0.0060] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0030 |  0.874 | 0.5780 | [-0.0035, 0.0099] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0066 |  1.327 | 0.2603 | [-0.0039, 0.0316] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0070 | -1.498 | 0.3413 | [-0.0177, 0.0043] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0048 | -2.402 | 0.0387 ** | [-0.0095, -0.0011] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0057 | -4.820 | 0.0008 ** | [-0.0079, -0.0036] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0064 |  2.550 | 0.0719 ** | [0.0006, 0.0138] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0312 |  2.970 | 0.1091 | [-0.0921, 0.1410] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0061 |  0.945 | 0.7016 | [-0.0503, 0.0678] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0263 |  5.334 | 0.1182 | [-0.0132, 0.0604] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0102 | -9.783 | 0.0547 ** | [-0.0164, -0.0085] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0042 |  1.700 | 0.0964 ** | [0.0001, 0.0091] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  0.769 | 0.5266 | [-0.0021, 0.0051] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0012 |  0.401 | 0.7077 | [-0.0057, 0.0091] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0022 |  0.904 | 0.4198 | [-0.0023, 0.0069] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0027 | -0.661 | 0.5440 | [-0.0102, 0.0049] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0036 | -1.162 | 0.3246 | [-0.0104, 0.0025] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0010 | -0.249 | 0.8293 | [-0.0087, 0.0085] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0079 |  2.419 | 0.0450 ** | [0.0014, 0.0144] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0001 | -0.049 | 0.9651 | [-0.0046, 0.0080] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0003 |  0.137 | 0.8888 | [-0.0034, 0.0052] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0023 | -2.468 | 0.0744 ** | [-0.0042, -0.0003] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0012 | -0.490 | 0.6307 | [-0.0075, 0.0040] | 50 |

# ch_at (Cash / Assets)

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.116 | 0.0103 ** | [0.0076, 0.0519] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.104 | 0.2487 | [-0.0018, 0.0520] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.290 | 0.9110 | [-0.0099, 0.0331] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.819 | 0.5945 | [-0.0054, 0.0399] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.464 | 0.6910 | [-0.0148, 0.0103] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.467 | 0.6825 | [-0.0090, 0.0208] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.253 | 0.8197 | [-0.0173, 0.0196] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.819 | 0.5943 | [-0.0055, 0.0395] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.464 | 0.6914 | [-0.0155, 0.0103] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.467 | 0.6721 | [-0.0090, 0.0208] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.253 | 0.8201 | [-0.0173, 0.0196] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
