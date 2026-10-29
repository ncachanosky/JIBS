# Results summary: Level-Lag Ebalance (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend). For ATT tests, that means evidence of a treatment effect. Rows starting with 'robustness_' are dominant-episode leave-one-country-out checks, not the main-spec result.

# ch_at (Cash / Assets)

## Transitioning sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0) |      . |  2.116 | 0.0114 ** | [0.0076, 0.0512] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1) |      . |  1.104 | 0.2427 | [-0.0018, 0.0511] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2) |      . |  0.290 | 0.9122 | [-0.0099, 0.0324] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4) |      . |  0.819 | 0.5970 | [-0.0054, 0.0390] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5) |      . | -0.464 | 0.6860 | [-0.0155, 0.0103] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6) |      . |  0.467 | 0.6783 | [-0.0090, 0.0208] | 50 |
| arm_equality | Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7) |      . | -0.253 | 0.8251 | [-0.0168, 0.0206] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4) |      . |  0.819 | 0.5956 | [-0.0054, 0.0394] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5) |      . | -0.464 | 0.6882 | [-0.0155, 0.0103] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6) |      . |  0.467 | 0.6755 | [-0.0090, 0.0208] | 50 |
| arm_equality_postonly | Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7) |      . | -0.253 | 0.8184 | [-0.0164, 0.0206] | 50 |

# intan_at (Intangibles / Assets)

## Asia

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0212 |  1.681 | 0.4470 | [-0.0034, 0.0535] | 11 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0140 |  1.451 | 0.5578 | [-0.0068, 0.0353] | 11 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0010 | -0.135 | 0.8413 | [-0.0182, 0.0197] | 11 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0022 | -0.578 | 0.8967 | [-0.0113, 0.0103] | 11 |

## Asia (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0160 |  1.832 | 0.2930 | [-0.0042, 0.0343] | 11 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0078 |  1.415 | 0.5154 | [-0.0114, 0.0249] | 11 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0059 | -1.138 | 0.5433 | [-0.0223, 0.0210] | 11 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0005 |  0.237 | 0.7932 | [-0.0028, 0.0103] | 11 |

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0030 |  0.619 | 0.5831 | [-0.0067, 0.0116] | 54 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  0.863 | 0.4367 | [-0.0030, 0.0079] | 54 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0013 | -0.524 | 0.6480 | [-0.0063, 0.0034] | 54 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0015 | -0.699 | 0.5233 | [-0.0058, 0.0022] | 54 |

## Eastern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0111 | -1.323 | 0.4444 | [-0.0442, 0.0283] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0026 | -0.506 | 0.6516 | [-0.0093, 0.0280] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0039 | -0.878 | 0.5577 | [-0.0171, 0.0215] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0141 | -0.990 | 0.1548 | [-0.1013, 0.0007] | 7 |

## Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0062 | -0.511 | 0.8526 | [-0.0351, 0.0185] | 29 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0027 |  0.402 | 0.7323 | [-0.0106, 0.0168] | 29 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0032 |  0.468 | 0.7441 | [-0.0103, 0.0181] | 29 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0153 | -1.744 | 0.0293 ** | [-0.0308, -0.0027] | 29 |

## Excluding no-treated regions

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0041 |  0.642 | 0.6511 | [-0.0101, 0.0169] | 36 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0033 |  0.778 | 0.5831 | [-0.0051, 0.0116] | 36 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0014 | -0.480 | 0.6748 | [-0.0077, 0.0043] | 36 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0008 | -0.411 | 0.7147 | [-0.0048, 0.0026] | 36 |

## Fully Democratic Sample

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0046 | -0.887 | 0.4519 | [-0.0150, 0.0057] | 49 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0009 | -0.263 | 0.8190 | [-0.0076, 0.0058] | 49 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0028 | -0.856 | 0.4810 | [-0.0093, 0.0041] | 49 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0042 | -1.456 | 0.1964 | [-0.0097, 0.0012] | 49 |

## High Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0008 | -0.119 | 0.8960 | [-0.0165, 0.0132] | 37 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.397 | 0.7491 | [-0.0089, 0.0059] | 37 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -0.748 | 0.5374 | [-0.0079, 0.0039] | 37 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.074 | 0.9504 | [-0.0033, 0.0034] | 37 |

## High Income (excl. United States)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0076 | -0.968 | 0.6507 | [-0.0265, 0.0071] | 37 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0044 | -1.087 | 0.3867 | [-0.0127, 0.0040] | 37 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0038 | -1.075 | 0.4489 | [-0.0112, 0.0040] | 37 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0037 | -1.798 | 0.1621 | [-0.0078, 0.0006] | 37 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0036 |  0.482 | 0.8541 | [-0.0112, 0.0209] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.172 | 0.9408 | [-0.0082, 0.0110] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0035 | -1.085 | 0.4903 | [-0.0109, 0.0046] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0098 | -2.450 | 0.0329 ** | [-0.0187, -0.0014] | 50 |

## Middle Income

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0217 |  1.701 | 0.3445 | [-0.0063, 0.0483] | 16 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0166 |  1.766 | 0.2973 | [-0.0042, 0.0363] | 16 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.065 | 0.9413 | [-0.0165, 0.0166] | 16 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0073 | -1.698 | 0.2242 | [-0.0174, 0.0017] | 16 |

## Middle Income (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0120 |  1.213 | 0.4132 | [-0.0098, 0.0559] | 16 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0078 |  1.239 | 0.3521 | [-0.0050, 0.0344] | 16 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0061 | -1.062 | 0.4258 | [-0.0193, 0.0192] | 16 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0135 | -1.792 | 0.2018 | [-0.0317, 0.0023] | 16 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0034 |  0.627 | 0.5758 | [-0.0079, 0.0130] | 51 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0038 |  1.282 | 0.2573 | [-0.0017, 0.0089] | 51 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.111 | 0.9164 | [-0.0046, 0.0046] | 51 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.029 | 0.9825 | [-0.0048, 0.0039] | 51 |

## Southern Europe

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0022 |  0.508 | 0.6648 | [-0.0031, 0.0112] | 7 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0016 | -0.682 | 0.7830 | [-0.0179, 0.0186] | 7 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0040 |  3.840 | 0.1038 | [0.0030, 0.0060] | 7 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  2.849 | 0.3359 | [-0.0043, 0.0044] | 7 |

## Transitioning sample (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0022 | -0.378 | 0.7361 | [-0.0137, 0.0087] | 49 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0010 | -0.323 | 0.7755 | [-0.0075, 0.0054] | 49 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0037 | -1.335 | 0.2853 | [-0.0093, 0.0021] | 49 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0031 | -1.144 | 0.3168 | [-0.0079, 0.0023] | 49 |

## Transitioning: Arm A (populist-only)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0039 | -0.751 | 0.5171 | [-0.0143, 0.0064] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.160 | 0.8864 | [-0.0071, 0.0060] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -0.646 | 0.5942 | [-0.0090, 0.0046] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0045 | -1.540 | 0.1780 | [-0.0100, 0.0010] | 50 |

## Transitioning: Arm B (exits democracy)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0129 |  1.591 | 0.2557 | [-0.0063, 0.0358] | 50 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0053 |  1.501 | 0.2579 | [-0.0026, 0.0152] | 50 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0013 | -0.757 | 0.5327 | [-0.0047, 0.0032] | 50 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0072 |  3.618 | 0.0562 ** | [0.0019, 0.0104] | 50 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
