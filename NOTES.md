# NOTES — JIBS (inference with very few country clusters)

> Durable project knowledge on **statistical inference in our stacked DiD when a
> sub-region / income-group split leaves only 2–7 country clusters**. Self-contained:
> a future session should be able to implement the correct method from this file alone,
> and should be able to read off which splits (G = 2, 3, 4, 7) can support valid
> inference and which cannot. Mirrors the house style of `ideology-efw/NOTES.md`.
>
> Scope note: this file is about **inference**, not identification. It does not touch
> the entropy-balancing / event-study specification, only the SEs / p-values / CIs
> attached to it.

---

## 0. TL;DR — what we were doing wrong / recommended fix

**What we were doing wrong.** Our randomization-inference (RI) scheme reshuffled *which
of the few treated countries is treated*, holding the number of treated countries fixed
within each cohort. With only `G1` treated countries out of `G` total, the number of
distinct treatment assignments is `C(G, G1)` (eq. 37 below). For a two-region split with
`G = 2` countries the reshuffle set has essentially 2 arrangements, so the finest
achievable two-sided p-value is ≈ 0.5 — **the test can never reject, by construction, no
matter how large the effect.** This is *not* "RI done wrong in a fixable way"; it is the
correct diagnosis that **RI over the treated clusters is uninformative when treated
clusters are few** (MacKinnon & Webb 2020; Alvarez, Ferman & Wüthrich 2026). Permuting
treatment *timing* among 2–4 countries does **not** rescue it either — the assignment
space is still tiny.

**The fix (recognized, valid scheme).** The re-randomization set is enlarged **not** by
reshuffling among the treated countries but by using the **many control countries as
placebo-treated units** and comparing the observed statistic to the empirical distribution
of the *same statistic computed on the controls*. This is the **Conley–Taber (2011)** /
**Ferman–Pinto (2019)** logic, extended to **staggered adoption + heterogeneous effects**
by **Alvarez & Ferman (2023a)**, and it is asymptotically equivalent to the **RI-t**
variant of **MacKinnon & Webb (2020)** (studentized, i.e. based on cluster-robust
t-statistics rather than raw coefficients). Validity comes from `N0 → ∞` (many controls),
**not** from `G1 → ∞`, so it works even with `G1 = 1` treated country — *provided* enough
control countries and homogeneity/exchangeability of the control errors.

**Threshold, read straight off theory.** With `N0` control clusters the RI/permutation
p-value can be no smaller than `1/(N0+1)`. So:

- rejection at **10%** requires roughly **`N0 ≥ 10`** control countries;
- rejection at **5%** requires roughly **`N0 ≥ 20`** control countries
  (Alvarez, Ferman & Wüthrich 2026, §4.1.1).

The binding constraint in our splits is therefore the **number of CONTROL countries in
the split, not the number of treated ones.** If a split has < ~10 control countries after
subsetting, *no* permutation/RI method can deliver a 10% rejection and we must say so.

**Bottom line for our splits — why RI CANNOT be done here.** A permutation test's reference
distribution is bounded by whichever margin is small, and in our region/income splits
**both margins are tiny.** Reshuffling among treated countries gives only `C(G, G1)` points
(§4); using control countries as placebos gives only ≈ `N0 + 1` points — but after
subsetting to a region the **control pool is itself just 1–5 countries** (§6). So *every*
within-split permutation scheme is degenerate on one side or the other: the finest
achievable p-value is ≈ 0.17–0.50, and the test cannot reject at conventional levels no
matter how large the true effect. The only way to obtain a large reference distribution is
to draw placebo adopters from control countries **outside the split** (a global
never-adopter pool), which no longer tests a within-region null. The honest report for the
region splits and the 2-country income split is therefore a **descriptive point estimate**
with the p-value ceiling `1 / min( C(G,G1), N0+1 )` stated explicitly — **not** a WCB CI
(empty/degenerate) and **not** a naive clustered t (over-rejects). Only the WB Upper-middle
(14) and High-income (37) splits have enough countries for valid inference, and those never
needed RI — the wild cluster bootstrap already works there.

---

## 1. The core problem, precisely

Our estimator clusters on `iso` (country). The number of clusters `G` **is** the number
of countries in the split (2–7), because a country's errors are correlated across the
cohorts it appears in — clustering on `firm_id` or `gvkey` would be wrong. Cluster-robust
asymptotics need **`G → ∞`** (more firms *within* a country does not help), so with
`G ∈ {2,…,7}`:

- The CRVE `t`-statistic with `t(G−1)` critical values **over-rejects severely**
  (Cameron–Miller 2015; MacKinnon, Nielsen & Webb 2023).
- What actually matters is not the *share* of treated units but the **number of treated
  clusters `G1`** (Alvarez, Ferman & Wüthrich 2026, Remark 2). In our design *all firms
  in a treated country-cohort are treated*, so `G1` = number of treated countries in the
  split, which is tiny (e.g. WB Lower-middle income: `G1 = 2`).
- The wild cluster bootstrap (`boottest`, Webb weights) **fails** here: with few treated
  clusters the WCR bootstrap distribution depends on the value of the test statistic,
  becomes bimodal, and **under-rejects** — in the extreme returning **no CI at all**.
  This matches exactly what we observed. See MacKinnon, Nielsen & Webb (2023, §5.3):
  "*it can sometimes perform very badly when the number of treated clusters `G1` is very
  small … the WCR bootstrap usually under-rejects in this case … rejection frequencies
  may be essentially zero.*"

