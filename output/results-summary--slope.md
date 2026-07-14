# Results summary: Slope Ebalance (11 Jul 2026)

Outcome: ch_at (cash / total assets). Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect.

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0093 |  1.386 | 0.0180 ** | [0.0013, 0.0523] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0031 |  2.417 | 0.1256 | [-0.0007, 0.0081] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0052 |  4.750 | 0.1024 | [-0.0002, 0.0077] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0082 |  1.452 | 0.4030 | [-0.0063, 0.0315] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | 0.0065 |  0.800 | 0.4367 | [-0.0094, 0.0637] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | 0.0000 |  0.018 | 0.9864 | [-0.0101, 0.0032] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | 0.0042 |  3.702 | 0.1354 | [-0.0018, 0.0061] | 11 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | 0.0039 |  0.743 | 0.5633 | [-0.0146, 0.0288] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0016 | -0.370 | 0.7348 | [-0.0089, 0.0066] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0021 | -0.530 | 0.6260 | [-0.0084, 0.0048] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0017 |  0.558 | 0.6139 | [-0.0036, 0.0066] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0056 |  1.432 | 0.2507 | [-0.0026, 0.0129] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0054 |  0.328 | 0.7767 | [-0.0231, 0.0864] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0050 |  0.480 | 0.7786 | [-0.0215, 0.0533] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0075 | -1.836 | 0.3175 | [-0.0217, 0.0209] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0043 | -1.825 | 0.1606 | [-0.0143, 0.0019] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0020 | -0.126 | 0.9153 | [-0.0364, 0.0350] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0022 |  0.181 | 0.8742 | [-0.0266, 0.0295] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0063 | -1.684 | 0.1759 | [-0.0121, 0.0019] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0030 | -0.698 | 0.5549 | [-0.0119, 0.0055] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0013 | -0.307 | 0.7798 | [-0.0085, 0.0082] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -0.630 | 0.5826 | [-0.0083, 0.0049] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0011 |  0.419 | 0.7213 | [-0.0039, 0.0056] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0051 |  1.538 | 0.2342 | [-0.0026, 0.0117] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0033 | -0.523 | 0.6806 | [-0.0143, 0.0098] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0039 | -0.840 | 0.4937 | [-0.0114, 0.0057] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.129 | 0.9083 | [-0.0042, 0.0061] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  0.515 | 0.6973 | [-0.0079, 0.0141] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0000 | -0.004 | 0.9973 | [-0.0124, 0.0137] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0041 |  0.880 | 0.4522 | [-0.0046, 0.0143] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0019 |  0.741 | 0.5378 | [-0.0035, 0.0067] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0052 |  1.365 | 0.3241 | [-0.0036, 0.0122] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | -0.0031 | -0.348 | 0.7627 | [-0.0208, 0.0175] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | 0.0001 |  0.020 | 0.9875 | [-0.0132, 0.0157] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | -0.0046 | -2.327 | 0.0610 ** | [-0.0083, -0.0005] | 37 |
| robustness_att | no average treatment effect in periods 0-3, excluding United States (H0: coefficient on post_x = 0) | -0.0010 | -0.228 | 0.8506 | [-0.0106, 0.0075] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0163 | -1.595 | 0.2572 | [-0.0403, 0.0046] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0199 | -1.807 | 0.1623 | [-0.0470, 0.0013] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0067 | -0.730 | 0.7033 | [-0.0299, 0.0135] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0079 | -1.571 | 0.3301 | [-0.0206, 0.0037] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0015 |  0.182 | 0.8522 | [-0.0207, 0.0228] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0049 | -0.585 | 0.9126 | [-0.0405, 0.0061] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0032 |  0.465 | 0.7202 | [-0.0226, 0.0162] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0032 |  0.525 | 0.7118 | [-0.0137, 0.0200] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | -0.0027 | -0.212 | 0.8644 | [-0.0498, 0.0368] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | -0.0139 | -1.248 | 0.7001 | [-0.0751, 0.0089] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | -0.0002 | -0.023 | 0.9932 | [-0.0461, 0.0247] | 16 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | -0.0026 | -0.445 | 0.6876 | [-0.0239, 0.0137] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0018 |  0.348 | 0.7588 | [-0.0073, 0.0154] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0021 |  0.543 | 0.6102 | [-0.0047, 0.0114] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0033 |  1.547 | 0.1757 | [-0.0007, 0.0079] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0092 |  2.313 | 0.0713 ** | [0.0009, 0.0188] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0063 |  0.308 | 0.8092 | [-0.0888, 0.1528] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0023 |  0.153 | 0.8824 | [-0.0663, 0.1158] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0035 | -1.696 | 0.4186 | [-0.0142, 0.0013] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0052 |  1.278 | 0.5663 | [-0.0069, 0.0462] | 7 |

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  0.967 | 0.3508 | [-0.0103, 0.0467] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  0.364 | 0.7815 | [-0.0145, 0.0494] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.090 | 0.9493 | [-0.0135, 0.0346] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.575 | 0.7837 | [-0.0071, 0.0369] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -1.837 | 0.1705 | [-0.0207, 0.0030] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . | -0.613 | 0.6009 | [-0.0249, 0.0166] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.809 | 0.4915 | [-0.0293, 0.0177] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.575 | 0.7876 | [-0.0071, 0.0366] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -1.837 | 0.1708 | [-0.0207, 0.0024] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . | -0.613 | 0.5875 | [-0.0238, 0.0156] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.809 | 0.4831 | [-0.0291, 0.0167] | 50 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0) | -0.0038 | -0.650 | 0.5699 | [-0.0140, 0.0077] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0) | -0.0036 | -0.691 | 0.5472 | [-0.0129, 0.0062] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0) | 0.0003 |  0.080 | 0.9494 | [-0.0070, 0.0076] | 49 |
| robustness_att | no average treatment effect in periods 0-3, excluding Thailand (H0: coefficient on post_x = 0) | 0.0036 |  0.732 | 0.6033 | [-0.0066, 0.0132] | 49 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
