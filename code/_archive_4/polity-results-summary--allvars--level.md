# Results summary: Level-Lag Ebalance (15 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# act_at (Current Assets / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0056 |  0.343 | 0.8404 | [-0.0577, 0.0410] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0227 | -1.298 | 0.3356 | [-0.0622, 0.0112] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0050 | -0.241 | 0.6705 | [-0.0463, 0.0235] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0027 | -0.179 | 0.7890 | [-0.0349, 0.0199] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0002 | -0.010 | 0.9916 | [-0.0478, 0.0321] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0294 | -1.200 | 0.2667 | [-0.0971, 0.0106] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0082 | -0.319 | 0.6036 | [-0.0791, 0.0308] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0014 |  0.092 | 0.9217 | [-0.0406, 0.0263] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0008 |  0.151 | 0.8840 | [-0.0083, 0.0116] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0002 | -0.049 | 0.9636 | [-0.0086, 0.0081] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0040 |  0.972 | 0.3975 | [-0.0046, 0.0112] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0074 | -1.109 | 0.3343 | [-0.0205, 0.0036] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0033 |  0.345 | 0.7583 | [-0.0204, 0.0630] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0023 |  0.281 | 0.8263 | [-0.0264, 0.0386] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0093 |  1.502 | 0.3179 | [-0.0143, 0.0420] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0128 |  1.024 | 0.3007 | [-0.0028, 0.0929] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.172 | 0.8849 | [-0.0256, 0.0231] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0012 |  0.115 | 0.9352 | [-0.0223, 0.0261] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.110 | 0.9342 | [-0.0160, 0.0145] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0117 |  1.178 | 0.2866 | [-0.0069, 0.0310] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0050 | -0.838 | 0.4440 | [-0.0155, 0.0075] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0055 | -1.116 | 0.2809 | [-0.0141, 0.0031] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0026 |  0.668 | 0.5235 | [-0.0047, 0.0096] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0014 | -0.326 | 0.7530 | [-0.0091, 0.0062] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0006 |  0.097 | 0.9343 | [-0.0103, 0.0120] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0040 | -0.708 | 0.5152 | [-0.0146, 0.0059] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0007 | -0.132 | 0.9015 | [-0.0121, 0.0094] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0022 | -0.305 | 0.7777 | [-0.0168, 0.0107] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0071 |  0.937 | 0.4535 | [-0.0071, 0.0238] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0105 |  1.280 | 0.2834 | [-0.0075, 0.0266] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0104 | -2.339 | 0.0368 ** | [-0.0202, -0.0016] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0051 | -0.749 | 0.5070 | [-0.0199, 0.0061] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0068 | -0.968 | 0.4280 | [-0.0207, 0.0087] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0010 | -0.127 | 0.9263 | [-0.0168, 0.0165] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0032 | -0.642 | 0.6425 | [-0.0144, 0.0079] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0082 | -0.969 | 0.4443 | [-0.0278, 0.0048] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  0.262 | 0.8527 | [-0.0234, 0.0267] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0070 | -0.948 | 0.4589 | [-0.0223, 0.0084] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0084 |  1.237 | 0.4736 | [-0.0095, 0.0245] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0039 |  0.448 | 0.7145 | [-0.0154, 0.0223] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0024 | -0.623 | 0.5663 | [-0.0089, 0.0057] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0008 | -0.144 | 0.9040 | [-0.0114, 0.0098] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0015 |  0.339 | 0.7972 | [-0.0076, 0.0087] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0106 | -1.590 | 0.1175 | [-0.0253, 0.0004] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0118 | -0.511 | 0.8619 | [-0.2421, 0.2337] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0046 | -0.264 | 0.8657 | [-0.1873, 0.1972] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0139 | -2.572 | 0.1388 | [-0.0665, 0.0504] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0200 |  4.082 | 0.0549 ** | [0.0047, 0.0467] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0069 |  0.745 | 0.4988 | [-0.0094, 0.0243] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0033 |  0.422 | 0.6974 | [-0.0123, 0.0181] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0031 | -0.591 | 0.6175 | [-0.0145, 0.0072] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0048 |  0.808 | 0.4911 | [-0.0076, 0.0152] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0045 |  0.748 | 0.5418 | [-0.0074, 0.0163] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0005 | -0.075 | 0.9439 | [-0.0124, 0.0101] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.303 | 0.7779 | [-0.0134, 0.0088] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0010 |  0.141 | 0.8990 | [-0.0141, 0.0137] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0114 | -0.836 | 0.5859 | [-0.0425, 0.0054] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0036 |  0.362 | 0.7859 | [-0.0189, 0.0168] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0127 |  4.037 | 0.0106 ** | [0.0062, 0.0193] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0236 | -4.526 | 0.0045 ** | [-0.0356, -0.0150] | 50 |