Because `2^G` (Rademacher) or `6^G` (Webb) is *smaller than `B`* when `G` is small,
`boottest` enumerates instead of resampling — but enumeration cannot manufacture support
points that the design does not contain, hence the empty/degenerate CI. Webb 6-point
weights help below 11 clusters relative to Rademacher, but **do not** cure the
**few-treated-cluster** failure — that is a different problem (few `G1`, not few `G`).

---

## 2. Randomization inference done correctly — MacKinnon & Webb (2020)

### 2.1 The RI construction and the exact-test logic
Let `G` clusters, `G1` treated. The number of ways treatment could have been assigned is

    G C G1  =  G! / [ G1! (G − G1)! ]          (eq. 37, MNW 2023)

One of these is the actual assignment; the remaining `S = (G C G1) − 1` are
**re-randomizations**. For each, pretend a different set of `G1` clusters was treated
(the *outcomes never change, only the treatment dummy*), refit, and collect a statistic
`τ*_j`. The RI p-value for an upper-tail test is (eq. 38):

    P1* = (1/S) Σ_j 1{τ*_j ≥ τ}          or
    P2* = (1/(S+1)) ( 1 + Σ_j 1{τ*_j ≥ τ} )     (P2* includes the actual assignment; more conservative, more common)

The test is **exact in finite samples** *iff* the `τ*_j` are exchangeable with `τ` under
the sharp null — i.e. under `H0: treatment has no effect on any unit`. This is the
Fisher (1935) exact-test logic (Lehmann & Romano 2005, ch. 15; Imbens & Rubin 2015, ch. 15).

### 2.2 RI-β vs RI-t, and why studentization matters
MacKinnon & Webb (2020) study **two** test statistics:

| Variant | Statistic `τ` | Behaviour |
|---|---|---|
| **RI-β** | the estimated **coefficient** on the treatment dummy | Works well only when clusters are homogeneous; **unreliable when treated clusters are systematically larger/smaller** than controls. |
| **RI-t** | the **cluster-robust `t`-statistic** (studentized) | **Recommended.** More robust under the null when clusters are heterogeneous, at the cost of some power. |

Studentization (RI-t) matters because our few treated clusters are heterogeneous
(different countries, different firm counts, entropy-balancing weights differ across
draws). MNW (2023, §6.2): "*when the treated clusters are systematically larger or
smaller than average, neither RI-β nor RI-t tests perform well, although the latter
typically perform better. In such cases, G may have to be quite large (much larger than
for the WCR bootstrap) before either procedure works really well.*" **This is the crux:
RI over the treated clusters needs `G` *large*, not small — it does not solve our
problem.** RI-t is the least-bad choice *if* one insists on treated-cluster reshuffling,
but the honest reading is that treated-cluster RI is not the right tool at `G ≤ 7`.

### 2.3 How treatment is permuted; staggered adoption
- **Permute assignment, not (only) timing.** The canonical RI reshuffles *which clusters*
  are treated. Our within-cohort "hold the count fixed, reassign which country is treated"
  is exactly RI-β/RI-t over cluster assignment — a **recognized scheme** — but its
  re-randomization set is `C(G, G1)`, which is tiny in our splits.
