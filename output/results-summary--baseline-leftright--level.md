# Results summary: Level-Lag Ebalance (29 Oct 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. Entropy-balance weights are estimated ONCE per spec (targeting ch_at's pre-trend) and reused for every outcome below - see the do-file header for why. See the do-file header for full method notes.

**How to read this table:** each row is one hypothesis test. 'H0' is the null hypothesis being tested - a low p-value (conventionally below 0.10) means the data are unlikely under that null, i.e. evidence AGAINST it. For pre-trend tests, that means evidence of a problem (differential pre-trend); 'pretrend' rows are individual tests, the 'pretrend_joint' row is the joint Wald test (its t-stat column holds the F). For ATT tests, a low p-value means evidence of a treatment effect. Rows starting with 'robustness_' come from the same spec re-estimated after dropping that spec's dominant episode (the excluded country is named in the spec label), not the main-spec result. N is the number of firm-year observations in the underlying regression.

# act_at (Current Assets / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0004 |  0.085 | 0.9375 | [-0.0090, 0.0104] | 54 |   566,311 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0001 | -0.025 | 0.9811 | [-0.0095, 0.0082] | 54 |   566,311 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0038 |  0.926 | 0.4348 | [-0.0052, 0.0110] | 54 |   566,311 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.736 | 0.7015 | [     .,      .] | 54 |   566,311 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0057 | -1.100 | 0.3330 | [-0.0155, 0.0040] | 54 |   566,311 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0028 | -0.649 | 0.5244 | [-0.0103, 0.0047] | 54 |   566,015 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -0.261 | 0.8202 | [-0.0122, 0.0081] | 54 |   566,015 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0016 |  0.356 | 0.7634 | [-0.0076, 0.0087] | 54 |   566,015 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.420 | 0.8313 | [     .,      .] | 54 |   566,015 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0082 | -1.648 | 0.1429 | [-0.0169, 0.0011] | 54 |   566,015 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0008 |  0.144 | 0.8947 | [-0.0103, 0.0119] | 54 |   562,420 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.107 | 0.9243 | [-0.0107, 0.0090] | 54 |   562,420 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0033 |  0.697 | 0.5480 | [-0.0070, 0.0120] | 54 |   562,420 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.475 | 0.8185 | [     .,      .] | 54 |   562,420 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0009 | -0.169 | 0.8815 | [-0.0110, 0.0091] | 54 |   562,420 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0034 |  0.330 | 0.8138 | [-0.0209, 0.0240] | 50 |   558,876 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0055 | -0.773 | 0.5512 | [-0.0213, 0.0086] | 50 |   558,876 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0071 |  1.210 | 0.4744 | [-0.0084, 0.0215] | 50 |   558,876 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.564 | 0.6134 | [     .,      .] | 50 |   558,876 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0066 |  0.879 | 0.4809 | [-0.0107, 0.0214] | 50 |   558,876 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0057 | -0.443 | 0.8205 | [-0.0374, 0.0215] | 50 |   558,580 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0086 | -0.897 | 0.5365 | [-0.0293, 0.0126] | 50 |   558,580 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0048 |  0.723 | 0.7182 | [-0.0121, 0.0218] | 50 |   558,580 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.704 | 0.9841 | [     .,      .] | 50 |   558,580 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.091 | 0.9495 | [-0.0184, 0.0200] | 50 |   558,580 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0030 | -0.814 | 0.4250 | [-0.0098, 0.0039] | 51 |   565,447 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0006 | -0.111 | 0.9275 | [-0.0124, 0.0093] | 51 |   565,447 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0014 |  0.316 | 0.7873 | [-0.0088, 0.0087] | 51 |   565,447 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.506 | 0.7886 | [     .,      .] | 51 |   565,447 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0091 | -1.826 | 0.1102 | [-0.0184, 0.0002] | 51 |   565,447 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0025 | -0.597 | 0.5796 | [-0.0103, 0.0058] | 51 |   561,556 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0019 | -0.264 | 0.8622 | [-0.0170, 0.0116] | 51 |   561,556 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0008 | -0.138 | 0.9572 | [-0.0132, 0.0085] | 51 |   561,556 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.152 | 0.9706 | [     .,      .] | 51 |   561,556 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0042 | -0.803 | 0.4790 | [-0.0144, 0.0055] | 51 |   561,556 |