# act_ex_ch_at (Current Assets ex. Cash / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0275 | -1.175 | 0.4402 | [-0.0763, 0.0307] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0317 | -1.972 | 0.1802 | [-0.0743, 0.0253] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0109 | -0.684 | 0.6151 | [-0.0435, 0.0125] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0034 | -0.153 | 0.7839 | [-0.0495, 0.0252] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0303 | -0.951 | 0.3670 | [-0.1194, 0.0186] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0350 | -1.488 | 0.1763 | [-0.0981, 0.0029] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0119 | -0.550 | 0.5655 | [-0.0721, 0.0210] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0027 | -0.127 | 0.8136 | [-0.0641, 0.0287] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0009 | -0.154 | 0.8833 | [-0.0119, 0.0094] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.097 | 0.9302 | [-0.0086, 0.0096] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0017 |  0.463 | 0.6730 | [-0.0054, 0.0080] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0082 |  1.920 | 0.0838 ** | [0.0002, 0.0163] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0048 |  1.029 | 0.3447 | [-0.0162, 0.0259] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0027 |  0.353 | 0.8265 | [-0.0267, 0.0363] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0103 |  1.458 | 0.3776 | [-0.0144, 0.0397] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0395 |  3.403 | 0.0656 ** | [0.0213, 0.1068] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0056 |  0.782 | 0.5732 | [-0.0109, 0.0205] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0020 |  0.245 | 0.8666 | [-0.0181, 0.0213] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0016 |  0.215 | 0.8928 | [-0.0153, 0.0185] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0330 |  4.082 | 0.0009 ** | [0.0170, 0.0499] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0059 | -1.052 | 0.2872 | [-0.0158, 0.0033] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0034 | -0.766 | 0.4376 | [-0.0106, 0.0039] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0009 |  0.230 | 0.8247 | [-0.0057, 0.0070] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0100 |  1.837 | 0.0905 ** | [0.0004, 0.0209] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.387 | 0.7241 | [-0.0160, 0.0093] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0044 | -0.837 | 0.4332 | [-0.0143, 0.0049] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0033 | -0.694 | 0.5219 | [-0.0133, 0.0051] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0150 |  2.831 | 0.0230 ** | [0.0051, 0.0243] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0064 | -1.199 | 0.3044 | [-0.0157, 0.0053] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0063 | -1.133 | 0.3387 | [-0.0173, 0.0047] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0097 |  2.224 | 0.1061 | [-0.0004, 0.0188] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0080 |  1.584 | 0.2343 | [-0.0025, 0.0185] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0008 |  0.117 | 0.9234 | [-0.0130, 0.0162] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0031 |  0.438 | 0.7293 | [-0.0110, 0.0188] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.004 | 0.9979 | [-0.0111, 0.0136] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0134 |  2.131 | 0.1157 | [-0.0004, 0.0266] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0034 |  0.433 | 0.7401 | [-0.0146, 0.0188] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0028 | -0.554 | 0.6675 | [-0.0133, 0.0078] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.149 | 0.9123 | [-0.0109, 0.0131] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0304 |  6.715 | 0.0000 ** | [0.0214, 0.0408] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0029 | -0.414 | 0.7310 | [-0.0170, 0.0103] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0001 |  0.022 | 0.9825 | [-0.0120, 0.0116] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.307 | 0.8132 | [-0.0075, 0.0082] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0023 |  0.499 | 0.6409 | [-0.0074, 0.0104] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0092 | -1.757 | 0.1886 | [-0.0136, 0.0298] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0101 | -1.264 | 0.6356 | [-0.0180, 0.0101] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0126 | -3.927 | 0.1089 | [-0.0168, 0.0109] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0265 | 16.035 | 0.0325 ** | [0.0232, 0.0406] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0102 | -1.423 | 0.2124 | [-0.0252, 0.0040] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0098 | -1.870 | 0.1239 | [-0.0208, 0.0011] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0032 |  0.619 | 0.5877 | [-0.0071, 0.0136] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0153 |  2.504 | 0.0538 ** | [0.0019, 0.0267] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0055 | -0.785 | 0.4686 | [-0.0202, 0.0076] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0080 | -1.475 | 0.1704 | [-0.0182, 0.0015] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0031 | -0.611 | 0.5815 | [-0.0136, 0.0064] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0155 |  2.775 | 0.0282 ** | [0.0044, 0.0253] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0024 |  0.305 | 0.8380 | [-0.0146, 0.0125] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0141 |  6.813 | 0.0010 ** | [0.0109, 0.0179] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0151 |  6.149 | 0.0051 ** | [0.0105, 0.0202] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0023 | -0.555 | 0.6049 | [-0.0100, 0.0077] | 50 |

