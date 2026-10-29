# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# ch_at (Cash / Assets)

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.116 | 0.0106 ** | [0.0076, 0.0521] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.104 | 0.2424 | [-0.0017, 0.0506] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.290 | 0.9084 | [-0.0099, 0.0328] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.819 | 0.5960 | [-0.0056, 0.0395] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.464 | 0.6895 | [-0.0155, 0.0103] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.467 | 0.6772 | [-0.0090, 0.0208] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.253 | 0.8198 | [-0.0173, 0.0196] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.819 | 0.5947 | [-0.0055, 0.0389] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.464 | 0.6960 | [-0.0155, 0.0103] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.467 | 0.6712 | [-0.0090, 0.0216] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.253 | 0.8241 | [-0.0173, 0.0196] | 50 |

# ivaeq_at (Equity Investments / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0013 |  1.121 | 0.2819 | [-0.0010, 0.0044] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0013 | -1.242 | 0.3632 | [-0.0038, 0.0011] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.357 | 0.7274 | [-0.0027, 0.0020] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0025 |  0.987 | 0.5729 | [-0.0083, 0.0099] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0045 |  6.801 | 0.0664 ** | [0.0008, 0.0058] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.196 | 0.8808 | [-0.0047, 0.0033] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0014 |  1.849 | 0.2901 | [-0.0036, 0.0031] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0030 |  1.075 | 0.5435 | [-0.0082, 0.0123] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  1.758 | 0.1214 | [-0.0002, 0.0069] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0010 |  0.796 | 0.5506 | [-0.0012, 0.0040] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.105 | 0.9247 | [-0.0024, 0.0023] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.196 | 0.2966 | [-0.0011, 0.0082] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0059 |  9.589 | 0.0254 ** | [0.0034, 0.0098] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0044 |  2.803 | 0.3123 | [-0.0055, 0.0085] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0002 | -0.157 | 0.8636 | [-0.0074, 0.0016] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0022 |  2.175 | 0.5742 | [-0.0045, 0.0042] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0085 |  2.901 | 0.0064 ** | [0.0033, 0.0153] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0067 |  1.972 | 0.0469 ** | [0.0007, 0.0142] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0034 |  0.933 | 0.5305 | [-0.0035, 0.0107] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0063 |  1.200 | 0.4208 | [-0.0047, 0.0195] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0020 |  1.293 | 0.3402 | [-0.0011, 0.0065] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.433 | 0.7797 | [-0.0017, 0.0033] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0009 | -1.057 | 0.4109 | [-0.0029, 0.0009] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  1.230 | 0.2629 | [-0.0011, 0.0096] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0048 |  3.264 | 0.0026 ** | [0.0022, 0.0077] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0024 |  1.595 | 0.1714 | [-0.0004, 0.0058] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0014 |  0.967 | 0.4339 | [-0.0013, 0.0042] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.067 | 0.3930 | [-0.0018, 0.0088] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0079 |  3.189 | 0.0018 ** | [0.0032, 0.0130] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0046 |  2.680 | 0.0171 ** | [0.0012, 0.0082] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0018 |  0.910 | 0.5121 | [-0.0021, 0.0056] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0032 |  1.064 | 0.4785 | [-0.0028, 0.0108] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0107 |  5.510 | 0.0002 ** | [0.0069, 0.0150] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0072 |  3.278 | 0.0037 ** | [0.0031, 0.0119] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0036 |  1.448 | 0.2167 | [-0.0011, 0.0083] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0049 |  1.225 | 0.4433 | [-0.0035, 0.0155] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0060 |  3.483 | 0.0035 ** | [0.0029, 0.0093] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.562 | 0.6865 | [-0.0025, 0.0052] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0005 | -0.241 | 0.8479 | [-0.0043, 0.0038] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0168 |  4.843 | 0.0000 ** | [0.0080, 0.0257] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.906 | 0.5090 | [-0.0009, 0.0045] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0013 | -1.493 | 0.3415 | [-0.0036, 0.0013] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.301 | 0.8041 | [-0.0020, 0.0021] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0038 |  1.467 | 0.2646 | [-0.0022, 0.0108] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0016 |  1.275 | 0.2739 | [-0.0016, 0.0042] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -2.290 | 0.1141 | [-0.0045, 0.0004] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.045 | 0.9724 | [-0.0038, 0.0025] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0066 |  2.025 | 0.2290 | [-0.0029, 0.0190] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0023 |  1.208 | 0.3605 | [-0.0017, 0.0073] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0013 |  1.046 | 0.5800 | [-0.0012, 0.0048] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.007 | 0.9954 | [-0.0013, 0.0021] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0005 | -0.626 | 0.5662 | [-0.0020, 0.0011] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0063 |  1.380 | 0.5793 | [-0.0442, 0.0148] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0025 |  0.901 | 0.7950 | [-0.0283, 0.0150] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0021 | -2.305 | 0.1512 | [-0.0056, 0.0069] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0227 |  3.770 | 0.2321 | [-0.0034, 0.0347] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0059 |  3.187 | 0.0021 ** | [0.0024, 0.0097] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0025 |  1.724 | 0.1788 | [-0.0004, 0.0057] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.947 | 0.4759 | [-0.0014, 0.0040] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0025 |  0.916 | 0.4092 | [-0.0023, 0.0083] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0048 |  3.115 | 0.0030 ** | [0.0021, 0.0079] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  1.557 | 0.1944 | [-0.0005, 0.0062] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0015 |  0.989 | 0.4192 | [-0.0013, 0.0043] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0026 |  0.982 | 0.4256 | [-0.0018, 0.0089] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0015 |  0.373 | 0.9406 | [-0.0084, 0.0136] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -1.369 | 0.2880 | [-0.0039, 0.0012] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0025 | -3.921 | 0.0101 ** | [-0.0041, -0.0009] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0027 |  0.872 | 0.4793 | [-0.0026, 0.0124] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