# act_ex_ch_at (Current Assets ex. Cash / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0012 | -0.219 | 0.8365 | [-0.0125, 0.0081] | 54 |   566,311 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0009 |  0.174 | 0.8697 | [-0.0092, 0.0099] | 54 |   566,311 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0012 |  0.322 | 0.7780 | [-0.0068, 0.0072] | 54 |   566,311 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.381 | 0.8329 | [     .,      .] | 54 |   566,311 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0062 |  1.285 | 0.2665 | [-0.0028, 0.0162] | 54 |   566,311 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0036 | -0.551 | 0.6226 | [-0.0172, 0.0072] | 54 |   566,015 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0001 |  0.017 | 0.9872 | [-0.0124, 0.0107] | 54 |   566,015 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0009 | -0.234 | 0.8450 | [-0.0093, 0.0056] | 54 |   566,015 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.746 | 0.6463 | [     .,      .] | 54 |   566,015 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0041 |  0.863 | 0.4184 | [-0.0042, 0.0139] | 54 |   566,015 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0007 | -0.110 | 0.9228 | [-0.0135, 0.0101] | 54 |   562,420 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.147 | 0.8934 | [-0.0093, 0.0097] | 54 |   562,420 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0021 |  0.490 | 0.6668 | [-0.0072, 0.0099] | 54 |   562,420 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.293 | 0.8843 | [     .,      .] | 54 |   562,420 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0072 |  1.376 | 0.2402 | [-0.0031, 0.0175] | 54 |   562,420 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0012 |  0.169 | 0.9013 | [-0.0146, 0.0170] | 50 |   558,876 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0030 | -0.632 | 0.6313 | [-0.0134, 0.0069] | 50 |   558,876 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.044 | 0.9760 | [-0.0103, 0.0112] | 50 |   558,876 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.949 | 0.7933 | [     .,      .] | 50 |   558,876 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0279 |  5.758 | 0.0000 ** | [0.0183, 0.0391] | 50 |   558,876 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0073 | -0.751 | 0.6172 | [-0.0293, 0.0138] | 50 |   558,580 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0057 | -0.876 | 0.5246 | [-0.0193, 0.0086] | 50 |   558,580 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0078 | -1.341 | 0.3354 | [-0.0205, 0.0056] | 50 |   558,580 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.652 | 0.3966 | [     .,      .] | 50 |   558,580 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0308 |  4.933 | 0.0000 ** | [0.0178, 0.0453] | 50 |   558,580 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0028 | -0.397 | 0.7564 | [-0.0185, 0.0089] | 51 |   565,447 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.166 | 0.8895 | [-0.0134, 0.0127] | 51 |   565,447 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.188 | 0.8883 | [-0.0090, 0.0078] | 51 |   565,447 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.752 | 0.3247 | [     .,      .] | 51 |   565,447 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0001 |  0.024 | 0.9843 | [-0.0095, 0.0102] | 51 |   565,447 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0043 | -0.514 | 0.7802 | [-0.0228, 0.0105] | 51 |   561,556 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.036 | 0.9808 | [-0.0165, 0.0135] | 51 |   561,556 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0008 |  0.145 | 0.9234 | [-0.0110, 0.0096] | 51 |   561,556 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.371 | 0.4646 | [     .,      .] | 51 |   561,556 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0004 | -0.068 | 0.9524 | [-0.0114, 0.0113] | 51 |   561,556 |