# ao_at (Other Assets / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0022 | -0.196 | 0.7489 | [-0.0585, 0.0432] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  0.203 | 0.8416 | [-0.0371, 0.0339] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0014 |  0.324 | 0.7027 | [-0.0099, 0.0129] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0128 |  2.338 | 0.0955 ** | [0.0037, 0.0281] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0003 | -0.031 | 0.9686 | [-0.0293, 0.0210] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0048 |  0.652 | 0.5577 | [-0.0202, 0.0193] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0044 |  1.613 | 0.4079 | [-0.0046, 0.0099] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0088 |  4.127 | 0.0236 ** | [0.0060, 0.0151] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0044 | -0.940 | 0.5363 | [-0.0143, 0.0054] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0030 | -1.249 | 0.3037 | [-0.0079, 0.0021] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0009 | -0.267 | 0.8167 | [-0.0073, 0.0070] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0055 |  2.212 | 0.0604 ** | [0.0008, 0.0101] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0183 |  2.404 | 0.0857 ** | [0.0029, 0.0514] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0023 |  0.770 | 0.4675 | [-0.0045, 0.0158] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.715 | 0.5338 | [-0.0070, 0.0083] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0035 | -0.751 | 0.7774 | [-0.0216, 0.0116] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0137 |  2.422 | 0.0403 ** | [0.0019, 0.0268] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0011 | -0.698 | 0.5016 | [-0.0037, 0.0022] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.491 | 0.5367 | [-0.0127, 0.0219] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0013 | -0.424 | 0.7053 | [-0.0090, 0.0049] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0011 | -0.200 | 0.8681 | [-0.0115, 0.0099] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0000 | -0.008 | 0.9946 | [-0.0055, 0.0064] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.156 | 0.8883 | [-0.0060, 0.0100] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0065 |  2.409 | 0.0419 ** | [0.0014, 0.0115] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0029 | -0.710 | 0.5295 | [-0.0106, 0.0052] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0037 | -1.236 | 0.2918 | [-0.0104, 0.0023] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0010 | -0.258 | 0.8257 | [-0.0088, 0.0077] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0080 |  2.326 | 0.0579 ** | [0.0012, 0.0149] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0073 |  2.291 | 0.0790 ** | [0.0003, 0.0146] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0003 |  0.220 | 0.8423 | [-0.0025, 0.0036] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0036 |  1.089 | 0.4544 | [-0.0044, 0.0112] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0051 |  2.192 | 0.0900 ** | [0.0002, 0.0099] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0108 |  2.410 | 0.0316 ** | [0.0019, 0.0207] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0019 |  0.793 | 0.4583 | [-0.0023, 0.0070] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.637 | 0.5261 | [-0.0084, 0.0170] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0050 |  1.632 | 0.2008 | [-0.0017, 0.0110] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0015 |  0.264 | 0.8421 | [-0.0103, 0.0121] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0001 |  0.016 | 0.9921 | [-0.0072, 0.0069] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0129 |  5.678 | 0.0000 ** | [0.0077, 0.0189] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0044 |  0.932 | 0.4780 | [-0.0060, 0.0144] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0055 | -1.115 | 0.4137 | [-0.0163, 0.0053] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0041 | -1.699 | 0.1412 | [-0.0095, 0.0007] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0057 | -4.290 | 0.0039 ** | [-0.0082, -0.0032] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0059 |  2.264 | 0.0638 ** | [0.0007, 0.0126] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0313 |  2.970 | 0.1099 | [-0.0920, 0.1495] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0061 |  0.948 | 0.7134 | [-0.0549, 0.0681] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0264 |  5.325 | 0.1257 | [-0.0203, 0.0597] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0102 | -9.880 | 0.0593 ** | [-0.0163, -0.0085] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0044 |  1.246 | 0.2675 | [-0.0018, 0.0125] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.274 | 0.8228 | [-0.0036, 0.0065] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0031 |  1.046 | 0.3676 | [-0.0031, 0.0101] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  1.045 | 0.3983 | [-0.0031, 0.0093] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0033 | -0.824 | 0.4597 | [-0.0109, 0.0051] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0043 | -1.503 | 0.2295 | [-0.0106, 0.0020] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.225 | 0.8393 | [-0.0085, 0.0077] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0077 |  2.182 | 0.0820 ** | [0.0003, 0.0151] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  0.588 | 0.7171 | [-0.0041, 0.0147] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0027 |  0.719 | 0.6022 | [-0.0031, 0.0122] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.127 | 0.9310 | [-0.0043, 0.0085] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.100 | 0.9222 | [-0.0043, 0.0038] | 50 |

