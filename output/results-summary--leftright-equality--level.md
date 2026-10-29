# Left vs. Right Populists: Formal Equality Test (29 Oct 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. ONE shared set of entropy-balance weights, targeting the combined Left+Right treated group's ch_at pre-trend - see the do-file header for why this differs from 09_estimates-outcome-battery.do's separately-weighted Left-only/Right-only sections. 

**How to read this table:** 'arm_equality'/'arm_equality_att' rows test whether Left's and Right's effects DIFFER (H0: they're equal) - a low p-value here is evidence Left and Right populists have genuinely different effects, not just different point estimates. 'att_pooledweight' rows are each arm's own ATT under the shared weighting scheme, included as a reference point, not a headline result.

# act_at (Current Assets / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.593 | 0.2264 | [-0.0190, 0.0446] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.370 | 0.7402 | [-0.0310, 0.0197] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  0.621 | 0.5959 | [-0.0135, 0.0397] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  1.710 | 0.1641 | [-0.0057, 0.0212] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.765 | 0.1423 | [-0.0043, 0.0329] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  2.543 | 0.1270 | [-0.0040, 0.0463] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  0.463 | 0.6826 | [-0.0596, 0.0297] | 54 |   566,311 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  0.963 | 0.6808 | [     .,      .] | 54 |   566,311 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  0.867 | 0.6667 | [     .,      .] | 54 |   566,311 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  1.728 | 0.2336 | [-0.0160, 0.0296] | 54 |   566,311 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0046 |  0.564 | 0.6187 | [-0.0318, 0.0213] | 54 |   566,311 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0088 | -1.730 | 0.1327 | [-0.0188, 0.0007] | 54 |   566,311 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0020 | -0.211 | 0.8559 | [-0.0379, 0.0268] | 54 |   566,311 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0082 | -1.296 | 0.2981 | [-0.0202, 0.0046] | 54 |   566,311 |

# act_ex_ch_at (Current Assets ex. Cash / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  0.359 | 0.7615 | [-0.0178, 0.0369] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.122 | 0.9125 | [-0.0209, 0.0202] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.043 | 0.9720 | [-0.0189, 0.0255] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  1.300 | 0.2499 | [-0.0024, 0.0257] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.952 | 0.0726 ** | [0.0020, 0.0589] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  3.029 | 0.0068 ** | [0.0150, 0.0776] | 54 |   566,311 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  4.164 | 0.0144 ** | [0.0167, 0.0499] | 54 |   566,311 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  0.041 | 0.9845 | [     .,      .] | 54 |   566,311 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  1.129 | 0.5179 | [     .,      .] | 54 |   566,311 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  3.008 | 0.0077 ** | [0.0107, 0.0490] | 54 |   566,311 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0252 |  3.717 | 0.0264 ** | [0.0120, 0.0533] | 54 |   566,311 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0006 |  0.124 | 0.9151 | [-0.0099, 0.0111] | 54 |   566,311 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0240 |  3.896 | 0.0236 ** | [0.0140, 0.0511] | 54 |   566,311 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0007 |  0.119 | 0.9239 | [-0.0118, 0.0133] | 54 |   566,311 |

# ao_at (Other Assets / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  0.507 | 0.6680 | [-0.0136, 0.0163] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.620 | 0.4898 | [-0.0033, 0.0120] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  3.464 | 0.0110 ** | [0.0084, 0.0376] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.907 | 0.2227 | [-0.0284, 0.0013] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.185 | 0.8461 | [-0.0151, 0.0252] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.807 | 0.4868 | [-0.0169, 0.0067] | 54 |   713,592 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.412 | 0.7065 | [-0.0182, 0.0222] | 54 |   713,592 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  6.941 | 0.3486 | [     .,      .] | 54 |   713,592 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  8.315 | 0.0047 ** | [     .,      .] | 54 |   713,592 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.974 | 0.5763 | [-0.0170, 0.0100] | 54 |   713,592 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0016 |  0.311 | 0.7848 | [-0.0086, 0.0195] | 54 |   713,592 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0070 |  2.868 | 0.0458 ** | [0.0014, 0.0135] | 54 |   713,592 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0009 | -0.110 | 0.9325 | [-0.0180, 0.0255] | 54 |   713,592 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0119 |  3.332 | 0.0255 ** | [0.0034, 0.0216] | 54 |   713,592 |

# ch_at (Cash / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -0.074 | 0.9514 | [-0.0394, 0.0170] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -0.574 | 0.6530 | [-0.0425, 0.0086] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.172 | 0.8807 | [-0.0262, 0.0111] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -0.249 | 0.8262 | [-0.0300, 0.0118] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.893 | 0.5216 | [-0.0253, 0.0103] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -1.727 | 0.0914 ** | [-0.0451, -0.0002] | 54 |   721,889 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -1.737 | 0.0451 ** | [-0.0604, -0.0019] | 54 |   721,889 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  1.665 | 0.4259 | [     .,      .] | 54 |   721,889 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  0.146 | 0.9627 | [     .,      .] | 54 |   721,889 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -1.302 | 0.2461 | [-0.0366, 0.0039] | 54 |   721,889 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0201 | -2.668 | 0.0285 ** | [-0.0522, -0.0060] | 54 |   721,889 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0096 | -2.078 | 0.1263 | [-0.0202, 0.0006] | 54 |   721,889 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0179 | -2.986 | 0.0867 ** | [-0.0339, -0.0019] | 54 |   721,889 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0094 | -2.085 | 0.0877 ** | [-0.0199, -0.0004] | 54 |   721,889 |

# intan_at (Intangibles / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -0.856 | 0.4185 | [-0.0177, 0.0133] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -1.673 | 0.3148 | [-0.0148, 0.0116] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -1.061 | 0.5258 | [-0.0212, 0.0087] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.364 | 0.2119 | [-0.0130, 0.0017] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -1.994 | 0.0829 ** | [-0.0205, -0.0006] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.591 | 0.5940 | [-0.0182, 0.0049] | 54 |   655,761 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.450 | 0.6824 | [-0.0319, 0.0076] | 54 |   655,761 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  0.779 | 0.9265 | [     .,      .] | 54 |   655,761 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  4.334 | 0.0156 ** | [     .,      .] | 54 |   655,761 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -1.047 | 0.3025 | [-0.0196, 0.0018] | 54 |   655,761 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0048 | -1.237 | 0.2316 | [-0.0233, 0.0016] | 54 |   655,761 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0005 | -0.210 | 0.8601 | [-0.0053, 0.0039] | 54 |   655,761 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0019 | -0.340 | 0.7337 | [-0.0272, 0.0072] | 54 |   655,761 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0027 | -0.692 | 0.5315 | [-0.0106, 0.0050] | 54 |   655,761 |

# invt_at (Inventories / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -0.021 | 0.9846 | [-0.0081, 0.0056] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.339 | 0.7629 | [-0.0056, 0.0109] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.692 | 0.5342 | [-0.0072, 0.0032] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -0.364 | 0.7717 | [-0.0110, 0.0084] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -1.143 | 0.4229 | [-0.0170, 0.0072] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  1.424 | 0.2752 | [-0.0060, 0.0183] | 54 |   659,596 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  0.643 | 0.5680 | [-0.0182, 0.0162] | 54 |   659,596 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  1.444 | 0.4032 | [     .,      .] | 54 |   659,596 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  0.529 | 0.8425 | [     .,      .] | 54 |   659,596 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  0.241 | 0.8672 | [-0.0090, 0.0105] | 54 |   659,596 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0015 |  0.601 | 0.6159 | [-0.0042, 0.0064] | 54 |   659,596 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0006 |  0.247 | 0.8917 | [-0.0043, 0.0057] | 54 |   659,596 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0034 |  1.274 | 0.2755 | [-0.0030, 0.0084] | 54 |   659,596 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0024 |  0.960 | 0.4433 | [-0.0027, 0.0075] | 54 |   659,596 |

# ivaeq_at (Equity Investments / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.062 | 0.4380 | [-0.0045, 0.0102] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -0.793 | 0.5234 | [-0.0073, 0.0075] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.766 | 0.7671 | [-0.0085, 0.0038] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  2.756 | 0.0428 ** | [0.0031, 0.0343] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.774 | 0.2992 | [-0.0027, 0.0316] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  3.134 | 0.0129 ** | [0.0061, 0.0314] | 54 |   559,378 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  2.607 | 0.0105 ** | [0.0044, 0.0429] | 54 |   559,378 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . | 15.112 | 0.1326 | [     .,      .] | 54 |   559,378 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  3.007 | 0.2112 | [     .,      .] | 54 |   559,378 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  2.760 | 0.0156 ** | [0.0045, 0.0326] | 54 |   559,378 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0178 |  2.632 | 0.0549 ** | [0.0028, 0.0319] | 54 |   559,378 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0012 | -1.476 | 0.1751 | [-0.0026, 0.0003] | 54 |   559,378 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0172 |  2.369 | 0.0757 ** | [0.0016, 0.0324] | 54 |   559,378 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0022 | -1.390 | 0.3091 | [-0.0060, 0.0008] | 54 |   559,378 |

# ivao_at (Other Investments / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.590 | 0.3315 | [-0.0278, 0.0271] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  1.924 | 0.1639 | [-0.0037, 0.0218] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  0.714 | 0.5582 | [-0.0082, 0.0102] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.688 | 0.3889 | [-0.0294, 0.0069] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.750 | 0.6464 | [-0.0329, 0.0248] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.550 | 0.6919 | [-0.0347, 0.0275] | 54 |   566,225 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.620 | 0.6748 | [-0.0367, 0.0253] | 54 |   566,225 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  4.360 | 0.4695 | [     .,      .] | 54 |   566,225 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  0.324 | 0.8761 | [     .,      .] | 54 |   566,225 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.835 | 0.6458 | [-0.0331, 0.0198] | 54 |   566,225 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0068 | -0.585 | 0.6996 | [-0.0295, 0.0205] | 54 |   566,225 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0031 |  1.381 | 0.1917 | [-0.0008, 0.0082] | 54 |   566,225 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0128 | -1.082 | 0.6976 | [-0.0362, 0.0142] | 54 |   566,225 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0038 |  1.091 | 0.3303 | [-0.0021, 0.0115] | 54 |   566,225 |

# ppent_at (Net PP&E / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |
|---|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -1.835 | 0.3077 | [-0.0320, 0.0167] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.322 | 0.7765 | [-0.0074, 0.0225] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -2.058 | 0.2451 | [-0.0383, 0.0074] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  0.236 | 0.8907 | [-0.0365, 0.0481] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.301 | 0.7860 | [-0.0420, 0.0248] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.379 | 0.8217 | [-0.0519, 0.0397] | 54 |   663,553 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.318 | 0.7943 | [-0.0458, 0.0455] | 54 |   663,553 |
| pretrend_joint_left | no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F) |      . |  3.166 | 0.4573 | [     .,      .] | 54 |   663,553 |
| pretrend_joint_right | no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F) |      . |  2.103 | 0.2399 | [     .,      .] | 54 |   663,553 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.209 | 0.8710 | [-0.0423, 0.0372] | 54 |   663,553 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0052 | -0.339 | 0.7961 | [-0.0422, 0.0485] | 54 |   663,553 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0021 | -0.565 | 0.5435 | [-0.0086, 0.0032] | 54 |   663,553 |
| att_rebaselined_left | no average Left-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | 0.0034 |  0.199 | 0.8800 | [-0.0388, 0.0514] | 54 |   663,553 |
| att_rebaselined_right | no average Right-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression | -0.0021 | -0.371 | 0.7085 | [-0.0132, 0.0069] | 54 |   663,553 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance.)*