# ao_at (Other Assets / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0067 | -1.274 | 0.4583 | [-0.0188, 0.0049] | 54 |   713,592 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0043 | -1.868 | 0.1846 | [-0.0091, 0.0010] | 54 |   713,592 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0009 | -0.291 | 0.7910 | [-0.0067, 0.0070] | 54 |   713,592 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.200 | 0.6637 | [     .,      .] | 54 |   713,592 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0057 |  2.426 | 0.0571 ** | [0.0008, 0.0103] | 54 |   713,592 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0054 | -1.185 | 0.4739 | [-0.0155, 0.0052] | 54 |   713,082 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0046 | -2.598 | 0.0287 ** | [-0.0077, -0.0013] | 54 |   713,082 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0021 | -0.635 | 0.5817 | [-0.0078, 0.0062] | 54 |   713,082 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.356 | 0.3337 | [     .,      .] | 54 |   713,082 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0056 |  2.158 | 0.0914 ** | [0.0002, 0.0107] | 54 |   713,082 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0010 | -0.204 | 0.9039 | [-0.0104, 0.0080] | 54 |   708,917 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0007 | -0.399 | 0.7549 | [-0.0037, 0.0027] | 54 |   708,917 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0013 |  0.413 | 0.6912 | [-0.0057, 0.0098] | 54 |   708,917 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.102 | 0.9823 | [     .,      .] | 54 |   708,917 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0026 |  1.186 | 0.3046 | [-0.0017, 0.0067] | 54 |   708,917 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0011 | -0.157 | 0.9494 | [-0.0167, 0.0114] | 50 |   704,430 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0004 | -0.100 | 0.9541 | [-0.0079, 0.0063] | 50 |   704,430 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0142 |  5.409 | 0.0000 ** | [0.0079, 0.0212] | 50 |   704,430 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 10.944 | 0.0082 ** | [     .,      .] | 50 |   704,430 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  0.695 | 0.6037 | [-0.0061, 0.0128] | 50 |   704,430 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0041 |  0.921 | 0.4607 | [-0.0057, 0.0140] | 50 |   703,920 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0012 | -0.523 | 0.6826 | [-0.0059, 0.0039] | 50 |   703,920 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0152 |  4.616 | 0.0001 ** | [0.0087, 0.0239] | 50 |   703,920 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 13.748 | 0.0027 ** | [     .,      .] | 50 |   703,920 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0031 |  0.468 | 0.7595 | [-0.0106, 0.0174] | 50 |   703,920 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0070 | -1.500 | 0.3485 | [-0.0177, 0.0043] | 51 |   712,312 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0048 | -2.399 | 0.0424 ** | [-0.0092, -0.0011] | 51 |   712,312 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0057 | -4.815 | 0.0012 ** | [-0.0079, -0.0036] | 51 |   712,312 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  8.469 | 0.0034 ** | [     .,      .] | 51 |   712,312 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0064 |  2.551 | 0.0731 ** | [0.0006, 0.0138] | 51 |   712,312 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0000 | -0.004 | 0.9977 | [-0.0085, 0.0084] | 51 |   707,637 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0007 | -0.590 | 0.5680 | [-0.0028, 0.0017] | 51 |   707,637 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0034 | -3.238 | 0.0204 ** | [-0.0055, -0.0012] | 51 |   707,637 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  4.095 | 0.0681 ** | [     .,      .] | 51 |   707,637 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0025 |  1.309 | 0.3006 | [-0.0019, 0.0068] | 51 |   707,637 |