# ch_at (Cash / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0124 |  1.760 | 0.0672 ** | [0.0037, 0.0332] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  0.822 | 0.5068 | [-0.0091, 0.0063] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0042 |  2.433 | 0.2396 | [-0.0026, 0.0093] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0105 | -1.101 | 0.6017 | [-0.0231, 0.0170] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0067 |  0.568 | 0.5737 | [-0.0124, 0.0480] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0020 | -0.487 | 0.6796 | [-0.0165, 0.0069] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0017 |  0.898 | 0.5589 | [-0.0051, 0.0054] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0092 | -1.158 | 0.5217 | [-0.0193, 0.0225] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0018 | -0.431 | 0.6863 | [-0.0086, 0.0064] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -0.357 | 0.7564 | [-0.0081, 0.0054] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.005 | 0.9966 | [-0.0054, 0.0048] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0156 | -3.399 | 0.0016 ** | [-0.0246, -0.0075] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0106 |  0.784 | 0.6151 | [-0.0162, 0.0756] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0106 |  1.199 | 0.5314 | [-0.0151, 0.0508] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.145 | 0.8798 | [-0.0155, 0.0192] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0272 | -11.800 | 0.0282 ** | [-0.0310, -0.0120] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0050 |  0.366 | 0.7570 | [-0.0249, 0.0340] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0082 |  0.817 | 0.5555 | [-0.0156, 0.0301] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0024 | -0.688 | 0.5660 | [-0.0079, 0.0049] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0218 | -3.987 | 0.0070 ** | [-0.0327, -0.0110] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.649 | 0.5566 | [-0.0094, 0.0054] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0025 | -0.706 | 0.5394 | [-0.0089, 0.0038] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0003 | -0.107 | 0.9304 | [-0.0057, 0.0044] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0113 | -2.821 | 0.0116 ** | [-0.0201, -0.0038] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0009 |  0.226 | 0.8451 | [-0.0064, 0.0092] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0006 |  0.214 | 0.8704 | [-0.0045, 0.0064] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0015 |  0.636 | 0.6495 | [-0.0026, 0.0059] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0173 | -3.606 | 0.0035 ** | [-0.0262, -0.0078] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0207 |  3.886 | 0.0079 ** | [0.0090, 0.0318] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0232 |  4.449 | 0.0006 ** | [0.0106, 0.0335] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0180 | -4.686 | 0.0004 ** | [-0.0260, -0.0108] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0117 | -3.007 | 0.0028 ** | [-0.0202, -0.0044] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0006 |  0.078 | 0.9519 | [-0.0141, 0.0160] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  0.386 | 0.8538 | [-0.0089, 0.0151] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0029 | -1.609 | 0.2380 | [-0.0067, 0.0013] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0215 | -3.754 | 0.0030 ** | [-0.0328, -0.0102] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0189 | -1.972 | 0.1201 | [-0.0412, 0.0007] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0140 | -1.286 | 0.4931 | [-0.0411, 0.0056] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0068 | -0.679 | 0.6918 | [-0.0328, 0.0152] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0244 | -4.272 | 0.0001 ** | [-0.0376, -0.0112] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0010 |  0.204 | 0.8680 | [-0.0074, 0.0129] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.327 | 0.7986 | [-0.0050, 0.0096] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0007 |  0.443 | 0.7409 | [-0.0027, 0.0044] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0127 | -2.705 | 0.0315 ** | [-0.0220, -0.0029] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0064 |  0.292 | 0.7661 | [-0.0920, 0.1997] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0078 |  0.574 | 0.6788 | [-0.0493, 0.1055] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0027 | -4.987 | 0.0219 ** | [-0.0050, -0.0013] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0052 | -1.581 | 0.3133 | [-0.0150, 0.0224] | 7 |

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  1.791 | 0.0064 ** | [0.0081, 0.0647] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.184 | 0.1114 | [-0.0002, 0.0651] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.756 | 0.7906 | [-0.0070, 0.0424] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.961 | 0.4778 | [-0.0046, 0.0429] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.194 | 0.8706 | [-0.0137, 0.0121] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.561 | 0.6320 | [-0.0104, 0.0219] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.186 | 0.8609 | [-0.0236, 0.0207] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.961 | 0.4817 | [-0.0046, 0.0432] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.194 | 0.8611 | [-0.0137, 0.0121] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.561 | 0.6245 | [-0.0104, 0.0219] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.186 | 0.8569 | [-0.0234, 0.0205] | 50 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0106 |  1.053 | 0.3382 | [-0.0101, 0.0269] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0099 |  0.900 | 0.4238 | [-0.0140, 0.0266] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0111 | -1.490 | 0.1184 | [-0.0266, 0.0004] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0104 | -2.446 | 0.0250 ** | [-0.0189, -0.0029] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0072 |  1.742 | 0.1077 | [-0.0001, 0.0158] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0074 |  2.355 | 0.0239 ** | [0.0019, 0.0139] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.132 | 0.9288 | [-0.0042, 0.0049] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0146 | -3.424 | 0.0063 ** | [-0.0230, -0.0062] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0208 | -1.380 | 0.0058 ** | [-0.0580, -0.0044] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0152 | -0.804 | 0.8664 | [-0.0618, 0.0060] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0103 | -0.745 | 0.9753 | [-0.0452, 0.0057] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0181 | -2.543 | 0.0156 ** | [-0.0362, -0.0056] | 50 |

