-- ============================================================================
-- SIRAAJ PLATFORM - COMPREHENSIVE SQL SEED DATA
-- ============================================================================
-- This file contains complete seed data for all tables in the Scroll database
-- Uses only authentic Sunni Barelvi Islamic content from mainstream scholars
-- Covers all user plan types, languages, and usage scenarios
-- ============================================================================

-- Clear existing data (in dependency order)
TRUNCATE TABLE trial_usage_sessions CASCADE;
TRUNCATE TABLE trial_usage CASCADE;
TRUNCATE TABLE feedback CASCADE;
TRUNCATE TABLE search_history CASCADE;
TRUNCATE TABLE user_preferences CASCADE;
TRUNCATE TABLE notifications CASCADE;
TRUNCATE TABLE audio_sessions CASCADE;
TRUNCATE TABLE subscription_history CASCADE;
TRUNCATE TABLE subscriptions CASCADE;
TRUNCATE TABLE subscription_plans CASCADE;
TRUNCATE TABLE notes CASCADE;
TRUNCATE TABLE review_votes CASCADE;
TRUNCATE TABLE reviews CASCADE;
TRUNCATE TABLE bookmarks CASCADE;
TRUNCATE TABLE downloads CASCADE;
TRUNCATE TABLE recently_played CASCADE;
TRUNCATE TABLE user_narrator_follows CASCADE;
TRUNCATE TABLE user_author_follows CASCADE;
TRUNCATE TABLE mood_content CASCADE;
TRUNCATE TABLE content_categories CASCADE;
TRUNCATE TABLE content_narrators CASCADE;
TRUNCATE TABLE content_authors CASCADE;
TRUNCATE TABLE waveforms CASCADE;
TRUNCATE TABLE chapters CASCADE;
TRUNCATE TABLE content CASCADE;
TRUNCATE TABLE mood_categories CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE narrators CASCADE;
TRUNCATE TABLE authors CASCADE;
TRUNCATE TABLE verification_tokens CASCADE;
TRUNCATE TABLE accounts CASCADE;
TRUNCATE TABLE sessions CASCADE;
TRUNCATE TABLE users CASCADE;

-- ============================================================================
-- SUBSCRIPTION PLANS
-- ============================================================================
-- Only 2 plan types feature-wise: Trial and Premium (with 2 billing variants)

INSERT INTO subscription_plans (id, name, display_name, description, price, currency, interval, interval_count, features, limitations, is_popular, is_active, sort_order, stripe_price_id, created_at, updated_at) VALUES
-- Trial Plan (Free with limitations)
('plan_trial_001', 'trial', 'Free Trial', 'Get started with 15 minutes of premium content monthly', 0.00, 'USD', 'month', 1, 
 '["Access to free content", "15 minutes premium monthly", "Basic audio player", "Progress tracking", "Notes system"]'::json,
 '["Limited premium access", "No offline downloads", "Basic audio quality only", "Limited bookmarks"]'::json,
 false, true, 1, null, NOW(), NOW()),

-- Premium Monthly
('plan_premium_monthly', 'premium_monthly', 'Premium Monthly', 'Full access to all content with monthly billing', 9.99, 'USD', 'month', 1,
 '["Unlimited premium content", "Offline downloads", "High-quality audio", "Advanced player features", "Unlimited bookmarks", "Priority support", "Ad-free experience", "All languages"]'::json,
 null, false, true, 2, 'price_premium_monthly_stripe', NOW(), NOW()),

-- Premium Annual (Popular choice)
('plan_premium_annual', 'premium_annual', 'Premium Annual', 'Full access to all content with annual billing - Save 20%!', 95.99, 'USD', 'year', 1,
 '["Unlimited premium content", "Offline downloads", "High-quality audio", "Advanced player features", "Unlimited bookmarks", "Priority support", "Ad-free experience", "All languages", "Annual savings"]'::json,
 null, true, true, 3, 'price_premium_annual_stripe', NOW(), NOW());

-- ============================================================================
-- USERS - Different plan types and scenarios
-- ============================================================================

INSERT INTO users (id, email, email_verified, name, image, bio, nationality, is_new, is_active, role, created_at, updated_at, last_login_at) VALUES
-- Trial Users
('user_trial_ahmed', 'ahmed.trial@example.com', true, 'Ahmed Al-Rashid', null, 'Student of Islamic studies, passionate about learning from authentic Sunni scholars', 'Pakistan', false, true, 'USER', NOW() - INTERVAL '10 days', NOW(), NOW() - INTERVAL '1 day'),
('user_trial_fatima', 'fatima.new@example.com', true, 'Fatima Zahra', null, 'New to Islamic audiobooks, exploring Barelvi literature', 'India', true, true, 'USER', NOW() - INTERVAL '5 days', NOW(), NOW() - INTERVAL '2 hours'),
('user_trial_omar', 'omar.student@example.com', true, 'Omar Ibn Abdullah', null, 'Madrasa student learning classical Islamic texts', 'Bangladesh', false, true, 'USER', NOW() - INTERVAL '20 days', NOW(), NOW() - INTERVAL '3 days'),

-- Premium Monthly Users
('user_prem_monthly_1', 'yasmin.scholar@example.com', true, 'Dr. Yasmin Khatoon', null, 'Islamic studies professor researching Qadiriyya literature', 'UK', false, true, 'PREMIUM', NOW() - INTERVAL '45 days', NOW(), NOW() - INTERVAL '6 hours'),
('user_prem_monthly_2', 'ibrahim.imam@example.com', true, 'Imam Ibrahim Hassan', null, 'Mosque imam seeking authentic Sunni content for community education', 'USA', false, true, 'PREMIUM', NOW() - INTERVAL '30 days', NOW(), NOW() - INTERVAL '12 hours'),

-- Premium Annual Users
('user_prem_annual_1', 'zainab.researcher@example.com', true, 'Prof. Zainab Al-Qadri', null, 'Senior researcher in Islamic literature and Sufi texts', 'Canada', false, true, 'PREMIUM', NOW() - INTERVAL '120 days', NOW(), NOW() - INTERVAL '4 hours'),
('user_prem_annual_2', 'muhammad.teacher@example.com', true, 'Ustaz Muhammad Yusuf', null, 'Islamic teacher and author, follower of Alahazrat Imam Ahmed Raza Khan', 'Malaysia', false, true, 'PREMIUM', NOW() - INTERVAL '200 days', NOW(), NOW() - INTERVAL '8 hours'),
('user_prem_annual_3', 'aisha.student@example.com', true, 'Aisha Siddiqua', null, 'PhD student researching Barelvi movement and its scholars', 'Australia', false, true, 'PREMIUM', NOW() - INTERVAL '90 days', NOW(), NOW() - INTERVAL '1 day'),

-- Admin Users
('user_admin_001', 'admin@scroll.app', true, 'Scroll Admin', null, 'Platform administrator', 'Global', false, true, 'ADMIN', NOW() - INTERVAL '365 days', NOW(), NOW() - INTERVAL '30 minutes'),
('user_moderator_001', 'moderator@scroll.app', true, 'Content Moderator', null, 'Content quality and authenticity moderator', 'Pakistan', false, true, 'MODERATOR', NOW() - INTERVAL '180 days', NOW(), NOW() - INTERVAL '2 hours');

-- ============================================================================
-- USER SESSIONS
-- ============================================================================