# ch_at (Cash / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0017 | -0.432 | 0.6980 | [-0.0084, 0.0062] | 54 |   721,889 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.421 | 0.7137 | [-0.0075, 0.0053] | 54 |   721,889 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.117 | 0.9241 | [-0.0048, 0.0049] | 54 |   721,889 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.148 | 0.9609 | [     .,      .] | 54 |   721,889 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0123 | -2.910 | 0.0083 ** | [-0.0216, -0.0044] | 54 |   721,889 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0014 | -0.279 | 0.7996 | [-0.0094, 0.0088] | 54 |   721,321 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0014 | -0.332 | 0.7746 | [-0.0087, 0.0069] | 54 |   721,321 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0001 |  0.027 | 0.9828 | [-0.0058, 0.0053] | 54 |   721,321 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.075 | 0.9907 | [     .,      .] | 54 |   721,321 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0114 | -2.651 | 0.0132 ** | [-0.0208, -0.0034] | 54 |   721,321 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0022 | -0.478 | 0.6759 | [-0.0104, 0.0065] | 54 |   717,214 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0017 | -0.402 | 0.7537 | [-0.0094, 0.0059] | 54 |   717,214 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0016 | -0.471 | 0.7336 | [-0.0079, 0.0040] | 54 |   717,214 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.114 | 0.9757 | [     .,      .] | 54 |   717,214 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0091 | -2.183 | 0.0489 ** | [-0.0183, -0.0013] | 54 |   717,214 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0159 | -1.655 | 0.2162 | [-0.0398, 0.0027] | 50 |   712,710 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0122 | -1.176 | 0.5563 | [-0.0390, 0.0061] | 50 |   712,710 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0068 | -0.747 | 0.7186 | [-0.0311, 0.0125] | 50 |   712,710 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.520 | 0.6710 | [     .,      .] | 50 |   712,710 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0203 | -3.545 | 0.0001 ** | [-0.0342, -0.0083] | 50 |   712,710 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0182 | -1.625 | 0.3529 | [-0.0472, 0.0053] | 50 |   712,142 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0154 | -1.177 | 0.8113 | [-0.0499, 0.0111] | 50 |   712,142 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0086 | -0.744 | 0.8163 | [-0.0403, 0.0190] | 50 |   712,142 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.871 | 0.7604 | [     .,      .] | 50 |   712,142 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0230 | -3.571 | 0.0023 ** | [-0.0378, -0.0074] | 50 |   712,142 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0004 |  0.091 | 0.9373 | [-0.0073, 0.0129] | 51 |   720,545 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0005 |  0.164 | 0.8899 | [-0.0053, 0.0089] | 51 |   720,545 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0010 |  0.726 | 0.6027 | [-0.0021, 0.0045] | 51 |   720,545 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.177 | 0.9654 | [     .,      .] | 51 |   720,545 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0094 | -2.285 | 0.0705 ** | [-0.0189, -0.0008] | 51 |   720,545 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0035 |  0.638 | 0.6076 | [-0.0067, 0.0161] | 51 |   715,870 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0019 |  0.554 | 0.6983 | [-0.0041, 0.0098] | 51 |   715,870 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0004 | -0.301 | 0.8269 | [-0.0030, 0.0023] | 51 |   715,870 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.181 | 0.9905 | [     .,      .] | 51 |   715,870 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0050 | -1.265 | 0.2973 | [-0.0136, 0.0028] | 51 |   715,870 |