# intan_at (Intangibles / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0034 | -0.814 | 0.4887 | [-0.0102, 0.0252] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0048 | -1.080 | 0.6573 | [-0.0114, 0.0237] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0110 | -1.824 | 0.3486 | [-0.0209, 0.0190] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0035 |  3.392 | 0.2504 | [-0.0030, 0.0055] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.266 | 0.7956 | [-0.0094, 0.0176] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0051 | -1.227 | 0.6437 | [-0.0118, 0.0082] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0123 | -2.111 | 0.4125 | [-0.0213, 0.0041] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0047 |  2.973 | 0.0553 ** | [0.0010, 0.0090] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0009 |  0.188 | 0.8706 | [-0.0096, 0.0104] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.393 | 0.7248 | [-0.0046, 0.0063] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0018 | -0.694 | 0.5667 | [-0.0071, 0.0034] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0014 | -0.604 | 0.5854 | [-0.0059, 0.0027] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0108 | -1.294 | 0.4477 | [-0.0436, 0.0282] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -0.461 | 0.6733 | [-0.0090, 0.0285] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0038 | -0.845 | 0.5793 | [-0.0174, 0.0219] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0140 | -0.985 | 0.1542 | [-0.1044, 0.0007] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0062 | -0.505 | 0.8515 | [-0.0348, 0.0188] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0028 |  0.411 | 0.7237 | [-0.0106, 0.0168] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0032 |  0.475 | 0.7380 | [-0.0102, 0.0182] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0153 | -1.741 | 0.0269 ** | [-0.0308, -0.0027] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.602 | 0.5938 | [-0.0110, 0.0054] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0009 | -0.315 | 0.7741 | [-0.0066, 0.0043] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0032 | -1.373 | 0.2528 | [-0.0081, 0.0014] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.080 | 0.9385 | [-0.0041, 0.0037] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0047 | -0.876 | 0.4533 | [-0.0153, 0.0059] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -0.425 | 0.7067 | [-0.0079, 0.0047] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0031 | -1.009 | 0.4106 | [-0.0093, 0.0034] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0040 | -1.482 | 0.1685 | [-0.0094, 0.0008] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0060 | -0.985 | 0.6140 | [-0.0207, 0.0074] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0030 | -1.141 | 0.4128 | [-0.0087, 0.0025] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.887 | 0.6940 | [-0.0064, 0.0025] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0012 | -0.871 | 0.5487 | [-0.0041, 0.0019] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0077 | -0.943 | 0.6688 | [-0.0275, 0.0076] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0042 | -0.981 | 0.4446 | [-0.0136, 0.0047] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0032 | -0.835 | 0.5403 | [-0.0113, 0.0053] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0037 | -1.594 | 0.2209 | [-0.0081, 0.0012] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0026 |  0.322 | 0.8791 | [-0.0134, 0.0221] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0009 |  0.206 | 0.9175 | [-0.0088, 0.0116] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0041 | -1.140 | 0.4551 | [-0.0120, 0.0050] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0105 | -2.534 | 0.0425 ** | [-0.0192, -0.0014] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.200 | 0.8684 | [-0.0114, 0.0124] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  0.799 | 0.5048 | [-0.0036, 0.0072] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0003 | -0.117 | 0.9240 | [-0.0059, 0.0045] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.089 | 0.9405 | [-0.0044, 0.0048] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0023 |  0.526 | 0.6657 | [-0.0030, 0.0114] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.648 | 0.8133 | [-0.0186, 0.0173] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0040 |  3.646 | 0.1055 | [-0.0080, 0.0148] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  2.850 | 0.3228 | [-0.0047, 0.0044] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0060 | -0.911 | 0.4422 | [-0.0189, 0.0070] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0020 | -0.524 | 0.6393 | [-0.0085, 0.0054] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0043 | -1.981 | 0.1258 | [-0.0086, 0.0005] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0047 | -1.718 | 0.1019 | [-0.0103, 0.0001] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0054 | -0.979 | 0.4168 | [-0.0165, 0.0056] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0018 | -0.565 | 0.6045 | [-0.0082, 0.0042] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0032 | -1.105 | 0.3792 | [-0.0090, 0.0029] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0045 | -1.665 | 0.1102 | [-0.0098, 0.0003] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0110 |  1.139 | 0.4190 | [-0.0051, 0.0348] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0053 |  0.974 | 0.4551 | [-0.0025, 0.0184] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.472 | 0.7383 | [-0.0037, 0.0032] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0078 |  4.112 | 0.0227 ** | [0.0034, 0.0110] | 50 |

# invt_at (Inventories / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0138 | -1.842 | 0.2322 | [-0.0511, 0.0200] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0097 | -1.681 | 0.2829 | [-0.0409, 0.0179] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0072 | -2.133 | 0.2486 | [-0.0256, 0.0085] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0034 | -1.935 | 0.0542 ** | [-0.0087, -0.0011] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0143 | -1.971 | 0.2446 | [-0.0332, 0.0086] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0105 | -2.000 | 0.2371 | [-0.0239, 0.0060] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0081 | -3.211 | 0.0669 ** | [-0.0140, -0.0006] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0045 | -1.999 | 0.0292 ** | [-0.0112, -0.0008] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0035 | -1.271 | 0.2901 | [-0.0090, 0.0017] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0029 | -1.179 | 0.3105 | [-0.0078, 0.0017] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -1.157 | 0.3521 | [-0.0049, 0.0014] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.444 | 0.7221 | [-0.0028, 0.0046] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0007 | -0.395 | 0.7598 | [-0.0087, 0.0085] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0053 | -2.717 | 0.1938 | [-0.0125, 0.0077] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0035 | -4.325 | 0.1815 | [-0.0059, 0.0021] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0086 |  1.064 | 0.2900 | [-0.0142, 0.0541] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0015 |  0.609 | 0.6179 | [-0.0038, 0.0069] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0043 | -3.412 | 0.0142 ** | [-0.0071, -0.0018] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0018 | -1.681 | 0.1554 | [-0.0038, 0.0004] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0077 |  1.122 | 0.3035 | [-0.0052, 0.0245] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0032 | -1.844 | 0.0713 ** | [-0.0062, -0.0003] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0028 | -1.365 | 0.1916 | [-0.0067, 0.0008] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0015 | -0.936 | 0.4377 | [-0.0047, 0.0019] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0005 |  0.245 | 0.8337 | [-0.0038, 0.0051] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0035 | -1.673 | 0.0916 ** | [-0.0070, -0.0000] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0041 | -1.721 | 0.1229 | [-0.0091, 0.0004] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0011 | -0.627 | 0.5837 | [-0.0050, 0.0024] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0023 |  1.047 | 0.3396 | [-0.0021, 0.0063] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0118 | -3.035 | 0.0207 ** | [-0.0199, -0.0028] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0137 | -5.197 | 0.0000 ** | [-0.0190, -0.0076] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0057 | -3.045 | 0.0089 ** | [-0.0102, -0.0018] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0046 | -2.369 | 0.0758 ** | [-0.0084, -0.0003] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0049 | -1.018 | 0.5046 | [-0.0162, 0.0042] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0091 | -2.736 | 0.0068 ** | [-0.0171, -0.0032] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0039 | -1.477 | 0.2334 | [-0.0099, 0.0007] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0008 | -0.230 | 0.8425 | [-0.0078, 0.0078] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0038 | -1.768 | 0.1508 | [-0.0081, 0.0005] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.124 | 0.9292 | [-0.0101, 0.0109] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0033 | -1.621 | 0.2299 | [-0.0071, 0.0012] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0025 |  0.956 | 0.4373 | [-0.0024, 0.0084] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0032 | -0.927 | 0.4790 | [-0.0104, 0.0029] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0032 | -1.189 | 0.3194 | [-0.0091, 0.0018] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0010 | -0.551 | 0.6464 | [-0.0053, 0.0028] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.286 | 0.8757 | [-0.0049, 0.0061] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0010 | -0.089 | 0.8889 | [-0.0216, 0.1224] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0020 | -0.920 | 0.8592 | [-0.0053, 0.0253] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0018 |  3.874 | 0.0313 ** | [0.0010, 0.0026] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0089 | 14.319 | 0.0503 ** | [0.0060, 0.0109] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0074 | -2.879 | 0.0221 ** | [-0.0122, -0.0026] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0050 | -1.256 | 0.2577 | [-0.0124, 0.0029] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0020 | -1.195 | 0.3183 | [-0.0056, 0.0015] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0009 | -0.497 | 0.6545 | [-0.0047, 0.0026] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0046 | -2.014 | 0.0412 ** | [-0.0086, -0.0008] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0052 | -2.022 | 0.0785 ** | [-0.0108, -0.0004] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0012 | -0.675 | 0.5610 | [-0.0052, 0.0024] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0022 |  0.994 | 0.3707 | [-0.0019, 0.0060] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0082 | -2.501 | 0.0282 ** | [-0.0159, -0.0024] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  0.198 | 0.8560 | [-0.0109, 0.0183] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0047 | -3.115 | 0.0432 ** | [-0.0078, -0.0014] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0038 | -3.171 | 0.0073 ** | [-0.0067, -0.0017] | 50 |

