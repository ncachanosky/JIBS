# Results summary: Level-Lag Ebalance (13 Jul 2026)

Outcome: ch_at (cash / total assets). Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect.

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0072 |  1.044 | 0.2062 | [-0.0013, 0.0528] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0015 |  1.258 | 0.3947 | [-0.0020, 0.0072] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0042 |  4.091 | 0.0791 ** | [0.0012, 0.0066] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0062 | -1.412 | 0.3547 | [-0.0158, 0.0159] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | 0.0043 |  0.514 | 0.6295 | [-0.0095, 0.0659] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | -0.0008 | -0.654 | 0.5693 | [-0.0072, 0.0017] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | 0.0016 |  2.462 | 0.1404 | [-0.0010, 0.0029] | 11 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | -0.0045 | -0.987 | 0.4627 | [-0.0197, 0.0220] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.489 | 0.6646 | [-0.0084, 0.0058] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.425 | 0.7120 | [-0.0075, 0.0052] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.112 | 0.9263 | [-0.0049, 0.0049] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0123 | -2.903 | 0.0108 ** | [-0.0216, -0.0044] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0097 |  0.744 | 0.6002 | [-0.0146, 0.0733] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0112 |  1.189 | 0.5337 | [-0.0138, 0.0540] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.125 | 0.9002 | [-0.0152, 0.0198] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0273 | -12.041 | 0.0277 ** | [-0.0310, -0.0123] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0040 |  0.304 | 0.7881 | [-0.0245, 0.0325] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0085 |  0.822 | 0.5527 | [-0.0156, 0.0309] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0026 | -0.732 | 0.5420 | [-0.0081, 0.0052] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0219 | -3.958 | 0.0081 ** | [-0.0328, -0.0109] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0018 | -0.437 | 0.6940 | [-0.0085, 0.0072] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0018 | -0.513 | 0.6630 | [-0.0077, 0.0056] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.238 | 0.8461 | [-0.0044, 0.0053] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0083 | -2.169 | 0.0719 ** | [-0.0176, -0.0007] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0006 |  0.137 | 0.9041 | [-0.0066, 0.0087] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.180 | 0.8773 | [-0.0047, 0.0068] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.555 | 0.6937 | [-0.0029, 0.0058] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0178 | -3.429 | 0.0072 ** | [-0.0275, -0.0081] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0000 | -0.011 | 0.9941 | [-0.0091, 0.0100] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0028 |  0.733 | 0.6102 | [-0.0043, 0.0107] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0018 | -1.004 | 0.4291 | [-0.0059, 0.0019] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0147 | -3.384 | 0.0020 ** | [-0.0237, -0.0075] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | 0.0005 |  0.083 | 0.9476 | [-0.0128, 0.0146] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | 0.0026 |  0.472 | 0.8176 | [-0.0078, 0.0149] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | -0.0026 | -1.467 | 0.2770 | [-0.0062, 0.0015] | 37 |
| robustness_att | no average treatment effect in periods 0-3, excluding United States (H0: coefficient on post_x = 0) | -0.0203 | -3.863 | 0.0023 ** | [-0.0301, -0.0105] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0159 | -1.656 | 0.2097 | [-0.0401, 0.0027] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0122 | -1.176 | 0.5579 | [-0.0396, 0.0061] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0068 | -0.746 | 0.7138 | [-0.0313, 0.0126] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0203 | -3.544 | 0.0001 ** | [-0.0342, -0.0083] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0002 |  0.029 | 0.9728 | [-0.0215, 0.0216] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0040 | -0.519 | 0.9652 | [-0.0369, 0.0062] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0028 |  0.413 | 0.7435 | [-0.0213, 0.0162] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0094 | -1.805 | 0.2071 | [-0.0231, 0.0071] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | -0.0048 | -0.349 | 0.7913 | [-0.0541, 0.0381] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | -0.0075 | -0.665 | 0.8811 | [-0.0703, 0.0157] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | -0.0043 | -0.471 | 0.9646 | [-0.0522, 0.0225] | 16 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | 0.0007 |  0.118 | 0.9187 | [-0.0212, 0.0165] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0002 |  0.037 | 0.9774 | [-0.0073, 0.0117] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.160 | 0.8857 | [-0.0053, 0.0089] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0010 |  0.712 | 0.6062 | [-0.0023, 0.0044] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0094 | -2.276 | 0.0748 ** | [-0.0184, -0.0008] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0064 |  0.292 | 0.7651 | [-0.0366, 0.2034] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0078 |  0.574 | 0.6789 | [-0.0499, 0.1131] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0027 | -4.987 | 0.0227 ** | [-0.0048, -0.0013] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0052 | -1.581 | 0.3139 | [-0.0150, 0.0222] | 7 |

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.116 | 0.0090 ** | [0.0075, 0.0517] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.163 | 0.1835 | [-0.0012, 0.0521] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.377 | 0.8860 | [-0.0090, 0.0331] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.866 | 0.5476 | [-0.0049, 0.0402] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.374 | 0.7508 | [-0.0147, 0.0106] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.555 | 0.6169 | [-0.0083, 0.0213] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.208 | 0.8495 | [-0.0165, 0.0209] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.866 | 0.5535 | [-0.0049, 0.0400] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.374 | 0.7440 | [-0.0147, 0.0112] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.555 | 0.6128 | [-0.0083, 0.0213] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.208 | 0.8522 | [-0.0169, 0.0199] | 50 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | -0.0035 | -0.722 | 0.5144 | [-0.0116, 0.0056] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | -0.0020 | -0.422 | 0.7382 | [-0.0103, 0.0063] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | -0.0022 | -0.611 | 0.6402 | [-0.0091, 0.0038] | 49 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | -0.0134 | -2.698 | 0.0079 ** | [-0.0238, -0.0047] | 49 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