# intan_at (Intangibles / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0030 |  0.615 | 0.5825 | [-0.0067, 0.0116] | 54 |   655,761 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  0.867 | 0.4353 | [-0.0030, 0.0079] | 54 |   655,761 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0013 | -0.526 | 0.6498 | [-0.0063, 0.0034] | 54 |   655,761 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.154 | 0.2105 | [     .,      .] | 54 |   655,761 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0014 | -0.698 | 0.5276 | [-0.0058, 0.0022] | 54 |   655,761 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0037 |  0.717 | 0.5129 | [-0.0066, 0.0128] | 54 |   655,371 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0038 |  1.291 | 0.2302 | [-0.0017, 0.0087] | 54 |   655,371 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.202 | 0.8590 | [-0.0035, 0.0044] | 54 |   655,371 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.397 | 0.3659 | [     .,      .] | 54 |   655,371 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0014 | -0.659 | 0.5655 | [-0.0060, 0.0023] | 54 |   655,371 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0002 |  0.046 | 0.9655 | [-0.0095, 0.0095] | 54 |   651,837 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0004 |  0.139 | 0.9003 | [-0.0048, 0.0056] | 54 |   651,837 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0031 | -1.281 | 0.3147 | [-0.0080, 0.0020] | 54 |   651,837 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.235 | 0.2611 | [     .,      .] | 54 |   651,837 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0026 | -1.092 | 0.3185 | [-0.0074, 0.0016] | 54 |   651,837 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0036 |  0.476 | 0.8572 | [-0.0113, 0.0217] | 50 |   647,471 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0008 |  0.186 | 0.9328 | [-0.0081, 0.0111] | 50 |   647,471 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0035 | -1.089 | 0.4738 | [-0.0109, 0.0046] | 50 |   647,471 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.493 | 0.7376 | [     .,      .] | 50 |   647,471 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0098 | -2.444 | 0.0382 ** | [-0.0191, -0.0014] | 50 |   647,471 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0095 |  0.917 | 0.7336 | [-0.0122, 0.0368] | 50 |   647,081 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0073 |  1.436 | 0.4785 | [-0.0045, 0.0202] | 50 |   647,081 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0035 |  1.167 | 0.4135 | [-0.0038, 0.0114] | 50 |   647,081 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.536 | 0.7942 | [     .,      .] | 50 |   647,081 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0131 | -3.838 | 0.0023 ** | [-0.0210, -0.0048] | 50 |   647,081 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0034 |  0.624 | 0.5733 | [-0.0080, 0.0129] | 51 |   654,693 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0038 |  1.284 | 0.2638 | [-0.0017, 0.0089] | 51 |   654,693 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0003 |  0.109 | 0.9178 | [-0.0046, 0.0046] | 51 |   654,693 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.707 | 0.1215 | [     .,      .] | 51 |   654,693 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0001 | -0.029 | 0.9796 | [-0.0048, 0.0039] | 51 |   654,693 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0001 | -0.022 | 0.9865 | [-0.0132, 0.0105] | 51 |   650,769 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0012 |  0.441 | 0.6795 | [-0.0045, 0.0063] | 51 |   650,769 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0013 | -0.556 | 0.6517 | [-0.0066, 0.0034] | 51 |   650,769 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  2.386 | 0.2315 | [     .,      .] | 51 |   650,769 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0010 | -0.363 | 0.7697 | [-0.0056, 0.0037] | 51 |   650,769 |

# invt_at (Inventories / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0029 | -1.095 | 0.3245 | [-0.0083, 0.0020] | 54 |   659,596 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0024 | -1.069 | 0.3203 | [-0.0073, 0.0015] | 54 |   659,596 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0022 | -1.565 | 0.2377 | [-0.0054, 0.0009] | 54 |   659,596 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.889 | 0.6747 | [     .,      .] | 54 |   659,596 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.456 | 0.7122 | [-0.0024, 0.0042] | 54 |   659,596 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0030 | -1.143 | 0.2924 | [-0.0085, 0.0019] | 54 |   659,229 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -1.008 | 0.3452 | [-0.0074, 0.0017] | 54 |   659,229 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0020 | -1.274 | 0.3275 | [-0.0053, 0.0014] | 54 |   659,229 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.661 | 0.7488 | [     .,      .] | 54 |   659,229 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0008 |  0.419 | 0.7503 | [-0.0026, 0.0046] | 54 |   659,229 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0038 | -1.366 | 0.2458 | [-0.0093, 0.0017] | 54 |   655,364 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0034 | -1.391 | 0.2148 | [-0.0085, 0.0012] | 54 |   655,364 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0026 | -1.840 | 0.1524 | [-0.0059, 0.0004] | 54 |   655,364 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.214 | 0.5873 | [     .,      .] | 54 |   655,364 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.112 | 0.9202 | [-0.0030, 0.0034] | 54 |   655,364 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0028 | -1.063 | 0.3775 | [-0.0081, 0.0027] | 50 |   651,420 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.070 | 0.9639 | [-0.0098, 0.0097] | 50 |   651,420 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0028 | -1.486 | 0.2599 | [-0.0064, 0.0012] | 50 |   651,420 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.072 | 0.8354 | [     .,      .] | 50 |   651,420 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0024 |  1.086 | 0.3672 | [-0.0020, 0.0075] | 50 |   651,420 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0034 | -1.122 | 0.3667 | [-0.0101, 0.0033] | 50 |   651,053 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  0.349 | 0.8584 | [-0.0108, 0.0151] | 50 |   651,053 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.612 | 0.6806 | [-0.0074, 0.0045] | 50 |   651,053 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.019 | 0.9119 | [     .,      .] | 50 |   651,053 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0027 |  1.086 | 0.3957 | [-0.0025, 0.0086] | 50 |   651,053 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0026 | -0.878 | 0.4260 | [-0.0091, 0.0026] | 51 |   658,602 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0026 | -1.140 | 0.3012 | [-0.0082, 0.0017] | 51 |   658,602 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0017 | -0.992 | 0.4500 | [-0.0058, 0.0023] | 51 |   658,602 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.475 | 0.8706 | [     .,      .] | 51 |   658,602 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.370 | 0.8256 | [-0.0040, 0.0059] | 51 |   658,602 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0037 | -1.097 | 0.3462 | [-0.0111, 0.0026] | 51 |   654,370 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0043 | -1.694 | 0.1460 | [-0.0104, 0.0005] | 51 |   654,370 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0021 | -1.235 | 0.3385 | [-0.0063, 0.0016] | 51 |   654,370 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.172 | 0.6619 | [     .,      .] | 51 |   654,370 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0003 |  0.140 | 0.9158 | [-0.0046, 0.0050] | 51 |   654,370 |

