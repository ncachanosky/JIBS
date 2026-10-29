# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# act_ex_ch_at (Current Assets ex. Cash / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0275 | -1.502 | 0.2914 | [-0.1284, 0.0183] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0256 | -1.998 | 0.1371 | [-0.1004, 0.0027] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0104 | -0.847 | 0.3497 | [-0.0799, 0.0185] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.016 | 0.9762 | [-0.0595, 0.0228] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0253 | -1.114 | 0.3022 | [-0.1596, 0.0394] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0274 | -1.606 | 0.1736 | [-0.1486, 0.0131] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0106 | -0.673 | 0.5303 | [-0.1147, 0.0297] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0033 | -0.249 | 0.7263 | [-0.0878, 0.0309] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0012 | -0.213 | 0.8402 | [-0.0125, 0.0082] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0008 |  0.161 | 0.8886 | [-0.0093, 0.0098] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0012 |  0.322 | 0.7727 | [-0.0068, 0.0072] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0062 |  1.293 | 0.2444 | [-0.0028, 0.0162] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0043 |  0.912 | 0.3595 | [-0.0178, 0.0269] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  0.293 | 0.8369 | [-0.0273, 0.0368] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0097 |  1.357 | 0.4071 | [-0.0152, 0.0395] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0393 |  3.372 | 0.0680 ** | [0.0210, 0.1113] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0053 |  0.747 | 0.5866 | [-0.0112, 0.0203] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  0.220 | 0.8767 | [-0.0183, 0.0211] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.179 | 0.9086 | [-0.0156, 0.0182] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0329 |  4.071 | 0.0009 ** | [0.0169, 0.0498] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0040 | -0.629 | 0.5483 | [-0.0179, 0.0065] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0007 | -0.113 | 0.9218 | [-0.0138, 0.0098] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.131 | 0.9053 | [-0.0080, 0.0069] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0049 |  0.851 | 0.4689 | [-0.0058, 0.0188] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.260 | 0.8099 | [-0.0159, 0.0107] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0042 | -0.734 | 0.4737 | [-0.0142, 0.0059] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0030 | -0.639 | 0.5544 | [-0.0130, 0.0059] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0135 |  2.496 | 0.0370 ** | [0.0034, 0.0230] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0022 |  0.469 | 0.6662 | [-0.0061, 0.0116] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0065 |  1.368 | 0.2133 | [-0.0024, 0.0163] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0052 |  1.434 | 0.2219 | [-0.0020, 0.0125] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0065 |  1.454 | 0.2064 | [-0.0019, 0.0164] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0002 | -0.038 | 0.9744 | [-0.0129, 0.0131] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  0.383 | 0.7541 | [-0.0108, 0.0167] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0007 | -0.127 | 0.9172 | [-0.0117, 0.0121] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0131 |  2.085 | 0.1127 | [-0.0007, 0.0262] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0013 |  0.180 | 0.8966 | [-0.0145, 0.0171] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0033 | -0.690 | 0.6019 | [-0.0132, 0.0066] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.038 | 0.9768 | [-0.0103, 0.0112] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0279 |  5.759 | 0.0000 ** | [0.0183, 0.0390] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0242 | -1.426 | 0.3096 | [-0.0974, 0.0166] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0219 | -1.887 | 0.2123 | [-0.0748, 0.0061] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0085 | -0.767 | 0.4418 | [-0.0582, 0.0180] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0111 |  1.190 | 0.3326 | [-0.0244, 0.0337] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0191 | -0.852 | 0.4695 | [-0.1226, 0.0445] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0179 | -1.120 | 0.3264 | [-0.0896, 0.0269] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0016 | -0.113 | 0.8661 | [-0.0670, 0.0395] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0155 |  1.192 | 0.3371 | [-0.0337, 0.0534] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0028 | -0.394 | 0.7515 | [-0.0185, 0.0089] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.161 | 0.8934 | [-0.0142, 0.0127] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.190 | 0.8882 | [-0.0090, 0.0078] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.032 | 0.9801 | [-0.0094, 0.0103] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0092 | -1.760 | 0.1863 | [-0.0136, 0.0300] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0100 | -1.257 | 0.6312 | [-0.0179, 0.0102] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0125 | -3.927 | 0.1110 | [-0.0167, 0.0125] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0266 | 15.724 | 0.0331 ** | [0.0232, 0.0366] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0001 |  0.015 | 0.9870 | [-0.0117, 0.0119] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0003 |  0.065 | 0.9523 | [-0.0091, 0.0098] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0024 |  0.563 | 0.6232 | [-0.0066, 0.0105] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0105 |  2.140 | 0.0687 ** | [0.0013, 0.0207] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0034 | -0.473 | 0.6594 | [-0.0168, 0.0092] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0051 | -0.888 | 0.3947 | [-0.0151, 0.0050] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0028 | -0.614 | 0.5669 | [-0.0125, 0.0053] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0125 |  2.432 | 0.0417 ** | [0.0029, 0.0215] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0078 |  1.450 | 0.2638 | [-0.0065, 0.0167] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0177 |  5.743 | 0.0044 ** | [0.0116, 0.0259] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0151 |  6.812 | 0.0015 ** | [0.0103, 0.0208] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0029 | -0.835 | 0.4970 | [-0.0092, 0.0069] | 50 |

# ch_at (Cash / Assets)

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.116 | 0.0111 ** | [0.0076, 0.0520] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.104 | 0.2410 | [-0.0017, 0.0515] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.290 | 0.9151 | [-0.0100, 0.0326] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.819 | 0.5944 | [-0.0055, 0.0399] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.464 | 0.6872 | [-0.0155, 0.0109] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.467 | 0.6765 | [-0.0090, 0.0208] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.253 | 0.8172 | [-0.0164, 0.0196] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.819 | 0.5946 | [-0.0055, 0.0395] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.464 | 0.6938 | [-0.0155, 0.0103] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.467 | 0.6769 | [-0.0097, 0.0208] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.253 | 0.8176 | [-0.0173, 0.0196] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
