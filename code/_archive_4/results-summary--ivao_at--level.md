# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

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

# ivao_at (Other Investments / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0127 |  1.440 | 0.1653 | [-0.0237, 0.0473] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0167 |  1.450 | 0.2568 | [-0.0466, 0.0696] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0068 |  1.127 | 0.2783 | [-0.0031, 0.0454] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0125 |  3.183 | 0.1227 | [-0.0027, 0.0249] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0179 |  2.023 | 0.0559 ** | [0.0023, 0.0394] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0231 |  1.929 | 0.0269 ** | [0.0040, 0.0950] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0088 |  1.103 | 0.2987 | [-0.0106, 0.0653] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0138 |  2.912 | 0.0570 ** | [0.0044, 0.0326] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0007 |  0.161 | 0.8915 | [-0.0071, 0.0084] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0020 |  0.690 | 0.5333 | [-0.0035, 0.0075] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.163 | 0.8788 | [-0.0042, 0.0054] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.285 | 0.7992 | [-0.0048, 0.0065] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0253 | -1.879 | 0.2527 | [-0.0848, 0.0129] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0182 | -1.902 | 0.2131 | [-0.0614, 0.0144] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0136 | -1.553 | 0.5939 | [-0.0515, 0.0149] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0096 |  1.861 | 0.3810 | [-0.0063, 0.0293] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0148 | -1.400 | 0.4703 | [-0.0392, 0.0101] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0125 | -1.528 | 0.4033 | [-0.0304, 0.0073] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0134 | -1.526 | 0.4223 | [-0.0328, 0.0079] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.019 | 0.9868 | [-0.0161, 0.0103] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  0.631 | 0.5861 | [-0.0062, 0.0120] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0029 |  0.853 | 0.4135 | [-0.0031, 0.0102] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0007 |  0.249 | 0.7943 | [-0.0044, 0.0064] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0006 | -0.194 | 0.8596 | [-0.0069, 0.0059] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0007 | -0.146 | 0.8993 | [-0.0103, 0.0088] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0021 |  0.576 | 0.6276 | [-0.0048, 0.0087] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.094 | 0.9365 | [-0.0062, 0.0069] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0042 |  1.225 | 0.2717 | [-0.0022, 0.0103] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0031 | -0.552 | 0.7285 | [-0.0143, 0.0087] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0018 | -0.408 | 0.8444 | [-0.0108, 0.0063] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0034 | -0.793 | 0.6922 | [-0.0125, 0.0051] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0011 |  0.298 | 0.7870 | [-0.0066, 0.0080] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0035 | -0.422 | 0.8541 | [-0.0219, 0.0139] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0036 | -0.560 | 0.7816 | [-0.0170, 0.0098] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0068 | -1.095 | 0.6118 | [-0.0204, 0.0062] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0058 |  1.173 | 0.3279 | [-0.0051, 0.0145] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0072 |  1.007 | 0.5190 | [-0.0109, 0.0238] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0089 |  3.151 | 0.0023 ** | [0.0033, 0.0158] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0031 |  2.630 | 0.0318 ** | [0.0008, 0.0054] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0064 | -1.260 | 0.5103 | [-0.0201, 0.0071] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0050 |  0.631 | 0.7261 | [-0.0247, 0.0264] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0132 |  1.534 | 0.3482 | [-0.0103, 0.0404] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0058 |  1.129 | 0.2988 | [-0.0036, 0.0327] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0063 |  1.397 | 0.3119 | [-0.0122, 0.0167] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0049 |  0.497 | 0.7912 | [-0.0330, 0.0268] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0176 |  1.960 | 0.0321 ** | [0.0043, 0.0447] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0075 |  0.976 | 0.4272 | [-0.0127, 0.0468] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0030 |  0.466 | 0.7776 | [-0.0224, 0.0170] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.539 | 0.7191 | [-0.0093, 0.0043] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.089 | 0.9264 | [-0.0064, 0.0066] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.041 | 0.9575 | [-0.0063, 0.0068] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0020 |  1.003 | 0.3366 | [-0.0013, 0.0070] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0234 | 13.549 | 0.0293 ** | [0.0183, 0.0269] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0148 |  2.226 | 0.0711 ** | [0.0038, 0.0434] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0158 |  3.978 | 0.0499 ** | [0.0082, 0.0326] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0201 | -3.317 | 0.3119 | [-0.0341, 0.0075] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0020 | -0.430 | 0.7242 | [-0.0110, 0.0071] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0021 |  0.642 | 0.6093 | [-0.0044, 0.0080] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.114 | 0.9302 | [-0.0060, 0.0068] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0011 |  0.357 | 0.7472 | [-0.0050, 0.0069] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0001 | -0.029 | 0.9810 | [-0.0094, 0.0091] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0024 |  0.665 | 0.5560 | [-0.0040, 0.0088] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.175 | 0.8776 | [-0.0053, 0.0070] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0039 |  1.112 | 0.3153 | [-0.0027, 0.0101] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0055 | -1.824 | 0.2432 | [-0.0134, 0.0024] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0007 | -0.899 | 0.3733 | [-0.0027, 0.0008] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.053 | 0.9566 | [-0.0009, 0.0013] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0021 | -1.566 | 0.2430 | [-0.0043, 0.0014] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