# ivaeq_at (Equity Investments / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0029 |  1.756 | 0.1154 | [-0.0002, 0.0069] | 54 |   559,378 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0010 |  0.794 | 0.5462 | [-0.0012, 0.0040] | 54 |   559,378 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.109 | 0.9214 | [-0.0024, 0.0024] | 54 |   559,378 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  3.079 | 0.1246 | [     .,      .] | 54 |   559,378 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.197 | 0.2829 | [-0.0011, 0.0082] | 54 |   559,378 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0028 |  1.571 | 0.1753 | [-0.0006, 0.0075] | 54 |   559,093 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0015 |  1.169 | 0.3701 | [-0.0008, 0.0047] | 54 |   559,093 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0004 | -0.287 | 0.8047 | [-0.0028, 0.0024] | 54 |   559,093 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  3.507 | 0.1032 | [     .,      .] | 54 |   559,093 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0025 |  1.048 | 0.3842 | [-0.0015, 0.0085] | 54 |   559,093 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0046 |  2.704 | 0.0046 ** | [0.0014, 0.0085] | 54 |   555,518 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0018 |  1.333 | 0.3021 | [-0.0009, 0.0048] | 54 |   555,518 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.429 | 0.7295 | [-0.0020, 0.0031] | 54 |   555,518 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  5.942 | 0.0147 ** | [     .,      .] | 54 |   555,518 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0028 |  1.069 | 0.3559 | [-0.0018, 0.0089] | 54 |   555,518 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0059 |  3.487 | 0.0038 ** | [0.0029, 0.0093] | 50 |   552,207 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0011 |  0.565 | 0.6859 | [-0.0025, 0.0052] | 50 |   552,207 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0005 | -0.243 | 0.8430 | [-0.0043, 0.0040] | 50 |   552,207 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 17.809 | 0.0013 ** | [     .,      .] | 50 |   552,207 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0169 |  4.850 | 0.0000 ** | [0.0080, 0.0253] | 50 |   552,207 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0067 |  2.357 | 0.0245 ** | [0.0017, 0.0123] | 50 |   551,922 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0035 |  1.223 | 0.3408 | [-0.0012, 0.0095] | 50 |   551,922 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0018 | -0.556 | 0.6415 | [-0.0077, 0.0052] | 50 |   551,922 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  9.569 | 0.0077 ** | [     .,      .] | 50 |   551,922 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0227 |  6.004 | 0.0000 ** | [0.0135, 0.0323] | 50 |   551,922 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0023 |  1.205 | 0.3684 | [-0.0017, 0.0072] | 51 |   558,589 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0013 |  1.044 | 0.5892 | [-0.0012, 0.0048] | 51 |   558,589 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0000 |  0.003 | 0.9977 | [-0.0013, 0.0021] | 51 |   558,589 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  6.849 | 0.0338 ** | [     .,      .] | 51 |   558,589 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0005 | -0.626 | 0.5672 | [-0.0021, 0.0011] | 51 |   558,589 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0044 |  2.396 | 0.0388 ** | [0.0005, 0.0085] | 51 |   554,729 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0024 |  2.020 | 0.1384 | [-0.0002, 0.0052] | 51 |   554,729 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0007 |  0.741 | 0.5702 | [-0.0010, 0.0029] | 51 |   554,729 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 19.727 | 0.0002 ** | [     .,      .] | 51 |   554,729 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0012 | -1.015 | 0.4200 | [-0.0036, 0.0010] | 51 |   554,729 |

