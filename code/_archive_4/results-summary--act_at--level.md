# Results summary: Level-Lag Ebalance (12 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# act_at (Current Assets / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0088 | -0.417 | 0.6620 | [-0.1044, 0.0422] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0188 | -1.357 | 0.2776 | [-0.0988, 0.0127] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0051 | -0.362 | 0.6691 | [-0.0848, 0.0281] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0008 | -0.091 | 0.9322 | [-0.0430, 0.0194] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0073 | -0.347 | 0.7727 | [-0.0825, 0.0483] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0234 | -1.277 | 0.2552 | [-0.1528, 0.0199] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0090 | -0.500 | 0.5754 | [-0.1314, 0.0367] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0000 |  0.004 | 0.9975 | [-0.0635, 0.0241] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0003 |  0.062 | 0.9541 | [-0.0091, 0.0098] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0001 | -0.015 | 0.9886 | [-0.0094, 0.0082] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0038 |  0.928 | 0.4270 | [-0.0052, 0.0110] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0057 | -1.091 | 0.3408 | [-0.0155, 0.0041] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0043 |  0.450 | 0.6927 | [-0.0197, 0.0637] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0033 |  0.406 | 0.7858 | [-0.0256, 0.0404] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0101 |  1.611 | 0.3006 | [-0.0138, 0.0434] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0132 |  1.057 | 0.2824 | [-0.0024, 0.0954] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0015 | -0.133 | 0.9113 | [-0.0255, 0.0232] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0016 |  0.150 | 0.9101 | [-0.0218, 0.0267] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0005 | -0.069 | 0.9600 | [-0.0158, 0.0148] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0119 |  1.201 | 0.2740 | [-0.0067, 0.0308] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0021 | -0.363 | 0.7414 | [-0.0144, 0.0095] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0021 | -0.413 | 0.6932 | [-0.0126, 0.0068] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.843 | 0.4689 | [-0.0055, 0.0106] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0027 | -0.711 | 0.5141 | [-0.0094, 0.0056] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0010 |  0.161 | 0.8883 | [-0.0110, 0.0130] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0037 | -0.634 | 0.5489 | [-0.0147, 0.0066] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0005 | -0.090 | 0.9318 | [-0.0117, 0.0095] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0042 | -0.559 | 0.6474 | [-0.0189, 0.0081] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.521 | 0.6458 | [-0.0117, 0.0077] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0043 |  0.782 | 0.4985 | [-0.0065, 0.0157] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0029 |  0.766 | 0.5224 | [-0.0054, 0.0095] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0093 | -1.445 | 0.1442 | [-0.0235, 0.0006] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0068 | -1.041 | 0.4052 | [-0.0198, 0.0076] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0007 | -0.097 | 0.9431 | [-0.0159, 0.0162] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0032 | -0.626 | 0.6466 | [-0.0138, 0.0074] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0071 | -0.951 | 0.4210 | [-0.0228, 0.0052] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0032 |  0.309 | 0.8237 | [-0.0214, 0.0238] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0053 | -0.734 | 0.5623 | [-0.0202, 0.0089] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0071 |  1.211 | 0.4769 | [-0.0086, 0.0215] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0067 |  0.890 | 0.4805 | [-0.0106, 0.0223] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0064 | -0.337 | 0.7424 | [-0.0400, 0.0398] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0161 | -1.274 | 0.2955 | [-0.0741, 0.0129] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0027 |  0.216 | 0.7948 | [-0.0541, 0.0315] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0038 |  0.420 | 0.7065 | [-0.0270, 0.0249] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0045 |  0.250 | 0.8600 | [-0.0648, 0.0518] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0111 | -0.621 | 0.5783 | [-0.0942, 0.0350] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0078 |  0.479 | 0.6088 | [-0.0750, 0.0519] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0200 |  1.677 | 0.2632 | [-0.0269, 0.0552] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0031 | -0.845 | 0.4198 | [-0.0099, 0.0033] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.110 | 0.9293 | [-0.0124, 0.0093] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0014 |  0.317 | 0.7898 | [-0.0088, 0.0087] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0091 | -1.816 | 0.1104 | [-0.0184, 0.0003] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0113 | -0.491 | 0.8598 | [-0.2266, 0.2333] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0044 | -0.254 | 0.8688 | [-0.1880, 0.1887] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0138 | -2.569 | 0.1459 | [-0.0704, 0.0513] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0201 |  4.052 | 0.0557 ** | [0.0047, 0.0553] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0003 | -0.051 | 0.9627 | [-0.0111, 0.0111] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0011 | -0.192 | 0.8555 | [-0.0116, 0.0095] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0031 |  0.647 | 0.5748 | [-0.0073, 0.0119] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0026 | -0.379 | 0.7581 | [-0.0172, 0.0088] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0020 |  0.334 | 0.7759 | [-0.0092, 0.0138] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0029 | -0.510 | 0.6278 | [-0.0129, 0.0071] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0010 | -0.192 | 0.8511 | [-0.0112, 0.0087] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0029 | -0.384 | 0.7520 | [-0.0176, 0.0094] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0068 | -0.923 | 0.3782 | [-0.0276, 0.0046] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0075 |  1.230 | 0.3391 | [-0.0113, 0.0172] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0183 |  6.405 | 0.0016 ** | [0.0098, 0.0249] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0245 | -4.296 | 0.0106 ** | [-0.0409, -0.0131] | 50 |

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