# ivaeq_at (Equity Investments / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0007 |  0.934 | 0.3099 | [-0.0007, 0.0020] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0027 | -2.474 | 0.1805 | [-0.0057, 0.0042] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.133 | 0.8308 | [-0.0025, 0.0019] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0042 |  1.175 | 0.5625 | [-0.0029, 0.0090] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0017 |  1.984 | 0.0676 ** | [0.0003, 0.0037] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0027 | -2.078 | 0.2759 | [-0.0051, 0.0005] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0009 |  0.735 | 0.5945 | [-0.0027, 0.0025] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0030 |  0.804 | 0.5699 | [-0.0074, 0.0085] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0039 |  2.368 | 0.0179 ** | [0.0010, 0.0074] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  1.040 | 0.4239 | [-0.0011, 0.0044] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0001 |  0.096 | 0.9398 | [-0.0024, 0.0027] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0027 |  1.083 | 0.3422 | [-0.0014, 0.0083] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0059 |  9.515 | 0.0260 ** | [0.0032, 0.0099] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0045 |  2.852 | 0.3109 | [-0.0054, 0.0086] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.069 | 0.9404 | [-0.0070, 0.0017] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0022 |  2.198 | 0.5699 | [-0.0045, 0.0043] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0085 |  2.903 | 0.0083 ** | [0.0033, 0.0154] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0067 |  1.976 | 0.0514 ** | [0.0007, 0.0142] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.935 | 0.5252 | [-0.0034, 0.0111] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0063 |  1.201 | 0.4104 | [-0.0047, 0.0196] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0032 |  2.394 | 0.0245 ** | [0.0007, 0.0065] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0013 |  1.069 | 0.4457 | [-0.0007, 0.0043] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0007 | -0.706 | 0.5398 | [-0.0029, 0.0014] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0034 |  1.305 | 0.2339 | [-0.0009, 0.0099] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0044 |  2.788 | 0.0166 ** | [0.0014, 0.0074] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  1.526 | 0.1962 | [-0.0005, 0.0052] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0012 |  0.974 | 0.4101 | [-0.0013, 0.0038] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.110 | 0.3833 | [-0.0016, 0.0085] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0066 |  3.363 | 0.0021 ** | [0.0034, 0.0106] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0036 |  2.484 | 0.0284 ** | [0.0009, 0.0065] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0016 |  1.074 | 0.4222 | [-0.0012, 0.0045] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  1.267 | 0.4433 | [-0.0026, 0.0088] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0113 |  5.197 | 0.0008 ** | [0.0070, 0.0163] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0077 |  3.111 | 0.0060 ** | [0.0031, 0.0130] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0039 |  1.379 | 0.2608 | [-0.0014, 0.0096] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0049 |  1.196 | 0.4277 | [-0.0037, 0.0153] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0065 |  3.159 | 0.0032 ** | [0.0028, 0.0108] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0019 |  0.870 | 0.5587 | [-0.0022, 0.0066] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.417 | 0.8311 | [-0.0029, 0.0048] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0156 |  4.541 | 0.0000 ** | [0.0082, 0.0248] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0035 |  1.832 | 0.1868 | [-0.0005, 0.0077] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  1.235 | 0.4851 | [-0.0011, 0.0052] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0001 |  0.136 | 0.9263 | [-0.0016, 0.0024] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0006 | -0.536 | 0.6954 | [-0.0026, 0.0013] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0063 |  1.387 | 0.5797 | [-0.0437, 0.0150] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  0.908 | 0.7998 | [-0.0280, 0.0080] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0020 | -2.260 | 0.1498 | [-0.0056, 0.0070] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0227 |  3.775 | 0.2386 | [-0.0034, 0.0347] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0041 |  3.280 | 0.0003 ** | [0.0016, 0.0065] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  1.601 | 0.1788 | [-0.0003, 0.0031] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  1.482 | 0.2256 | [-0.0005, 0.0031] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0043 |  1.442 | 0.1747 | [-0.0010, 0.0107] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0039 |  2.505 | 0.0326 ** | [0.0010, 0.0067] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0017 |  1.382 | 0.2510 | [-0.0006, 0.0045] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0011 |  0.976 | 0.4135 | [-0.0012, 0.0036] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.163 | 0.3536 | [-0.0017, 0.0081] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0003 |  0.089 | 0.9643 | [-0.0053, 0.0071] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -1.341 | 0.1424 | [-0.0040, 0.0002] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0019 | -2.680 | 0.0202 ** | [-0.0036, -0.0006] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0056 |  1.163 | 0.2301 | [-0.0013, 0.0164] | 50 |