# ivao_at (Other Investments / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0007 |  0.161 | 0.8893 | [-0.0071, 0.0084] | 54 |   566,225 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0020 |  0.692 | 0.5367 | [-0.0035, 0.0076] | 54 |   566,225 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0004 |  0.164 | 0.8746 | [-0.0042, 0.0054] | 54 |   566,225 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.405 | 0.8629 | [     .,      .] | 54 |   566,225 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0009 |  0.287 | 0.8021 | [-0.0048, 0.0065] | 54 |   566,225 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0013 | -0.334 | 0.7615 | [-0.0089, 0.0062] | 54 |   565,929 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0003 |  0.095 | 0.9228 | [-0.0051, 0.0063] | 54 |   565,929 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0006 |  0.208 | 0.8138 | [-0.0048, 0.0068] | 54 |   565,929 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.140 | 0.9419 | [     .,      .] | 54 |   565,929 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0009 | -0.335 | 0.7546 | [-0.0062, 0.0043] | 54 |   565,929 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0001 |  0.011 | 0.9923 | [-0.0097, 0.0093] | 54 |   562,334 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0026 |  0.798 | 0.4969 | [-0.0039, 0.0088] | 54 |   562,334 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0005 |  0.145 | 0.9025 | [-0.0055, 0.0065] | 54 |   562,334 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.010 | 0.6309 | [     .,      .] | 54 |   562,334 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0002 | -0.070 | 0.9496 | [-0.0067, 0.0058] | 54 |   562,334 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0072 |  1.006 | 0.5124 | [-0.0101, 0.0238] | 50 |   558,790 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0090 |  3.157 | 0.0023 ** | [0.0034, 0.0155] | 50 |   558,790 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0031 |  2.630 | 0.0333 ** | [0.0008, 0.0052] | 50 |   558,790 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  7.033 | 0.0374 ** | [     .,      .] | 50 |   558,790 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0064 | -1.257 | 0.5071 | [-0.0199, 0.0072] | 50 |   558,790 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0006 | -0.079 | 0.9494 | [-0.0168, 0.0181] | 50 |   558,494 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0023 |  1.361 | 0.2308 | [-0.0011, 0.0059] | 50 |   558,494 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0032 |  1.540 | 0.2219 | [-0.0011, 0.0071] | 50 |   558,494 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.345 | 0.6223 | [     .,      .] | 50 |   558,494 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0180 | -3.727 | 0.0207 ** | [-0.0296, -0.0058] | 50 |   558,494 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0019 | -0.539 | 0.7178 | [-0.0093, 0.0039] | 51 |   565,365 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0003 | -0.088 | 0.9157 | [-0.0064, 0.0066] | 51 |   565,365 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.040 | 0.9573 | [-0.0063, 0.0068] | 51 |   565,365 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.168 | 0.9510 | [     .,      .] | 51 |   565,365 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0021 |  1.004 | 0.3364 | [-0.0013, 0.0070] | 51 |   565,365 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0025 | -0.580 | 0.7959 | [-0.0126, 0.0051] | 51 |   561,474 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | 0.0007 |  0.150 | 0.8737 | [-0.0083, 0.0101] | 51 |   561,474 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.048 | 0.9460 | [-0.0089, 0.0099] | 51 |   561,474 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.454 | 0.8987 | [     .,      .] | 51 |   561,474 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0011 |  0.501 | 0.6420 | [-0.0028, 0.0060] | 51 |   561,474 |

# ppent_at (Net PP&E / Assets)

