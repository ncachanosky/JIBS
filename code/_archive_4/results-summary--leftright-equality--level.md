# Left vs. Right Populists: Formal Equality Test (13 Aug 2026)

Wild cluster bootstrap inference (Webb weights, null imposed, 9999 replications), clustered by country. ONE shared set of entropy-balance weights, targeting the combined Left+Right treated group's ch_at pre-trend - see the do-file header for why this differs from estimates-outcome-battery.do's separately-weighted Left-only/Right-only sections. 

**How to read this table:** 'arm_equality'/'arm_equality_att' rows test whether Left's and Right's effects DIFFER (H0: they're equal) - a low p-value here is evidence Left and Right populists have genuinely different effects, not just different point estimates. 'att_pooledweight' rows are each arm's own ATT under the shared weighting scheme, included as a reference point, not a headline result.

# act_at (Current Assets / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.592 | 0.2326 | [-0.0200, 0.0445] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.369 | 0.7468 | [-0.0305, 0.0197] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  0.621 | 0.6094 | [-0.0139, 0.0402] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  1.706 | 0.1600 | [-0.0050, 0.0211] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.763 | 0.1417 | [-0.0034, 0.0329] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  2.544 | 0.1299 | [-0.0043, 0.0466] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  0.461 | 0.6793 | [-0.0617, 0.0293] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  1.726 | 0.2353 | [-0.0170, 0.0297] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0046 |  0.565 | 0.6105 | [-0.0319, 0.0212] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0087 | -1.725 | 0.1318 | [-0.0182, 0.0007] | 54 |

# act_ex_ch_at (Current Assets ex. Cash / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  0.359 | 0.7555 | [-0.0173, 0.0369] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.122 | 0.9126 | [-0.0219, 0.0202] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.043 | 0.9711 | [-0.0191, 0.0254] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  1.297 | 0.2486 | [-0.0025, 0.0258] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.951 | 0.0676 ** | [0.0025, 0.0593] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  3.029 | 0.0069 ** | [0.0148, 0.0778] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  4.166 | 0.0149 ** | [0.0172, 0.0502] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  3.007 | 0.0070 ** | [0.0107, 0.0499] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0252 |  3.720 | 0.0261 ** | [0.0122, 0.0527] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0007 |  0.130 | 0.9090 | [-0.0098, 0.0111] | 54 |

# ao_at (Other Assets / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  0.510 | 0.6549 | [-0.0136, 0.0163] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.622 | 0.4811 | [-0.0033, 0.0116] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  3.464 | 0.0102 ** | [0.0084, 0.0376] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.905 | 0.2259 | [-0.0284, 0.0013] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.183 | 0.8460 | [-0.0151, 0.0254] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.804 | 0.4808 | [-0.0168, 0.0065] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.410 | 0.7026 | [-0.0181, 0.0220] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.971 | 0.5715 | [-0.0170, 0.0096] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0016 |  0.310 | 0.7847 | [-0.0086, 0.0189] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0070 |  2.867 | 0.0474 ** | [0.0014, 0.0135] | 54 |

# ch_at (Cash / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -0.074 | 0.9515 | [-0.0394, 0.0170] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -0.574 | 0.6528 | [-0.0425, 0.0086] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.172 | 0.8805 | [-0.0262, 0.0111] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -0.249 | 0.8263 | [-0.0300, 0.0118] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.893 | 0.5214 | [-0.0253, 0.0103] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -1.727 | 0.0914 ** | [-0.0451, -0.0002] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -1.737 | 0.0451 ** | [-0.0604, -0.0019] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -1.302 | 0.2553 | [-0.0370, 0.0041] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0201 | -2.668 | 0.0323 ** | [-0.0525, -0.0059] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0096 | -2.078 | 0.1228 | [-0.0202, 0.0006] | 54 |

# intan_at (Intangibles / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -0.856 | 0.4268 | [-0.0177, 0.0140] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -1.673 | 0.3117 | [-0.0148, 0.0120] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -1.061 | 0.5226 | [-0.0212, 0.0087] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.364 | 0.2176 | [-0.0130, 0.0017] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -1.994 | 0.0898 ** | [-0.0204, -0.0003] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.591 | 0.5958 | [-0.0181, 0.0049] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.450 | 0.6821 | [-0.0319, 0.0075] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -1.047 | 0.3044 | [-0.0195, 0.0018] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0048 | -1.237 | 0.2320 | [-0.0233, 0.0016] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0005 | -0.211 | 0.8596 | [-0.0053, 0.0039] | 54 |

# ivaeq_at (Equity Investments / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.061 | 0.4319 | [-0.0045, 0.0102] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . | -0.793 | 0.5273 | [-0.0073, 0.0075] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -0.766 | 0.7747 | [-0.0085, 0.0038] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  2.756 | 0.0411 ** | [0.0031, 0.0343] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . |  1.774 | 0.2886 | [-0.0027, 0.0316] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . |  3.134 | 0.0141 ** | [0.0061, 0.0314] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . |  2.607 | 0.0114 ** | [0.0044, 0.0420] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . |  2.760 | 0.0161 ** | [0.0038, 0.0326] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | 0.0178 |  2.632 | 0.0567 ** | [0.0028, 0.0319] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0012 | -1.477 | 0.1770 | [-0.0026, 0.0003] | 54 |

# ivao_at (Other Investments / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . |  1.590 | 0.3286 | [-0.0274, 0.0271] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  1.924 | 0.1697 | [-0.0037, 0.0218] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . |  0.714 | 0.5558 | [-0.0087, 0.0102] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . | -1.688 | 0.3859 | [-0.0294, 0.0069] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.750 | 0.6434 | [-0.0330, 0.0248] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.550 | 0.6788 | [-0.0344, 0.0272] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.620 | 0.6765 | [-0.0362, 0.0251] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.835 | 0.6616 | [-0.0329, 0.0198] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0068 | -0.585 | 0.6890 | [-0.0297, 0.0205] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | 0.0031 |  1.382 | 0.1897 | [-0.0008, 0.0082] | 54 |

# ppent_at (Net PP&E / Assets)

| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |
|---|---|---|---|---|---|---|
| arm_equality | Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0) |      . | -1.835 | 0.3047 | [-0.0321, 0.0172] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1) |      . |  0.322 | 0.7772 | [-0.0073, 0.0224] | 54 |
| arm_equality | Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2) |      . | -2.058 | 0.2441 | [-0.0378, 0.0069] | 54 |
| arm_equality | Left and Right populists have the same effect at t=0 (H0: dL4 = dR4) |      . |  0.236 | 0.8956 | [-0.0362, 0.0457] | 54 |
| arm_equality | Left and Right populists have the same effect at t=1 (H0: dL5 = dR5) |      . | -0.301 | 0.7767 | [-0.0419, 0.0249] | 54 |
| arm_equality | Left and Right populists have the same effect at t=2 (H0: dL6 = dR6) |      . | -0.379 | 0.8163 | [-0.0515, 0.0409] | 54 |
| arm_equality | Left and Right populists have the same effect at t=3 (H0: dL7 = dR7) |      . | -0.317 | 0.8001 | [-0.0459, 0.0470] | 54 |
| arm_equality_att | Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR) |      . | -0.209 | 0.8683 | [-0.0422, 0.0373] | 54 |
| att_pooledweight | no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0) | -0.0052 | -0.339 | 0.7945 | [-0.0424, 0.0459] | 54 |
| att_pooledweight | no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0) | -0.0021 | -0.565 | 0.5393 | [-0.0086, 0.0032] | 54 |

*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance.)*