# ivao_at (Other Investments / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0141 |  1.838 | 0.2548 | [-0.0021, 0.0467] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0240 |  6.095 | 0.0322 ** | [0.0161, 0.0403] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0111 |  1.274 | 0.1532 | [-0.0004, 0.0303] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0106 |  2.323 | 0.0936 ** | [0.0001, 0.0328] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0175 |  2.683 | 0.0710 ** | [0.0010, 0.0340] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0289 |  4.271 | 0.0165 ** | [0.0181, 0.0483] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0121 |  1.026 | 0.3518 | [-0.0045, 0.0473] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0140 |  3.210 | 0.0093 ** | [0.0042, 0.0280] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0000 |  0.010 | 0.9928 | [-0.0070, 0.0075] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0020 |  0.700 | 0.5232 | [-0.0030, 0.0074] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.202 | 0.8490 | [-0.0043, 0.0054] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0019 |  0.655 | 0.5555 | [-0.0036, 0.0071] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0253 | -1.874 | 0.2662 | [-0.0863, 0.0140] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0181 | -1.894 | 0.2128 | [-0.0607, 0.0145] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0136 | -1.546 | 0.5981 | [-0.0521, 0.0154] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0097 |  1.875 | 0.3681 | [-0.0061, 0.0291] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0148 | -1.398 | 0.4634 | [-0.0390, 0.0100] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0124 | -1.526 | 0.4026 | [-0.0313, 0.0073] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0134 | -1.524 | 0.4096 | [-0.0327, 0.0079] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.016 | 0.9891 | [-0.0161, 0.0103] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0021 |  0.501 | 0.6370 | [-0.0053, 0.0096] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0033 |  1.072 | 0.3223 | [-0.0021, 0.0091] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0011 |  0.356 | 0.7355 | [-0.0042, 0.0063] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0003 |  0.108 | 0.9217 | [-0.0050, 0.0056] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0001 | -0.018 | 0.9862 | [-0.0109, 0.0106] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0030 |  0.732 | 0.5114 | [-0.0047, 0.0108] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.125 | 0.9151 | [-0.0066, 0.0071] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0037 |  1.109 | 0.3152 | [-0.0025, 0.0096] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0060 | -0.941 | 0.5235 | [-0.0194, 0.0088] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0042 | -0.795 | 0.5619 | [-0.0147, 0.0080] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0067 | -1.576 | 0.4279 | [-0.0169, 0.0036] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0066 |  1.494 | 0.2186 | [-0.0021, 0.0154] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0037 | -0.447 | 0.8346 | [-0.0207, 0.0143] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0040 | -0.639 | 0.7304 | [-0.0173, 0.0092] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0073 | -1.176 | 0.5382 | [-0.0217, 0.0064] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0057 |  1.103 | 0.3589 | [-0.0057, 0.0153] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0040 |  0.602 | 0.7397 | [-0.0136, 0.0180] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0087 |  2.937 | 0.0018 ** | [0.0032, 0.0156] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0024 |  1.814 | 0.1037 | [-0.0001, 0.0050] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0050 | -0.898 | 0.6075 | [-0.0198, 0.0085] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0023 | -0.631 | 0.6680 | [-0.0090, 0.0040] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0001 | -0.028 | 0.9691 | [-0.0062, 0.0064] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.010 | 0.9907 | [-0.0064, 0.0072] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0034 |  1.833 | 0.0607 ** | [0.0003, 0.0082] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0234 | 13.585 | 0.0310 ** | [0.0183, 0.0269] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0147 |  2.200 | 0.0700 ** | [0.0037, 0.0433] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0158 |  3.983 | 0.0485 ** | [0.0082, 0.0327] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0201 | -3.320 | 0.3058 | [-0.0331, 0.0073] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.431 | 0.7388 | [-0.0167, 0.0108] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0025 |  0.582 | 0.6475 | [-0.0069, 0.0114] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0019 |  0.400 | 0.7422 | [-0.0079, 0.0117] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0035 |  0.777 | 0.4965 | [-0.0044, 0.0128] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0009 | -0.139 | 0.8953 | [-0.0131, 0.0114] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0028 |  0.629 | 0.5704 | [-0.0060, 0.0115] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.089 | 0.9489 | [-0.0071, 0.0074] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0032 |  0.981 | 0.3876 | [-0.0033, 0.0091] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0009 | -0.157 | 0.8958 | [-0.0102, 0.0140] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  0.467 | 0.7180 | [-0.0040, 0.0105] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0037 |  0.711 | 0.6696 | [-0.0031, 0.0150] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0020 |  0.302 | 0.9317 | [-0.0059, 0.0171] | 50 |

