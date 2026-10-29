# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# ch_at (Cash / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0072 |  1.043 | 0.2072 | [-0.0013, 0.0529] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0015 |  1.257 | 0.3950 | [-0.0020, 0.0072] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0042 |  4.103 | 0.0786 ** | [0.0012, 0.0066] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0062 | -1.412 | 0.3549 | [-0.0158, 0.0159] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0043 |  0.513 | 0.6397 | [-0.0092, 0.0681] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0008 | -0.652 | 0.5716 | [-0.0068, 0.0017] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0016 |  2.486 | 0.1454 | [-0.0010, 0.0029] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0045 | -0.987 | 0.4539 | [-0.0195, 0.0210] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0017 | -0.431 | 0.6983 | [-0.0084, 0.0062] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.420 | 0.7141 | [-0.0075, 0.0053] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.117 | 0.9241 | [-0.0048, 0.0049] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0123 | -2.909 | 0.0106 ** | [-0.0217, -0.0044] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0106 |  0.787 | 0.6074 | [-0.0160, 0.0748] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0106 |  1.203 | 0.5326 | [-0.0142, 0.0508] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.152 | 0.8750 | [-0.0149, 0.0192] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0272 | -11.799 | 0.0266 ** | [-0.0310, -0.0112] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0050 |  0.366 | 0.7616 | [-0.0250, 0.0341] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0082 |  0.817 | 0.5496 | [-0.0153, 0.0306] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0024 | -0.688 | 0.5673 | [-0.0079, 0.0049] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0218 | -3.987 | 0.0061 ** | [-0.0327, -0.0110] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0016 | -0.386 | 0.7298 | [-0.0085, 0.0076] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0018 | -0.512 | 0.6645 | [-0.0077, 0.0056] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.241 | 0.8440 | [-0.0043, 0.0053] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0083 | -2.175 | 0.0718 ** | [-0.0176, -0.0008] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0008 |  0.195 | 0.8583 | [-0.0072, 0.0098] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0006 |  0.184 | 0.8791 | [-0.0047, 0.0068] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.565 | 0.6873 | [-0.0028, 0.0058] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0178 | -3.439 | 0.0088 ** | [-0.0275, -0.0076] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0003 |  0.069 | 0.9556 | [-0.0094, 0.0111] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0027 |  0.735 | 0.6085 | [-0.0042, 0.0106] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.988 | 0.4504 | [-0.0058, 0.0019] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0147 | -3.396 | 0.0012 ** | [-0.0237, -0.0076] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.167 | 0.9047 | [-0.0131, 0.0161] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0025 |  0.466 | 0.8232 | [-0.0082, 0.0150] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0025 | -1.438 | 0.2971 | [-0.0060, 0.0015] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0203 | -3.889 | 0.0038 ** | [-0.0301, -0.0100] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0159 | -1.655 | 0.2099 | [-0.0401, 0.0027] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0122 | -1.176 | 0.5582 | [-0.0396, 0.0061] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0068 | -0.747 | 0.7137 | [-0.0312, 0.0126] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0203 | -3.545 | 0.0001 ** | [-0.0342, -0.0083] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0002 |  0.028 | 0.9749 | [-0.0220, 0.0220] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0040 | -0.519 | 0.9625 | [-0.0378, 0.0063] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0028 |  0.414 | 0.7433 | [-0.0222, 0.0163] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0094 | -1.805 | 0.2052 | [-0.0237, 0.0070] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0047 | -0.347 | 0.7891 | [-0.0552, 0.0437] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0074 | -0.660 | 0.8804 | [-0.0694, 0.0162] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0042 | -0.467 | 0.9691 | [-0.0531, 0.0219] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.136 | 0.9031 | [-0.0212, 0.0165] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0004 |  0.091 | 0.9427 | [-0.0073, 0.0123] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.164 | 0.8839 | [-0.0053, 0.0089] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0010 |  0.726 | 0.6007 | [-0.0023, 0.0044] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0094 | -2.285 | 0.0735 ** | [-0.0185, -0.0008] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0064 |  0.292 | 0.7645 | [-0.0365, 0.1985] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0078 |  0.574 | 0.6727 | [-0.0528, 0.1112] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0027 | -4.987 | 0.0230 ** | [-0.0050, -0.0013] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0052 | -1.581 | 0.3198 | [-0.0150, 0.0222] | 7 |

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.135 | 0.0096 ** | [0.0078, 0.0520] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.165 | 0.1928 | [-0.0012, 0.0528] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.379 | 0.8889 | [-0.0089, 0.0338] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.869 | 0.5520 | [-0.0048, 0.0404] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.377 | 0.7465 | [-0.0141, 0.0106] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.549 | 0.6267 | [-0.0083, 0.0212] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.209 | 0.8483 | [-0.0169, 0.0199] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.869 | 0.5514 | [-0.0048, 0.0399] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.377 | 0.7480 | [-0.0147, 0.0112] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.549 | 0.6212 | [-0.0083, 0.0212] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.209 | 0.8528 | [-0.0169, 0.0199] | 50 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0033 | -0.656 | 0.5607 | [-0.0121, 0.0061] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0020 | -0.421 | 0.7418 | [-0.0103, 0.0063] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -0.605 | 0.6424 | [-0.0091, 0.0038] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0135 | -2.705 | 0.0092 ** | [-0.0239, -0.0047] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0032 |  0.746 | 0.5085 | [-0.0049, 0.0118] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0021 |  0.690 | 0.5512 | [-0.0032, 0.0084] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.359 | 0.7886 | [-0.0032, 0.0050] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0158 | -3.121 | 0.0098 ** | [-0.0253, -0.0064] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0194 | -2.004 | 0.0081 ** | [-0.0525, -0.0087] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0127 | -1.018 | 0.3849 | [-0.0559, 0.0024] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0031 | -0.308 | 0.9582 | [-0.0391, 0.0080] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0182 | -2.715 | 0.0106 ** | [-0.0406, -0.0060] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
