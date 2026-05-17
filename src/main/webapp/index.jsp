<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voiceless — Be Their Voice</title>
    <meta name="description" content="Voiceless is a digital wildlife conservation platform empowering communities to report, track, and protect endangered species.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/voiceless_logo.png">
</head>
<body>

    <!-- Particle Background Canvas -->
    <canvas id="particleCanvas"></canvas>

    <!-- Navigation -->
    <nav class="landing-nav" id="mainNav">
        <a href="#" class="nav-brand">
            <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless">
            Voiceless
        </a>
        <button type="button" class="nav-toggle" id="navToggle" aria-label="Open menu" aria-expanded="false">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 6h16M4 12h16M4 18h16"/></svg>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="#mission">Mission</a>
            <a href="#how-it-works">How It Works</a>
            <a href="#impact">Impact</a>
            <a href="${pageContext.request.contextPath}/login">Sign In</a>
            <a href="${pageContext.request.contextPath}/register" class="btn-nav-primary">Get Started</a>
        </div>
    </nav>

    <!-- ===== HERO SECTION ===== -->
    <section class="landing-section section-dark hero-section" id="hero">
        <div class="hero-badge">
            <span class="badge-dot"></span>
            Wildlife Conservation Platform
        </div>
        <h1 class="hero-title">
            Be Their <span class="highlight">Voice</span>
        </h1>
        <p class="hero-subtitle">
            Empowering communities to report, monitor, and protect wildlife.
            Every sighting matters. Every report saves lives.
        </p>
        <div class="hero-cta">
            <a href="${pageContext.request.contextPath}/register" class="btn-pill btn-pill-primary">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                Start Reporting
            </a>
            <a href="#mission" class="btn-pill btn-pill-outline">
                Learn More
            </a>
        </div>
        <div class="hero-scroll-hint">
            <div class="scroll-indicator">
                <span>Scroll</span>
                <div class="scroll-line"></div>
            </div>
        </div>
    </section>

    <!-- ===== MISSION SECTION (Light) ===== -->
    <section class="landing-section section-light mission-section" id="mission">
        <div class="reveal">
            <div class="section-label dark">
                <span class="label-line"></span>
                Our Mission
            </div>
            <h2 class="section-title dark">Giving Wildlife a <br>Digital Guardian</h2>
            <p class="section-subtitle dark">
                Voiceless bridges the gap between communities and conservation teams.
                With real-time incident reporting and rapid field dispatch, we ensure no
                animal in distress goes unnoticed.
            </p>
        </div>
        <div class="stats-row reveal">
            <div class="stat-item on-light">
                <div class="stat-number dark" data-count="2500" data-suffix="+">0</div>
                <div class="stat-desc dark">Incidents Reported</div>
            </div>
            <div class="stat-item on-light">
                <div class="stat-number dark" data-count="180" data-suffix="+">0</div>
                <div class="stat-desc dark">Species Monitored</div>
            </div>
            <div class="stat-item on-light">
                <div class="stat-number dark" data-count="45">0</div>
                <div class="stat-desc dark">Field Staff Active</div>
            </div>
            <div class="stat-item on-light">
                <div class="stat-number dark" data-count="98" data-suffix="%">0</div>
                <div class="stat-desc dark">Response Rate</div>
            </div>
        </div>
    </section>

    <!-- ===== HOW IT WORKS SECTION (Dark) ===== -->
    <section class="landing-section section-dark" id="how-it-works">
        <div class="reveal">
            <div class="section-label light" style="justify-content: center;">
                <span class="label-line"></span>
                How It Works
            </div>
            <h2 class="section-title light" style="text-align: center;">From Sighting to <br>Safe Rescue</h2>
            <p class="section-subtitle light" style="text-align: center; margin-left: auto; margin-right: auto;">
                Three simple steps to protect wildlife in your area.
            </p>
        </div>
        <div class="steps-grid reveal">
            <div class="step-card on-dark">
                <div class="step-number on-dark">1</div>
                <div class="step-icon on-dark">&#128065;</div>
                <h3 class="step-title on-dark">Report a Sighting</h3>
                <p class="step-desc on-dark">
                    Spot an injured, deceased, or wild animal? File a report with
                    location, photos, and description in seconds.
                </p>
            </div>
            <div class="step-card on-dark">
                <div class="step-number on-dark">2</div>
                <div class="step-icon on-dark">&#128225;</div>
                <h3 class="step-title on-dark">Staff Dispatched</h3>
                <p class="step-desc on-dark">
                    Trained field staff request assignment, admin approves,
                    and a team is dispatched to the exact GPS coordinates.
                </p>
            </div>
            <div class="step-card on-dark">
                <div class="step-number on-dark">3</div>
                <div class="step-icon on-dark">&#128154;</div>
                <h3 class="step-title on-dark">Resolved & Verified</h3>
                <p class="step-desc on-dark">
                    Staff submit a completion report. Admin verifies the outcome.
                    The animal is safe — and the community is informed.
                </p>
            </div>
        </div>
    </section>

    <!-- ===== ACHIEVEMENTS / IMPACT SECTION (Light) ===== -->
    <section class="landing-section section-light mission-section" id="impact">
        <div class="reveal">
            <div class="section-label dark">
                <span class="label-line"></span>
                Our Impact
            </div>
            <h2 class="section-title dark">What We've<br>Achieved Together</h2>
            <p class="section-subtitle dark">
                Every report filed by our community has contributed to real, 
                measurable conservation outcomes.
            </p>
        </div>
        <div class="achievements-grid reveal">
            <div class="achievement-card on-light">
                <div class="achievement-icon">&#127795;</div>
                <h3 class="achievement-title">Habitat Protection</h3>
                <p class="achievement-desc">
                    Heatmap data from reports has helped identify 12 critical
                    wildlife corridors now under active protection.
                </p>
            </div>
            <div class="achievement-card on-light">
                <div class="achievement-icon">&#128058;</div>
                <h3 class="achievement-title">Rapid Response</h3>
                <p class="achievement-desc">
                    Average response time reduced to under 2 hours thanks to
                    real-time GPS incident reporting and dispatch.
                </p>
            </div>
            <div class="achievement-card on-light">
                <div class="achievement-icon">&#129309;</div>
                <h3 class="achievement-title">Community Driven</h3>
                <p class="achievement-desc">
                    Over 1,200 community members actively report sightings,
                    creating a living map of wildlife activity.
                </p>
            </div>
            <div class="achievement-card on-light">
                <div class="achievement-icon">&#128200;</div>
                <h3 class="achievement-title">Data for Policy</h3>
                <p class="achievement-desc">
                    Aggregated incident data is shared with conservation authorities
                    to influence wildlife protection policy.
                </p>
            </div>
        </div>
    </section>

    <!-- ===== CALL TO ACTION (Dark) ===== -->
    <section class="landing-section section-dark" style="min-height: 60vh;">
        <div class="reveal" style="text-align: center;">
            <h2 class="section-title light" style="text-align: center;">Ready to Make a<br><span style="background: linear-gradient(135deg, #95d5b2, #40916c); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Difference?</span></h2>
            <p class="section-subtitle light" style="text-align: center; margin-left: auto; margin-right: auto;">
                Join thousands of wildlife guardians. Your next report could save a life.
            </p>
            <div class="hero-cta" style="margin-top: 32px;">
                <a href="${pageContext.request.contextPath}/register" class="btn-pill btn-pill-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                    Create Free Account
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn-pill btn-pill-outline">
                    Sign In
                </a>
            </div>
        </div>
    </section>

    <!-- ===== FOOTER ===== -->
    <footer class="landing-footer">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless">
            Voiceless
        </div>
        <div class="footer-links">
            <a href="#mission">Mission</a>
            <a href="#how-it-works">How It Works</a>
            <a href="#impact">Impact</a>
            <a href="${pageContext.request.contextPath}/login">Sign In</a>
            <a href="${pageContext.request.contextPath}/register">Register</a>
        </div>
        <div class="footer-copy">
            &copy; 2026 Voiceless Wildlife Conservation Platform. All rights reserved.
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/landing.js"></script>
</body>
</html>