# ppent_at (Net PP&E / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0038 | -0.370 | 0.6529 | [-0.0309, 0.0210] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0023 |  0.339 | 0.7762 | [-0.0090, 0.0182] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0028 |  0.726 | 0.5859 | [-0.0112, 0.0115] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0337 | -2.545 | 0.1004 | [-0.0527, 0.0002] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0064 | -0.777 | 0.5458 | [-0.0177, 0.0214] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.128 | 0.8903 | [-0.0075, 0.0172] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0018 |  0.626 | 0.5718 | [-0.0044, 0.0086] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0334 | -2.331 | 0.2627 | [-0.0570, 0.0069] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0023 | -0.451 | 0.6692 | [-0.0113, 0.0072] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0013 | -0.400 | 0.7175 | [-0.0073, 0.0053] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0040 | -0.888 | 0.4273 | [-0.0124, 0.0044] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -0.490 | 0.6648 | [-0.0136, 0.0080] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0163 |  0.864 | 0.5596 | [-0.0922, 0.0697] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0157 |  1.491 | 0.4217 | [-0.0528, 0.0423] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0151 |  0.903 | 0.4976 | [-0.0764, 0.0686] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.021 | 0.9884 | [-0.0292, 0.0209] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0045 |  0.258 | 0.8406 | [-0.0358, 0.0364] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0067 |  0.621 | 0.6369 | [-0.0199, 0.0263] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0055 |  0.337 | 0.8067 | [-0.0359, 0.0371] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0042 |  0.578 | 0.5832 | [-0.0101, 0.0200] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  0.591 | 0.5861 | [-0.0063, 0.0116] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0014 |  0.511 | 0.6290 | [-0.0034, 0.0065] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0024 | -0.571 | 0.6046 | [-0.0105, 0.0051] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0096 | -1.678 | 0.1309 | [-0.0197, 0.0011] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0036 |  0.577 | 0.6031 | [-0.0074, 0.0145] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0042 |  1.064 | 0.3294 | [-0.0032, 0.0115] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0009 |  0.164 | 0.8845 | [-0.0096, 0.0109] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0087 | -1.154 | 0.2964 | [-0.0221, 0.0054] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0033 | -0.401 | 0.7432 | [-0.0215, 0.0158] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0017 | -0.298 | 0.7936 | [-0.0144, 0.0110] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0142 |  2.261 | 0.1693 | [-0.0017, 0.0280] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0062 | -1.087 | 0.5186 | [-0.0193, 0.0063] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0042 |  0.434 | 0.8039 | [-0.0173, 0.0236] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0049 |  0.779 | 0.5406 | [-0.0089, 0.0180] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0090 |  0.927 | 0.5469 | [-0.0132, 0.0292] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0001 |  0.010 | 0.9933 | [-0.0203, 0.0185] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0085 | -1.358 | 0.3046 | [-0.0237, 0.0046] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0004 |  0.072 | 0.9478 | [-0.0100, 0.0101] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0175 | -3.085 | 0.0414 ** | [-0.0319, -0.0031] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0031 | -0.237 | 0.8681 | [-0.0325, 0.0261] | 50 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0012 |  0.213 | 0.8527 | [-0.0085, 0.0126] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -0.363 | 0.7397 | [-0.0083, 0.0064] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.045 | 0.9731 | [-0.0073, 0.0103] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0016 | -0.358 | 0.7197 | [-0.0099, 0.0058] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0318 | -3.019 | 0.1060 | [-0.0679, 0.0474] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0125 | -0.860 | 0.6988 | [-0.1163, 0.0531] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0300 | -55.544 | 0.0076 ** | [-0.0305, -0.0280] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -0.516 | 0.5986 | [-0.0364, 0.0138] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0025 | -0.329 | 0.7919 | [-0.0184, 0.0117] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.122 | 0.9110 | [-0.0112, 0.0114] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0030 |  0.550 | 0.7174 | [-0.0085, 0.0158] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0073 | -1.155 | 0.3307 | [-0.0191, 0.0052] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0028 |  0.432 | 0.7108 | [-0.0094, 0.0143] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0031 |  0.752 | 0.5024 | [-0.0047, 0.0110] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0020 |  0.343 | 0.7882 | [-0.0089, 0.0122] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0103 | -1.355 | 0.2528 | [-0.0237, 0.0048] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0089 | -1.064 | 0.3290 | [-0.0264, 0.0086] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0055 | -0.855 | 0.4419 | [-0.0183, 0.0087] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0089 | -3.078 | 0.0232 ** | [-0.0150, -0.0032] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0040 |  0.887 | 0.4317 | [-0.0055, 0.0125] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
