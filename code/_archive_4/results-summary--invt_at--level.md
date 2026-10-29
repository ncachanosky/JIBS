# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# ch_at (Cash / Assets)

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.117 | 0.0098 ** | [0.0075, 0.0510] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.104 | 0.2408 | [-0.0017, 0.0521] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.290 | 0.9094 | [-0.0099, 0.0320] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.819 | 0.5886 | [-0.0055, 0.0399] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.465 | 0.6876 | [-0.0154, 0.0103] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.466 | 0.6801 | [-0.0090, 0.0208] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.252 | 0.8225 | [-0.0174, 0.0196] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.819 | 0.5918 | [-0.0054, 0.0391] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.465 | 0.6954 | [-0.0154, 0.0103] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.466 | 0.6876 | [-0.0097, 0.0208] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.252 | 0.8127 | [-0.0164, 0.0187] | 50 |

# invt_at (Inventories / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0048 | -1.181 | 0.4617 | [-0.0193, 0.0065] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0024 | -0.728 | 0.5610 | [-0.0175, 0.0060] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0028 | -1.026 | 0.3589 | [-0.0147, 0.0081] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0013 | -0.631 | 0.5526 | [-0.0132, 0.0022] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0052 | -1.021 | 0.4722 | [-0.0270, 0.0058] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0037 | -1.029 | 0.3898 | [-0.0191, 0.0030] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0037 | -1.294 | 0.2715 | [-0.0158, 0.0029] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0036 | -1.586 | 0.0918 ** | [-0.0199, 0.0002] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0029 | -1.093 | 0.3363 | [-0.0083, 0.0020] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0024 | -1.073 | 0.3182 | [-0.0073, 0.0015] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -1.568 | 0.2377 | [-0.0054, 0.0009] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.457 | 0.7163 | [-0.0024, 0.0044] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0009 | -0.473 | 0.7197 | [-0.0089, 0.0083] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0055 | -2.824 | 0.1996 | [-0.0120, 0.0081] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0036 | -4.450 | 0.1804 | [-0.0061, 0.0020] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0085 |  1.056 | 0.2937 | [-0.0144, 0.0548] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0015 |  0.588 | 0.6334 | [-0.0035, 0.0068] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0044 | -3.466 | 0.0129 ** | [-0.0072, -0.0019] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0018 | -1.740 | 0.1431 | [-0.0039, 0.0003] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0077 |  1.119 | 0.3128 | [-0.0052, 0.0245] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0021 | -0.813 | 0.4745 | [-0.0076, 0.0033] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0022 | -1.077 | 0.2955 | [-0.0071, 0.0012] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0025 | -1.711 | 0.2058 | [-0.0057, 0.0007] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0011 |  0.616 | 0.6137 | [-0.0024, 0.0049] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0029 | -1.382 | 0.1643 | [-0.0064, 0.0006] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0035 | -1.506 | 0.1896 | [-0.0085, 0.0009] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.450 | 0.6874 | [-0.0047, 0.0027] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0019 |  0.807 | 0.4823 | [-0.0025, 0.0060] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0067 | -1.771 | 0.1688 | [-0.0139, 0.0008] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0083 | -3.321 | 0.0024 ** | [-0.0128, -0.0034] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0043 | -2.466 | 0.0247 ** | [-0.0077, -0.0008] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0007 | -0.251 | 0.8380 | [-0.0062, 0.0051] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0055 | -1.129 | 0.4514 | [-0.0158, 0.0036] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0097 | -2.880 | 0.0031 ** | [-0.0170, -0.0037] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0044 | -1.655 | 0.1407 | [-0.0102, 0.0003] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0010 | -0.315 | 0.7860 | [-0.0071, 0.0069] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0028 | -1.064 | 0.3870 | [-0.0081, 0.0027] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.082 | 0.9581 | [-0.0099, 0.0101] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0028 | -1.495 | 0.2624 | [-0.0066, 0.0011] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0024 |  1.079 | 0.3668 | [-0.0020, 0.0074] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0031 | -0.991 | 0.6169 | [-0.0105, 0.0062] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0012 |  0.381 | 0.7407 | [-0.0052, 0.0119] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0015 | -0.784 | 0.5218 | [-0.0068, 0.0043] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.411 | 0.6970 | [-0.0043, 0.0059] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0036 | -0.837 | 0.6803 | [-0.0117, 0.0064] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0038 |  0.943 | 0.5296 | [-0.0074, 0.0211] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0014 | -0.523 | 0.6899 | [-0.0069, 0.0105] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0000 |  0.001 | 0.9985 | [-0.0081, 0.0137] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.876 | 0.4319 | [-0.0091, 0.0026] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0026 | -1.141 | 0.2994 | [-0.0085, 0.0017] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.994 | 0.4501 | [-0.0060, 0.0023] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.372 | 0.8227 | [-0.0040, 0.0059] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0009 | -0.087 | 0.8958 | [-0.0216, 0.1044] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0020 | -0.922 | 0.8573 | [-0.0053, 0.0244] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0018 |  3.895 | 0.0306 ** | [0.0010, 0.0025] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0089 | 14.266 | 0.0527 ** | [0.0060, 0.0110] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0054 | -2.087 | 0.0659 ** | [-0.0102, -0.0006] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0044 | -1.636 | 0.1885 | [-0.0097, 0.0012] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0024 | -1.532 | 0.2227 | [-0.0060, 0.0009] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0005 |  0.222 | 0.8446 | [-0.0036, 0.0043] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0033 | -1.518 | 0.1388 | [-0.0068, 0.0003] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0037 | -1.620 | 0.1523 | [-0.0085, 0.0006] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.445 | 0.6992 | [-0.0045, 0.0026] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0019 |  0.817 | 0.4751 | [-0.0025, 0.0061] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0084 | -1.798 | 0.2998 | [-0.0212, 0.0030] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0019 | -0.300 | 0.8080 | [-0.0152, 0.0177] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0057 | -3.519 | 0.0188 ** | [-0.0100, -0.0014] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -2.753 | 0.0279 ** | [-0.0053, -0.0010] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