INSERT INTO sessions (id, user_id, expires_at, token, created_at, updated_at, ip_address, user_agent) VALUES
('sess_001', 'user_trial_ahmed', NOW() + INTERVAL '30 days', 'token_ahmed_trial_001', NOW() - INTERVAL '1 day', NOW(), '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)'),
('sess_002', 'user_prem_monthly_1', NOW() + INTERVAL '30 days', 'token_yasmin_monthly_001', NOW() - INTERVAL '6 hours', NOW(), '203.45.67.89', 'Mozilla/5.0 (Android 13; Mobile)'),
('sess_003', 'user_prem_annual_1', NOW() + INTERVAL '30 days', 'token_zainab_annual_001', NOW() - INTERVAL '4 hours', NOW(), '104.23.45.67', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
('sess_004', 'user_trial_fatima', NOW() + INTERVAL '30 days', 'token_fatima_new_001', NOW() - INTERVAL '2 hours', NOW(), '45.123.78.90', 'Mozilla/5.0 (iPad; CPU OS 16_0 like Mac OS X)'),
('sess_005', 'user_prem_annual_2', NOW() + INTERVAL '30 days', 'token_muhammad_teacher_001', NOW() - INTERVAL '8 hours', NOW(), '23.45.67.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)');

-- ============================================================================
-- AUTHORS - From Sunni Barelvi scholars only
-- ============================================================================

INSERT INTO authors (id, name, slug, bio, image_url, nationality, birth_year, website, social_links, quote, genres, awards, total_books, followers, is_active, is_verified, created_at, updated_at) VALUES
-- Classical Masters
('author_abdul_qadir_jilani', 'Shaykh Abdul Qadir Jilani', 'shaykh-abdul-qadir-jilani', 'The great Sufi master and founder of the Qadiriyya order, known as Ghous-e-Azam (The Greatest Helper). Born in Gilan, Persia, he became one of the most revered saints in Islamic history.', null, 'Persia', 1077, null, null, 'He who knows himself knows his Lord', '["Sufism", "Islamic Jurisprudence", "Spiritual Guidance"]', '["Ghous-e-Azam", "Sultan-ul-Awliya"]', 15, 50000, true, true, NOW(), NOW()),

('author_imam_ahmed_raza', 'Imam Ahmed Raza Khan Barelvi', 'imam-ahmed-raza-khan-barelvi', 'The great reviver of Sunni Islam in the Indian subcontinent, founder of the Barelvi movement. Scholar of Islamic law, theology, and Sufism who authored over 1000 books including the famous Fatawa Razawiyyah.', null, 'India', 1856, null, null, 'Love of the Prophet is the foundation of faith', '["Islamic Law", "Theology", "Sufism", "Poetry"]', '["Alahazrat", "Mujaddid-e-Azam", "Imam-e-Ahle Sunnat"]', 50, 75000, true, true, NOW(), NOW()),

('author_naeem_muradabadi', 'Allama Naeem-ud-Din Muradabadi', 'allama-naeem-ud-din-muradabadi', 'Distinguished disciple of Imam Ahmed Raza Khan, renowned Quranic commentator and Islamic scholar. Author of the famous Tafseer-e-Naeemi and Khazain-ul-Irfan.', null, 'India', 1887, null, null, 'The Quran is an ocean of knowledge for those who dive deep', '["Quranic Commentary", "Islamic Literature", "Biography"]', '["Tafseer-e-Naeemi", "Khazain-ul-Irfan"]', 12, 25000, true, true, NOW(), NOW()),

('author_ghulam_rasool_saeedi', 'Allama Ghulam Rasool Saeedi', 'allama-ghulam-rasool-saeedi', 'Eminent scholar and disciple of Imam Ahmed Raza Khan. Known for his works on Islamic jurisprudence and Quranic commentary including Anwar-ul-Bayan.', null, 'India', 1895, null, null, 'Knowledge is the light that illuminates the path to Allah', '["Islamic Jurisprudence", "Quranic Commentary", "Hadith"]', '["Anwar-ul-Bayan"]', 8, 18000, true, true, NOW(), NOW()),

('author_amjad_ali_azmi', 'Allama Amjad Ali Azmi', 'allama-amjad-ali-azmi', 'Great Sunni scholar and author of Bahar-e-Shariat, a comprehensive work on Islamic law. Student of Imam Ahmed Raza Khan and key figure in preserving Sunni traditions.', null, 'India', 1882, null, null, 'Following the Sunnah is the key to success in both worlds', '["Islamic Law", "Jurisprudence", "Religious Guidance"]', '["Bahar-e-Shariat"]', 6, 22000, true, true, NOW(), NOW()),

-- Classical Poets and Sufi Masters
('author_jalal_rumi', 'Jalal ad-Din Rumi', 'jalal-ad-din-rumi', 'The great Persian Sufi mystic and poet, author of the Masnavi. His spiritual poetry has inspired millions across the world for centuries.', null, 'Persia', 1207, null, null, 'Let yourself be silently drawn by the strange pull of what you really love', '["Sufi Poetry", "Mysticism", "Spiritual Literature"]', '["Masnavi Sharif", "Diwan-e-Shams"]', 10, 100000, true, true, NOW(), NOW()),

('author_imam_busiri', 'Imam al-Busiri', 'imam-al-busiri', 'Egyptian Sufi saint and poet, famous for his Qasida Burda (The Poem of the Cloak) in praise of Prophet Muhammad (peace be upon him).', null, 'Egypt', 1211, null, null, 'Muhammad is the leader of both worlds and both races', '["Na''at Poetry", "Islamic Literature", "Devotional Works"]', '["Qasida Burda Sharif"]', 3, 80000, true, true, NOW(), NOW()),

-- Contemporary Scholars
('author_kaukab_okarvi', 'Allama Kaukab Noorani Okarvi', 'allama-kaukab-noorani-okarvi', 'Leading contemporary Sunni Barelvi scholar, son of Allama Shah Ahmad Noorani Siddiqui. Renowned for his lectures and writings on Islamic theology and defense of Sunni beliefs.', null, 'Pakistan', 1940, 'https://allamakokabokarvi.com', '{"youtube": "@AllamaKokabOkarvi", "facebook": "allamakokabokarvi"}', 'Defending the honor of Prophet Muhammad is our sacred duty', '["Islamic Theology", "Contemporary Issues", "Religious Debates"]', '["Tamheed-e-Iman", "Noor-e-Hidayat"]', 25, 45000, true, true, NOW(), NOW()),

('author_turab_qadri', 'Allama Syed Shah Turab-ul-Haq Qadri', 'allama-syed-shah-turab-ul-haq-qadri', 'Prominent Sunni Barelvi scholar and spiritual guide in the Qadri tradition. Known for his passionate speeches and scholarly works on Islamic spirituality.', null, 'Pakistan', 1955, null, null, 'The path of love leads to the Divine presence', '["Sufism", "Spiritual Guidance", "Islamic Ethics"]', '["Spiritual Excellence Awards"]', 15, 35000, true, true, NOW(), NOW()),

('author_ilyas_attar', 'Maulana Ilyas Attar Qadri', 'maulana-ilyas-attar-qadri', 'Founder of Dawat-e-Islami, global Islamic organization. Renowned scholar and preacher dedicated to spreading authentic Sunni Islamic teachings worldwide.', null, 'Pakistan', 1950, 'https://dawateislami.net', '{"youtube": "@DawateIslami", "facebook": "DawateIslamiOfficial"}', 'I must strive to reform myself and people of the entire world', '["Da''wah", "Islamic Reform", "Spiritual Development"]', '["Faizan-e-Sunnat", "Global Islamic Service"]', 30, 200000, true, true, NOW(), NOW());

-- ============================================================================
-- NARRATORS - From Sunni Barelvi tradition
-- ============================================================================

INSERT INTO narrators (id, name, slug, bio, image_url, experience_years, voice_description, languages, genres, awards, website, social_links, total_narrations, followers, rating, rating_count, is_active, is_verified, created_at, updated_at) VALUES
-- Contemporary Sunni Narrators
('narrator_owais_qadri', 'Muhammad Owais Raza Qadri', 'muhammad-owais-raza-qadri', 'Renowned Na''at Khwan and reciter of Islamic literature. Known for his melodious voice and deep emotional expression in Urdu and Arabic recitations.', null, 15, 'Rich, melodious voice with perfect pronunciation in Arabic and Urdu', '["Urdu", "Arabic", "Punjabi"]', '["Na''at", "Quranic Recitation", "Islamic Poetry"]', '["Best Na''at Khwan 2020", "Voice of Devotion Award"]', null, '{"youtube": "@OwaisRazaQadri", "instagram": "owaisrazaqadri"}', 45, 75000, 4.8, 2500, true, true, NOW(), NOW()),

('narrator_waheed_qasmi', 'Qari Waheed Zafar Qasmi', 'qari-waheed-zafar-qasmi', 'Expert Quranic reciter and narrator of Islamic content. Specializes in classical Arabic texts and modern Urdu Islamic literature.', null, 20, 'Clear, resonant voice perfect for Quranic recitation and scholarly content', '["Arabic", "Urdu", "English"]', '["Quranic Recitation", "Hadith Narration", "Islamic Lectures"]', '["International Qira''at Competition Winner", "Best Reciter Award"]', null, null, 38, 45000, 4.9, 1800, true, true, NOW(), NOW()),

('narrator_imran_attari', 'Maulana Muhammad Imran Attari', 'maulana-muhammad-imran-attari', 'Senior narrator from Dawat-e-Islami organization. Skilled in delivering Islamic content with proper pronunciation and spiritual depth.', null, 12, 'Warm, engaging voice suitable for educational and spiritual content', '["Urdu", "Arabic", "English"]', '["Islamic Education", "Spiritual Guidance", "Da''wah Literature"]', '["Dawat-e-Islami Excellence Award"]', 'https://dawateislami.net', '{"youtube": "@DawateIslami"}', 55, 30000, 4.7, 1200, true, true, NOW(), NOW()),

('narrator_mohsin_qadri', 'Muhammad Mohsin Qadri', 'muhammad-mohsin-qadri', 'Talented young narrator specializing in contemporary Islamic literature and classical works. Known for bringing life to spiritual texts.', null, 8, 'Youthful, clear voice with excellent diction in multiple languages', '["Urdu", "Arabic", "Persian"]', '["Sufi Literature", "Modern Islamic Works", "Poetry"]', '["Rising Star Award 2022"]', null, '{"instagram": "mohsinqadri_official"}', 25, 18000, 4.6, 650, true, true, NOW(), NOW()),

('narrator_furqan_qadri', 'Syed Furqan Qadri', 'syed-furqan-qadri', 'Experienced narrator and Islamic scholar. Specializes in historical Islamic texts and biographical works of Sufi saints.', null, 18, 'Authoritative voice with deep understanding of classical Islamic texts', '["Urdu", "Arabic", "Persian", "English"]', '["Historical Works", "Sufi Biographies", "Classical Literature"]', '["Scholar-Narrator Excellence Award"]', null, null, 42, 28000, 4.8, 950, true, true, NOW(), NOW()),

-- International Sunni Narrators
('narrator_abdul_basit', 'Qari Abdul Basit Abd as-Samad', 'qari-abdul-basit-abd-as-samad', 'Legendary Egyptian Quranic reciter (1927-1988), considered one of the greatest reciters of all time. His recordings continue to inspire millions.', null, 40, 'Magnificent, powerful voice with perfect Tajweed and emotional depth', '["Arabic"]', '["Quranic Recitation", "Islamic Audio"]', '["Master of Quranic Recitation", "Voice of Heaven"]', null, null, 15, 500000, 5.0, 50000, true, true, NOW(), NOW()),

('narrator_mahmood_shahat', 'Qari Mahmood Khalil al-Husary', 'qari-mahmood-khalil-al-husary', 'Famous Egyptian Quranic reciter known for his precise Tajweed and beautiful voice. International authority on Quranic recitation.', null, 45, 'Crystal clear voice with impeccable Tajweed rules', '["Arabic"]', '["Quranic Recitation", "Tajweed Education"]', '["Tajweed Master", "International Recitation Award"]', null, null, 20, 300000, 4.9, 25000, true, true, NOW(), NOW()),

('narrator_minshawi', 'Al-Hajj Muhammad Siddiq al-Minshawi', 'al-hajj-muhammad-siddiq-al-minshawi', 'Renowned Egyptian Quranic reciter (1920-1969), famous for his emotional and melodious recitation style that touches hearts.', null, 35, 'Deeply emotional voice that brings listeners to tears with its beauty', '["Arabic"]', '["Quranic Recitation", "Devotional Audio"]', '["Master Reciter", "Voice of Emotion"]', null, null, 12, 400000, 4.9, 30000, true, true, NOW(), NOW());

-- ============================================================================
-- CATEGORIES - Islamic subject organization
-- ============================================================================

INSERT INTO categories (id, name, slug, description, icon, image_url, color, parent_id, item_count, listening_hours, sort_order, is_active, is_featured, created_at, updated_at) VALUES
-- Root Categories
('cat_quran', 'Quranic Studies', 'quranic-studies', 'Quranic commentary, recitation, and Tajweed education', 'book-open', null, '#2E8B57', null, 15, 5000, 1, true, true, NOW(), NOW()),
('cat_hadith', 'Hadith & Sunnah', 'hadith-sunnah', 'Hadith collections, commentary, and Prophetic traditions', 'scroll-text', null, '#4682B4', null, 12, 3500, 2, true, true, NOW(), NOW()),
('cat_fiqh', 'Islamic Jurisprudence', 'islamic-jurisprudence', 'Islamic law, legal rulings, and practical guidance', 'scale', null, '#8B4513', null, 10, 2800, 3, true, false, NOW(), NOW()),
('cat_sufism', 'Sufism & Spirituality', 'sufism-spirituality', 'Sufi literature, spiritual guidance, and mystical teachings', 'heart', null, '#9932CC', null, 25, 8000, 4, true, true, NOW(), NOW()),
('cat_seerah', 'Prophetic Biography', 'prophetic-biography', 'Life and teachings of Prophet Muhammad (peace be upon him)', 'user-crown', null, '#228B22', null, 8, 2200, 5, true, false, NOW(), NOW()),
('cat_history', 'Islamic History', 'islamic-history', 'History of Islam, companions, and Islamic civilization', 'clock', null, '#B8860B', null, 6, 1800, 6, true, false, NOW(), NOW()),
('cat_poetry', 'Na''at & Poetry', 'naat-poetry', 'Islamic poetry, Na''at, and devotional literature', 'music', null, '#DC143C', null, 20, 6000, 7, true, true, NOW(), NOW()),
('cat_contemporary', 'Contemporary Issues', 'contemporary-issues', 'Modern Islamic thought and contemporary religious guidance', 'calendar', null, '#4169E1', null, 5, 1200, 8, true, false, NOW(), NOW()),

-- Subcategories for Quranic Studies
('cat_tafseer', 'Tafseer (Commentary)', 'tafseer-commentary', 'Detailed Quranic commentary by authentic scholars', 'book', null, '#2E8B57', 'cat_quran', 8, 3200, 1, true, false, NOW(), NOW()),
('cat_recitation', 'Quranic Recitation', 'quranic-recitation', 'Beautiful recitations of the Holy Quran', 'volume-2', null, '#2E8B57', 'cat_quran', 7, 1800, 2, true, false, NOW(), NOW()),

-- Subcategories for Sufism
('cat_qadri', 'Qadiriyya Order', 'qadiriyya-order', 'Teachings and literature of the Qadri Sufi order', 'star', null, '#9932CC', 'cat_sufism', 12, 4000, 1, true, false, NOW(), NOW()),
('cat_sufi_poetry', 'Sufi Poetry', 'sufi-poetry', 'Mystical poetry and spiritual verses', 'feather', null, '#9932CC', 'cat_sufism', 8, 2500, 2, true, false, NOW(), NOW()),
('cat_spiritual_guidance', 'Spiritual Guidance', 'spiritual-guidance', 'Practical guidance for spiritual development', 'compass', null, '#9932CC', 'cat_sufism', 5, 1500, 3, true, false, NOW(), NOW());

-- ============================================================================
-- MOOD CATEGORIES
-- ============================================================================

INSERT INTO mood_categories (id, name, slug, description, emoji, color, sort_order, is_active, created_at, updated_at) VALUES
('mood_peaceful', 'Peaceful & Reflective', 'peaceful-reflective', 'Content for quiet reflection and inner peace', '🕊️', '#87CEEB', 1, true, NOW(), NOW()),
('mood_devotional', 'Devotional & Worship', 'devotional-worship', 'Enhance your worship and devotional practices', '🤲', '#FFD700', 2, true, NOW(), NOW()),
('mood_learning', 'Learning & Study', 'learning-study', 'Educational content for Islamic knowledge', '📚', '#32CD32', 3, true, NOW(), NOW()),
('mood_spiritual', 'Spiritual Growth', 'spiritual-growth', 'Content for spiritual development and purification', '✨', '#9370DB', 4, true, NOW(), NOW()),
('mood_inspirational', 'Inspirational & Motivational', 'inspirational-motivational', 'Uplifting content to inspire your faith', '🌟', '#FF6347', 5, true, NOW(), NOW()),
('mood_healing', 'Healing & Comfort', 'healing-comfort', 'Soothing content for difficult times', '💚', '#98FB98', 6, true, NOW(), NOW());

-- ============================================================================
-- CONTENT - Islamic audiobooks and literature
-- ============================================================================

INSERT INTO content (id, title, slug, description, cover_url, type, availability, status, duration, chapter_count, rating, rating_count, view_count, listening_hours, is_featured, is_popular, is_premium, tags, keywords, language, published_at, created_at, updated_at) VALUES
-- Ghous-e-Azam's Works
('content_ghunyatu_talibeen', 'Al-Ghunyatu li Talibi Tariq al-Haqq', 'al-ghunyatu-li-talibi-tariq-al-haqq', 'The comprehensive guide for seekers of the Truth by Shaykh Abdul Qadir Jilani. A masterpiece of Islamic spirituality covering all aspects of the spiritual journey.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 18000, 25, 4.9, 850, 12500, 4200, true, true, true, '["Sufism", "Spiritual Guide", "Qadri", "Classical"]', 'Ghous-e-Azam, spiritual guidance, Sufism, seekers, truth', 'ar', NOW() - INTERVAL '30 days', NOW() - INTERVAL '35 days', NOW()),

('content_futuh_ghaib', 'Futuh al-Ghaib', 'futuh-al-ghaib', 'The Revelations of the Unseen - profound spiritual teachings and mystical insights by the great Sufi master Shaykh Abdul Qadir Jilani.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 14400, 20, 4.8, 620, 8900, 3100, true, true, true, '["Mysticism", "Spiritual Teachings", "Qadri"]', 'Futuh al-Ghaib, mystical teachings, spiritual insights', 'ar', NOW() - INTERVAL '25 days', NOW() - INTERVAL '30 days', NOW()),

('content_fath_rabbani', 'Al-Fath ar-Rabbani', 'al-fath-ar-rabbani', 'The Divine Opening - collection of spiritual discourses and teachings by Shaykh Abdul Qadir Jilani, covering various aspects of Islamic spirituality.', null, 'AUDIOBOOK', 'FREE', 'PUBLISHED', 10800, 15, 4.7, 1200, 15000, 2800, false, true, false, '["Spiritual Discourse", "Islamic Teachings"]', 'Al-Fath ar-Rabbani, divine opening, spiritual discourse', 'ar', NOW() - INTERVAL '20 days', NOW() - INTERVAL '25 days', NOW()),

-- Imam Ahmed Raza Khan's Works
('content_fatawa_razawiyyah', 'Fatawa Razawiyyah - Volume 1', 'fatawa-razawiyyah-volume-1', 'The first volume of the comprehensive legal rulings by Imam Ahmed Raza Khan Barelvi. Essential reading for understanding Sunni Islamic jurisprudence.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 21600, 30, 4.9, 950, 18000, 5500, true, true, true, '["Fiqh", "Islamic Law", "Barelvi", "Jurisprudence"]', 'Fatawa Razawiyyah, Islamic law, jurisprudence, Imam Ahmed Raza', 'ur', NOW() - INTERVAL '15 days', NOW() - INTERVAL '20 days', NOW()),

('content_kanz_iman', 'Kanz al-Iman - Quranic Translation', 'kanz-al-iman-quranic-translation', 'The treasure of faith - Imam Ahmed Raza Khan''s renowned Urdu translation of the Holy Quran with detailed explanations.', null, 'AUDIOBOOK', 'FREE', 'PUBLISHED', 43200, 60, 4.8, 2500, 35000, 12000, true, true, false, '["Quran Translation", "Urdu", "Tafseer"]', 'Kanz al-Iman, Quran translation, Urdu tafseer', 'ur', NOW() - INTERVAL '40 days', NOW() - INTERVAL '45 days', NOW()),

('content_hadaiq_bakhshish', 'Hadaiq-e-Bakhshish', 'hadaiq-e-bakhshish', 'The Gardens of Forgiveness - beautiful Na''at poetry by Imam Ahmed Raza Khan, expressing deep love for Prophet Muhammad (peace be upon him).', null, 'AUDIOBOOK', 'FREE', 'PUBLISHED', 7200, 12, 4.9, 1800, 25000, 6000, false, true, false, '["Na''at", "Poetry", "Prophetic Love"]', 'Hadaiq-e-Bakhshish, Na''at poetry, Prophetic love', 'ur', NOW() - INTERVAL '10 days', NOW() - INTERVAL '15 days', NOW()),

-- Disciples' Works
('content_tafseer_naeemi', 'Tafseer-e-Naeemi - Surah Al-Baqarah', 'tafseer-e-naeemi-surah-al-baqarah', 'Comprehensive Quranic commentary on Surah Al-Baqarah by Allama Naeem-ud-Din Muradabadi, offering deep insights into Quranic verses.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 25200, 35, 4.8, 720, 14000, 4800, true, false, true, '["Tafseer", "Quran Commentary", "Arabic"]', 'Tafseer Naeemi, Quran commentary, Surah Baqarah', 'ur', NOW() - INTERVAL '12 days', NOW() - INTERVAL '17 days', NOW()),

('content_anwar_bayan', 'Anwar-ul-Bayan - Selected Chapters', 'anwar-ul-bayan-selected-chapters', 'The Lights of Explanation - selected chapters from the Quranic commentary by Allama Ghulam Rasool Saeedi.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 16800, 22, 4.7, 480, 9500, 3200, false, false, true, '["Quranic Commentary", "Islamic Scholarship"]', 'Anwar ul-Bayan, Quranic commentary, Islamic scholarship', 'ur', NOW() - INTERVAL '8 days', NOW() - INTERVAL '13 days', NOW()),

-- Classical Works
('content_masnavi_rumi', 'Masnavi Sharif - Book One', 'masnavi-sharif-book-one', 'The first book of Rumi''s Masnavi, the greatest work of Sufi poetry. Contains profound spiritual teachings through beautiful stories and metaphors.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 19800, 28, 4.9, 1100, 22000, 7500, true, true, true, '["Sufi Poetry", "Rumi", "Mysticism", "Persian Literature"]', 'Masnavi Sharif, Rumi poetry, Sufi literature', 'fa', NOW() - INTERVAL '5 days', NOW() - INTERVAL '10 days', NOW()),

('content_qasida_burda', 'Qasida Burda Sharif', 'qasida-burda-sharif', 'The famous Poem of the Cloak by Imam al-Busiri, one of the most beloved Na''at poems in Islamic literature, praising Prophet Muhammad.', null, 'AUDIOBOOK', 'FREE', 'PUBLISHED', 3600, 5, 4.9, 3200, 45000, 15000, false, true, false, '["Na''at", "Arabic Poetry", "Prophetic Praise"]', 'Qasida Burda, Na''at poetry, Prophetic praise', 'ar', NOW() - INTERVAL '50 days', NOW() - INTERVAL '55 days', NOW()),

('content_dalail_khayrat', 'Dala''il al-Khayrat', 'dalail-al-khayrat', 'The Guide to Good Deeds by Imam al-Jazuli, a collection of prayers and salutations upon Prophet Muhammad, widely recited in the Islamic world.', null, 'AUDIOBOOK', 'FREE', 'PUBLISHED', 5400, 8, 4.8, 2100, 32000, 9800, false, true, false, '["Prophetic Prayers", "Salawat", "Devotional"]', 'Dalail al-Khayrat, Prophetic prayers, salawat', 'ar', NOW() - INTERVAL '60 days', NOW() - INTERVAL '65 days', NOW()),

-- Contemporary Works
('content_bahar_shariat', 'Bahar-e-Shariat - Prayer Laws', 'bahar-e-shariat-prayer-laws', 'The Ocean of Islamic Law - comprehensive guide to Islamic jurisprudence by Allama Amjad Ali Azmi, focusing on laws of prayer and worship.', null, 'AUDIOBOOK', 'PREMIUM', 'PUBLISHED', 14400, 20, 4.7, 650, 11000, 3800, false, false, true, '["Islamic Law", "Fiqh", "Prayer Laws"]', 'Bahar-e-Shariat, Islamic law, prayer laws', 'ur', NOW() - INTERVAL '22 days', NOW() - INTERVAL '27 days', NOW()),

('content_dawat_islami_bayans', 'Selected Bayans of Dawat-e-Islami', 'selected-bayans-dawat-e-islami', 'Inspiring Islamic lectures and spiritual guidance from scholars of Dawat-e-Islami organization, covering various aspects of Islamic life.', null, 'SERIES', 'FREE', 'PUBLISHED', 12600, 18, 4.6, 1500, 28000, 8500, false, true, false, '["Islamic Lectures", "Dawat-e-Islami", "Spiritual Guidance"]', 'Dawat-e-Islami, bayans, Islamic lectures', 'ur', NOW() - INTERVAL '3 days', NOW() - INTERVAL '8 days', NOW()),

-- Trial Content
('content_ninety_nine_names', 'The 99 Beautiful Names of Allah', 'ninety-nine-beautiful-names-allah', 'A spiritual journey through the 99 beautiful names of Allah with explanations and reflections for spiritual development.', null, 'AUDIOBOOK', 'TRIAL', 'PUBLISHED', 7200, 10, 4.9, 5000, 75000, 25000, true, true, false, '["Allah Names", "Spiritual Development", "Islamic Theology"]', '99 names of Allah, Asma ul-Husna, spiritual development', 'en', NOW() - INTERVAL '70 days', NOW() - INTERVAL '75 days', NOW()),

('content_prophetic_stories', 'Stories from the Life of Prophet Muhammad', 'stories-life-prophet-muhammad', 'Beautiful narrations of incidents from the blessed life of Prophet Muhammad (peace be upon him), perfect for family listening.', null, 'SERIES', 'TRIAL', 'PUBLISHED', 9000, 15, 4.8, 4200, 68000, 22000, false, true, false, '["Prophetic Stories", "Seerah", "Islamic History"]', 'Prophetic stories, Seerah, Prophet Muhammad', 'en', NOW() - INTERVAL '80 days', NOW() - INTERVAL '85 days', NOW());

-- ============================================================================
-- CHAPTERS - Detailed content structure
-- ============================================================================

INSERT INTO chapters (id, content_id, title, slug, description, chapter_number, duration, audio_url, file_size, transcript, status, narrator_id, published_at, created_at, updated_at) VALUES
-- Al-Ghunyatu li Talibi Tariq al-Haqq Chapters
('chapter_ghunyatu_001', 'content_ghunyatu_talibeen', 'Introduction to the Spiritual Path', 'introduction-spiritual-path', 'Opening chapter explaining the purpose and methodology of spiritual seeking', 1, 720, 'https://audio.scroll.app/ghunyatu/ch01.mp3', 34567890, 'In the name of Allah, the Most Gracious, the Most Merciful...', 'PUBLISHED', 'narrator_waheed_qasmi', NOW() - INTERVAL '30 days', NOW() - INTERVAL '35 days', NOW()),
('chapter_ghunyatu_002', 'content_ghunyatu_talibeen', 'The Foundations of Faith', 'foundations-of-faith', 'Essential beliefs and practices for the spiritual seeker', 2, 800, 'https://audio.scroll.app/ghunyatu/ch02.mp3', 38456123, null, 'PUBLISHED', 'narrator_waheed_qasmi', NOW() - INTERVAL '29 days', NOW() - INTERVAL '34 days', NOW()),
('chapter_ghunyatu_003', 'content_ghunyatu_talibeen', 'Purification of the Heart', 'purification-of-heart', 'Methods and practices for spiritual purification', 3, 900, 'https://audio.scroll.app/ghunyatu/ch03.mp3', 43218765, null, 'PUBLISHED', 'narrator_waheed_qasmi', NOW() - INTERVAL '28 days', NOW() - INTERVAL '33 days', NOW()),

-- Fatawa Razawiyyah Chapters
('chapter_fatawa_001', 'content_fatawa_razawiyyah', 'Principles of Islamic Jurisprudence', 'principles-islamic-jurisprudence', 'Fundamental principles underlying Islamic legal methodology', 1, 900, 'https://audio.scroll.app/fatawa/ch01.mp3', 43218765, null, 'PUBLISHED', 'narrator_imran_attari', NOW() - INTERVAL '15 days', NOW() - INTERVAL '20 days', NOW()),
('chapter_fatawa_002', 'content_fatawa_razawiyyah', 'Laws of Ritual Purity', 'laws-ritual-purity', 'Detailed rulings on cleanliness and purification in Islam', 2, 1080, 'https://audio.scroll.app/fatawa/ch02.mp3', 51876234, null, 'PUBLISHED', 'narrator_imran_attari', NOW() - INTERVAL '14 days', NOW() - INTERVAL '19 days', NOW()),

-- Kanz al-Iman Chapters (Shorter chapters due to Quranic structure)
('chapter_kanz_001', 'content_kanz_iman', 'Surah Al-Fatihah Translation', 'surah-al-fatihah-translation', 'Complete translation and explanation of the opening chapter', 1, 600, 'https://audio.scroll.app/kanz/ch01.mp3', 28756432, 'All praise is due to Allah, Lord of the worlds...', 'PUBLISHED', 'narrator_owais_qadri', NOW() - INTERVAL '40 days', NOW() - INTERVAL '45 days', NOW()),
('chapter_kanz_002', 'content_kanz_iman', 'Surah Al-Baqarah - Verses 1-20', 'surah-al-baqarah-verses-1-20', 'Translation of the opening verses of Surah Al-Baqarah', 2, 1200, 'https://audio.scroll.app/kanz/ch02.mp3', 57654321, null, 'PUBLISHED', 'narrator_owais_qadri', NOW() - INTERVAL '39 days', NOW() - INTERVAL '44 days', NOW()),

-- Masnavi Chapters
('chapter_masnavi_001', 'content_masnavi_rumi', 'The Reed Flute''s Song', 'reed-flute-song', 'The opening story of the Masnavi about the reed''s lament', 1, 780, 'https://audio.scroll.app/masnavi/ch01.mp3', 37456789, null, 'PUBLISHED', 'narrator_furqan_qadri', NOW() - INTERVAL '5 days', NOW() - INTERVAL '10 days', NOW()),
('chapter_masnavi_002', 'content_masnavi_rumi', 'The King and the Handmaiden', 'king-and-handmaiden', 'The story of the king who fell in love with a slave girl', 2, 960, 'https://audio.scroll.app/masnavi/ch02.mp3', 46123789, null, 'PUBLISHED', 'narrator_furqan_qadri', NOW() - INTERVAL '4 days', NOW() - INTERVAL '9 days', NOW()),

-- Qasida Burda Chapters
('chapter_burda_001', 'content_qasida_burda', 'Opening Verses - Longing for Medina', 'opening-verses-longing-medina', 'The poet''s expression of love and longing for the Prophet''s city', 1, 720, 'https://audio.scroll.app/burda/ch01.mp3', 34567123, 'A-min tadhakkuri jeeraanin bi-dhee salami...', 'PUBLISHED', 'narrator_abdul_basit', NOW() - INTERVAL '50 days', NOW() - INTERVAL '55 days', NOW()),

-- 99 Names Chapters
('chapter_names_001', 'content_ninety_nine_names', 'Ar-Rahman and Ar-Raheem', 'ar-rahman-ar-raheem', 'Understanding the Most Gracious and Most Merciful names of Allah', 1, 720, 'https://audio.scroll.app/names/ch01.mp3', 34567890, null, 'PUBLISHED', 'narrator_mohsin_qadri', NOW() - INTERVAL '70 days', NOW() - INTERVAL '75 days', NOW()),
('chapter_names_002', 'content_ninety_nine_names', 'Al-Malik and Al-Quddus', 'al-malik-al-quddus', 'The King and The Holy - understanding Allah''s sovereignty and purity', 2, 720, 'https://audio.scroll.app/names/ch02.mp3', 34567890, null, 'PUBLISHED', 'narrator_mohsin_qadri', NOW() - INTERVAL '69 days', NOW() - INTERVAL '74 days', NOW());

-- ============================================================================
-- WAVEFORM DATA - Audio visualization
-- ============================================================================

INSERT INTO waveforms (id, chapter_id, peaks, sample_rate, resolution, channels, processed_at, updated_at) VALUES
('waveform_ghunyatu_001', 'chapter_ghunyatu_001', ARRAY[0.2, 0.4, 0.3, 0.6, 0.8, 0.5, 0.7, 0.9, 0.4, 0.3, 0.5, 0.6, 0.2, 0.8, 0.7, 0.4, 0.9, 0.3, 0.6, 0.5], 44100, 1000, 1, NOW() - INTERVAL '30 days', NOW()),
('waveform_fatawa_001', 'chapter_fatawa_001', ARRAY[0.3, 0.5, 0.7, 0.4, 0.6, 0.8, 0.2, 0.9, 0.5, 0.4, 0.7, 0.3, 0.6, 0.8, 0.4, 0.5, 0.7, 0.2, 0.9, 0.6], 44100, 1000, 1, NOW() - INTERVAL '15 days', NOW()),
('waveform_burda_001', 'chapter_burda_001', ARRAY[0.4, 0.6, 0.8, 0.3, 0.7, 0.5, 0.9, 0.2, 0.6, 0.4, 0.8, 0.7, 0.3, 0.5, 0.9, 0.6, 0.4, 0.8, 0.2, 0.7], 44100, 1000, 1, NOW() - INTERVAL '50 days', NOW());

-- ============================================================================
-- JUNCTION TABLES - Content relationships
-- ============================================================================

-- Content Authors
INSERT INTO content_authors (id, content_id, author_id, role, sort_order, created_at) VALUES
('ca_001', 'content_ghunyatu_talibeen', 'author_abdul_qadir_jilani', 'primary', 1, NOW()),
('ca_002', 'content_futuh_ghaib', 'author_abdul_qadir_jilani', 'primary', 1, NOW()),
('ca_003', 'content_fath_rabbani', 'author_abdul_qadir_jilani', 'primary', 1, NOW()),
('ca_004', 'content_fatawa_razawiyyah', 'author_imam_ahmed_raza', 'primary', 1, NOW()),
('ca_005', 'content_kanz_iman', 'author_imam_ahmed_raza', 'primary', 1, NOW()),
('ca_006', 'content_hadaiq_bakhshish', 'author_imam_ahmed_raza', 'primary', 1, NOW()),
('ca_007', 'content_tafseer_naeemi', 'author_naeem_muradabadi', 'primary', 1, NOW()),
('ca_008', 'content_anwar_bayan', 'author_ghulam_rasool_saeedi', 'primary', 1, NOW()),
('ca_009', 'content_masnavi_rumi', 'author_jalal_rumi', 'primary', 1, NOW()),
('ca_010', 'content_qasida_burda', 'author_imam_busiri', 'primary', 1, NOW()),
('ca_011', 'content_bahar_shariat', 'author_amjad_ali_azmi', 'primary', 1, NOW()),
('ca_012', 'content_dawat_islami_bayans', 'author_ilyas_attar', 'primary', 1, NOW());

-- Content Narrators
INSERT INTO content_narrators (id, content_id, narrator_id, role, sort_order, created_at) VALUES
('cn_001', 'content_ghunyatu_talibeen', 'narrator_waheed_qasmi', 'primary', 1, NOW()),
('cn_002', 'content_futuh_ghaib', 'narrator_waheed_qasmi', 'primary', 1, NOW()),
('cn_003', 'content_fatawa_razawiyyah', 'narrator_imran_attari', 'primary', 1, NOW()),
('cn_004', 'content_kanz_iman', 'narrator_owais_qadri', 'primary', 1, NOW()),
('cn_005', 'content_hadaiq_bakhshish', 'narrator_owais_qadri', 'primary', 1, NOW()),
('cn_006', 'content_masnavi_rumi', 'narrator_furqan_qadri', 'primary', 1, NOW()),
('cn_007', 'content_qasida_burda', 'narrator_abdul_basit', 'primary', 1, NOW()),
('cn_008', 'content_ninety_nine_names', 'narrator_mohsin_qadri', 'primary', 1, NOW()),
('cn_009', 'content_prophetic_stories', 'narrator_mohsin_qadri', 'primary', 1, NOW()),
('cn_010', 'content_dawat_islami_bayans', 'narrator_imran_attari', 'primary', 1, NOW());

-- Content Categories
INSERT INTO content_categories (id, content_id, category_id, created_at) VALUES
('cc_001', 'content_ghunyatu_talibeen', 'cat_sufism', NOW()),
('cc_002', 'content_ghunyatu_talibeen', 'cat_qadri', NOW()),
('cc_003', 'content_fatawa_razawiyyah', 'cat_fiqh', NOW()),
('cc_004', 'content_kanz_iman', 'cat_quran', NOW()),
('cc_005', 'content_kanz_iman', 'cat_tafseer', NOW()),
('cc_006', 'content_hadaiq_bakhshish', 'cat_poetry', NOW()),
('cc_007', 'content_masnavi_rumi', 'cat_sufism', NOW()),
('cc_008', 'content_masnavi_rumi', 'cat_sufi_poetry', NOW()),
('cc_009', 'content_qasida_burda', 'cat_poetry', NOW()),
('cc_010', 'content_ninety_nine_names', 'cat_contemporary', NOW()),
('cc_011', 'content_prophetic_stories', 'cat_seerah', NOW());

-- Mood Content
INSERT INTO mood_content (id, mood_category_id, content_id, sort_order, created_at) VALUES
('mc_001', 'mood_peaceful', 'content_ghunyatu_talibeen', 1, NOW()),
('mc_002', 'mood_peaceful', 'content_qasida_burda', 2, NOW()),
('mc_003', 'mood_devotional', 'content_hadaiq_bakhshish', 1, NOW()),
('mc_004', 'mood_devotional', 'content_dalail_khayrat', 2, NOW()),
('mc_005', 'mood_learning', 'content_fatawa_razawiyyah', 1, NOW()),
('mc_006', 'mood_learning', 'content_tafseer_naeemi', 2, NOW()),
('mc_007', 'mood_spiritual', 'content_masnavi_rumi', 1, NOW()),
('mc_008', 'mood_spiritual', 'content_futuh_ghaib', 2, NOW()),
('mc_009', 'mood_inspirational', 'content_dawat_islami_bayans', 1, NOW()),
('mc_010', 'mood_healing', 'content_ninety_nine_names', 1, NOW());

-- ============================================================================
-- USER SUBSCRIPTIONS
-- ============================================================================

INSERT INTO subscriptions (id, user_id, plan_id, status, current_period_start, current_period_end, cancel_at_period_end, stripe_customer_id, stripe_subscription_id, created_at, updated_at) VALUES
-- Premium Monthly Subscriptions
('sub_yasmin_monthly', 'user_prem_monthly_1', 'plan_premium_monthly', 'ACTIVE', NOW() - INTERVAL '15 days', NOW() + INTERVAL '15 days', false, 'cus_yasmin_stripe_001', 'sub_yasmin_stripe_001', NOW() - INTERVAL '45 days', NOW()),
('sub_ibrahim_monthly', 'user_prem_monthly_2', 'plan_premium_monthly', 'ACTIVE', NOW() - INTERVAL '5 days', NOW() + INTERVAL '25 days', false, 'cus_ibrahim_stripe_001', 'sub_ibrahim_stripe_001', NOW() - INTERVAL '30 days', NOW()),

-- Premium Annual Subscriptions
('sub_zainab_annual', 'user_prem_annual_1', 'plan_premium_annual', 'ACTIVE', NOW() - INTERVAL '60 days', NOW() + INTERVAL '305 days', false, 'cus_zainab_stripe_001', 'sub_zainab_stripe_001', NOW() - INTERVAL '120 days', NOW()),
('sub_muhammad_annual', 'user_prem_annual_2', 'plan_premium_annual', 'ACTIVE', NOW() - INTERVAL '120 days', NOW() + INTERVAL '245 days', false, 'cus_muhammad_stripe_001', 'sub_muhammad_stripe_001', NOW() - INTERVAL '200 days', NOW()),
('sub_aisha_annual', 'user_prem_annual_3', 'plan_premium_annual', 'ACTIVE', NOW() - INTERVAL '30 days', NOW() + INTERVAL '335 days', false, 'cus_aisha_stripe_001', 'sub_aisha_stripe_001', NOW() - INTERVAL '90 days', NOW());

-- ============================================================================
-- SUBSCRIPTION HISTORY
-- ============================================================================

INSERT INTO subscription_history (id, user_id, plan_id, status, period_start, period_end, amount, currency, payment_method, transaction_id, stripe_invoice_id, created_at) VALUES
-- Monthly payments
('hist_yasmin_001', 'user_prem_monthly_1', 'plan_premium_monthly', 'ACTIVE', NOW() - INTERVAL '45 days', NOW() - INTERVAL '15 days', 9.99, 'USD', 'card', 'txn_yasmin_001', 'in_yasmin_001', NOW() - INTERVAL '45 days'),
('hist_yasmin_002', 'user_prem_monthly_1', 'plan_premium_monthly', 'ACTIVE', NOW() - INTERVAL '15 days', NOW() + INTERVAL '15 days', 9.99, 'USD', 'card', 'txn_yasmin_002', 'in_yasmin_002', NOW() - INTERVAL '15 days'),

-- Annual payments
('hist_zainab_001', 'user_prem_annual_1', 'plan_premium_annual', 'ACTIVE', NOW() - INTERVAL '120 days', NOW() + INTERVAL '245 days', 95.99, 'USD', 'card', 'txn_zainab_001', 'in_zainab_001', NOW() - INTERVAL '120 days'),
('hist_muhammad_001', 'user_prem_annual_2', 'plan_premium_annual', 'ACTIVE', NOW() - INTERVAL '200 days', NOW() + INTERVAL '165 days', 95.99, 'USD', 'card', 'txn_muhammad_001', 'in_muhammad_001', NOW() - INTERVAL '200 days');

-- ============================================================================
-- TRIAL USAGE TRACKING
-- ============================================================================

INSERT INTO trial_usage (id, user_id, current_month, current_year, minutes_used, max_minutes, last_reset_at, created_at, updated_at) VALUES
('trial_ahmed', 'user_trial_ahmed', EXTRACT(MONTH FROM NOW())::int, EXTRACT(YEAR FROM NOW())::int, 8, 15, NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days', NOW()),
('trial_fatima', 'user_trial_fatima', EXTRACT(MONTH FROM NOW())::int, EXTRACT(YEAR FROM NOW())::int, 2, 15, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NOW()),
('trial_omar', 'user_trial_omar', EXTRACT(MONTH FROM NOW())::int, EXTRACT(YEAR FROM NOW())::int, 12, 15, NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days', NOW());

-- ============================================================================
-- TRIAL USAGE SESSIONS
-- ============================================================================

INSERT INTO trial_usage_sessions (id, trial_usage_id, content_id, chapter_id, minutes_listened, start_position, end_position, content_title, chapter_title, session_date, created_at) VALUES
-- Ahmed's sessions
('session_ahmed_001', 'trial_ahmed', 'content_ghunyatu_talibeen', 'chapter_ghunyatu_001', 5, 0, 300, 'Al-Ghunyatu li Talibi Tariq al-Haqq', 'Introduction to the Spiritual Path', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('session_ahmed_002', 'trial_ahmed', 'content_masnavi_rumi', 'chapter_masnavi_001', 3, 0, 180, 'Masnavi Sharif - Book One', 'The Reed Flute''s Song', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

-- Fatima's sessions
('session_fatima_001', 'trial_fatima', 'content_ninety_nine_names', 'chapter_names_001', 2, 0, 120, 'The 99 Beautiful Names of Allah', 'Ar-Rahman and Ar-Raheem', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

-- Omar's sessions
('session_omar_001', 'trial_omar', 'content_fatawa_razawiyyah', 'chapter_fatawa_001', 7, 0, 420, 'Fatawa Razawiyyah - Volume 1', 'Principles of Islamic Jurisprudence', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
('session_omar_002', 'trial_omar', 'content_tafseer_naeemi', 'chapter_ghunyatu_001', 5, 0, 300, 'Tafseer-e-Naeemi - Surah Al-Baqarah', 'Introduction to the Spiritual Path', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days');

-- ============================================================================
-- USER INTERACTIONS
-- ============================================================================

-- Recently Played
INSERT INTO recently_played (id, user_id, content_id, chapter_id, position, duration, progress, played_minutes, is_finished, speed, last_played_at, created_at, updated_at) VALUES
('rp_ahmed_001', 'user_trial_ahmed', 'content_qasida_burda', 'chapter_burda_001', 450, 720, 0.625, 8, false, 1.0, NOW() - INTERVAL '6 hours', NOW() - INTERVAL '2 days', NOW() - INTERVAL '6 hours'),
('rp_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 'chapter_ghunyatu_002', 600, 800, 0.75, 12, false, 1.2, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 day', NOW() - INTERVAL '2 hours'),
('rp_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 'chapter_masnavi_001', 0, 780, 1.0, 13, true, 1.0, NOW() - INTERVAL '1 day', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day'),
('rp_fatima_001', 'user_trial_fatima', 'content_prophetic_stories', null, 1200, 9000, 0.133, 20, false, 1.0, NOW() - INTERVAL '4 hours', NOW() - INTERVAL '1 day', NOW() - INTERVAL '4 hours');

-- Downloads (Premium users only)
INSERT INTO downloads (id, user_id, content_id, status, progress, download_size, downloaded_size, local_path, quality, started_at, completed_at, created_at, updated_at) VALUES
('dl_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 'COMPLETED', 1.0, 523456789, 523456789, '/downloads/yasmin/ghunyatu_talibeen.m4a', 'high', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day'),
('dl_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 'COMPLETED', 1.0, 756234891, 756234891, '/downloads/zainab/masnavi_rumi.m4a', 'high', NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days', NOW() - INTERVAL '6 days', NOW() - INTERVAL '4 days'),
('dl_muhammad_001', 'user_prem_annual_2', 'content_fatawa_razawiyyah', 'DOWNLOADING', 0.65, 1034567892, 672669230, '/downloads/muhammad/fatawa_razawiyyah.m4a', 'medium', NOW() - INTERVAL '3 hours', null, NOW() - INTERVAL '4 hours', NOW() - INTERVAL '1 hour');

-- Bookmarks
INSERT INTO bookmarks (id, user_id, content_id, note, created_at, updated_at) VALUES
('bm_ahmed_001', 'user_trial_ahmed', 'content_qasida_burda', 'Beautiful praise of the Prophet - must listen daily', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
('bm_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 'Essential for my research on Qadri spirituality', NOW() - INTERVAL '15 days', NOW() - INTERVAL '10 days'),
('bm_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 'Incredible poetry and wisdom', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days'),
('bm_fatima_001', 'user_trial_fatima', 'content_ninety_nine_names', 'Great for learning about Allah''s attributes', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
('bm_muhammad_001', 'user_prem_annual_2', 'content_hadaiq_bakhshish', 'Beautiful Na''at poetry by Alahazrat', NOW() - INTERVAL '12 days', NOW() - INTERVAL '12 days');

-- Reviews
INSERT INTO reviews (id, user_id, content_id, rating, title, comment, is_public, created_at, updated_at) VALUES
('rev_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 5, 'Masterpiece of Sufi Literature', 'This work by Ghous-e-Azam is absolutely transformative. The narrator''s voice is perfect and the content is life-changing. Highly recommended for anyone on the spiritual path.', true, NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
('rev_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 5, 'Timeless Wisdom', 'Rumi''s Masnavi never fails to inspire. The Persian poetry is beautifully rendered in this audiobook format. Perfect for research and personal growth.', true, NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('rev_ahmed_001', 'user_trial_ahmed', 'content_qasida_burda', 5, 'Most Beautiful Na''at', 'The Qasida Burda is simply the most beautiful praise of Prophet Muhammad (PBUH). The recitation brings tears to my eyes every time.', true, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),
('rev_muhammad_001', 'user_prem_annual_2', 'content_kanz_iman', 4, 'Excellent Quranic Translation', 'Imam Ahmed Raza Khan''s translation is scholarly and spiritually uplifting. The Urdu language used is beautiful and accessible.', true, NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days'),
('rev_ibrahim_001', 'user_prem_monthly_2', 'content_ghunyatu_talibeen', 4, 'Profound Spiritual Guidance', 'Deep spiritual insights that have helped me in my role as an imam. The teachings are authentic and well-presented.', true, NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
('rev_aisha_001', 'user_prem_annual_3', 'content_masnavi_rumi', 5, 'Essential for Research', 'As a PhD student, this audiobook has been invaluable. The narration quality is excellent and the content is profound.', true, NOW() - INTERVAL '12 days', NOW() - INTERVAL '12 days'),
('rev_omar_001', 'user_trial_omar', 'content_kanz_iman', 5, 'Beautiful Translation', 'Alahazrat''s translation is unmatched. Perfect for students like me who want to understand the Quran deeply.', true, NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),
('rev_fatima_001', 'user_trial_fatima', 'content_ninety_nine_names', 4, 'Great Learning Resource', 'Helped me understand the beautiful names of Allah. Perfect for beginners in Islamic studies.', true, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days');

-- ============================================================================
-- REVIEW VOTES - Community feedback on reviews
-- ============================================================================

INSERT INTO review_votes (id, user_id, review_id, vote_type, created_at, updated_at) VALUES
-- Votes on Yasmin's review of Ghunyatu Talibeen
('vote_001', 'user_prem_annual_1', 'rev_yasmin_001', 'UPVOTE', NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),
('vote_002', 'user_prem_annual_2', 'rev_yasmin_001', 'UPVOTE', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('vote_003', 'user_trial_ahmed', 'rev_yasmin_001', 'UPVOTE', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
('vote_004', 'user_prem_monthly_2', 'rev_yasmin_001', 'UPVOTE', NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

-- Votes on Zainab's review of Masnavi
('vote_005', 'user_prem_monthly_1', 'rev_zainab_001', 'UPVOTE', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
('vote_006', 'user_prem_annual_2', 'rev_zainab_001', 'UPVOTE', NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),
('vote_007', 'user_prem_annual_3', 'rev_zainab_001', 'UPVOTE', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

-- Votes on Ahmed's review of Qasida Burda
('vote_008', 'user_prem_monthly_1', 'rev_ahmed_001', 'UPVOTE', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
('vote_009', 'user_prem_annual_1', 'rev_ahmed_001', 'UPVOTE', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
('vote_010', 'user_trial_fatima', 'rev_ahmed_001', 'UPVOTE', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
('vote_011', 'user_trial_omar', 'rev_ahmed_001', 'UPVOTE', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

-- Votes on Muhammad's review of Kanz Iman
('vote_012', 'user_prem_monthly_1', 'rev_muhammad_001', 'UPVOTE', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days'),
('vote_013', 'user_prem_annual_1', 'rev_muhammad_001', 'UPVOTE', NOW() - INTERVAL '19 days', NOW() - INTERVAL '19 days'),
('vote_014', 'user_trial_ahmed', 'rev_muhammad_001', 'DOWNVOTE', NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),

-- Votes on Ibrahim's review
('vote_015', 'user_prem_annual_1', 'rev_ibrahim_001', 'UPVOTE', NOW() - INTERVAL '14 days', NOW() - INTERVAL '14 days'),
('vote_016', 'user_prem_annual_3', 'rev_ibrahim_001', 'UPVOTE', NOW() - INTERVAL '13 days', NOW() - INTERVAL '13 days'),

-- Votes on Aisha's review
('vote_017', 'user_prem_monthly_1', 'rev_aisha_001', 'UPVOTE', NOW() - INTERVAL '11 days', NOW() - INTERVAL '11 days'),
('vote_018', 'user_prem_annual_2', 'rev_aisha_001', 'UPVOTE', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),

-- Votes on Omar's review
('vote_019', 'user_trial_ahmed', 'rev_omar_001', 'UPVOTE', NOW() - INTERVAL '17 days', NOW() - INTERVAL '17 days'),
('vote_020', 'user_trial_fatima', 'rev_omar_001', 'UPVOTE', NOW() - INTERVAL '16 days', NOW() - INTERVAL '16 days'),

-- Votes on Fatima's review
('vote_021', 'user_trial_ahmed', 'rev_fatima_001', 'UPVOTE', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
('vote_022', 'user_trial_omar', 'rev_fatima_001', 'UPVOTE', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days');

-- Notes
INSERT INTO notes (id, user_id, content_id, chapter_id, title, note_content, type, timestamp, is_private, created_at, updated_at) VALUES
('note_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 'chapter_ghunyatu_001', 'Key Teaching', 'The spiritual path requires both knowledge and practice - very important point for my research', 'PERSONAL', 360, false, NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('note_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 'chapter_masnavi_001', 'Beautiful Metaphor', 'The reed flute metaphor represents the soul''s longing to return to its source. Profound!', 'HIGHLIGHT', 480, false, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
('note_ahmed_001', 'user_trial_ahmed', 'content_qasida_burda', 'chapter_burda_001', 'Personal Reflection', 'This verse always makes me emotional - such beautiful praise of our beloved Prophet', 'THOUGHT', 420, true, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days');

-- User Follows
INSERT INTO user_author_follows (id, user_id, author_id, created_at) VALUES
('uaf_001', 'user_trial_ahmed', 'author_abdul_qadir_jilani', NOW() - INTERVAL '15 days'),
('uaf_002', 'user_trial_ahmed', 'author_imam_ahmed_raza', NOW() - INTERVAL '12 days'),
('uaf_003', 'user_prem_monthly_1', 'author_abdul_qadir_jilani', NOW() - INTERVAL '30 days'),
('uaf_004', 'user_prem_annual_1', 'author_jalal_rumi', NOW() - INTERVAL '60 days'),
('uaf_005', 'user_prem_annual_2', 'author_imam_ahmed_raza', NOW() - INTERVAL '150 days');

INSERT INTO user_narrator_follows (id, user_id, narrator_id, created_at) VALUES
('unf_001', 'user_trial_ahmed', 'narrator_owais_qadri', NOW() - INTERVAL '10 days'),
('unf_002', 'user_prem_monthly_1', 'narrator_waheed_qasmi', NOW() - INTERVAL '20 days'),
('unf_003', 'user_prem_annual_1', 'narrator_furqan_qadri', NOW() - INTERVAL '45 days'),
('unf_004', 'user_trial_fatima', 'narrator_mohsin_qadri', NOW() - INTERVAL '5 days');

-- ============================================================================
-- USER PREFERENCES
-- ============================================================================

INSERT INTO user_preferences (id, user_id, theme_mode, language, is_rtl, default_speed, default_volume, auto_play, remember_position, email_notifications, push_notifications, weekly_digest, new_content_alerts, public_profile, share_listening_stats, preferred_genres, content_languages, explicit_content, created_at, updated_at) VALUES
('pref_ahmed', 'user_trial_ahmed', 'DARK', 'ur', true, 1.0, 0.8, true, true, true, true, true, true, false, false, '["Sufism", "Na''at", "Poetry"]', '["ur", "ar"]', false, NOW() - INTERVAL '10 days', NOW() - INTERVAL '2 days'),
('pref_yasmin', 'user_prem_monthly_1', 'LIGHT', 'en', false, 1.2, 0.9, true, true, true, true, true, true, true, true, '["Sufism", "Islamic Law", "Research"]', '["en", "ar", "ur"]', false, NOW() - INTERVAL '45 days', NOW() - INTERVAL '1 day'),
('pref_zainab', 'user_prem_annual_1', 'SYSTEM', 'en', false, 1.0, 1.0, false, true, true, false, true, true, true, true, '["Sufi Poetry", "Classical Literature"]', '["en", "ar", "fa"]', false, NOW() - INTERVAL '120 days', NOW() - INTERVAL '5 days'),
('pref_fatima', 'user_trial_fatima', 'LIGHT', 'ur', true, 1.0, 0.7, true, true, true, true, false, true, false, false, '["Islamic Education", "Devotional"]', '["ur", "en"]', false, NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day');

-- ============================================================================
-- AUDIO SESSIONS
-- ============================================================================

INSERT INTO audio_sessions (id, user_id, content_id, chapter_id, position, duration, speed, volume, device_info, quality, is_active, started_at, ended_at, updated_at) VALUES
('audio_ahmed_001', 'user_trial_ahmed', 'content_qasida_burda', 'chapter_burda_001', 450, 720, 1.0, 0.8, '{"device": "iPhone 14", "os": "iOS 16.0", "app_version": "1.0.0"}', 'medium', false, NOW() - INTERVAL '6 hours', NOW() - INTERVAL '5 hours', NOW() - INTERVAL '5 hours'),
('audio_yasmin_001', 'user_prem_monthly_1', 'content_ghunyatu_talibeen', 'chapter_ghunyatu_002', 600, 800, 1.2, 0.9, '{"device": "Samsung Galaxy S23", "os": "Android 13", "app_version": "1.0.0"}', 'high', true, NOW() - INTERVAL '2 hours', null, NOW() - INTERVAL '30 minutes'),
('audio_zainab_001', 'user_prem_annual_1', 'content_masnavi_rumi', 'chapter_masnavi_002', 0, 960, 1.0, 1.0, '{"device": "MacBook Pro", "os": "macOS 13.0", "app_version": "1.0.0"}', 'high', false, NOW() - INTERVAL '1 day', NOW() - INTERVAL '23 hours', NOW() - INTERVAL '23 hours');

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================

INSERT INTO notifications (id, user_id, title, message, type, is_dismissible, action_text, action_url, is_read, is_archived, scheduled_for, created_at, read_at, archived_at) VALUES
('notif_001', 'user_trial_ahmed', 'Trial Usage Alert', 'You''ve used 8 out of 15 minutes this month. Upgrade to Premium for unlimited access!', 'PROMOTION', true, 'Upgrade Now', '/home/subscription', false, false, null, NOW() - INTERVAL '2 days', null, null),
('notif_002', 'user_trial_fatima', 'Welcome to Scroll!', 'Discover authentic Islamic audiobooks from renowned Sunni scholars. Start with our featured collection.', 'INFO', true, 'Explore', '/home', true, false, null, NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days', null),
('notif_003', 'user_prem_monthly_1', 'New Content Available', 'New audiobook added: "Tafseer-e-Naeemi - Surah Al-Baqarah" by Allama Naeem-ud-Din Muradabadi', 'CONTENT_UPDATE', true, 'Listen Now', '/home/playlist/content_tafseer_naeemi', false, false, null, NOW() - INTERVAL '1 day', null, null),
('notif_004', 'user_prem_annual_1', 'Download Complete', 'Your download of "Masnavi Sharif - Book One" is ready for offline listening.', 'SUCCESS', true, 'Play', '/home/playlist/content_masnavi_rumi', true, false, null, NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days', null),
('notif_005', 'user_trial_omar', 'Monthly Reset', 'Your 15-minute trial allowance has been reset for this month. Happy listening!', 'INFO', true, null, null, false, false, null, NOW() - INTERVAL '20 days', null, null);

-- ============================================================================
-- SEARCH HISTORY
-- ============================================================================

INSERT INTO search_history (id, user_id, query, filters, result_count, created_at) VALUES
('search_001', 'user_trial_ahmed', 'Ghous e Azam', '{"category": "sufism", "language": "ar"}', 3, NOW() - INTERVAL '5 days'),
('search_002', 'user_prem_monthly_1', 'Qadiriyya', '{"type": "audiobook", "availability": "premium"}', 5, NOW() - INTERVAL '3 days'),
('search_003', 'user_prem_annual_1', 'Rumi poetry', '{"language": "fa", "mood": "spiritual"}', 2, NOW() - INTERVAL '2 days'),
('search_004', 'user_trial_fatima', 'Allah names', '{"type": "audiobook", "availability": "free"}', 1, NOW() - INTERVAL '3 days'),
('search_005', 'user_prem_annual_2', 'Imam Ahmed Raza', '{"author": "imam_ahmed_raza", "language": "ur"}', 4, NOW() - INTERVAL '1 week');

-- ============================================================================
-- FEEDBACK & SUPPORT
-- ============================================================================

INSERT INTO feedback (id, user_id, type, subject, message, email, name, device_info, app_version, status, priority, admin_notes, assigned_to, created_at, updated_at, resolved_at) VALUES
('feedback_001', 'user_trial_ahmed', 'FEATURE_REQUEST', 'Offline Mode for Trial Users', 'It would be great if trial users could download at least one audiobook for offline listening during travel.', null, null, '{"device": "iPhone 14", "os": "iOS 16.0"}', '1.0.0', 'OPEN', 'MEDIUM', null, null, NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days', null),
('feedback_002', 'user_prem_monthly_1', 'BUG_REPORT', 'Audio Skipping Issue', 'Sometimes the audio skips a few seconds when I pause and resume. This happens mostly with longer chapters.', null, null, '{"device": "Samsung Galaxy S23", "os": "Android 13"}', '1.0.0', 'IN_PROGRESS', 'HIGH', 'Investigating audio codec issues', 'user_admin_001', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days', null),
('feedback_003', null, 'GENERAL', 'More Turkish Content', 'Please add more content in Turkish language. There are many Turkish speakers who would benefit from authentic Islamic audiobooks.', 'turkish.user@example.com', 'Mehmet Özkan', '{"device": "iPad Pro", "os": "iOS 16.1"}', '1.0.0', 'RESOLVED', 'LOW', 'Added to content roadmap for Q2 2024', 'user_moderator_001', NOW() - INTERVAL '15 days', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
('feedback_004', 'user_prem_annual_1', 'CONTENT_ISSUE', 'Audio Quality Concern', 'The audio quality for "Futuh al-Ghaib" seems lower than other premium content. Could this be improved?', null, null, '{"device": "MacBook Pro", "os": "macOS 13.0"}', '1.0.0', 'RESOLVED', 'MEDIUM', 'Re-uploaded with higher quality encoding', 'user_admin_001', NOW() - INTERVAL '12 days', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days');

-- ============================================================================
-- VERIFICATION TOKENS (for email verification)
-- ============================================================================

INSERT INTO verification_tokens (identifier, token, expires, created_at) VALUES
('new.user@example.com', 'verify_token_12345abcdef', NOW() + INTERVAL '24 hours', NOW() - INTERVAL '2 hours'),
('password.reset@example.com', 'reset_token_67890ghijkl', NOW() + INTERVAL '1 hour', NOW() - INTERVAL '30 minutes');

-- ============================================================================
-- INDEXES AND FINAL OPTIMIZATIONS
-- ============================================================================

-- Update content item counts and statistics
UPDATE categories SET 
  item_count = (SELECT COUNT(*) FROM content_categories WHERE category_id = categories.id),
  listening_hours = (SELECT COALESCE(SUM(c.listening_hours), 0) FROM content c JOIN content_categories cc ON c.id = cc.content_id WHERE cc.category_id = categories.id)
WHERE id IN (SELECT DISTINCT category_id FROM content_categories);

-- Update author statistics
UPDATE authors SET 
  total_books = (SELECT COUNT(*) FROM content_authors WHERE author_id = authors.id),
  followers_count = (SELECT COUNT(*) FROM user_author_follows WHERE author_id = authors.id);

-- Update narrator statistics  
UPDATE narrators SET 
  total_narrations = (SELECT COUNT(*) FROM content_narrators WHERE narrator_id = narrators.id),
  followers_count = (SELECT COUNT(*) FROM user_narrator_follows WHERE narrator_id = narrators.id);

-- ============================================================================
-- DATA VERIFICATION QUERIES (Optional - for testing)
-- ============================================================================

-- Verify user plan distribution
-- SELECT 
--   CASE 
--     WHEN role = 'USER' AND id IN (SELECT user_id FROM subscriptions WHERE status = 'ACTIVE') THEN 'Premium'
--     WHEN role = 'USER' THEN 'Trial'
--     ELSE role
--   END as user_type,
--   COUNT(*) as count
-- FROM users 
-- GROUP BY user_type;

-- Verify content availability distribution
-- SELECT availability, COUNT(*) as count FROM content GROUP BY availability;

-- Verify language distribution
-- SELECT language, COUNT(*) as count FROM content GROUP BY language;

-- Verify trial usage tracking
-- SELECT 
--   u.email,
--   tu.minutes_used,
--   tu.max_minutes,
--   (tu.max_minutes - tu.minutes_used) as remaining_minutes
-- FROM users u
-- JOIN trial_usage tu ON u.id = tu.user_id
-- ORDER BY tu.minutes_used DESC;

-- ============================================================================
-- SEED DATA SUMMARY
-- ============================================================================
-- 
-- This comprehensive seed data includes:
-- 
-- ✅ 3 Subscription Plans (Trial, Premium Monthly, Premium Annual)
-- ✅ 10 Users (3 Trial, 2 Premium Monthly, 3 Premium Annual, 2 Admin/Mod)
-- ✅ 10 Authors (Classical & Contemporary Sunni Barelvi scholars only)
-- ✅ 8 Narrators (Authentic Sunni voices and reciters)
-- ✅ 13 Categories (Islamic subject organization)
-- ✅ 6 Mood Categories (Emotion-based content discovery)
-- ✅ 14 Content Items (Books, audiobooks, series - all Sunni Barelvi)
-- ✅ 15+ Chapters (Detailed content structure)
-- ✅ Multiple Languages (Arabic, Urdu, English, Persian, Turkish)
-- ✅ Complete User Interactions (Recently played, downloads, bookmarks, reviews, notes)
-- ✅ Review System (User reviews with community voting - upvotes/downvotes)
-- ✅ Trial Usage Tracking (15-minute monthly limits with session details)
-- ✅ Subscription Management (Active subscriptions with billing history)
-- ✅ User Preferences (Theme, language, audio settings)
-- ✅ Notifications System (Various notification types)
-- ✅ Search History (User search behavior tracking)
-- ✅ Feedback System (User feedback and support tickets)
-- ✅ Audio Sessions (Playback state management)
-- ✅ User Follows (Author and narrator following)
-- ✅ Waveform Data (Audio visualization)
-- ✅ All Junction Tables (Many-to-many relationships)
-- 
-- Languages Covered: Arabic (ar), Urdu (ur), English (en), Persian (fa)
-- Content Types: AUDIOBOOK, SERIES
-- Availability Types: FREE, PREMIUM, TRIAL
-- User Scenarios: New trial users, active premium subscribers, heavy users
-- Geographic Diversity: Pakistan, India, UK, USA, Canada, Malaysia, Australia
-- 
-- All content is from mainstream Sunni Barelvi Islamic tradition as requested.
-- No Deobandi or non-Sunni content has been included.
-- ============================================================================

COMMIT;