## Baseline

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0022 | -0.480 | 0.6561 | [-0.0110, 0.0065] | 54 |   663,553 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0019 | -0.633 | 0.5680 | [-0.0071, 0.0040] | 54 |   663,553 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0041 | -0.964 | 0.3891 | [-0.0120, 0.0038] | 54 |   663,553 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.409 | 0.8366 | [     .,      .] | 54 |   663,553 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0028 | -0.544 | 0.6351 | [-0.0126, 0.0064] | 54 |   663,553 |

## Baseline (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0010 | -0.211 | 0.8419 | [-0.0103, 0.0077] | 54 |   663,153 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0015 | -0.458 | 0.6752 | [-0.0072, 0.0049] | 54 |   663,153 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0038 | -0.814 | 0.4716 | [-0.0125, 0.0049] | 54 |   663,153 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.449 | 0.8157 | [     .,      .] | 54 |   663,153 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0013 |  0.310 | 0.7461 | [-0.0056, 0.0077] | 54 |   663,153 |

## Baseline (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0040 | -0.751 | 0.5037 | [-0.0141, 0.0060] | 54 |   658,988 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0027 | -0.808 | 0.4779 | [-0.0091, 0.0040] | 54 |   658,988 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0041 | -0.837 | 0.4722 | [-0.0139, 0.0051] | 54 |   658,988 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  0.265 | 0.9076 | [     .,      .] | 54 |   658,988 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0002 |  0.028 | 0.9811 | [-0.0109, 0.0106] | 54 |   658,988 |

## Left populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0102 | -1.766 | 0.1982 | [-0.0235, 0.0031] | 50 |   654,700 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0001 | -0.017 | 0.9873 | [-0.0101, 0.0095] | 50 |   654,700 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0181 | -3.444 | 0.0356 ** | [-0.0308, -0.0042] | 50 |   654,700 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 16.107 | 0.0009 ** | [     .,      .] | 50 |   654,700 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0039 | -0.358 | 0.7930 | [-0.0273, 0.0220] | 50 |   654,700 |

## Left populists (excl. Indonesia)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0122 | -1.699 | 0.2198 | [-0.0297, 0.0036] | 50 |   654,300 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0005 | -0.080 | 0.9524 | [-0.0152, 0.0121] | 50 |   654,300 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0244 | -4.094 | 0.0103 ** | [-0.0389, -0.0093] | 50 |   654,300 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . | 33.248 | 0.0004 ** | [     .,      .] | 50 |   654,300 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0102 |  0.818 | 0.5679 | [-0.0184, 0.0361] | 50 |   654,300 |

## Right populists

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | 0.0011 |  0.228 | 0.8560 | [-0.0078, 0.0100] | 51 |   662,388 |
| pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0023 | -0.696 | 0.5527 | [-0.0080, 0.0045] | 51 |   662,388 |
| pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | -0.0001 | -0.016 | 0.9915 | [-0.0070, 0.0092] | 51 |   662,388 |
| pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.458 | 0.4007 | [     .,      .] | 51 |   662,388 |
| att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | -0.0009 | -0.263 | 0.7737 | [-0.0071, 0.0041] | 51 |   662,388 |

## Right populists (excl. Thailand)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| robustness_pretrend | no differential pre-trend at t=-4 (H0: coefficient on d0 = 0) | -0.0013 | -0.221 | 0.8604 | [-0.0134, 0.0107] | 51 |   657,823 |
| robustness_pretrend | no differential pre-trend at t=-3 (H0: coefficient on d1 = 0) | -0.0036 | -0.913 | 0.4333 | [-0.0114, 0.0046] | 51 |   657,823 |
| robustness_pretrend | no differential pre-trend at t=-2 (H0: coefficient on d2 = 0) | 0.0002 |  0.040 | 0.9822 | [-0.0091, 0.0119] | 51 |   657,823 |
| robustness_pretrend_joint | no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F) |      . |  1.868 | 0.3225 | [     .,      .] | 51 |   657,823 |
| robustness_att | no average treatment effect in periods 0-3 (H0: coefficient on post = 0) | 0.0033 |  1.021 | 0.3288 | [-0.0028, 0.0083] | 51 |   657,823 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; check the actual magnitude and CI, not just significance.)*