- **Staggered adoption.** Because each cohort is a separate sub-experiment with its own
  treated country-year, RI must respect the block structure: reassign treatment *within
  the admissible set of that cohort*, then aggregate the event-study coefficients. This
  is the design-respecting permutation for a stacked/staggered design (cf. Shaikh &
  Toulis 2021; Roth & Sant'Anna 2023 discuss design-based DiD with staggered adoption).
  **But reshuffling timing among 2–4 countries does not enlarge the space meaningfully.**

### 2.4 The correct sharp null and admissible re-randomizations for OUR stacked design
- **Sharp null:** `H0: Y_it(1) = Y_it(0)` for every firm-period (no effect on any unit,
  any cohort). Under this null the observed log-cash is invariant to the treatment label,
  which is what licenses the permutation.
- **Admissible re-randomizations:** the set of counterfactual treatment labelings that
  are *ex-ante equally likely given the design*. In our stacked design the design-honest
  set is "within each cohort, which country-copy is treated" — but since treatment is a
  **country×cohort** property and control units are cohort-specific copies, the natural
  and *informative* enlargement is to let **each control country stand in as a
  placebo-treated country** (this is §3.3 below). That is the move that grows the
  reference distribution from `C(G,G1)` (tiny) to ≈ `N0` support points (large).

**Key granularity fact (write this on the wall):** the finest achievable p-value is
`1 / (number of distinct rearrangements)`. Reshuffle among treated → `1/C(G,G1)` ≈ 0.5 at
`G=2`. Reshuffle using controls as placebos → `1/(N0+1)`. **Only the second is
informative.**

---

## 3. Methods for EXTREMELY few clusters (2–7), compared

Notation: `G1` = # treated countries, `N0`/`G−G1` = # control countries.
"Works at G=…" refers to the treated count `G1` unless stated, and assumes the control
pool is large enough where the method needs `N0 → ∞`.

| Method | Ref | G1 = 1 | G1 = 2 | G1 = 3–4 | G1 = 5–7 | Key assumption / caveat |
|---|---|---|---|---|---|---|
| CRVE + t(G−1) | Cameron–Miller 2015 | ✗ | ✗ | ✗ | ✗ (over-rejects) | Needs `G → ∞`. Never trust at these counts. |
| WCR (wild cluster) bootstrap, Webb wts | CGM 2008; Webb 2023; MacKinnon–Webb 2018 | ✗ (bimodal, ~0 rej.) | ✗ (often no CI) | ✗/△ under-rejects | △ marginal | Fails with few **treated** clusters — our observed failure. |
| Subcluster wild bootstrap | MacKinnon–Webb 2018 | △ | △ | △ | △ | Aimed at few-treated case; can over- **or** under-reject "dramatically"; not a clean fix. |
| **RI-β** (coefficient) | MacKinnon–Webb 2020 | trivial `p=1` | `p∈{.5,1}` only | coarse | coarse | Reshuffles treated clusters; degenerate at low `G1`; sensitive to cluster heterogeneity. |
| **RI-t** (studentized) | MacKinnon–Webb 2020 | trivial | coarse | coarse | better, still needs large `G` | Best treated-cluster RI, but needs `G` **large** to be reliable. |
| **Conley–Taber / placebo-in-controls** | Conley–Taber 2011; Ferman–Pinto 2019 | **✓** | **✓** | **✓** | **✓** | Validity from `N0 → ∞`; assumes control errors iid/exchangeable & homogeneous effects. **Our recommended core.** |
| CT extended to staggered + heterog. FX | Alvarez & Ferman 2023a | ✓ | ✓ | ✓ | ✓ | Same, but allows variation in treatment timing & heterogeneous effects; gives uniform event-study bands. **Directly matches our design.** |
| Ibragimov–Müller (group t-test) | Ibragimov–Müller 2010; 2016 | ✗ | △ (`G1≥2`) | ✓ (conservative) | ✓ | Needs each *group* large enough for a within-group CLT; in DiD may require **coarsening** clusters (merge treated+control) → power loss. Invalid/trivial power if min(G1, controls)=1. |
| Sign-changes / approx. randomization | Canay, Romano & Shaikh 2017; Canay–Santos–Shaikh 2021; Cai et al. 2023 | trivial | trivial (`p∈{.5,1}`) | needs ≥5 (10%) / ≥6 (5%) | ✓ | Group `{−1,1}^{G1}`: needs **≥5 treated** for non-trivial 10%, **≥6** for 5%. Assumes symmetry of `(τ_j−τ*)+ε_j`. |
| Design-based / finite-population | Abadie–Athey–Imbens–Wooldridge 2020, 2022 | ✗ | ✗ | ✗ | ✗ | Needs # treated **and** # controls → ∞; performs poorly with few treated (same failure as §1). Useful conceptually for *why* to cluster, not for our SEs. |
| Synthetic control / SDID placebo | Abadie et al. 2010; Arkhangelsky et al. 2021 | ✓ (placebo) | ✓ | ✓ | ✓ | Placebo inference reassigns treatment to controls (same logic as CT). SDID jackknife SE **undefined** if any adoption period has a single treated unit. Different estimand than ours. |

### 3.1 Ibragimov–Müller (t-test with few groups)
Estimate the parameter **separately in each of `q ≥ 2` independent groups**, then run a
**standard `t`-test on the `q` group estimates** with `t(q−1)` critical values. Valid for
few *heterogeneous, large* groups. In a **treatment** DiD every group must contain both
treated and control units, so you must **coarsen** (merge a treated country with some
controls into each group), which reduces the effective number of groups and costs power.
Ibragimov–Müller (2016) give the sample-size/significance conditions under which the
unequal-variance (Welch) t-test is *conservative*. Under an equal-variance assumption
across groups this collapses to a modified Bester–Conley–Hansen (2011) test that is exact
regardless of sample size (Alvarez, Ferman & Wüthrich 2026, App. D.2). **Practical:**
needs `G1 ≥ 2` and enough controls to form ≥ ~2–4 balanced groups; realistic only for our
`G = 7` splits.

### 3.2 Sign-changes / approximate randomization (Canay–Romano–Shaikh)
Cluster the data into `G1` groups (one treated each), compute a group-level estimator,
and apply the sign-change group `{−1,1}^{G1}`. **Hard power floor:** the p-value can never
be below `1/2^{G1}`, so the test has *trivial power* for `α < 2^{-G1}`. Concretely:
**`G1 = 1` → p=1 always; `G1 = 2` → p ∈ {0.5, 1} only; need ≥5 treated for a non-trivial
10% test, ≥6 for 5%** (Cai et al. 2023). Assumes `(τ_j − τ*) + ε_j` symmetric about zero
(allows heteroskedasticity & stochastic effect heterogeneity, but **not** deterministic
effect heterogeneity). **This is the same granularity wall we hit with treated-cluster RI**
— it confirms the diagnosis rather than escaping it.

### 3.3 Conley–Taber (2011) — the recommended core, and why it escapes the wall
Idea: the DiD estimator with `G1` fixed is **not consistent**, but under `N0 → ∞` its
asymptotic distribution can be **recovered from the residuals of the many control units**.
Concretely, compute the treated-unit statistic `τ̂`, then compute the *same* placebo
statistic `Ŵ_j` for each control country (as if it were treated), and form (AFW 2026,
eq. 10):

    p = (1/N0) Σ_{j∈controls} 1{ |Ŵ_j| ≥ |τ̂ − c| }

valid as `N0 → ∞` for a two-sided test of `H0: τ* = c`. **This is a permutation test whose
reference set has ≈ `N0` support points, not `C(G,G1)`** — which is exactly why it dodges
the degeneracy. Assumptions: control errors `W_j` iid (or weakly dependent — see below)
across control countries, treated errors drawn from the same distribution, and
**homogeneous treatment effects** (deterministic heterogeneity allowed only asymptotically).
CIs by test inversion. AFW (2026) recommend a **finite-`N0` exact** re-implementation
(their App. C.1) that is a genuine permutation test and does not rely on `N0 → ∞`.

**Ferman–Pinto (2019)** extend CT to **heteroskedastic** control errors (e.g. treated
country much smaller than controls → larger error variance): rescale the `Ŵ_j` by an
estimated heteroskedasticity function `σ(X_j)` before forming the reference distribution.
Relevant for us because country size / firm-count varies a lot across the control pool.

**Alvarez & Ferman (2023a)** extend CT and Ferman–Pinto to **staggered adoption and
heterogeneous treatment effects**, estimate each `α_{j,t}` separately then aggregate, and
derive **uniform confidence bands for dynamic (event-study) DiD** valid with `N1` fixed
(incl. `N1 = 1`) — i.e. exactly the event-study object we plot. **This is the closest
published match to our setting** (stacked, event-time coefficients, few treated countries,
many control firms/countries).

### 3.4 Design-based / finite-population (AAIW)
Abadie, Athey, Imbens & Wooldridge (2020 *Econometrica*; 2022 *QJE* "When should you
adjust standard errors for clustering?") reframe clustering as a **design** question: you
cluster when treatment is assigned at the cluster level and/or you sample clusters from a
population. Useful for justifying *why* we cluster on `iso` (treatment is a country×cohort
property → cluster at country). **But** their asymptotic t-based inference needs both the
number of treated *and* control clusters → ∞, so it inherits the same few-treated failure
(AFW 2026, §5.2) and is **not** a solution to our SE problem.

### 3.5 Synthetic control / SDID
Placebo inference (Abadie et al. 2010) reassigns treatment to each control and compares —
same logic as CT, `N0` support points. SDID (Arkhangelsky et al. 2021) offers bootstrap /
**jackknife** / placebo SEs; the **jackknife is undefined when any adoption period has a
single treated unit** (true for several of our cohorts), and placebo is the fallback for
few treated. Different estimand (synthetic weights) than our entropy-balanced areg, so
this is a *robustness* option, not a drop-in.

---

## 4. How theory bounds granularity / validity (the numbers to quote)

1. **p-value granularity = 1 / (# distinct rearrangements).**
   - Treated-cluster reshuffle: `# = C(G, G1)`. At `G = 2, G1 = 1` → 2 arrangements →
     finest two-sided p ≈ **0.5**. At `G = 4, G1 = 1` → 4 → finest ≈ **0.25**. At
     `G = 7, G1 = 1` → 7 → finest ≈ **0.14** (still can't reach 0.10 two-sided cleanly).
   - Controls-as-placebos (CT): `# = N0 + 1` → finest p ≈ `1/(N0+1)`.
2. **Minimum clusters to reject** (AFW 2026, §4.1.1; Cai et al. 2023):
   - CT / placebo-in-controls: **`N0 ≥ 10`** for a 10% test, **`N0 ≥ 20`** for 5%.
   - Sign-changes / approx-randomization over treated: **`G1 ≥ 5`** for 10%, **`G1 ≥ 6`**
     for 5%.
3. **Does permuting TIMING or exploiting the staggered structure enlarge the set?**
   Permuting *timing among the few treated countries* does **not** meaningfully enlarge
   `C(G,G1)` — the treated pool is still 2–4. What validly enlarges the reference
   distribution is **using control countries as placebo adopters** (CT / Alvarez–Ferman
   2023a), which respects the staggered block structure (reassign within each cohort's
   admissible control set) and grows the support to ≈ `N0`. Assumptions: sharp null +
   exchangeability/iid (or modeled heteroskedasticity, Ferman–Pinto) of control errors,
   and effect homogeneity for exact validity (relaxed asymptotically).
4. **Is our within-cohort reassignment recognized/valid?** Yes as a *scheme* (it is
   RI-β/RI-t over assignment), but it is **the wrong lever** at low `G1`: valid but
   uninformative. The recognized informative scheme for few treated is the
   controls-as-placebos permutation.

---

## 5. Best-practice recommendation for OUR exact setting

Setting recap: stacked DiD, `firm_id = group(gvkey, iso, cohort)`, treatment =
**country × cohort**, cluster on `iso`, entropy-balancing weights on pre-trend lags,
event-study coefficients (rel. years −4..+3, base −1), splits with `G ∈ {2,…,7}` treated
countries but **many control countries/firms**.

**Recommended core method:** **Conley–Taber (2011) placebo-in-controls, in the
Alvarez–Ferman (2023a) staggered/heterogeneous extension**, reported as the primary
inference for every few-cluster split, computed as **RI-t** (studentized) whenever
feasible for robustness to cluster heterogeneity (MacKinnon & Webb 2020). Operationally:

1. Fix the treated country-cohorts; estimate the event-study coefficients as now.
2. For each **control country**, re-run the *same* stacked spec pretending that control
   country is the adopter in the relevant cohort(s) (recompute entropy-balance weights
   each placebo draw, exactly as we already do), collect placebo event-study coefficients
   / t-stats.
3. RI p-value per event-time = share of `|placebo| ≥ |observed|`; CI by inversion or
   uniform bands (Alvarez–Ferman 2023a).
4. Because the entropy weights are recomputed per draw, the reference distribution is
   design-consistent — this is a strength of our existing loop, just pointed at controls.

**Is valid inference possible at `G = 2` treated?** Treated-count is *not* the binding
constraint — `G1 = 1` is fine for CT. The binding constraint is **`N0` (control
countries) in that split**. So:

- If the `G = 2`-**treated** split still has **`N0 ≥ 10`** control countries → a 10% CT
  test is possible (5% needs `N0 ≥ 20`).
- If a split has **fewer than ~10 control countries**, **no method delivers a valid 10%
  rejection.** The honest report is: point estimate + explicit statement that inference is
  **not possible / underpowered by design** at that cluster count, plus the finest
  achievable p-value (`1/(N0+1)`) so readers see the ceiling. Do **not** report a WCB CI
  (it will be empty/degenerate) or a naive CRVE t (it over-rejects).

**Threshold below which nothing works:** when the *control* pool is so small that
`1/(N0+1) > 0.10` (i.e. `N0 < 9`), *and* treated count `G1 < 5` (ruling out sign-changes),
**there is no valid frequentist rejection at conventional levels.** Report the estimate as
descriptive.

**Reporting hygiene** (MacKinnon, Nielsen & Webb 2023, §7): always report `G`, `G1`,
`N0`, median and max cluster (firm-count) size for each split. When methods disagree,
report several. Consider the **max p-value across a set of defensible methods** as a
conservative summary (AFW 2026, §6), but exclude methods that are trivially conservative
at that `G1` (they would just inflate the p-value uselessly).

---

## 6. Per-split decision table — RI is degenerate on BOTH margins here

The reason RI cannot be done on the region splits is **not** the treated count alone; it is
that **both** the treated pool `G1` **and** the control pool `N0` collapse after subsetting
to a region. A within-split permutation reference distribution has at most
`max( C(G,G1), N0+1 )` distinct points, and both terms are small. Counts below are from the
data (`distinct iso` on the split; a "control" country = a **never-adopter** in that split,
so `N0 = total − ever-adopter countries`):

| Split | Countries (total) | Treated `G1` | Control `N0` | Treated-reshuffle `C(G,G1)` | Controls-as-placebo ≈`N0+1` (finest p) | Within-split verdict |
|---|---|---|---|---|---|---|
| Eastern Asia | 4 | 3 | **1** | 4 | 2 (0.50) | **No valid RI** — both margins tiny. |
| Southeastern Asia | 3 | 2 | **1** | 3 | 2 (0.50) | **No valid RI.** |
| Eastern Europe | 7 | 4 | **3** | 35* | 4 (0.25) | **No valid RI** — CT capped at p ≈ 0.25. |
| Southern Europe | 7 | 2 | **5** | 21* | 6 (0.17) | **No valid RI** — CT capped at p ≈ 0.17. |
| WB Lower-middle income | 2 | — | — | ≤2 | ≤2 (≥0.50) | **No valid RI** — 2 countries total. |
| WB Upper-middle income | 14 | — | — | large | large | Enough clusters — **use WCB** (RI unnecessary). |
| WB High income | 37 | — | — | large | large | Enough clusters — **use WCB**. |

*The raw `C(G,G1)` count is not a usable finest-p: treated-reshuffle RI is invalid/unreliable
at these `G1` regardless of the combinatorics (MacKinnon–Webb 2020 need `G` *large*). The
binding informative bound is the controls-as-placebo count `N0+1`, which **never reaches the
`N0 ≥ 10` needed for a 10% test.** (WB treated/control breakdown not separately pulled, but
Lower-middle has only 2 countries total; Upper-middle/High have enough clusters that WCB is
valid.)

**Read-off / verdict.** For every region split and WB Lower-middle, **no within-split
permutation or randomization test can reach conventional significance** — the reference
distribution has ≤ 6 usable points, so the p-value floor is ≈ 0.17–0.50. Enlarging it
requires placebo adopters drawn from **outside the split** (all never-adopter countries),
which tests a broader null than "the effect within this region." Absent that, report these
splits **descriptively** with the explicit ceiling `1 / min( C(G,G1), N0+1 )`. Only WB
Upper-middle (14) and High income (37) support valid inference, and they already get it from
the wild cluster bootstrap — RI was never needed for them.

---

## 7. Stata implementation notes

| Tool | Command | Use here | Notes |
|---|---|---|---|
| Wild cluster bootstrap | `boottest` (Roodman, MacKinnon, Nielsen & Webb 2019, Stata J.) | **Not** for our few-treated splits | Confirmed to return no CI at `G1 = 2–4`; keep only for the many-cluster full sample. `weight(webb)`, `reps(9999)`, null imposed. Cannot follow `reghdfe` with >1 absorbed FE set (see ideology-efw NOTES §5) — fit with explicit dummies. |
| RI-β / RI-t | `randcmd` / `randcmdci` (MacKinnon & Webb) | Treated-cluster RI (documented but **degenerate** at low `G1`) | Produces both RI-β and RI-t; use to *demonstrate* the granularity wall, not as primary. |
| General RI / permutation | `ritest` (Heß 2017, Stata J. 17(3):630–651) | **Primary engine for controls-as-placebos** | Flexible permutation of an arbitrary treatment indicator; wrap our estimation (incl. `ebalance` recompute) in the resampled program so weights are re-derived each draw. Permute the *placebo adopter among controls within cohort*, not among treated. |
| Conley–Taber | hand-coded loop (no canonical package) | Placebo-in-controls p-values + CI by inversion | Loop over control countries as placebo adopters; collect `Ŵ_j`; p = share `|Ŵ_j| ≥ |τ̂|`. Our existing per-draw entropy-weight loop is 90% of this already. |
| SDID (robustness) | `sdid` (Clarke, Pailañir, Athey & Imbens 2024, Stata J. 24(4):557–598) | Alternative estimand robustness | `vce(placebo)` for few treated; **jackknife undefined** with a single treated unit in an adoption period. |

Implementation gotchas carried over from `ideology-efw/NOTES.md`: `boottest` rejects
factor-variable coefficient names and >1 absorbed FE set — use plain dummies; recompute
`ebalance` weights *inside* the permutation loop; `postfile` must be `postclose`d before
`use`. Always `StataBE -e do script.do` (never `-b`).

---

## 8. Key references (verified against primary sources)

DOIs / volumes verified against journal pages, the survey bibliographies of
MacKinnon–Nielsen–Webb (2023) and Alvarez–Ferman–Wüthrich (2026), and Stata Journal
listings. Working papers marked as such; where a DOI was not independently re-confirmed
this pass it is carried from the ideology-efw NOTES (already verified there) and flagged.

- **MacKinnon, J. G. & Webb, M. D. (2020)**, "Randomization inference for
  difference-in-differences with few treated clusters," *Journal of Econometrics*
  218(2):435–450. DOI 10.1016/j.jeconom.2020.04.024. — **RI-β vs RI-t; recommends RI-t.**
- **MacKinnon, J. G., Nielsen, M. Ø. & Webb, M. D. (2023)**, "Cluster-robust inference:
  A guide to empirical practice," *Journal of Econometrics* 232(2):272–299.
  (Working-paper version arXiv:2205.03285.) — §5.3 WCB few-treated failure; §6.2 RI,
  eqs. (37)–(38); §7 reporting. ⚠️ *Journal volume/issue/pages 232(2):272–299 not
  re-verified this pass — confirm against the JoE page before final cite.*
- **Alvarez, L., Ferman, B. & Wüthrich, K. (2026)**, "Inference with few treated units,"
  *arXiv:2504.19841* (working paper, this draft 6 May 2026). — thresholds `N0 ≥ 10 (10%)`
  / `N0 ≥ 20 (5%)`; comprehensive taxonomy; Table 1 over-rejection with `N1 = 1…5`.
- **Alvarez, L. & Ferman, B. (2023a)**, "Extensions for inference in
  difference-in-differences with few treated clusters," *arXiv:2302.03131* (working
  paper). — CT/Ferman–Pinto extended to **staggered adoption + heterogeneous effects**;
  **uniform event-study confidence bands**. Closest match to our design.
- **Conley, T. G. & Taber, C. R. (2011)**, "Inference with 'Difference in Differences'
  with a Small Number of Policy Changes," *Review of Economics and Statistics*
  93(1):113–125. DOI 10.1162/REST_a_00049. — **placebo-in-controls; `N0 → ∞` validity.**
- **Ferman, B. & Pinto, R. (2019)**, "Inference in differences-in-differences with few
  treated groups and heteroskedasticity," *Review of Economics and Statistics*
  101(3):452–467. DOI 10.1162/rest_a_00759. — heteroskedasticity-robust extension of CT.
  ⚠️ *DOI/pages not re-verified this pass — confirm before final cite.*
- **Ibragimov, R. & Müller, U. K. (2010)**, "t-Statistic Based Correlation and
  Heterogeneity Robust Inference," *Journal of Business & Economic Statistics*
  28(4):453–468. DOI 10.1198/jbes.2009.08046. — group-level t-test with few groups.
- **Ibragimov, R. & Müller, U. K. (2016)**, "Inference with Few Heterogeneous Clusters,"
  *Review of Economics and Statistics* 98(1):83–96. DOI 10.1162/REST_a_00545. —
  sample-size/significance conditions for conservative unequal-variance t-test.
  ⚠️ *DOI not re-verified this pass — confirm before final cite.*
- **Canay, I. A., Romano, J. P. & Shaikh, A. M. (2017)**, "Randomization tests under an
  approximate symmetry assumption," *Econometrica* 85(3):1013–1030. DOI 10.3982/ECTA13081.
  — sign-changes; power floor `1/2^{G1}`.
- **Canay, I. A., Santos, A. & Shaikh, A. M. (2021)**, "The wild bootstrap with a 'small'
  number of 'large' clusters," *Review of Economics and Statistics* 103(2):346–363.
  DOI 10.1162/rest_a_00developing. ⚠️ *DOI placeholder — verify; volume/pages 103(2):346–363
  confirmed via AFW 2026 bibliography.* — WCB can be exact with `N` large, `G` small under
  strong homogeneity.
- **Cai, Y., Canay, I. A., Kim, D. & Shaikh, A. M. (2023)**, "On the implementation of
  approximate randomization tests in linear models with a small number of clusters,"
  *Journal of Econometric Methods* 12(1):85–103. — implementation; "≥5 (10%) / ≥6 (5%)
  treated" rule. ⚠️ *DOI not verified this pass.*
- **MacKinnon, J. G. & Webb, M. D. (2018)**, "The wild bootstrap for few (treated)
  clusters," *Econometrics Journal* 21(2):114–135. DOI 10.1111/ectj.12107. —
  subcluster wild bootstrap.
- **Cameron, A. C. & Miller, D. L. (2015)**, "A Practitioner's Guide to Cluster-Robust
  Inference," *Journal of Human Resources* 50(2):317–372. DOI 10.3368/jhr.50.2.317.
- **Cameron, A. C., Gelbach, J. B. & Miller, D. L. (2008)**, "Bootstrap-Based
  Improvements for Inference with Clustered Errors," *Review of Economics and Statistics*
  90(3):414–427. DOI 10.1162/rest.90.3.414. — origin of wild cluster bootstrap-t.
- **Webb, M. D. (2023)**, "Reworking wild bootstrap-based inference for clustered errors,"
  *Canadian Journal of Economics* 56(3):839–858. DOI 10.1111/caje.12661. — 6-point Webb
  weights; `2^G` point-mass problem below 11 clusters.
- **Abadie, A., Athey, S., Imbens, G. W. & Wooldridge, J. M. (2020)**, "Sampling-based
  versus design-based uncertainty in regression analysis," *Econometrica* 88(1):265–296.
  DOI 10.3982/ECTA12675. ⚠️ *DOI not verified this pass.*
- **Abadie, A., Athey, S., Imbens, G. W. & Wooldridge, J. M. (2022)**, "When Should You
  Adjust Standard Errors for Clustering?," *Quarterly Journal of Economics* 138(1):1–35.
  DOI 10.1093/qje/qjac038. ⚠️ *DOI not verified this pass.*
- **Arkhangelsky, D., Athey, S., Hirshberg, D. A., Imbens, G. W. & Wager, S. (2021)**,
  "Synthetic Difference-in-Differences," *American Economic Review* 111(12):4088–4118.
  DOI 10.1257/aer.20190159. — placebo/jackknife/bootstrap SEs; jackknife undefined with a
  single treated unit per adoption period.
- **Heß, S. (2017)**, "Randomization inference with Stata: A guide and software,"
  *Stata Journal* 17(3):630–651. DOI 10.1177/1536867X1701700306. — `ritest`.
- **Clarke, D., Pailañir, D., Athey, S. & Imbens, G. (2024)**, "On synthetic
  difference-in-differences and related estimation methods in Stata," *Stata Journal*
  24(4):557–598. — `sdid`. ⚠️ *DOI not verified this pass.*
- **Roodman, D., MacKinnon, J. G., Nielsen, M. Ø. & Webb, M. D. (2019)**, "Fast and wild:
  Bootstrap inference in Stata using boottest," *Stata Journal* 19(1):4–60.
  DOI 10.1177/1536867X19830877. — `boottest`.
- **Roth, J. & Sant'Anna, P. H. C. (2023)** and the Roth–Sant'Anna DiD review /
  clustering lecture notes (psantanna.com/DiD) — background on design-based DiD, staggered
  adoption, and clustering with few clusters. (Notes, not a journal cite.)

**Do-not-invent flag:** every entry marked ⚠️ must be reconciled against the journal page
before the final manuscript. The un-flagged DOIs are verified (primary source or
cross-checked in ≥2 bibliographies).

---

## 9. One-paragraph synthesis (for a referee response)

With 2–7 treated country clusters, cluster-robust t-tests over-reject and the wild cluster
bootstrap under-rejects to the point of returning no confidence interval — both are known,
expected failures of the few-**treated**-cluster regime, not implementation bugs.
Randomization inference that reshuffles *which of the few treated countries is treated*
(our original scheme) is a valid permutation test but its reference distribution has only
`C(G, G1)` points, so at `G1 ≤ 4` the finest attainable p-value (≈ 0.5 at `G1 = 1–2`)
cannot reach conventional significance — this is a design ceiling, not a coding error. The
correct, recognized fix is to enlarge the reference set by using the **many control
countries as placebo adopters** (Conley–Taber 2011; Ferman–Pinto 2019; extended to our
staggered, heterogeneous-effect, event-study design by Alvarez–Ferman 2023a), reported as
a studentized RI-t statistic (MacKinnon–Webb 2020). Validity then comes from the number of
**control** countries `N0 → ∞`, so it works even with a single treated country — but it
still requires `N0 ≥ 10` for a 10% test and `N0 ≥ 20` for 5%. Where a split's control pool
is smaller than that, no frequentist method delivers valid inference at conventional
levels, and the honest report is a descriptive point estimate with the p-value ceiling
`1/(N0+1)` stated explicitly.

---

## 10. Sanity check — `boottest` respects the entropy-balance weights (asymmetric WCB CIs are genuine)

**Scope:** this is about the MANY-cluster wild-cluster-bootstrap file
(`code/estimates-sample-splits-wild.do`), not the few-cluster RI problem above.

**The worry.** The WCB event-study CIs are visibly **asymmetric**. Concern: `boottest` might
ignore the `[aweight=ebal]` weights — building its bootstrap DGP on the *unweighted* model
while the plotted point estimate `_b[d*]` is weighted — so the CI would be centered on the
wrong (unweighted) estimate and only *look* asymmetric.

**Test** (baseline split, `G = 54` clusters, Webb, reps = 999): per event dummy, compare
(a) `boottest` CI after the WEIGHTED areg vs after the UNWEIGHTED areg, and (b) the weighted
WCB CI midpoint vs the weighted `b_w` and unweighted `b_unw`, benchmarked to the normal CI
`b_w ± 1.645·se_w`.

| ev | b_w | b_unw | normCI(w) | WCB CI (weighted) | midpt | WCB CI (unweighted) |
|---|---|---|---|---|---|---|
| −4 | −0.148 | **+0.120** | [−0.344, 0.048] | [−0.366, 0.095] | **−0.135** | [−0.167, 0.473] |
| 0 | −0.096 | −0.095 | [−0.281, 0.088] | [−0.406, 0.095] | −0.156 | [−1.006, 0.260] |
| 3 | −0.131 | −0.047 | [−0.485, 0.224] | [−0.785, 0.335] | −0.225 | [−1.485, 0.505] |

**Findings.**
1. **Weights ARE used.** Weighted vs unweighted WCB CIs are completely different (event 0:
   `[−0.41, 0.10]` vs `[−1.01, 0.26]`). If `boottest` ignored `aweight` they would coincide.
2. **Centered on the WEIGHTED estimate.** Smoking gun at event −4, where entropy balancing
   flips the sign (`b_w = −0.148` vs `b_unw = +0.120`): the weighted WCB CI midpoint is
   **−0.135**, sitting on `b_w`, nowhere near `b_unw`. The unweighted WCB centers on its own
   `b_unw`. Each bootstrap tracks its own point estimate.
3. **Asymmetry is genuine, not a centering bug.** Pre-treatment coefficients (−4..−2) have
   near-symmetric WCB CIs almost identical to the normal `b ± 1.645·se`; the asymmetry
   concentrates in the **post-treatment** coefficients (0..3), which are identified off only
   **18 treated country-clusters** of very unequal size — exactly the few-treated + size-
   heterogeneity regime where the wild bootstrap distribution is skewed and *should* diverge
   from the (too-narrow) normal CI.

**Verdict.** The asymmetric WCB CIs are legitimate — `ebalance` weights are respected, the
intervals are centered on the weighted point estimates, and the skew is a real finite-sample
feature of the post-treatment estimates. No fix needed. (Diagnostic: scratch `diag_weights.do`,
not committed.)

---

## 11. Polity2 merge into `master-stacked-firm.dta` — coverage / unmatched country-years

**What.** `code/build-clean-window-firm.do` now merges `data/polity-clean.dta` (country-year:
`iso` str3, `year`, `polity2`, `cow_code`) onto the stacked firm panel just before the save, as
`merge m:1 iso year ... keep(master match) nogen`.

**Key-type gotcha (why it's not a literal one-liner).** In the firm panel `iso` is an **encoded
numeric** (`long`, value label = alpha-3: 1→ARG, 2→AUS, …, 58→USA), whereas in `polity-clean`
`iso` is the `str3` code itself. A plain `merge m:1 iso year` errors with `r(106)` (numeric vs
string key). Bridged by decoding the panel key to a string, merging, then restoring the numeric:

```stata
rename iso iso_n
decode iso_n, gen(iso)
merge m:1 iso year using "$path/JIBS/data/polity-clean.dta", keep(master match) nogen
drop iso
rename iso_n iso
```

**Merge result:** 693,728 matched, 37,648 unmatched-from-master (kept, `polity2 == .`), 0 from using.

**The 37,648 unmatched rows are exactly two disjoint causes — no other gaps exist:**

1. **Edge years 2019 & 2020 (≈73% of unmatched).** Polity5's series ends in **2018**, so every
   firm-observation dated 2019 or 2020 is unmatched. For all 36 non-excluded countries below, the
   *only* missing cells are 2019/2020 — nothing pre-2019.
2. **Countries Polity excludes entirely (all years 1995–2020):** **Iceland** (10,328 obs, 100%)
   and **Malta** (88 obs, 100%) — both below Polity's population cutoff, absent from the series.
   These two account for *all* pre-2019 unmatched rows.

**All 38 countries with any unmatched rows:** Australia, Austria, Belgium, Canada, Chile, China,
Colombia, Croatia, Cyprus, Czech Republic, Denmark, Egypt, Estonia, Finland, France, Germany,
**Iceland**, Ireland, Japan, Latvia, Lithuania, Luxembourg, Malaysia, **Malta**, New Zealand,
Norway, Peru, Portugal, Romania, Russia, Slovenia, South Korea, Spain, Sweden, Switzerland,
Taiwan, Thailand, Uruguay. (Large per-country totals — Finland 5,858; Thailand 6,728 — just
reflect firm counts in the two edge years, not extra year gaps.)

**If fuller coverage is wanted:** the only fixable gap is the 2019–2020 tail, which needs a source
extending past Polity5's 2018 end (e.g. substitute V-Dem for those years). Iceland/Malta cannot be
recovered from Polity at all.
