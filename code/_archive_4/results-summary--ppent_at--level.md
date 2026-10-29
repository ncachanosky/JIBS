# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

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

# ppent_at (Net PP&E / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0055 | -1.268 | 0.3086 | [-0.0172, 0.0169] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0008 |  0.170 | 0.8952 | [-0.0087, 0.0233] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -1.133 | 0.3740 | [-0.0066, 0.0054] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0215 | -1.927 | 0.2533 | [-0.0488, 0.0265] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0096 | -1.735 | 0.2744 | [-0.0264, 0.0205] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0005 | -0.093 | 0.9380 | [-0.0096, 0.0301] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0014 | -0.563 | 0.7338 | [-0.0066, 0.0096] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0186 | -1.368 | 0.3604 | [-0.0561, 0.0340] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0022 | -0.472 | 0.6620 | [-0.0109, 0.0060] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0019 | -0.640 | 0.5682 | [-0.0072, 0.0037] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0041 | -0.966 | 0.3895 | [-0.0120, 0.0038] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -0.543 | 0.6290 | [-0.0126, 0.0064] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0159 |  0.843 | 0.5733 | [-0.0942, 0.0704] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0153 |  1.452 | 0.4300 | [-0.0542, 0.0416] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0148 |  0.882 | 0.5029 | [-0.0754, 0.0682] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0002 | -0.029 | 0.9791 | [-0.0290, 0.0199] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0042 |  0.244 | 0.8493 | [-0.0366, 0.0367] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0065 |  0.604 | 0.6444 | [-0.0200, 0.0260] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0054 |  0.328 | 0.8121 | [-0.0364, 0.0369] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0041 |  0.568 | 0.5894 | [-0.0101, 0.0199] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0010 | -0.240 | 0.8276 | [-0.0095, 0.0070] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0018 | -0.699 | 0.5187 | [-0.0059, 0.0038] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0042 | -1.037 | 0.3593 | [-0.0123, 0.0039] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0043 | -0.773 | 0.5060 | [-0.0165, 0.0055] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0023 |  0.368 | 0.7402 | [-0.0086, 0.0131] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0029 |  0.718 | 0.5069 | [-0.0043, 0.0102] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0001 |  0.025 | 0.9825 | [-0.0105, 0.0101] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0074 | -1.033 | 0.3526 | [-0.0201, 0.0060] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0036 | -0.450 | 0.7040 | [-0.0184, 0.0130] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0030 | -0.564 | 0.6206 | [-0.0134, 0.0086] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0001 |  0.011 | 0.9936 | [-0.0152, 0.0162] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0036 |  0.556 | 0.6193 | [-0.0115, 0.0151] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0048 |  0.508 | 0.7812 | [-0.0161, 0.0237] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0050 |  0.835 | 0.5244 | [-0.0089, 0.0177] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0093 |  0.988 | 0.5319 | [-0.0131, 0.0282] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0006 | -0.074 | 0.9564 | [-0.0195, 0.0173] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0101 | -1.750 | 0.2058 | [-0.0234, 0.0032] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0002 | -0.043 | 0.9715 | [-0.0102, 0.0093] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0181 | -3.447 | 0.0335 ** | [-0.0311, -0.0042] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0040 | -0.358 | 0.8010 | [-0.0276, 0.0218] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0044 | -0.721 | 0.5217 | [-0.0168, 0.0189] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.133 | 0.9025 | [-0.0090, 0.0164] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0101 | -2.532 | 0.0434 ** | [-0.0217, -0.0031] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0176 | -1.555 | 0.2677 | [-0.0463, 0.0202] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0094 | -0.932 | 0.4395 | [-0.0455, 0.0187] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0035 | -0.497 | 0.6638 | [-0.0304, 0.0132] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0161 | -3.001 | 0.0151 ** | [-0.0303, -0.0080] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0217 | -1.486 | 0.2702 | [-0.0699, 0.0263] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.236 | 0.8423 | [-0.0078, 0.0105] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -0.696 | 0.5471 | [-0.0080, 0.0045] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.016 | 0.9909 | [-0.0070, 0.0092] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0009 | -0.261 | 0.7753 | [-0.0072, 0.0041] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0320 | -3.072 | 0.1001 | [-0.0679, -0.0092] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0126 | -0.868 | 0.7081 | [-0.1134, 0.0786] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0300 | -55.935 | 0.0085 ** | [-0.0305, -0.0281] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -0.520 | 0.5934 | [-0.0514, 0.0158] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0038 | -0.634 | 0.5734 | [-0.0144, 0.0081] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0024 | -0.595 | 0.5906 | [-0.0099, 0.0060] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0036 | -0.668 | 0.5593 | [-0.0139, 0.0072] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0010 |  0.162 | 0.8861 | [-0.0114, 0.0128] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0010 |  0.171 | 0.8767 | [-0.0096, 0.0116] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0021 |  0.515 | 0.6340 | [-0.0050, 0.0095] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0003 | -0.047 | 0.9670 | [-0.0107, 0.0095] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0078 | -1.102 | 0.3277 | [-0.0203, 0.0055] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0106 | -1.727 | 0.2153 | [-0.0256, 0.0043] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0113 | -3.246 | 0.0589 ** | [-0.0186, -0.0025] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0128 | -5.242 | 0.0091 ** | [-0.0187, -0.0063] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0104 |  2.329 | 0.1236 | [-0.0014, 0.0218] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
